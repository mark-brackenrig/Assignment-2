## Codebase example ##

#### Read data ####

setwd("C:/Users/mbrackenrig/Desktop/University/Sem1_18/Statistical Thinking for Data Science/Assignment 2/AirBnB Data Set")


# Quick Ingestion of Data
library(readr)
listings <- read_csv("Data/listings.csv")
calendar <- read_csv("Data/calendar.csv")
reviews <- read_csv("Data/reviews.csv")


# Google Distane Matrix 

library(gmapsdistance)

##PLZZZ Dont use my API KEy
set.api.key('API_KEY_HERE!!!!')

#gmapsdistance(origin, destination, combinations, mode, key,
#shape, avoid, departure, dep_date, dep_time,
#traffic_model, arrival, arr_date, arr_time)

