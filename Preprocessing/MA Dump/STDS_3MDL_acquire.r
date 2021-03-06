#### Environment setup ####

# set the working directory for R and confirm it is correct

setwd("G:\\Team Drives\\STDS - Assignment 2 - 3MDL\\Dataset")
getwd() 

## Note: these require JAVA to be installed.  Using v8+ in this code

# check java version ... returns error if JAVA not installed so go and get it!
system("java -version")

# set environment variable for java - this is not required if already been added to o/s system variables

Sys.setenv(JAVA_HOME = "C:/Program Files/Java/jdk/")

#### using package: XLConnect ####

install.packages("XLConnect")
install.packages("XLConnectJars")  #dependency, called by XLConnect
install.packages("reshape2")       #has recast()
install.packages("tidyverse")
library(XLConnectJars)
library(XLConnect)
library(reshape2)
library(tidyverse)

## EXAMPLE OF SYNTAX
##
# demoExcelFile <- system.file("demoFiles/mtcars.xlsx", package = "XLConnect")
# mm <- as.matrix(readWorksheetFromFile(demoExcelFile, sheet=1))
# class(mm)<-"character" # convert all to character
# which(mm=="3.435", arr.ind=T)
# read.table(text=apply(mm[25:27, 6:8],1,paste, collapse="\t"), sep="\t")


## DATA MUNGING OBJECTIVE
##
## Steps followed in Excel that should be reproduced/improved on
##
# A7 = country name
# A8:L18 = first block
# Transpose first block (not required?)
# tidy row labels
# Append block name
# Add missing col labels
# copy years down
# transponse next block without row/col labels
# repeat 2-4
# create new column, col name = Country, constant value =  file name
# merge with other country files


## Read in first block - need to get data for this block from each of the spreadsheets

## better approach
base_path <- getwd()
base_path
wb_filename <- loadWorkbook("Accommodation/IVS1 YE Dec 2017_UpdatedMar2018.xlsx")
wb_fullpath <- paste(base_path, wb_filename, sep="")

# Set up excel ranges to read in remaining blocks of data from the workbook
rs <- 8
re <- rs + 5

# starting with block1=visitors from sheet="China"
B1_raw <- readWorksheetFromFile(wb_fullpath, sheet = "China", startRow = 8, startCol = 1,
                               endRow = 10, endCol = 12 )
#rm(B1_raw, B1_t, B1, wb, wb_filename, base_path, wb_fullpath)
str(B1_raw)
dim(B1_raw)
View(B1_raw)

## (not required .... transpose the block - swap rows and columns
#B1_t <- as.data.frame(t(as.matrix(B1_raw))) ### TO DO: fix this!   messes up the col ###
#View(B1_t)   
## Note: Martin is using melt() instead of t()

## Transpose Purpose & Year down the rows, final structure is ...
##   Year, Country, Purpose, Visitors, Spend, Nights etc

###
# see spreadsheet 'Munging.xlsx' for mockup.
###


# create new columns: 
#   Country = sheet name (or A7)
# (not required) Purpose  = col1 name                     ### TO DO: pass col1 name to new Reason column ###
#   Col1 name & "Year" = 2007 to 2017

# work out number of times to populate 'Country'
CR <- length(B1$Purpose)     ### This is referenced in the mutate statement

# work out how many times to repeat the pattern of years
K <- unique(B1$Purpose)
yrs <- as.factor(c(2007:2017))
all_yrs <- rep(Z,K)                

# add column vector "Country", populate with Sheet name
# add a column vector "Year", populate 2007 to 2017 for each block
B1 <- mutate(B1_raw, Country = rep("sheetname":CR), 
                    Year = all_yrs)
View(B1)

# move new columns to begining of data frame
B1 <- select(B1, Year, Country, Purpose, everything())
View(B1)


# Set up excel ranges to read in remaining blocks of data from all sheets in the workbook

rs <- 8
re <- rs + 9
rs1 <- re + 3
re1 <- rs1 +9


# loop through all these ... rs2 = re1 + 3 = rs2 + 9 for all data blocks

rs2 <- re1 + 3
re2 <- rs2 + 9

# have a look at what we've got

str(B1)
B1
B2
B3


#### Merging ideas ####

## Create subset for matching against AirBnB listings
## bring all the blocks together and pull out columns: Business, Non-Business, Total
## Business =Business + Work, Non-Business =Total - Business - Work

# set each block to a matrix
# ... use: matrix() ...
B1m <- as.matrix(B1)

# create a list of matrices
blocklist <- list(B1m, B2m, B3m)

## transpose the blocks

B1
B1_t <- as.data.frame(t(as.matrix(B1)))
B1_t


# Extract columns of interest
# ...  use: sapply(), lapply()  ...


## Roll up AirBnB listings to match against travel data set 
## by city, business ready (for more groupings, add to the 'by=' argument)
## selecting only listings with specific factors

F <- abnblist[abnblist$cancellation_type=="Flexible"
              aggregate(F$number_of_reviews, by=F["city", "is_business_travel_ready"], FUN=sum)
              
              # at example using flights data object
              by_day <- group_by(flights, year, month, day)
              summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
              
              ## Merge matching AirBnB listings with Travel stats - matching on City, Year, Business/non-business
              ## ... take one data frame and add extra columns, sourced from the second data frame
              ## ... result is single aggregated data frame


#### Abandoned: XLConnect - first approach ####

# work out where the data is in the source workbook

mm <- as.matrix(readWorksheetFromFile("Accommodation/IVS1 YE Dec 2017_UpdatedMar2018.xlsx", sheet=2))
class(mm)<-"character" # convert all to character

rc <- which(mm=="VISITOR NIGHTS", arr.ind=T)
rc
### use mapply() ?? to get row number and col number from rc

# read in  blocks of data from the workbook

rs <- 8
re <- rs + 9
rs1 <- re + 3
re1 <- rs1 +9

B1 <- read.table(text=apply(mm[rs:re, 1:12],1,paste, collapse="\t"), sep="\t")
B2 <- read.table(text=apply(mm[rs1:re1, 1:12],1,paste, collapse="\t"), sep="\t")

# loop through all these ... rs2 = re1 + 3 = rs2 + 9 for all data blocks

rs2 <- re1 + 3
re2 <- rs2 + 9
B3 <- read.table(text=apply(mm[rs2:re2, 1:12],1,paste, collapse="\t"), sep="\t")

# have a look at what we've got

str(B1)
B1
B2
B3

## Add this to the loop above:
## In each block ... 
##
## 1. Pull out a specific row  to use as column headings
##
## 2. replace leading text 'YEAR ENDING DECEMBER' with rs
##    'YEAR ENDING DECEMBER 2007' becomes 'VISITORS 2007'
##
## 3. Rename column 1 as 'REASON'
##
## 4. Add a new column 'COUNTRY' populated with cell value A7
##
## 5. (not this one) recast() COUNTRY, REASON as id, others as measure
##     B1 <- recast(B1, variable ~ variable, id.var = 1:2)


# Pull out column headings
## this isn't a good way to do it
Bcols <- read.table(text=apply(mm[7:8, 1:12],1,paste, collapse="\t"), sep="\t")
Bcols

# 4. create new column with country name
B1_new <- mutate(B1, country = "China")


# read in country name from cell A7
country1 <- read.table(text=apply(mm[6:6, 1:1],1,paste, collapse="\t"), sep="\t")
country1

# create new column vector with blockname 
# ... use: values rs:1, rs1:1 etc

# add column vector "Country", populate with Sheet name
CR <- length(B1$Purpose)
B1_final <- mutate(B1,Country = c(sheetname:CR))

# add a column vector "Year", populate 2007 to 2017 for each block
##... create empty column ...
##... populate with the following ...
K <- unique(B1$Purpose)
Y <- c(rep(2007,K):rep(2017,K)
lapply(Y)  ### finish this line !!

# Remove rows with 'Total'


#### Abandonded ... using package: excel.link ####
#install.packages("excel.link")
#library(excel.link)

# xl.workbook.open(filname, password=null)
# xl.workbook.activate(Xl.workbook.name)
# xl.workbook.close(filname, password=null)

# also xl.sheets

# xl.read.file(filename, header = TRUE, row.names = NULL, col.names = NULL,
#            xl.sheet = NULL, top.left.cell = "A1", na = "", password = NULL, 
#            excel.visible = FALSE)


# xl.save.file(r.obj, filename, row.names = NULL, col.names = NULL,
#            xl.sheet = NULL, top.left.cell = "A1", na = "", password = NULL, 
#            excel.visible = FALSE)

#### Abandonded ... using package: xlsx ####
install.packages("xlsx")
library("xlsx")

# read.xlsx2(file, sheetIndex, sheetName=NULL, startRow=1,
#            colIndex=NULL, endRow=NULL, as.data.frame=TRUE, header=TRUE,
#            colClasses="character", ...)


