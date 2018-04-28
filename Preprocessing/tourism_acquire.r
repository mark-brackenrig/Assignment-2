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

#TODO REMOVEsheet_names = c("New Zealand")

# Build dataset across all sheets
for (sheet in sheet_names){
  
  # Need to get type as well!
  TODO VISITOR DATAS
  
  # get VISITOR sheet data
  sheet_data <- readWorksheet(tourism_workbook, 
                              sheet, 
                              startRow = 8, 
                              startCol = 1,
                              endRow = 17, 
                              endCol = 12
                              )
  
  # Change names of features to "purpose" and from 2007, to 2017
  names(sheet_data) <- c("purpose",2007:2017)
  
  # Strip leading and trailing whitespace
  sheet_data$purpose <- trimws(sheet_data$purpose)

    # Melt the years features into a single year feature
  sheet_data %>% 
    melt(id.vars=c("purpose"),
         variable.name="year",
         value.name="no_of_visitors") TODO
  -> sheet_data

  # add country name
  #country is sheet name
  sheet_data %>% 
    mutate(country = sheet) 
  -> sheet_data
  
  # Strip total row
  sheet_data <- sheet_data[!(sheet_data$purpose == "Total"),]
  # Strip non backpackers
  sheet_data <- sheet_data[!(sheet_data$purpose == "Non backpackers"),]
  
  
  
}


