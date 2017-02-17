# Author: Heidi Maanonen
# Date: 17.2.2017
# File description:

# Reading the "Human development" data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# Reading the "Gender Inequality" data
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


# Structure, dimensions and summary of hd

str(hd) # 195 observations and 8 variables: 2 integers, 2 character and 4 numeric (continous) variables
dim(hd) # Same values than above
summary(hd) # There are some missing values
table(is.na(hd)) # 14 missing values


# Structure, dimensions and summary of gii

str(gii) # 195 observations and 10 variables: 2 integers, 1 character and 7 numeric (continuous) variables
summary(gii) # There are some missing values
table(is.na(gii)) # 132 missing values



# Creating short names of Human development data
colnames(hd) # Printing just the column names 

library(dplyr)
hd <- rename(hd, HDI_rank = HDI.Rank,
       country = Country,
       HDI_index = Human.Development.Index..HDI.,
       Elife = Life.Expectancy.at.Birth, 
       Eedu = Expected.Years.of.Education,
       Medu = Mean.Years.of.Education,
       GNIpc = Gross.National.Income..GNI..per.Capita,
       GH_rank = GNI.per.Capita.Rank.Minus.HDI.Rank)

colnames(hd) # Verifying the column names

# HDI_rank = The rank of a country in the Human development index
# country = Country
# HDI_index = Human development index per country
# Elife = Expected life years at birth per country
# Eedu = Expected years of schooling per country
# Medu = Mean years of schooling per country
# GNIpc = Gross national income per capita per country in PPP (https://en.wikipedia.org/wiki/Purchasing_power_parity)
# GH_rank = Gross national income per capita rank minus HDI rank 



# Creating short names of Gender inequality data

colnames(gii) # Printing just the column names

gii <- rename(gii,
              GII_rank = GII.Rank,
              country = Country,
              GII_index = Gender.Inequality.Index..GII.,
              mort_ratio = Maternal.Mortality.Ratio,
              ad_birth = Adolescent.Birth.Rate,
              seats = Percent.Representation.in.Parliament,
              SFedu = Population.with.Secondary.Education..Female.,
              SMedu = Population.with.Secondary.Education..Male.,
              Flabour = Labour.Force.Participation.Rate..Female.,
              Mlabour = Labour.Force.Participation.Rate..Male.)

colnames(gii) # Verifying the column names

# GII_rank = The rank of a country in the Gender inequality index
# country = Country
# GII_index = Gender inequality index per country
# mort_ratio = Maternal mortality ratio (deaths per 100,000 live births)
# ad_birth = Adolescent birth rate (births per 1,000 women ages 15-19)
# seats = Share of seats in parliament (% held by women)
# SFedu = Females, Population with at least some secondary education (% ages 25 and older)
# SMedu = Males, Population with at least some secondary education (% ages 25 and older)
# Flabour = Females, Labour force participation rate (% ages 15 and older)
# Mlabour = Males, Labour force participation rate (% ages 15 and older


# Creating 2 new variables

gii <- mutate(gii, SFM_edu = SFedu / SMedu, FMlabour = Flabour / Mlabour)
colnames(gii)


# Joining the datasets

join_by <- c("country")
human <- inner_join(hd, gii, by = c(join_by), suffix = c(".hd", ".gii"))

colnames(human)
glimpse(human) # 195 observations and 19 variables


# Saving the create_human and joined "human" datset to the data folder

setwd("C:/Users/heidi/Documents/YLIOPISTO/TILASTOTIEDE/INTRODUCTION TO OPEN DATA SCIENCE/IODS-project/data")
getwd()
