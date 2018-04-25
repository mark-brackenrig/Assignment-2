### Ingest Airbnb Dataset ###

setwd("G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB")

#Read all file names in the AirBnB Dataset file
files <- list.files()

library(readr)

#Run through each file and 
for(i in 1:length(files)){
#Read file  
  if(grepl(pattern = ".csv",x = files[i])==T){
temp <- read_csv(files[i])
#call the file by the name of the csv
assign(substr(files[i], start = 0, stop = nchar(files[i])-4),temp)
#remove the temp file name
rm(temp)  }
}


