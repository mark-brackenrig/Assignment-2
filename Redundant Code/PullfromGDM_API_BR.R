#PullfromGDM_API - Business listings only


library(gmapsdistance)

#The gmaps function is as follows
#gmapsdistance(origin, destination, combinations, mode, key,
#shape, avoid, departure, dep_date, dep_time,
#traffic_model, arrival, arr_date, arr_time)

#Register do parallel so it is faster
library(doParallel)

registerDoParallel(cores = detectCores()-1)

#get the unique listing (note they are all unique) 
Timedata1 <- unique(subset(listings, select = c("latitude", "longitude","id"), listings$is_business_travel_ready=="t"))


#The date and time will be determined on the weekend
#Business Travel
# Convention centre
# Macquarie Park
# Bella Vista
# Paramatta
# Alexandria
# UNSW
# UTS



grid <- expand.grid(destination = c("14+Darling+Dr+Sydney","macquarie+park+train+station+nsw","parramatta+nsw"), mode = c( "transit","driving"))


Timedata <- merge(grid, Timedata1) #take every combination of the grid and Timedata

####Public Transport + Drive to all areas####
Timedata$Time <- 0
Timedata$Distance <- 0
Timedata$Status <- "0"

for(i in 1:nrow(Timedata)) {
Data <-  gmapsdistance(origin =paste0(Timedata$latitude[i],"+",Timedata$longitude[i]),destination = Timedata$destination[i], arrival = as.numeric(as.POSIXct("2018-05-21 09:00:00")),combinations = "all",mode = Timedata$mode[i], shape = "wide")
  
Timedata$Time[i] <- as.numeric(unlist(Data[1]))
Timedata$Distance[i] <- as.numeric(unlist(Data[2]))
Timedata$Status[i] <- as.character(unlist(Data[3]))
}

#Write to DF
write_csv(Timedata,"G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/Time_data.csv")
