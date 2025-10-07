x <- seq(from = -6, to = 6, by = 0.5)
y <- sin(x)

# Set the layout and margin widths:
par(mfrow = c(1, 1), mar = c(4, 4, 3, 1)) 

# Plot y against x:
plot(x, y,
     main= "Graph with \nTwo Lines",
     pch = 8,
     col = rainbow(10),
     cex = 1.5,
     xlab = expression(theta),
     ylab = expression(sin(theta)),
     xlim = c(-10, 10),
     ylim = c(-10, 10),
     cex.axis = 1,
     cex.main = 1,
     cex.lab = 1,
     type = "l",
     lwd = 4,
     lty = 5)

curve(expr = sin, from = -6, to = 6,
      main = 'plot of the sin function',
      col='blue',
      xlab = expression(theta),
      ylab = expression(sin(theta),
      cex.axis = 1.2,
      cex.main = 1.5,
      cex.lab = 1.2,
      lwd = 2,
      lty = 1))

abline(h = 0)
abline(v = -6:6, lty = 2, col = "gray")
abline(a = 0, b = 0.5, col = "red3")
abline(a = 1, b = 0.25, col = "red1")
