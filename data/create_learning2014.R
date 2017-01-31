# author: Heidi Maanonen
# date: 29.1.2017
# file description: RStudio Exercise 2, Data wrangling

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep = "\t", header = TRUE)
dim(lrn14)
str(lrn14)
# Using dim() you find 183 rows i.e. respondents and 60 columns i.e. variables in the data
# Using str() you'll see the structure of the data i.e. data frames or list of the variables among their first observations

library(dplyr)
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06", "D15", "D23", "D31")
strategic_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")
surface_questions <- c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21", "SU29", "SU08", "SU16", "SU24", "SU32")
attitude_questions <- c("Da", "Db", "Dc", "Dd", "De", "Df", "Dg", "Dh", "Di", "Dj")

deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

attitude_columns <- select(lrn14, one_of(attitude_questions))
lrn14$attitude <- rowMeans(attitude_columns)

keep_columns <- c("gender", "Age", "attitude", "deep", "stra", "surf", "Points")
learning2014 <- select(lrn14, one_of(keep_columns))

str(learning2014)
colnames(learning2014)
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"
colnames(learning2014)

learning2014 <- subset(learning2014, (points > 0))
str(learning2014)
head(learning2014)

getwd()
setwd("C:/Users/heidi/Documents/YLIOPISTO/TILASTOTIEDE/INTRODUCTION TO OPEN DATA SCIENCE/IODS-project/data")
getwd()

write.csv(learning2014, file = "learning2014.csv")
read.csv("learning2014.csv", header = TRUE)

str(learning2014)
head(learning2014)

write.table(learning2014, file = "learning2014.txt")
read.table("learning2014.txt", header = TRUE)
