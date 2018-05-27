#Index File
WD <- "C:/Users/mbrackenrig/Documents/Assignment-2" #input the path to the local github repo

Gdrive <- "G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB" #input the path to the AirBnB data set file on gdrive

setwd(WD)

#Pull in data
source("Preprocessing/ReadAirbnb.r")

setwd(WD)

#Clean data - Put it in correct formate, etc..
source("Preprocessing/Cleaning.r")

#Start building features from the cleaning phase
source("Preprocessing/Feature Engineering.r")

#Build a modelling table
source("Preprocessing/Modelling Table.r")

#Create a model

source("Model/Price & Occupancy Model.r")

#visualisations

source("EDA/Amenities Princomp Plots.r")

source("EDA/Charts.r")