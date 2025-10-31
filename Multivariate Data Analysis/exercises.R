x1 <- c(9, 2, 6, 5, 8)
x2 <- c(12, 8, 6, 4, 10)
x3 <- c(3, 4, 0, 2, 1)

X <- cbind(x1, x2, x3)
sample_mean <- colMeans(X)

x1 = c(3, 5, 5, 7, 7, 7, 8, 9, 10, 11)
x2 = c(2.3, 1.9, 1, 0.7, 0.3, 1, 1.05, 0.45, 0.7, 0.3)

X = cbind(x1, x2)
plot(X)

var(X)
cor(X)

setwd("C:/Users/javie/Downloads/")
load('Module_Data.Rdata')
summary(lizard)

sample_mean = colMeans(lizard)
sample_mean
var(lizard)
cor(lizard)

plot(lizard)
