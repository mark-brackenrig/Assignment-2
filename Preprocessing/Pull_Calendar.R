#Calculate Occupancy

#Read from Web
#Example of target
#"http://data.insideairbnb.com/australia/nsw/sydney/2017-12-05/data/calendar.csv.gz"

library(rvest)

#Specifying the url for desired website to be scrapped
url <- 'http://insideairbnb.com/get-the-data.html'

#Reading the HTML code from the website
webpage <- read_html(url)

#Pick out all of the 'cell' nodes in a table
rank_data_html <- html_nodes(webpage,'td')

#Convert to a text vector
rank_data <- html_text(rank_data_html)

#Structure it uppppp
webdata <- as.data.frame(matrix(rank_data, ncol = 4, byrow = T))

#Cosmetic
colnames(webdata) <- c("Date", "City", "File", "Description")

webdata$Date <- as.Date(as.character(webdata$Date), "%d %B, %Y")

#Retrieve important dates
webdata <- subset(webdata, webdata$City=="Sydney"&webdata$File=="calendar.csv.gz")

#I do the first one so 
string <- paste0("http://data.insideairbnb.com/australia/nsw/sydney/",webdata$Date[1],"/data/calendar.csv.gz")
calendar <- read_csv(string)
colnames(calendar) <- c("id","date","available_current", "price_current" )


library(readr)
for(i in 2:12){
string <- paste0("http://data.insideairbnb.com/australia/nsw/sydney/",webdata$Date[i],"/data/calendar.csv.gz")
temp <- read_csv(string)
colnames(temp) <- c("id","date",paste0("available_",webdata$Date[i]), paste0("price",webdata$Date[i]) )
calendar <- merge(temp, calendar, all= T)
rm(temp)
gc()
}
