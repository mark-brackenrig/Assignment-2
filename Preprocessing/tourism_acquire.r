# This file takes the tourism spreadsheet data and turns into a tidy dataset

# Install XLConnect if not already installed
if(!"XLConnect" %in% rownames(installed.packages())) {
  install.packages("XLConnect")
}

if(!"reshape2" %in% rownames(installed.packages())) {
  install.packages("reshape2")
}

# Use XLConnect to deal with multiple worksheets
library(XLConnect)
library(reshape2)
library(stringr)
library(taRifx)   # work with NA when destring

base_path <- "G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/Accommodation/"
tourism_filename <- "IVS1 YE Dec 2017_UpdatedMar2018.xlsx"
tourism_fullpath <- paste(base_path, tourism_filename, sep="")

# Load tourism workbook
tourism_workbook <- loadWorkbook(tourism_fullpath)

# Get sheet names
sheet_names <- getSheets(tourism_workbook)

# inspect sheet names
sheet_names

# We are only interested in country sheets 
sheet_names <- sheet_names[!sheet_names %in% c("Contents", "Total")]


# Spreadsheet configuration details

# There are 7 visit dimensions located in Cell A8 and increasing by 12 rows with last dimensions in Cell A80
sheet_section_range = 1:7
sheet_year_range = 2007:2017
visitor_dimension_col = 1
visitor_dimension_startRow = 8
visitor_dimension_nextRowStep = 12

# Each visit dimension has its own associated section of data
data_startRow = 8
data_startCol = 1
data_endRow = 17
data_endCol = 12
data_nextRowStep = 12

# Helper functions
# Get specific Cell Value from sheet
getCellValue <- function(workbook, sheet, row, col) {
  names(readWorksheet(workbook, sheet, startRow = row, startCol = col, endRow = row, endCol = col))
}

# Get data frame for bounded box
getDataTable <- function(workbook, sheet, start_row, start_col, end_row, end_col) {
  readWorksheet(workbook, sheet, startRow = start_row, startCol = start_col, endRow = end_row, endCol = end_col)
}

# Visit dimension name cleaned for friendly format i.e. friendly_feature_name
cleanVisitDimensionName <- function(s) {
  s %>% 
    str_replace_all("\\.", " ") %>%   # Replace all . with spaces
    str_replace_all("  ", " ") %>%    # Collapse double spaces
    str_extract("[A-Z ]+") %>%        # Get words only
    trimws() %>%                      # Remove leading and trailing whitespace
    str_replace_all(" ", "_") %>%     # Replace spaces with underscore
    tolower()                         # Lower case
}

# Final Tourism data frame
tourism.data = data.frame()

# Build dataset across all sheets
for (sheet in sheet_names){

  # Context data for current sheet
  sheet_data <- data.frame() 
  
  # Loop through each section in the sheet as they are iterated over each visit dimension
  for (i in sheet_section_range) {

    # visit dimension name, want in format lower case words seperated by underscore
    visit_dimension_name = getCellValue(tourism_workbook, sheet, 
                                        visitor_dimension_startRow + ((i-1) * visitor_dimension_nextRowStep), 
                                        visitor_dimension_col)
    
    # Visit Dimension Metric
    visit_dimension_name <- cleanVisitDimensionName(visit_dimension_name)
    
    # get sheet data for visit dimension Metric
    sheet_section_data <- getDataTable(tourism_workbook, sheet,
                                       data_startRow + ((i-1) * data_nextRowStep), data_startCol,
                                       data_endRow + ((i-1) * data_nextRowStep), data_endCol)

    # Change names of features to "purpose" and from 2007, to 2017
    names(sheet_section_data) <- c("purpose", sheet_year_range)
    
    # Strip leading and trailing whitespace
    sheet_section_data$purpose <- trimws(sheet_section_data$purpose)
    
    # Strip total row, and backpacker data
    sheet_section_data <- sheet_section_data[!(sheet_section_data$purpose == "Total"),]
    sheet_section_data <- sheet_section_data[!(sheet_section_data$purpose == "Backpackers"),]
    sheet_section_data <- sheet_section_data[!(sheet_section_data$purpose == "Non backpackers"),]
    
    # Melt the years features into a single year feature
    sheet_section_data %>% 
      melt(id.vars=c("purpose"),
           variable.name="year",
           value.name=visit_dimension_name) -> sheet_section_data
   
    # need to join
    if (nrow(sheet_data) == 0) {
      sheet_data <- sheet_section_data # first time
    } else {
      sheet_data <- merge(sheet_data, sheet_section_data, by=c("purpose","year"))
    }
  }
  
  # add country name, this is the current sheet name
  sheet_data %>% 
    mutate(country = as.factor(sheet)) -> sheet_data
  
  # need to append now this dataset
  tourism.data <- rbind(tourism.data, sheet_data)
}

# Clean metric data, and put as proper type
dim_index <- which(names(tourism.data) %in% c("purpose", "year","country"))
metric_columns <- names(tourism.data[-dim_index])

for (col in metric_columns) {
  tourism.data[,col] <- as.numeric(destring(tourism.data[,col])) # convert to number, and set np to NA
}

# Check fine
str(tourism.data)
head(tourism.data)
