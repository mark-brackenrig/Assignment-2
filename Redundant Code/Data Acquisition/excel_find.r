#### Locate requried data in Excel datasets ####

## IMPORTANT: snippet only ... has dependecies on prior code ##

# work out where the data is in the source workbook

mm <- as.matrix(readWorksheetFromFile("Accommodation/IVS1 YE Dec 2017_UpdatedMar2018.xlsx", sheet=2))
class(mm)<-"character" # convert all to character

# type search string in mm=="" below to work out where the data is in the source workbook
rc <- which(mm=="VISITOR NIGHTS", arr.ind=T)
rc
# repeat as required

### TO DO: read row number and col number from rc to feed into other functions

# read in  blocks of data from the workbook
rs <- 8
re <- rs + 9
rs1 <- re + 3
re1 <- rs1 +9

B1 <- read.table(text=apply(mm[rs:re, 1:12],1,paste, collapse="\t"), sep="\t")
B2 <- read.table(text=apply(mm[rs1:re1, 1:12],1,paste, collapse="\t"), sep="\t")

rs2 <- re1 + 3
re2 <- rs2 + 9
B3 <- read.table(text=apply(mm[rs2:re2, 1:12],1,paste, collapse="\t"), sep="\t")

### TO DO: loop through all these ... rs2 = re1 + 3 = rs2 + 9 for all data blocks

# have a look at what we've got
str(B1)
View(B1)
View(B2)
View(B3)
