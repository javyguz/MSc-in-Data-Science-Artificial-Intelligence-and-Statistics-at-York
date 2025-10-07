# Create three vectors
var1 <- c(9, 2, 6, 5, 8)
var2 <- c(12, 8, 6, 4, 10)
var3 <- c(3, 4, 0, 2, 1)

# Create a matrix
X = cbind(var1, var2, var3)

# Calculat the mean sample
mean_vector <- colMeans(X)

