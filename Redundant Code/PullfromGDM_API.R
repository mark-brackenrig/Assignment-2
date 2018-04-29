### Read Google Data###
#install.packages("gmapsdistance")
#devtools::install_github("rodazuero/gmapsdistance@058009e8d77ca51d8c7dbc6b0e3b622fb7f489a2")

library(gmapsdistance)

#The gmaps function is as follows
#gmapsdistance(origin, destination, combinations, mode, key,
#shape, avoid, departure, dep_date, dep_time,
#traffic_model, arrival, arr_date, arr_time)

#Register do parallel so it is faster
library(doParallel)

registerDoParallel(cores = detectCores()-1)

#get the unique listing (note they are all unique) 
Timedata1 <- unique(subset(listings, select = c("latitude", "longitude","id")))


#Test
#gmapsdistance(origin =paste0("-33.8","+,+","151"),destination = 'Sydney+Opera+House', departure = as.numeric(as.POSIXct("2018-04-21 12:00:00")),combinations = "all",mode = "transit", shape = "wide")



####Public Transport to Opera House####
#Opera_Public_Data <- foreach(i=1:nrow(Timedata)) %dopar% {
#  library(gmapsdistance)
  #Dont steal my API
#  set.api.key('YOU MUST SEt THE API KEY!!!')
  
#  OperaTimePublic <- gmapsdistance(origin =paste0(Timedata$latitude[i],"+",Timedata$longitude[i]),destination = 'Sydney+Opera+House', departure = as.numeric(as.POSIXct("2018-04-21 12:00:00")),combinations = "all",mode = "transit", shape = "wide")
  
#}

#Write to DF
#Opera_Public <- as.data.frame(matrix(unlist(Opera_Public_Data), ncol = 3,byrow = TRUE))
#Opera_Public <- cbind(Opera_Public, listings$id)

#Rename for Cleaning
#colnames(Opera_Public) <- c("Time", "Distance", "Status", "id")

#Change columns to correct format
#Time in Seconds
#Opera_Public$Time <- as.numeric(as.character(Opera_Public$Time))

#Distance in Meters
#Opera_Public$Distance <- as.numeric(as.character(Opera_Public$Distance))


#write_csv(Opera_Public, "G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/Opera House by Public Transport.csv")




####Define Grid####
# important places to go in sydeny are as follows:
# Opera House and Harbour Bridge
# Luna Park
# Bondi Beach
# Manly Beach
# Blue mountains (three sisters)
# Pokolbin (hunter valley)

#We will make the assumption that participants will either want to travel by car or by public transport, not by walking or cycling

#The date and time will be determined on the weekend
#Business Travel
# Convention centre
# Macquarie Park
# Bella Vista
# Paramatta
# Alexandria
# UNSW
# UTS



grid <- expand.grid(destination = c("Sydney+Opera+House","Bondi+Beach", "Manly+Beach","Three+Sisters", "Pokolbin+NSW"), mode = c( "transit"))

grid <- subset(grid, grid$destination!="Sydney+Opera+House"|grid$mode!="transit")

Timedata <- merge(grid, Timedata1) #take every combination of the grid and Timedata

####Public Transport + Drive to all areas####


  Total_Data<-  foreach(i=1:nrow(Timedata)) %dopar% {
  library(gmapsdistance)

    #Dont steal my API
  set.api.key('')
  TimeTotal <-  gmapsdistance(origin =paste0(Timedata$latitude[i],"+",Timedata$longitude[i]),destination = Timedata$destination[i], departure = as.numeric(as.POSIXct("2018-05-21 12:00:00")),combinations = "all",mode = Timedata$mode[i], shape = "wide")

}


#Write to DF
Total_Data_DF <- as.data.frame(matrix(unlist(Total_Data), ncol = 3,byrow = TRUE)) #turn to tidyform


Total_Data_DF_Final <- cbind(Total_Data_DF, Timedata) #Match with the other stuff

#Rename for Cleaning
#colnames(Opera_Public) <- c("Time", "Distance", "Status", "id")

#Change columns to correct format
#Time in Seconds
#Opera_Public$Time <- as.numeric(as.character(Opera_Public$Time))

#Distance in Meters
#Opera_Public$Distance <- as.numeric(as.character(Opera_Public$Distance))


#write_csv(Opera_Public, "G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/Opera House by Public Transport.csv")


#####



