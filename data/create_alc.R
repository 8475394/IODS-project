# Author: Heidi Maanonen
# Date: 8.2.2017
# File description: RStudio Exercise 3, Data wrangling, creating joined data of secondary student alcohol consumption

# Data reference: Using Data Mining To Predict Secondary School Student Alcohol Consumption. Fabio Pagnotta, Hossain Mohammad Amran. Department of Computer Science,University of Camerino.
# Data source: https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION


library(readr)
library(tidyr)


# Reading math and por files
math <- read.csv2(file.path("C:/Users/heidi/Documents/YLIOPISTO/TILASTOTIEDE/INTRODUCTION TO OPEN DATA SCIENCE/IODS-project/data", "student-mat.csv"))
por <-read.csv2(file.path("C:/Users/heidi/Documents/YLIOPISTO/TILASTOTIEDE/INTRODUCTION TO OPEN DATA SCIENCE/IODS-project/data", "student-por.csv"))


# Exploring the structures and dimensions of both datasets
str(math) # 395 observations and 33 variables, same as dimensions
str(por) # 649 observations and 33 variables, same as dimensions


# Joining the datasets
library(dplyr)
join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery", "internet", ".math", ".por")
math_por <- inner_join(math, por, by = c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery", "internet"), suffix = c(".math", ".por"))
join_by # veryfying the right variables


# Looking inside of the joined data
colnames(math_por)
glimpse(math_por) # 382 observations and 53 variables
str(math_por) # Gives more information especially about factors


# Combining the duplicated answers with if-else structure
alc <- select(math_por, one_of(join_by))
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]
notjoined_columns


# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

glimpse(alc) # 382 observations and 33 variables


# Creating new columns of alc_use and high_use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc) # 382 observations and 35 variables


# Saving the joined and modified data set to the data folder
getwd() 
setwd("C:/Users/heidi/Documents/YLIOPISTO/TILASTOTIEDE/INTRODUCTION TO OPEN DATA SCIENCE/IODS-project/data")
getwd()
write.csv(alc, file = "student_alc.csv", row.names = FALSE)

# Checking that data reading works and r can actually use the file
student_alc <- read.csv("student_alc.csv")
str(student_alc) # 382 observations and 35 variables
glimpse(student_alc)


