qchisq(0.5, 2)

# Exercise 2.5
setwd("C:/Users/javie/Downloads/")
load('Module_Data.Rdata')
summary(stiff)

# Turn each column of data into
# a separate vector in R:
plot(stiff)

attach(stiff) 

# Request plots in a 3x3 array:
par(mfrow = c(3,3))

qqnorm(x1)
qqnorm(x2)
qqnorm(x3)
plot(x1,x2)
plot(x1,x3)
plot(x2,x3)

install.packages("heplots")
library("heplots")
cqplot(stiff)
