from pyspark.sql.functions import lit, when, col, round
from pyspark.sql.functions import split
from pyspark.sql.functions import sum as _sum
from pyspark.sql import Window, DataFrame

def get_week_plant_norma_agg(df, week_analysis_value):
    """
    Aggregates total volume and computes volume weights for each PlanProd, Plant_Code, and norma
    for a given week_analysis value. Also calculates resistance-based weights for v2 logic.

    Parameters
    ----------
    df : pyspark.sql.DataFrame
        Input DataFrame
    week_analysis_value : str
        The week_analysis value to filter the DataFrame (e.g., "2025-08-19").

    Returns
    -------
    pyspark.sql.DataFrame
        DataFrame grouped by PlanProd, Plant_Code, norma, and week_analysis with resistance-based weights
    """
    week_0 = df.filter(df["week_analysis"] == week_analysis_value)
    week_0 = week_0.withColumn("norma", split(col("Codigo_de_producto"), "-")[0])
    week_0 = week_0.withColumn("resistance", split(col("Codigo_de_producto"), "-")[1])

    # Group by PlanProd, Plant_Code, norma, resistance, week_analysis
    week_0_grouped = (
        week_0.groupby(
            [
                'PlanProd',
                'Plant_Code',
                'norma',
                'resistance',
                'week_analysis'
            ]
        )
        .agg({'total_volume': 'sum'})
        .withColumnRenamed('sum(total_volume)', 'total_volume')
    )

    # Calculate total volume per Plant_Code and norma
    window_spec = Window.partitionBy("Plant_Code", "norma")
    week_0_grouped = week_0_grouped.withColumn(
        "total_volume_sum",
        _sum("total_volume").over(window_spec)
    )
    
    # Calculate total volume per Plant_Code, norma, and resistance (for v2 weights)
    window_spec_resistance = Window.partitionBy("Plant_Code", "norma", "resistance")
    week_0_grouped = week_0_grouped.withColumn(
        "total_volume_by_resistance",
        _sum("total_volume").over(window_spec_resistance)
    )
    
    # Calculate resistance-based weight (proportion of volume for this resistance within Plant_Code-norma)
    week_0_grouped = week_0_grouped.withColumn(
        "weight_by_resistance",
        when(col("total_volume_sum") == 0, lit(0))
        .otherwise(col("total_volume_by_resistance") / col("total_volume_sum"))
    ).drop("total_volume_by_resistance")

    # Order columns
    cols = week_0_grouped.columns
    ordered_cols = (
        ["PlanProd", "Plant_Code", "norma", "resistance", "total_volume", "weight_by_resistance", "week_analysis"] +
        [c for c in cols if c not in ["PlanProd", "Plant_Code", "norma", "resistance", "total_volume", "weight_by_resistance", "week_analysis"]]
    )
    return week_0_grouped.select(*ordered_cols)

def get_weekly_samples_weights(df_adjustments, week_analysis_value, n_column='No_de_viajes_muestreados'):
    """
    Aggregates the number of sampled trips and computes sample weights for each Planta and norma
    for a given week_analysis value.

    Parameters
    ----------
    df_adjustments : pyspark.sql.DataFrame
        Input DataFrame
    week_analysis_value : str
        The week_analysis value to filter the DataFrame (e.g., "2025-08-19").

    Returns
    -------
    pyspark.sql.DataFrame
        DataFrame grouped by Planta and norma
    """
    week_df = df_adjustments.filter(df_adjustments["week_analysis"] == week_analysis_value)
    week_df = week_df.withColumn("norma", split(col("Producto_Tecnico"), "-")[0])


    cols = week_df.columns
    ordered_cols = (
        ["Planta", "norma", n_column, "Ajuste_por_ML"] +
        [c for c in cols if c not in ["Planta", "norma", n_column, "Ajuste_por_ML"]]
    )
    return week_df.select(*ordered_cols)

def calculate_grouped_sample_weights(df: DataFrame, n_column='No_de_viajes_muestreados') -> DataFrame:
    """
    Calculate sample weights grouped by Plant and Standard (norma).
    
    New logic v3:
    - Matched rows (with volume): redistribute their total samples using volume weights
    - Unmatched rows with resistance weight: redistribute unmatched samples using resistance weights
    - Unmatched rows without resistance weight: keep original sample count
    - All n_muestras_new are then normalized to calculate final weights
    
    Args:
        df (DataFrame): Input PySpark DataFrame containing the sample data.
                       Expected to have 'weight_volume' and 'weight_by_resistance' columns.
    
    Returns:
        DataFrame: Enhanced DataFrame with the following new columns:
            - n_muestras_new: Recalculated sample counts (never null)
            - weight_samples_new: Normalized weights within each Plant-Standard group
            - new_adjust_weighted: Weights * ML adjustment
    
    Process:
        1. For matched rows (with volume): n_muestras_new = weight_volume * sum(samples of matched rows)
        2. For unmatched rows with resistance weight: n_muestras_new = weight_by_resistance * sum(samples of unmatched rows)
        3. For unmatched rows without resistance weight: n_muestras_new = original n_column value
        4. Normalize all n_muestras_new within Planta-norma to get weight_samples_new
        5. Apply ML adjustments to final weights
    """
    
    # Define window for grouping operations by Plant and Standard
    window_partition = Window.partitionBy("Planta", "norma")
    
    # Calculate total samples for matched rows (with volume)
    df = df.withColumn(
        "sum_samples_matched",
        _sum(when(col("total_volume").isNotNull(), col(n_column)).otherwise(0)).over(window_partition)
    )
    
    # Calculate total samples for unmatched rows (without volume)
    df = df.withColumn(
        "sum_samples_unmatched",
        _sum(when(col("total_volume").isNull(), col(n_column)).otherwise(0)).over(window_partition)
    )
    
    # Calculate n_muestras_new with 3 cases:
    # Case 1: Has volume (matched) -> use weight_volume * sum_samples_matched
    # Case 2: No volume but has resistance weight -> use weight_by_resistance * sum_samples_unmatched
    # Case 3: No volume and no resistance weight -> use original n_column
    df = df.withColumn(
        "n_muestras_new",
        when(col("total_volume").isNotNull(), 
             col("weight_volume") * col("sum_samples_matched"))
        .otherwise(
            when(col("weight_by_resistance").isNotNull(),
                 col("weight_by_resistance") * col("sum_samples_unmatched"))
            .otherwise(col(n_column))  # Copy original value
        )
    )
    
    # Calculate total of all new sample counts by group
    df = df.withColumn(
        "sum_all_new_samples",
        _sum(col("n_muestras_new")).over(window_partition)
    )
    
    # Calculate normalized weights within each group
    # Normalize all n_muestras_new together
    df = df.withColumn(
        "weight_samples_new",
        when(col("sum_all_new_samples") == 0, lit(0))
        .otherwise(col("n_muestras_new") / col("sum_all_new_samples"))
    )
    
    # Calculate weighted adjustment
    df = df.withColumn(
        "new_adjust_weighted",
        col("weight_samples_new") * col("Ajuste_por_ML")
    )
    
    # Remove intermediate calculation columns
    df = df.drop("sum_samples_matched", "sum_samples_unmatched", "sum_all_new_samples")
    
    return df


def compute_agg_adjusted_weights(df_week_0_5, df_adjustments, week_analysis_list, n_column='No_de_viajes_muestreados'):
    """
    Computes the sum of new_adjust_weighted by Planta and norma for multiple weeks.
    
    Uses resistance-based weights from week_0_5 for null volume rows.

    Parameters
    ----------
    df_week_0_5 : pyspark.sql.DataFrame
        DataFrame with volume data (must include 'week_analysis', 'Codigo_de_producto', 'PlanProd', 'Plant_Code', 'total_volume')
    df_adjustments : pyspark.sql.DataFrame
        DataFrame with adjustments (must include 'week_analysis', 'Producto_Tecnico', 'Planta', 'PlanProd', 'No_de_viajes_muestreados', 'Ajuste_por_ML')
    week_analysis_list : list
        List of week_analysis values (e.g., ["2025-08-19", "2025-08-26"]).

    Returns
    -------
    pyspark.sql.DataFrame
        Aggregated DataFrame with columns: week_analysis, Planta, norma, sum_new_adjust_weighted
    """
    dfs = []
    results = []
    for week_analysis_value in week_analysis_list:
        week_0_5 = get_week_plant_norma_agg(df_week_0_5, week_analysis_value)
        week_1 = get_weekly_samples_weights(df_adjustments, week_analysis_value, n_column=n_column)

        joined_df = week_1.join(
            week_0_5,
            week_1["PlanProd"] == week_0_5["PlanProd"],
            how="left"
        ).select(
            week_1["Planta"],
            week_1["norma"],
            week_1["PlanProd"],
            week_1[n_column],
            week_1["Ajuste_por_ML"],
            week_1["Producto_Tecnico"],
            week_0_5["total_volume"],
            week_0_5["weight_by_resistance"],
        )
        
        # Extract resistance from Producto_Tecnico (always available from week_1)
        # Use week_0_5 resistance if available, otherwise extract from Producto_Tecnico
        joined_df = joined_df.withColumn(
            "resistance",
            split(col("Producto_Tecnico"), "-")[1]
        )

        window_spec = Window.partitionBy("Planta", "norma")
        joined_df = joined_df.withColumn(
            "total_volume_sum",
            _sum("total_volume").over(window_spec)
        )
        joined_df = joined_df.withColumn(
            "weight_volume",
            when((col("total_volume_sum") == 0) | (col("total_volume_sum").isNull()), lit(None))
            .otherwise(col("total_volume") / col("total_volume_sum"))
        ).drop("total_volume_sum")

        result_df = calculate_grouped_sample_weights(joined_df, n_column=n_column)
        results.append(result_df)

        agg_df = result_df.groupBy("Planta", "norma").agg(
            _sum("new_adjust_weighted").alias("sum_new_adjust_weighted")
        )
        # Add week_analysis column, as constant value for this chunk
        agg_df = agg_df.withColumn("week_analysis", lit(week_analysis_value))

        dfs.append(agg_df)

    # Union all weeks, matching columns
    final_df = dfs[0]
    for df_next in dfs[1:]:
        final_df = final_df.unionByName(df_next)

    # Rearrange columns for clarity
    final_df = final_df.select("week_analysis", "Planta", "norma", "sum_new_adjust_weighted")
    return final_df, results