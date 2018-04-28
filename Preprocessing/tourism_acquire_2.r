## Read in first block - need to get data for this block from each of the spreadsheets

## approach
base_path <- getwd()
wb_filename <- loadWorkbook("Accommodation/IVS1 YE Dec 2017_UpdatedMar2018.xlsx")
wb_fullpath <- paste(base_path, tourism_filename, sep="")

# Set up excel ranges to read in remaining blocks of data from the workbook
rs <- 8
re <- rs + 9

# starting with block1=visitors from sheet="China"
B1_raw <- readWorksheetFromFile(wb, sheet = "China", startRow = 8, startCol = 1,
                                endRow = 13, endCol = 12 )
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
       
       B1 <- mutate(B1_raw, Country = c(sheetname:CR)), 
       Year = lappystmsgoeshere)
View(B1)


# move new columns to begining of data frame
B1 <- select(B1, Year, Country, Purpose, everything())
View(B1)