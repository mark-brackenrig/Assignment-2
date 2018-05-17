#Index File
WD <- "C:/Users/mbrackenrig/Documents/Assignment-2" #input the path to the local github repo

Gdrive <- "G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB" #input the path to the AirBnB data set file on gdrive

setwd(WD)

#Pull in data
source("Preprocessing/ReadAirbnb.r")

setwd(WD)

#Clean data - Put it in correct formate, etc..
source("Preprocessing/Cleaning.r")


