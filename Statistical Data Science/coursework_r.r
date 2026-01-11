library(ggplot2)
library(dplyr)
library(tidyr)

# Load the dataset
# Replace with correct path if needed
data <- read.csv("C:/Users/javie/Desktop/Data Pulse Analytics/GitHub/MSc-in-Data-Science-Artificial-Intelligence-and-Statistics-at-York/Statistical Data Science/CONFIDENTIALdata.csv")

# 1. Prepare Data
# Create a unique ID for each sample to group lines correctly
signal_data <- data %>% 
  mutate(sample_id = row_number()) # Create a unique ID for each sample to group lines correctly

# 2. Reshape to Long Format (Tidy Data) for ggplot
# Everything else is considered a signal reading.
long_data <- signal_data %>%
  pivot_longer(
    cols = -c(type, run_id, sample_id), # Select all columns except metadata
    names_to = "reading_index",
    values_to = "value"
  ) %>%
  # Extract the numeric index from the column name.
  # R often adds 'X' to numeric column names (e.g. "1" becomes "X1")
  # We remove any non-numeric characters to get the integer index.
  mutate(reading_index = as.numeric(gsub("[^0-9]", "", reading_index)))

# 3. Calculate Mean Lines per Type for the overlay
mean_data <- long_data %>%
  group_by(type, reading_index) %>%
  summarise(mean_value = mean(value, na.rm = TRUE), .groups = "drop")

# 4. Generate the Plot
ggplot() +
  # Layer 1: Individual sample lines (faint and colored by type)
  geom_line(data = long_data, 
            aes(x = reading_index, y = value, group = sample_id, color = type), 
            alpha = 0.2, linewidth = 0.3) +
  
  # Layer 2: Mean lines (bold, dashed, black)
  geom_line(data = mean_data, 
            aes(x = reading_index, y = mean_value), 
            color = "black", linetype = "dashed", linewidth = 0.8) +
  
  # Facet by Type to create separate panels (GS, CF, FT)
  facet_wrap(~type, ncol = 1, scales = "fixed") +
  
  # Custom Colors to match Python script
  scale_color_manual(values = c("GS" = "#008080", "CF" = "steelblue", "FT" = "lightgreen")) +
  
  # Labels and Theme
  labs(
    title = "Cyclic Voltammetry Signals by Class",
    x = "Reading Index",
    y = "Reading Value"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    strip.text = element_text(size = 12, face = "bold"),
    panel.grid.minor = element_blank()
  )

