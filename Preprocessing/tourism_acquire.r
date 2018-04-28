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

tourism.data = data.frame()

# Build dataset across all sheets
for (sheet in sheet_names){

  # empty data sheet
  sheet_data <- data.frame(purpose=character(),
                           year=integer(), 
                           stringsAsFactors=FALSE) 
  
  # Loop through each section in the sheet as they are iterated over each visit dimension
  for (i in sheet_section_range) {

    # visit dimension name, what in format lower case words seperated by underscore
    # get cell
    visit_dimension_name = names(readWorksheet(tourism_workbook, 
                                         sheet, 
                                         startRow = visitor_dimension_startRow + ((i-1) * visitor_dimension_nextRowStep), 
                                         startCol = visitor_dimension_col,
                                         endRow = visitor_dimension_startRow + ((i-1) * visitor_dimension_nextRowStep), 
                                         endCol = visitor_dimension_col
    ))
    
    # Make friendly feature name 
    visit_dimension_name %>% 
      str_replace_all("\\.", " ") %>%   # Replace all . with spaces
      str_extract("[A-Z ]+") %>%        # Get words only
      trimws() %>%                      # Remove leading and trailing whitespace
      str_replace_all(" ", "_") %>%     # Replace spaces with underscore
      tolower() -> visit_dimension_name # Lower case
    
    # get sheet data for visit dimension
    sheet_section_data <- readWorksheet(tourism_workbook, 
                                sheet, 
                                startRow = data_startRow + ((i-1) * data_nextRowStep), 
                                startCol = data_startCol,
                                endRow = data_endRow + ((i-1) * data_nextRowStep), 
                                endCol = data_endCol
    )

    # Change names of features to "purpose" and from 2007, to 2017
    names(sheet_section_data) <- c("purpose", sheet_year_range)
    
    # Strip leading and trailing whitespace
    sheet_section_data$purpose <- trimws(sheet_section_data$purpose)
    
    # Strip total row
    sheet_section_data <- sheet_section_data[!(sheet_section_data$purpose == "Total"),]
    # Strip backpackers
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
    mutate(country = sheet) -> sheet_data
  
  # need to append now this dataset
  if (nrow(tourism.data) == 0) {
    tourism.data <- sheet_data
  } else {
    # coerce types into original dataset
    
    # if sheet section data is not numeric, convert to numeric
    # where np replace with NA
    #cleanNumeric <- function(s) {
    #  as.numeric(destring(s))
    #}
    
    #sheet_section_data <-
    #  cbind(
    #    sheet_section_data[,1],
    #    apply(sheet_section_data[,c(3:data_endCol-data_startCol)], 2, cleanNumeric)
    #  )
    
    tourism.data <- rbind(tourism.data, sheet_data)
  }
}


