##### Getting Started with RStudio #####

### Getting familiar with coding

# Simple addition
1 + 2

# Create an object called firstLine that has the value of hello world :).
firstLine <- "hello world :)" 
# The object should appear in the Environment window in the top right.
# Use the function print() to display in the console the value of firstLine.
print(firstLine)

# Objects can also be calculated.
firstNumber <- 6 + 3 + 2
secondNumber <- 4 + 7 + 8

# Use objects to create new objects based on their values.
newNumber <- secondNumber - firstNumber
# Print this value in the console
print(newNumber)

# Use the function c() to combine different values of the same type into a vector.
treeHeights <- c(22, 25, 28, 18, 20)
colours <- c("red", "blue", "green", "yellow", "pink")

# Use the matrix() function to create a matrix of values of the same type.
temperatureLocation <- matrix(c(7,3,6,5), nrow = 2, byrow = TRUE)

# Use the data.frame() function to combine different vectors of variables into a data frame where different variables are represented by different columns and each row contains a different observation.
treeData <- data.frame(treeHeights, colours)
# In the Environment the data frame will appear under a Data subheading. If you click on the name of the data frame a new tab next to your RScript will appear where you can view the data frame.

# The following functions can be used to describe the structure of the data and check data is being read into Rstudio as expected.
# In particular word data is being read in as characters and number data is being read in as numbers. Missing data should be being identified as a ‘.’ in the data frame.
names(treeData)
str(treeData)
head(treeData)

### Getting Data In

# Tell RStudio which folder the data is stored in.
# Copy and paste the folder path into the setwd() function. Setwd() stands for set working directory. 
# In the folder path the slashes should be changed to be in this / direction, and not \
setwd("C:/Users/javie/Downloads/")

# Data can be read into RStudio from a range of file formats. This example will use a .csv file (comma separated values) and the read.csv() function.
# Set the name of the file in the read.csv function to the name of your data file. You need to include .csv after the name of the file. 
# header = TRUE argument means that the names of each variable are included in the first row of the data set and R will use these as the variable names in the data frame.
# sep = ‘,’ argument indicates that in the data file different values are separated by commas
data <- read.csv("RStudio Data.csv", header = TRUE, sep = ',')


### Installing packages 
# Functions that we want to use are stored in different packages.
# There are lots of different packages that contain functions specific to different purposes. 
# Packages only need to be installed once! 
# Every now and then you may need to update a package
# To install a package use the install.packages() function with the name of the package.
install.packages("psych") # psych contains functions to manage and analyse data commonly used by psychologists
install.packages("dplyr") # dplyr contains functions to manipulate data
install.packages("ggplot2") # ggplot contains functions to make graphs
install.packages("ggsignif") # ggsignif contains functions that can be used with ggplot graphs to add indicators of significance
install.packages("plotly") # plotly contains functions to make graphs interactive

### Loading packages
# Everytime you open RStudio you need to load the packages that contain the functions you will use. 
# You only need to do this once when you start your new session in RStudio.
# Use the library() function to do this.
library(psych)
library(ggplot2)
library(dplyr)
library(ggsignif)
library(plotly)

### Descriptive Statistics

# To calculate descriptive statistics in R there are a few methods. 
# The summary function calculates the mean, median and quartile values of continuous data.
# If categorical data is included in the data it just tells you the length.
# You can call the whole data set into the summary function to calculate descriptive statistics of all variables
summary(data)
# Or you can use the $ operator to call specific variables from data
summary(data$Ducks)

# Functions can also be nested in other functions. For example the round() function to round the output can be used within the summary() function
# The digits = 0 argument of the round() function specifies to round to 0 decimal places, as such whole numbers. This argument can be changed to round to different numbers of decimal places.
summary(round(data$Ducks), digits=0)

# Another method to specify data is to use indexing.
# Indexing uses square brackets after the name of the data.
# The first number in the square bracket indicates the row, the second number indicates the column. A comma separates the two numbers. E.g. [row,column]
# If no number is specified then all rows or columns will be called.
# For example these square brackets will index all rows and only column 13.
summary(data[,13])
# A colon can be used to specify all values between a minimum and maximum value.
# For example below will index the first 50 rows for all columns.
summary(data[1:50,])
# You can combine this together to calculate the descriptive statistics for the first 50 observations (rows) for the 13th and 14th variables (columns).
summary(data[1:50,13:14])

# If you just wanted to calculate the means of the different variables you could use the lapply() function. This function will apply the specified function to every variable in the data. 
# For example the code below will apply the mean function to every column in the data
lapply(data, mean)
# However this will create a warning message as you cannot calculate a mean of the categorical variables in the data.
# To remove the warning message use indexing to specify calculating the mean of only columns that have continuous data
lapply(data[,3:14], mean)
# To calculate descriptive statistics of a continuous variable for each group of a categorical variable you could use the tapply() function which splits the data by a categorical variable and applies a function to a different variable.
# For example below will calculate the mean number of animals for each faculty group.
tapply(data$Number.of.animals, data$Faculty, mean)

# Another method to calculate descriptive statistics is to use different functions from specific packages. 
#For example the describe() function from the psych package calculates the mean, median, standard deviation, skew, kurtosis and other descriptive statistics for continuous variables and displays them in a table.
# Be careful however it also attempts to calculate these descriptive statistics for categorical variables when this might be inappropriate. 
describe(data)
# If you want to calculate descriptive statistics for each group of a categorical variable use describeBY. 
# For example this calculates descriptive statistics for the number of animals for each faculty group.
describeBy(data$Number.of.animals, group = data$Faculty)


### Data Management
# This section covers some techniques that are commonly used when organising data.
# For your own data you may need to use some of these or others may be more appropriate.

# To create a subset of the variables in your data set use cbind() to bind together selected columns, alongside as.data.frame() to assign this object as a data frame.
dataNew <- as.data.frame(cbind(data$Degree.Level, data$Faculty, data$Number.of.animals, data$Average.Opinion))
# You will need to change the column names, as they get reassigned as V1, V2, ect. 
colnames(dataNew) <- c("Degree", "Faculty", "Number", "Opinion")

# When you create a new subset sometimes the type of data is changed, and becomes incorrect. For example the numbers may incorrectly be recognised as characters.
# To correct this use as.integer() and as.numeric()
dataNew$Number <- as.integer(dataNew$Number)
dataNew$Opinion <- as.numeric(dataNew$Opinion)

# To create a subset of the participants or observations use the subset function().
# You can use different mathematical and logical operators to filter data.
onlyScience <- subset(dataNew, Faculty=="Science")
highOpinion <- subset(dataNew, Opinion >= 3)

# Another method to subset a data set is using indexing.
# You can use a which() function within indexing to index only rows or columns which meet certain criteria.
onlyScience2 <- dataNew[which(dataNew$Faculty=="Science"),]
# You can use & to specify more than one criteria.
scienceOpinion <- dataNew[which(dataNew$Faculty=="Science" & dataNew$Opinion >= 3),]

# To recode a variable you can use mutate().
dataNew <- dataNew %>% mutate(Faculty=recode(Faculty, "Science" = "Science", "SocSci" ="Social Sciences", "Arts&Hu" = "Arts and Humanities"))

# mutate() can also be used to create new variables based off other variables or combinations of variables.
dataNew <- dataNew %>% mutate(OpinionGroup = if_else(dataNew$Opinion >= 3, "High", "Low"))
# Another method to create new variables is to use the $ operator to add a new variable to a data set.
dataNew$NumberPerDay = dataNew$Number / 7

# To save the data frame as a data file use write.csv
# You can also write data frames into other file formats.
write.csv(dataNew, "dataNew.csv")


### Graphs
# There are lots of functions that can be used to make graphs 
# This section will focus on using ggplot() 

# To create a graph first use the ggplot() function and call the name of the data frame inside the brackets.
# We will then add (+) additional functions to this to create the graph. 
# Adding a geom_ creates the type of graph. 
# You always need to use the aes(), which stands for aesthetics, function either within ggplot() or within geom_().
# Assign the plot as an object so that you can use it with other functions.
barPlot <- ggplot(dataNew) + geom_bar(aes(x=Faculty, y=Number), stat = "identity")
barPlot

# You can create ggplots off any data frame or summary statistics table. 
# Use stat_summary() to calculate statistics to display in a plot from a data frame.
barPlot <- ggplot(dataNew, aes(x=Faculty, y=Number)) +
stat_summary(fun.data=mean_sdl, geom="bar")
barPlot

# You can add more than one geom_() or stat_summary() to add additional elements to graphs. 
barPlot <- ggplot(dataNew, aes(x=Faculty, y=Number)) +
stat_summary(fun = mean, geom="bar") +
stat_summary(fun = mean, geom = "errorbar", fun.max = function(x) mean(x) + sd(x), fun.min = function(x) mean(x) - sd(x)) 
barPlot

# There are many different packages that you can install and use alongside ggplot to add additional features. 
# geom_signif() comes from the package “ggsignif”
barPlot <- ggplot(dataNew, aes(x=Faculty, y=Number)) + stat_summary(fun = mean, geom="bar") + 
stat_summary(fun = mean, geom = "errorbar", fun.max = function(x) mean(x) + sd(x), fun.min = function(x) mean(x) - sd(x)) + 
geom_signif(comparisons = list(c("Arts and Humanities", "Science"), c("Arts and Humanities", "Social Sciences"), c("Science", "Social Sciences")), map_signif_level=TRUE)
barPlot

# There are also lots of functions that can be used to make the graphs look how you would like to.
# Some of these have features to make graphs accessible such as the viridis colour themes.
barPlot <- ggplot(dataNew, aes(x=Faculty, y=Number, fill = Faculty)) + 
stat_summary(fun = mean, geom="bar") + 
stat_summary(fun = mean, geom = "errorbar", fun.max = function(x) mean(x) + sd(x), fun.min = function(x) mean(x) - sd(x), width = 0.4) + 
geom_signif(comparisons = list(c("Arts and Humanities", "Science"), c("Arts and Humanities", "Social Sciences"), c("Science", "Social Sciences")), map_signif_level=TRUE, y_position = c(48, 52, 44)) +
theme_classic() +
scale_y_continuous(limits = c(0,60), expand = expansion(mult = 0)) +
scale_fill_viridis_d(option = "C") +
theme(legend.position="none") 
barPlot

# To save your graph
ggsave("bargraph.png")

# To make your graph interactive using the “plotly” package
ggplotly(barPlot)

