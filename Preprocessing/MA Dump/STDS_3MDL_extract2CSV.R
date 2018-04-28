#### Environment setup ####

# set the working directory for R and confirm it is correct

setwd("G:\\Team Drives\\STDS - Assignment 2 - 3MDL\\Dataset")
getwd() 

# check java version
system("java -version")

# set environment variable for java - this is not required if already been added to o/s system variables

Sys.setenv(JAVA_HOME = "C:/Program Files/Java/jdk/")

# Install and load packages

install.packages("XLConnectJars")  #dependency, called by XLConnect
install.packages("XLConnect")

library(XLConnect)

#### extract sheets to CSV files from Excel workbooks ####

# Note: Workbook name and dir are currently hard coded in the .vbs
#       Could be set to read an array of file names
#       

# move to required directory
setwd("Accommodation")
wd <- paste(getwd(),"/ExtractSheets2CSV.vbs", sep="")
wd


## get workbook names  (use later to loop through workbooks)
# wbnames <- list.files(getwd(),pattern=".xlsx")

# run VB script to extract the files into a new directory
shell(shQuote(normalizePath(wd)), "cscript", flag = "//nologo")

# change back to team working directory
setwd("..")
getwd()


