### Read Google Data###
#install.packages("gmapsdistance")
#devtools::install_github("rodazuero/gmapsdistance@058009e8d77ca51d8c7dbc6b0e3b622fb7f489a2")

library(gmapsdistance)

#The gmaps function is as follows
#gmapsdistance(origin, destination, combinations, mode, key,
#shape, avoid, departure, dep_date, dep_time,
#traffic_model, arrival, arr_date, arr_time)

#Set the API key (note that i have hidden this since I have to pay for the calls)
set.api.key('SETAPIKEY')
#Register do parallel so it is faster
library(doParallel)

registerDoParallel(cores = detectCores()-1)

#get the unique listing of the 
Timedata <- unique(subset(listings, select = c("latitude", "longitude")))


#Test
gmapsdistance(origin =paste0("-33.8","+,+","151"),destination = 'Sydney+Opera+House', departure = as.numeric(as.POSIXct("2018-04-21 12:00:00")),combinations = "all",mode = "transit", shape = "wide")

#Driving time to chatswood
Opera_Public_Data <- foreach(i=1:nrow(Timedata)) %dopar% {
  library(gmapsdistance)
  #Dont steal my API
  set.api.key('YOU MUST SEt THE API KEY!!!')
  
  OperaTimePublic <- gmapsdistance(origin =paste0(Timedata$latitude[i],"+",Timedata$longitude[i]),destination = 'Sydney+Opera+House', departure = as.numeric(as.POSIXct("2018-04-21 12:00:00")),combinations = "all",mode = "transit", shape = "wide")
  
}

#Write to DF
Opera_Public <- as.data.frame(matrix(unlist(Opera_Public_Data), ncol = 3,byrow = TRUE))
Opera_Public <- cbind(Opera_Public, listings$id)

#Rename for Cleaning
colnames(Opera_Public) <- c("Time", "Distance", "Status", "id")

#Change columns to correct format
#Time in Seconds
Opera_Public$Time <- as.numeric(as.character(Opera_Public$Time))

#Distance in Meters
Opera_Public$Distance <- as.numeric(as.character(Opera_Public$Distance))


write_csv(Opera_Public, "G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/Opera House by Public Transport.csv")
