# Author: Heidi Maanonen

# Original Date: 17.2.2017
# Continuing the Human data wrangling, Date: 19.2.2017

# File description 1: Initial Data Wrangling for next week's exercise (Dimensionality reduction techniques)
# File description 2: Data Wrangling for Dimensionality reduction techniques

# Data Reference: "http://hdr.undp.org/en/content/human-development-index-hdi"


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
hdnew <- rename(hd, HDI_rank = HDI.Rank,
       country = Country,
       HDI_index = Human.Development.Index..HDI.,
       Elife = Life.Expectancy.at.Birth, 
       Eedu = Expected.Years.of.Education,
       Medu = Mean.Years.of.Education,
       GNIpc = Gross.National.Income..GNI..per.Capita,
       GH_rank = GNI.per.Capita.Rank.Minus.HDI.Rank)

colnames(hdnew) # Verifying the column names

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

giinew <- rename(gii,
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

colnames(giinew) # Verifying the column names

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

giinew <- mutate(giinew, SFM_edu = SFedu / SMedu, FMlabour = Flabour / Mlabour)
colnames(giinew)


# Joining the datasets

join_by <- c("country")
human <- inner_join(hdnew, giinew, by = c(join_by), suffix = c(".hdnew", ".giinew"))

colnames(human)
glimpse(human) # 195 observations and 19 variables
str(human)


# Saving the create_human and joined "human" datset to the data folder

setwd("C:/Users/heidi/Documents/YLIOPISTO/TILASTOTIEDE/INTRODUCTION TO OPEN DATA SCIENCE/IODS-project/data")
getwd()


# Continuing the Wrangling

library(tidyr) 
library(stringr)
library(dplyr)

# Mutating the GNI variable to numeric
str(human$GNIpc)
human$GNIpc <- str_replace(human$GNIpc, pattern= ",", replace="") %>% as.numeric(human$GNIpc)
str(human$GNIpc) # verifying the numeric content

# Excluding unneeded variables, keeping the columns country (Country),SFM_edu (Edu2.FM), FMlabour (Labo.FM), 
# Eedu (Edu.Exp), Elife (Life.Exp), GNIpc (GNI), mort_ratio (Mat.Mor), ad_birth (Ado.Birth), seats (Parli.F)

keep <- c("country", "SFM_edu", "FMlabour", "Eedu", "Elife", "GNIpc", "mort_ratio", "ad_birth", "seats")
human <- select(human, one_of(keep))
str(human) # Verifying the content: 195 observation and 9 variables


# Removing rows with missing values

complete.cases(human)
comp <- complete.cases(human)
data.frame(human[-1], comp = complete.cases(human)) # TRUE are the complete cases without NA:s
str(human) 

# Removing the rows with missing values 

human_ <- filter(human, comp == TRUE)
str(human_) # 162 observations and 9 variables


# Removing the observations which relate to regions instead of countries

tail(human_, 20) # last 7 variables are regions
last <- nrow(human_) - 7
human_ <- human_[1:last,]
tail(human_, 10) # veryfying the tail

# Defining the row names of the data by the country names 
rownames(human_) <- human_$country
str(human_) # 155 observations and 9 variables 
colnames(human_)

# Removing the country name column from the data
human_ <- dplyr::select(human_, -country)

# Saving the Dataset
write.csv(human_, file = "human_1.csv", row.names = TRUE)

# Checking that data reading works and r can actually use the file
human_1 <- read.csv("human_1.csv")
str(human_1)

