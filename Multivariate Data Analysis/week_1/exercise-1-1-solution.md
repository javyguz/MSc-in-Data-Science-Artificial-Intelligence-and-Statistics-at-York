# Complete Solution Guide: Exercise 1.1 - Sample Covariance and Correlation Matrices

## Introduction

This document provides a complete step-by-step solution to Exercise 1.1, focusing on understanding the matrix dimensions, operations, and mathematical concepts behind calculating sample covariance and correlation matrices.

## Given Data

We have five observations of three variables X₁, X₂, and X₃:

| Variable | Obs 1 | Obs 2 | Obs 3 | Obs 4 | Obs 5 |
|----------|-------|-------|-------|-------|-------|
| X₁       | 9     | 2     | 6     | 5     | 8     |
| X₂       | 12    | 8     | 6     | 4     | 10    |
| X₃       | 3     | 4     | 0     | 2     | 1     |

## Step 1: Setting Up the Data Matrix

### Matrix Representation
The **data matrix X** is organized with:
- **Rows**: Variables (X₁, X₂, X₃)  
- **Columns**: Observations (1, 2, 3, 4, 5)

```
X = [9  2  6  5  8 ]  ← X₁ values
    [12 8  6  4  10]  ← X₂ values  
    [3  4  0  2  1 ]  ← X₃ values
```

**Matrix Dimensions**: X is a 3×5 matrix
- 3 rows (p = 3 variables)
- 5 columns (n = 5 observations)

## Step 2: Calculate the Sample Mean Vector

### Formula
For the k-th variable: X̄ₖ = (1/n) Σⱼ₌₁ⁿ Xⱼₖ

### Calculations
- X̄₁ = (9 + 2 + 6 + 5 + 8)/5 = 30/5 = 6.0
- X̄₂ = (12 + 8 + 6 + 4 + 10)/5 = 40/5 = 8.0  
- X̄₃ = (3 + 4 + 0 + 2 + 1)/5 = 10/5 = 2.0

### Sample Mean Vector
```
X̄ = [6.0]  ← Mean of X₁
    [8.0]  ← Mean of X₂
    [2.0]  ← Mean of X₃
```

**Matrix Dimensions**: X̄ is a 3×1 column vector

## Step 3: Calculate the Sample Covariance Matrix Using Equation (1.1)

### The Formula
```
S = (1/(n-1)) Σⱼ₌₁ⁿ (Xⱼ - X̄)(Xⱼ - X̄)ᵀ
```

Where:
- n = 5 observations
- n-1 = 4 (degrees of freedom)
- Each (Xⱼ - X̄) is a 3×1 column vector
- Each (Xⱼ - X̄)(Xⱼ - X̄)ᵀ is a 3×3 matrix

### Step 3a: Calculate Centered Observations (Xⱼ - X̄)

For each observation j, we subtract the mean vector:

**Observation 1**: X₁ - X̄
```
[9 ]   [6.0]   [3.0]
[12] - [8.0] = [4.0]
[3 ]   [2.0]   [1.0]
```

**Observation 2**: X₂ - X̄
```
[2]   [6.0]   [-4.0]
[8] - [8.0] = [ 0.0]
[4]   [2.0]   [ 2.0]
```

**Observation 3**: X₃ - X̄
```
[6]   [6.0]   [ 0.0]
[6] - [8.0] = [-2.0]
[0]   [2.0]   [-2.0]
```

**Observation 4**: X₄ - X̄
```
[5]   [6.0]   [-1.0]
[4] - [8.0] = [-4.0]
[2]   [2.0]   [ 0.0]
```

**Observation 5**: X₅ - X̄
```
[8 ]   [6.0]   [2.0]
[10] - [8.0] = [2.0]
[1 ]   [2.0]   [-1.0]
```

### Step 3b: Calculate Outer Products (Xⱼ - X̄)(Xⱼ - X̄)ᵀ

Each outer product is calculated as: (3×1) × (1×3) = (3×3)

**For Observation 1**:
```
[3.0]           [9.0  12.0  3.0]
[4.0] × [3.0 4.0 1.0] = [12.0 16.0  4.0]
[1.0]           [3.0   4.0  1.0]
```

**For Observation 2**:
```
[-4.0]              [16.0   0.0  -8.0]
[ 0.0] × [-4.0 0.0 2.0] = [ 0.0   0.0   0.0]
[ 2.0]              [-8.0   0.0   4.0]
```

**For Observation 3**:
```
[ 0.0]              [0.0  0.0  0.0]
[-2.0] × [0.0 -2.0 -2.0] = [0.0  4.0  4.0]
[-2.0]              [0.0  4.0  4.0]
```

**For Observation 4**:
```
[-1.0]              [1.0   4.0  0.0]
[-4.0] × [-1.0 -4.0 0.0] = [4.0  16.0  0.0]
[ 0.0]              [0.0   0.0  0.0]
```

**For Observation 5**:
```
[ 2.0]              [4.0   4.0  -2.0]
[ 2.0] × [2.0 2.0 -1.0] = [4.0   4.0  -2.0]
[-1.0]              [-2.0 -2.0   1.0]
```

### Step 3c: Sum All Outer Products

```
Sum = [9.0  12.0   3.0] + [16.0  0.0  -8.0] + [0.0  0.0  0.0] + [1.0   4.0  0.0] + [4.0   4.0  -2.0]
      [12.0 16.0   4.0]   [ 0.0  0.0   0.0]   [0.0  4.0  4.0]   [4.0  16.0  0.0]   [4.0   4.0  -2.0]
      [3.0   4.0   1.0]   [-8.0  0.0   4.0]   [0.0  4.0  4.0]   [0.0   0.0  0.0]   [-2.0 -2.0   1.0]

    = [30.0  20.0  -7.0]
      [20.0  40.0   6.0]
      [-7.0   6.0  10.0]
```

### Step 3d: Divide by (n-1) to Get Sample Covariance Matrix

```
S = (1/4) × [30.0  20.0  -7.0] = [7.50   5.00  -1.75]
            [20.0  40.0   6.0]   [5.00  10.00   1.50]
            [-7.0   6.0  10.0]   [-1.75  1.50   2.50]
```

**Matrix Dimensions**: S is a 3×3 symmetric matrix

### Understanding the Covariance Matrix Elements

- **S₁₁ = 7.50**: Variance of X₁
- **S₂₂ = 10.00**: Variance of X₂  
- **S₃₃ = 2.50**: Variance of X₃
- **S₁₂ = S₂₁ = 5.00**: Covariance between X₁ and X₂
- **S₁₃ = S₃₁ = -1.75**: Covariance between X₁ and X₃
- **S₂₃ = S₃₂ = 1.50**: Covariance between X₂ and X₃

## Step 4: Calculate the Sample Correlation Matrix

### Formula
For correlation coefficient between variables i and k:
```
rᵢₖ = Sᵢₖ / √(SᵢᵢSₖₖ)
```

### Calculate Standard Deviations
- √S₁₁ = √7.50 = 2.7386
- √S₂₂ = √10.00 = 3.1623  
- √S₃₃ = √2.50 = 1.5811

### Calculate Correlation Coefficients

**r₁₂ (Correlation between X₁ and X₂)**:
```
r₁₂ = S₁₂ / √(S₁₁S₂₂) = 5.00 / √(7.50 × 10.00) = 5.00 / √75.00 = 5.00 / 8.6603 = 0.5774
```

**r₁₃ (Correlation between X₁ and X₃)**:
```
r₁₃ = S₁₃ / √(S₁₁S₃₃) = -1.75 / √(7.50 × 2.50) = -1.75 / √18.75 = -1.75 / 4.3301 = -0.4041
```

**r₂₃ (Correlation between X₂ and X₃)**:
```
r₂₃ = S₂₃ / √(S₂₂S₃₃) = 1.50 / √(10.00 × 2.50) = 1.50 / √25.00 = 1.50 / 5.0000 = 0.3000
```

### Sample Correlation Matrix R

```
R = [1.0000   0.5774  -0.4041]
    [0.5774   1.0000   0.3000]
    [-0.4041  0.3000   1.0000]
```

**Matrix Dimensions**: R is a 3×3 symmetric matrix with 1's on the diagonal

## Alternative Matrix Calculation Method

The covariance matrix can also be calculated using the centered data matrix approach:

### Create Centered Data Matrix
```
(X - X̄) = [3.0  -4.0   0.0  -1.0   2.0]
          [4.0   0.0  -2.0  -4.0   2.0]
          [1.0   2.0  -2.0   0.0  -1.0]
```

### Matrix Multiplication Formula
```
S = (1/(n-1)) × (X - X̄)(X - X̄)ᵀ
```

Where:
- (X - X̄) is 3×5
- (X - X̄)ᵀ is 5×3  
- The result is 3×3

This gives the same result as the step-by-step outer product method.

## Key Matrix Dimension Summary

| Matrix/Vector | Dimensions | Description |
|---------------|------------|-------------|
| X | 3×5 | Data matrix (variables × observations) |
| X̄ | 3×1 | Sample mean vector |
| Xⱼ - X̄ | 3×1 | Each centered observation |
| (Xⱼ - X̄)(Xⱼ - X̄)ᵀ | 3×3 | Each outer product matrix |
| S | 3×3 | Sample covariance matrix |
| R | 3×3 | Sample correlation matrix |

## Final Answer

**Data Matrix X**:
```
[9  2  6  5  8 ]
[12 8  6  4  10]
[3  4  0  2  1 ]
```

**Sample Mean Vector X̄**:
```
[6.0]
[8.0] 
[2.0]
```

**Sample Covariance Matrix S**:
```
[7.50   5.00  -1.75]
[5.00  10.00   1.50]
[-1.75  1.50   2.50]
```

**Sample Correlation Matrix R**:
```
[1.0000   0.5774  -0.4041]
[0.5774   1.0000   0.3000]
[-0.4041  0.3000   1.0000]
```

This solution demonstrates all matrix operations explicitly, showing how each dimension transforms through the calculations and providing complete understanding of the mathematical procedures involved.