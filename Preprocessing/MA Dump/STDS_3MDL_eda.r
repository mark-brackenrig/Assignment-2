
#### Environment setup ####

#set the working directory for R and confirm it is correct

setwd("G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset")
getwd() 

## Install and load packages

install.packages("tidyverse")
install.packages("DataExplorer")

library(tidyverse)
library(DataExplorer)

#### EDA -reduced AirBnB data set ####

## change to required sub directory
#setwd("AirBnB/TomSlee_version")
#setwd("Accommodation")
#getwd()

abnblst_filename = "/TomSlee_version/tomslee_airbnb_sydney_1523_2017-07-23.csv"
chiv_filename = "/Accommodation/China_IV.csv"

##
## Note: When reading in complete set of files...
##
## #read in file names and use lapply() to read in the files
## filenames <- list.files(getwd(),pattern=".txt")
## #read files into a character vector
## files <- lapply(filenames,readLines)
## #check the correct number of files loaded 
## length(files)
##       

abnblist <- read_csv(abnblst_filename)
chiv <- read_csv(chvi_filename)

data_list <- list(abnblist, chiv)
plot_str(data_list)

plot_str(data_list, type = "r")

