setwd("C:/Users/javie/Downloads/")
load('Module_Data.Rdata')

galaxy[1:10,]
nrow(galaxy)
galaxy$Clusters
galaxy[galaxy$Clusters > 10000, c('Name', "Type")]
galaxy[1, 7]

for(i in 2:6){
  print(sum(galaxy[,i])/nrow(galaxy))
}

for(i in 2:6){
  m <- sum(galaxy[,i])/nrow(galaxy)
  if (m < 1000){
    print(m)
  }
}

for(i in 1:nrow(galaxy)){

  if(galaxy$BlackHole[i] > 9){
    print(galaxy[i, "Distance"]/1000)
  }
}

galaxy[galaxy$BlackHole > 9, 'Distance']/1000

x1 <- c(3, 3.5, 4, 5, 6, 7, 10, 12, 19.5, 30)
x2 <- c(11, 11, 17, 13, 14, 24, 16,  3,  3,  0)

X <- cbind(x1, x2)
par(mar=c(4,4,1,1))
plot(X)

cor(X)

plot(galaxy[, 2:6])
cor(galaxy[, 2:6])

# Estimated parameters
mu <- mean(galaxy$Vdisp)
sigma <- sd(galaxy$Vdisp)

# Order statistics:
sort(galaxy$Vdisp)

# Standarized order statistics:
z <- (sort(galaxy$Vdisp) - mu)/sigma

# Vector of values for r:
n <- length(galaxy$Vdisp)
r <- 1:n

# Quantiles of N(0, 1)
q <- qnorm(r/(n+1))

# Normal Q-Q plot:
plot(q, z)

# Linea with intercept 0 and slope 1:
abline(a=0, b=1, col = 'red')

hist(z)

qqnorm(z)
abline(a=0, b=1, col='red')

qqnorm(galaxy$Vdisp)

par(mfrow = c(3,2))
curve(dnorm, from =-3, to = 3, main = 'True Density Function')
x <- rnorm(mean=0, sd=1, n=200)
qqnorm(x, main = 'Normal Q-Q plot hen n = 200')
x <- rnorm(mean=0, sd=1, n=30)
qqnorm(x, main = 'Normal Q-Q plot hen n = 30')
x <- rnorm(mean = 0, sd = 1, n = 30)
qqnorm(x, main = "Normal Q-Q plot when n = 30 again")
x <- rnorm(mean = 0, sd = 1, n = 10)
qqnorm(x, main = "Normal Q-Q plot when n = 10")
x <- rnorm(mean = 0, sd = 1, n = 10)
qqnorm(x, main = "Normal Q-Q plot when n = 10 again")

par(mfrow = c(2, 2))

# Sampling from the exponential distribution Exp(1):

curve(dexp, from = 0, to = 10, main = "True density")

x <- rexp(n = 200)
qqnorm(x, main = "Normal Q-Q plot when n = 200")

x <- rexp(n = 30)
qqnorm(x, main = "Normal Q-Q plot when n = 30")

x <- rexp(n = 10)
qqnorm(x, main = "Normal Q-Q plot when n = 10")

par(mfrow = c(2, 2))

# Sampling from the uniform distribution U[0,1]:

curve(dunif, from = 0, to = 1, main = "True Density Function")

x <- runif(n = 200)
qqnorm(x)

x <- runif(n = 30)
qqnorm(x)

x <- runif(n = 10)
qqnorm(x)
