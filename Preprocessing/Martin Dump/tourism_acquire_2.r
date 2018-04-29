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

# Set up excel ranges to read in remaining blocks of data from the workbook
rs <- 8
re <- rs + 9


#rm(B1_raw, B1_t, B1)
str(B1_raw)
dim(B1_raw)
View(B1_raw)

## (not required .... transpose the block - swap rows and columns
#B1_t <- as.data.frame(t(as.matrix(B1_raw))) ### TO DO: fix this!   messes up the col ###
#View(B1_t)   
## Note: Martin is using melt() instead of t()

## Transpose Purpose & Year down the rows 
## so we have Year, Country, Purpose, Visitors, Spend, Nights etc


# Get sheet names
sheet_names <- getSheets(tourism_workbook)

# inspect sheet names
sheet_names

# We are only interested in country sheets 
sheet_names <- sheet_names[!sheet_names %in% c("Contents", "Total")]

for (sheet in sheet_names){
  
  # starting with block1=visitors from sheet="China"
  B1_raw <- readWorksheet(tourism_workbook, sheet = sheet, startRow = 8, startCol = 1,
                          endRow = 13, endCol = 12 )
  
  names(B1_raw) <- c("purpose", 2007:2017)
  B1_raw %>% melt(id.vars=c("purpose"),
                  variable.name="year",
                  value.name="value")
  
  
  

# see spreadsheet 'Munging.xlsx' for mockup.

# create new columns: 
#   Country = sheet name (or A7)
#   (not required) Purpose  = col1 name                     ### TO DO: pass col1 name to new Reason column ###
#   Col1 name & "Year" = 2007 to 2017

# add column vector "Country", populate with Sheet name
CR <- length(B1$Purpose)     ### Put this is referenced in the mutate statemetnt

# add a column vector "Year", populate 2007 to 2017 for each block
##... create empty column ...
##... populate with the following ...
K <- unique(B1$Purpose)
Y <- c(rep(2007,K):rep(2017,K)    ### not quite right but this is the idea
       lapply(Y)                  ### tidy up and put this bit into the mutate statemetnt
       
       B1 <- mutate(B1_raw, Country = "China", 
       Year = lappystmsgoeshere)
View(B1)


# move new columns to begining of data frame
B1 <- select(B1, Year, Country, Purpose, everything())
View(B1)




# Build dataset across all sheets
Loop through each sheet
  

  # Loop through each section in the sheet as they are iterated over each visit dimension
  Loop through each section within sheet
    
    # get sheet data for visit dimension Metric
    data <- GetBlock()
    
    # Change names of features to "purpose" and from 2007, to 2017
    names(sheet_section_data) <- c("purpose", sheet_year_range)
    
    # visit dimension name, want in format lower case words seperated by underscore
    visit_dimension_name = getCellValue(tourism_workbook, sheet, 
                                        visitor_dimension_startRow + ((i-1) * visitor_dimension_nextRowStep), 
                                        visitor_dimension_col)
    
    # Melt the years features into a single year feature
    sheet_section_data %>% 
      melt(id.vars=c("purpose"),
           variable.name="year",
           value.name=visit_dimension_name) -> sheet_section_data
    
    # need to join
    sheet_data <- merge(sheet_data, sheet_section_data, by=c("purpose","year"))
  }
  
  # add country name, this is the current sheet name
  sheet_data %>% 
    mutate(country = as.factor(sheet)) -> sheet_data
  
  # need to append now this dataset
  tourism.data <- rbind(tourism.data, sheet_data)
}















tourism data

for block in blocks

  block data

  for sheet in sheets

    get block in sheet
    
    append to current block
    
  
  melt blocks
  
  add to tourism data

  

tourism data

for sheet in sheets
  
  sheet data
  
  for block in blocks
    
    get block in sheet
    
    append to current sheet
  
  melt sheet
  
  add to tourism data



# Final Tourism data frame
tourism.data = data.frame()

# Build dataset across all sheets
for (sheet in sheet_names){
  
  # Context data for current sheet
  sheet_data <- data.frame() 
  
  # Loop through each section in the sheet as they are iterated over each visit dimension
  for (i in sheet_section_range) {
    
    # get sheet data for visit dimension Metric
    sheet_section_data <- getVisitDimensionBlock(tourism_workbook, sheet, i)
    
    # Change names of features to "purpose" and from 2007, to 2017
    names(sheet_section_data) <- c("purpose", sheet_year_range)
    
    # visit dimension name, want in format lower case words seperated by underscore
    visit_dimension_name = getVisitDimensionName(tourism_workbook, sheet, i)
    
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










library(tidyverse)
library(httr)
library(jsonlite)
install.packages(c("httr", "jsonlite"))
airbnb_reviews_url <- url("http://data.insideairbnb.com/australia/nsw/sydney/2018-01-13/data/reviews.csv.gz")
gzip_conn <- gzcon(airbnb_reviews_url)
lines <- readLines(gzip_conn)
airbnb_reviews_df <- read.csv(textConnection(lines))
# Read Gzip


airbnb_reviews_url = getURL("http://data.insideairbnb.com/australia/nsw/sydney/2018-01-13/data/reviews.csv.gz",
                            encoding="gzip")
airbnb_reviews_df <- read.table(airbnb_reviews_url)



reviews_url <- "http://data.insideairbnb.com/australia/nsw/sydney/2018-01-13/data/reviews.csv.gz"
airbnb_gdrive_base_path <- "G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/"
reviews_filename <- "reviews.csv"
reviews_full_path <- paste(airbnb_gdrive_base_path, reviews_filename, sep="")

reviews <- data.frame()

# If file already cached to g drive then load from there
if (file.exists(reviews_full_path)) {
  reviews <- read_csv(reviews_full_path)
} else { # otherwise get from URL and save to gdrive
  url = getURL(reviews_url, encoding="gzip")
  reviews_table <- read.table(url)
  write_csv(reviews_table, reviews_full_path)
  reviews <- reviews_table
}

# Reviews now contains a properly loaded
  

f <- paste0("C://Users//Prices//",companiesIsin,".csv")
if (file.exists(f))
  df <- read.csv2(f, TRUE, stringsAsFactors=FALSE)


