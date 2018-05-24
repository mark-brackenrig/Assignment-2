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

#only look at the past two years of data
calendar <- subset(calendar, calendar$date>="2017-01-01"&is.na(calendar$available_current)==F)
gc()

colnames(calendar)

calendar <- subset(calendar, select = c( "id","date",  "available_2017-03-03",
                                         "price2017-03-03"     , "available_2017-04-03", "price2017-04-03"   ,  
                                         "available_2017-10-03", "price2017-10-03"   ,   "available_2017-11-07",
                                         "price2017-11-07"     , "available_2017-12-05" ,"price2017-12-05"    , 
                                        "available_current" ,   "price_current"     
                                        ))

write_csv(calendar,"/Volumes/GoogleDrive/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/calendar_full.csv")


calendar$bookflag <- ifelse(calendar$available_current=="f"&calendar$`available_2017-12-05`=="t"|
                              calendar$available_current=="f"&calendar$`available_2017-11-07`=="t"|
                              calendar$available_current=="f"&calendar$`available_2017-10-03`=="t"|
                              calendar$available_current=="f"&calendar$`available_2017-04-03`=="t",1,0)

Bookings <- aggregate(calendar$bookflag, by = list(calendar$id), sum)
colnames(Bookings) <- c("id","bookings")
Bookings$bookings[is.na(Bookings$bookings)] <- 0

write_csv(Bookings,"/Volumes/GoogleDrive/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/bookings.csv")


listings <- merge(listings, Bookings)
