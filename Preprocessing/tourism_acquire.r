# This file takes the tourism spreadsheet data and turns into a tidy dataset

## Note: these require JAVA to be installed.  Using v8+ in this code

# check java version ... returns error if JAVA not installed so go and get it!
system("java -version")

# set environment variable for java - this is not required if already been added to o/s system variables
Sys.setenv(JAVA_HOME = "C:/Program Files/Java/jdk/")

# url <- "https://www.tra.gov.au/ArticleDocuments/233/IVS1%20YE%20Dec%202017.xlsx.aspx"
# Need to get data manually and place in drive, since website does support direct access (instead streams data through aspx page)

# Install required packes if not already installed: 
# XLConnect,  XLConnectJars - called by XLConnect, reshape2, stringr, saRifx

install.packages("reshape2")       #has recast()
if(!"XLConnect" %in% rownames(installed.packages())) {
  install.packages("XLConnect") 
}

if(!"reshape2" %in% rownames(installed.packages())) {
  install.packages("reshape2")
}

# Use XLConnect to deal with multiple worksheets
library(tidyverse)  # mutate
library(XLConnect)  # excel
library(reshape2)   # melt
library(stringr)    # regex
library(taRifx)     # destring

tourism_base_path <- "G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/Accommodation/"
tourism_filename <- "IVS1 YE Dec 2017_UpdatedMar2018.xlsx"
tourism_dest_filename <- "sydney_tourism_201803.csv"
tourism_fullpath <- paste(tourism_base_path, tourism_filename, sep="")
tourism_dest_fullpath <- paste(tourism_base_path, tourism_dest_filename, sep="")

# Load tourism workbook
tourism_workbook <- loadWorkbook(tourism_fullpath)

# Get sheet names
sheet_names <- getSheets(tourism_workbook)

# We are only interested in country sheets 
sheet_names <- sheet_names[!sheet_names %in% c("Contents", "Total")]

# Spreadsheet configuration details

# There are 7 visit dimensions located in Cell A8 and increasing by 12 rows with last dimensions in Cell A80
sheet_block_range = 1:7
sheet_year_range = 2007:2017

visitor_dimension_startRow = 8
visitor_dimension_col = 1
visitor_dimension_nextRowStep = 12

# Each visit dimension has its own associated block of data
data_startRow = 8
data_startCol = 1
data_endRow = 17
data_endCol = 12
data_nextRowStep = 12

# Helper functions

# Visit dimension name cleaned for friendly format i.e. friendly_feature_name
# features are currently of format UPPER.WORDS.AND.SO..ON.(000)
cleanVisitDimensionName <- function(s) {
  s %>% 
    str_replace_all("\\.", " ") %>%   # Replace all . with spaces
    str_replace_all("  ", " ") %>%    # Collapse double spaces
    str_extract("[A-Z ]+") %>%        # Get words only
    trimws() %>%                      # Remove leading and trailing whitespace
    str_replace_all(" ", "_") %>%     # Replace spaces with underscore
    tolower()                         # Lower case
}

# Get Visit Dimension Name from sheet
getVisitDimensionName <- function(workbook, sheet, block_index) {
  visit_dimension_name = readWorksheet(workbook, sheet, 
                                       startRow = visitor_dimension_startRow + ((block_index-1) * visitor_dimension_nextRowStep), 
                                       startCol = visitor_dimension_col, 
                                       endRow = visitor_dimension_startRow + ((block_index-1) * visitor_dimension_nextRowStep), 
                                       endCol = visitor_dimension_col)
  cleanVisitDimensionName(names(visit_dimension_name))
}

# Get Visit Dimension Block Data from sheet
getVisitDimensionBlock <- function(workbook, sheet, block_index) {
  readWorksheet(workbook, sheet, 
                startRow = data_startRow + ((block_index-1) * data_nextRowStep), startCol = data_startCol, 
                endRow = data_endRow + ((block_index-1) * data_nextRowStep), endCol = data_endCol)
}

# Final Tourism data frame
tourism.data = data.frame()

# Build dataset across all sheets
for (sheet in sheet_names){
  
  # Context data for current sheet
  sheet_data <- data.frame() 
  
  # Loop through each block in the sheet as they are iterated over each visit dimension
  for (block_index in sheet_block_range) {
    
    # get sheet data for visit dimension Metric
    sheet_block_data <- getVisitDimensionBlock(tourism_workbook, sheet, block_index)
    
    # Change names of features to "purpose" and from 2007, to 2017
    names(sheet_block_data) <- c("purpose", sheet_year_range)
    
    # visit dimension name, want in format lower case words seperated by underscore
    visit_dimension_name = getVisitDimensionName(tourism_workbook, sheet, block_index)
    
    # Melt the years features into a single year feature
    sheet_block_data %>% 
      melt(id.vars=c("purpose"),
           variable.name="year",
           value.name=visit_dimension_name) -> sheet_block_data
    
    # Each block is a feature, inner join on purpose and year
    if (nrow(sheet_data) == 0) {
      sheet_data <- sheet_block_data # first time
    } else {
      sheet_data <- merge(sheet_data, sheet_block_data, by=c("purpose","year"))
    }
  }
  
  # add country name, this is the current sheet name
  sheet_data %>% 
    mutate(country = as.factor(sheet)) -> sheet_data
  
  # need to append now this dataset
  tourism.data <- rbind(tourism.data, sheet_data)
}

# Clean Tourism.data

# Strip leading and trailing whitespace
tourism.data$purpose <- trimws(tourism.data$purpose)

# Strip total row  
tourism.data <- tourism.data[!(tourism.data$purpose == "Total"),]

# Strip backpacker data - this data duplicates the by reason data
### Consider commenting these lines and split this into separate data frame
tourism.data <- tourism.data[!(tourism.data$purpose == "Backpackers"),] 
tourism.data <- tourism.data[!(tourism.data$purpose == "Non backpackers"),]

# Convert to factor
tourism.data$purpose <- as.factor(tourism.data$purpose)

# Clean metric data, and put as proper type
dim_index <- which(names(tourism.data) %in% c("purpose", "year","country"))
metric_columns <- names(tourism.data[-dim_index])

for (col in metric_columns) {
  tourism.data[,col] <- as.numeric(destring(tourism.data[,col])) # convert to number, and set np to NA
}

# Check structure and content are as expected
str(tourism.data)
head(tourism.data)

# the sort the rows so values are in a predicable order
tourism.data <- select(tourism.data, purpose, country, year, everything())
View(tourism.data)


# Write data to shared drive
write.csv(tourism.data, file=tourism_dest_filename)

# create categories Business and non-business
bus <- list(tourism.data[tourism.data$Purpose == "Employment","Business Travel"])
nonbus <- list(tourism.data[tourism.data$Purpose == !"Employment",!"Business Travel"])

aggregate(tourism.data$visitors,by=tourism.bus["Year","Country","Purpose", everything()], FUN=sum)   ## incomplete

## finish this!!