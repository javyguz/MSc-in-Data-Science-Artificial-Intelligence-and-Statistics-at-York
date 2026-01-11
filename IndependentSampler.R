install.packages("ISLR")

library(ISLR)
data(Default, package="ISLR")
Def2 <- Default %>% 

mutate(default = as.integer(as.character(default) == "Yes")) %>%
mutate(student = as.integer(as.character(student) == "Yes"))
#-----TO ENSURE THAT THE PIPE SYNTAX IS RECOGNISED------
#install.package("dplyr")
#library(dplyr)
#-----------INVOKE NORMAL(0,10^2) PRIORS ON EACH BETA----------
#----WHAT HAPPENS IF YOU CHANGE THE MEAN & VAR OF THE PRIOR DENSITY?
prior <- function(betas){return(prod(sapply(betas, dnorm, mean=0, sd=10)))}
