#### Data Cleaning ####


#### Listings File ####
##TODO ##
# Remove unnecessary fields
# Convert characters to factor fields where relevent
# remove relevant special characters in text fields
# 

###NOTES####
# Inspect Market and State fields.... Clearly some scraping issues
# I suggest that we just remove them

## Remove unneeded ID fields, and fields with no information

#No information in these fields (i.e. all the same response), lets remove it

listings$experiences_offered <- NULL #no information
listings$host_acceptance_rate <- NULL #no information
listings$scrape_id <- NULL #Doesnt link to anything ie. redundant field
listings$host_name <- NULL #We have host ID... lets remove for privacy reasons
listings$country <- NULL #We are only looking at Sydney
listings$country_code <- NULL #as above
listings$has_availability <- NULL #No information
listings$requires_license <- NULL #no information
listings$license <- NULL #No information
#Remove incosistent fields...
listings <- subset(listings, !listings$state %in% c("VIC", "Queensland")&!listings$market %in% c("Gold Coast-Tweed","Central Florida Atlantic Coast","Prague")&is.na(listings$jurisdiction_names))
listings$jurisdiction_names <- NULL



## Price Fields 
    #clean Price fields
    priceclean <- function(x){
      x <- gsub(pattern = "\\$", replacement = "", x)
      x <- gsub(pattern = "\\,", replacement = "", x)
      x <- as.numeric(x)
    }
    
    #Check price fields
    #subset(colnames(listings),grepl("price",tolower(colnames(listings)))==T)
    
    #other price fields clean
    listings$price <- priceclean(listings$price)
    listings$weekly_price <- priceclean(listings$weekly_price)
    listings$monthly_price <- priceclean(listings$monthly_price)

#Other price fields    
    listings$security_deposit <- priceclean(listings$security_deposit)
    listings$cleaning_fee <- priceclean(listings$cleaning_fee)
    listings$extra_people <- priceclean(listings$extra_people)
    

## Remove URLs
listings <- subset(listings, select = c( subset(colnames(listings),grepl("url",tolower(colnames(listings)))==F)))


#Host response rate
listings$host_response_rate <- gsub(pattern = "\\%", replacement = "", listings$host_response_rate)

#Coerce the text null values to actual null values
#this is cosmetic code, its just so that R doesnt throw a warning
listings$host_response_rate[listings$host_response_rate=="N/A"] <- NA

#Convert to numeric
listings$host_response_rate <- as.numeric(listings$host_response_rate)

## Convert t/f to factors ##
#colnames(listings[,grep(pattern = "is_", colnames(listings))])

#columns with "is_" in them tend are t/f


listings$host_is_superhost <- as.factor(listings$host_is_superhost) 
listings$is_location_exact <- as.factor(listings$is_location_exact) 
listings$is_business_travel_ready <-as.factor(listings$is_business_travel_ready)
listings$instant_bookable <- as.factor(listings$instant_bookable)
listings$property_type <- as.factor(listings$property_type)
listings$host_has_profile_pic <- as.factor(listings$host_has_profile_pic)
listings$host_response_time[listings$host_response_time=="N/A"] <- NA 
listings$host_response_time <- factor(listings$host_response_time,levels = c("within an hour", "within a few hours", "within a day", "a few days or more"), ordered = T)
listings$host_identity_verified <- as.factor(listings$host_identity_verified)
listings$room_type <- as.factor(listings$room_type)
listings$bed_type <- as.factor(listings$bed_type)
listings$cancellation_policy <- factor(listings$cancellation_policy,levels = c("flexible", "moderate","strict","super_strict_30"), ordered = T)
listings$require_guest_phone_verification <- as.factor(listings$require_guest_phone_verification)
listings$require_guest_profile_picture <- as.factor(listings$require_guest_profile_picture)

#Host Verifications
Host_Verifications <- subset(listings, select = c("id", "host_verifications"))
Host_Verifications$host_verifications <- gsub(pattern = "\\]", replacement = "",Host_Verifications$host_verifications)
Host_Verifications$host_verifications <- gsub(pattern = "\\[", replacement = "",Host_Verifications$host_verifications)
Host_Verifications$host_verifications <- gsub(pattern = "\\'", replacement = "",Host_Verifications$host_verifications)

split <- strsplit(Host_Verifications$host_verifications,split = ",")
split <- unlist(split)
split <- unique(split)


for(i in 1:length(split)){
  Host_Verifications$temp <- grepl(pattern = split[i] ,x = Host_Verifications$host_verifications)
  colnames(Host_Verifications)[colnames(Host_Verifications)=="temp"] <- paste0("host_verification_",split[i])
temp <- NULL
}
#Remove unneccessary field
Host_Verifications$host_verifications <- NULL
listings$host_verifications <- NULL
#listings <- merge(Host_Verifications, listings, by  = "id" )

## Amenities

Amenities <- subset(listings, select = c("id", "amenities"))
Amenities$amenities <- gsub(pattern = "\\{", replacement = "",Amenities$amenities)
Amenities$amenities <- gsub(pattern = "\\}", replacement = "",Amenities$amenities)
Amenities$amenities <- gsub(pattern = '\"',fixed = T, replacement = "",Amenities$amenities)

split <- strsplit(Amenities$amenities,split = ",")
split <- unlist(split)
split <- unique(split)


for(i in 1:length(split)){
  Amenities$temp <- grepl(pattern = split[i] ,x = Amenities$amenities)
  colnames(Amenities)[colnames(Amenities)=="temp"] <- paste0("Amenities_",split[i])
  temp <- NULL
}
Amenities$amenities <- NULL

keep <- c()
for(i in 2:ncol(Amenities)){
  #Choose 650, i.e. at least approximately 2% of properties should have this feature  
  if(sum(Amenities[,i]==T)>650){
keep <- c(keep, i)    
    
  }
}

#this vector is an index vector of all of the columns I suggest we include in the analysis for amenities
keep <- c(1,keep)

#You may wish to uncomment out this code. 
#Amenities <- Amenities[,c(1,keep)]

#Merge into listings - I have removed this because I think it will keep the files a little cleaner at the moment
#listings <- merge(Amenities, listings, by  = "id" )
listings$amenities <- NULL

listings <- subset(listings, is.na(listings$price)==F)


#### Reviews ####
#find cancel flag
reviews$cancelflag <- grepl("the host cancel", tolower(reviews$comments))

#find proportion
cancelflag <- as.data.frame(prop.table(table(reviews$listing_id,reviews$cancelflag),1))

colnames(cancelflag) <- c("id","Var2", "Cancelflag")

cancelflag <- subset(cancelflag, cancelflag$Var2=="TRUE")
cancelflag$id <- as.numeric(as.character(cancelflag$id))
cancelflag$Var2 <- NULL
listings <- merge(listings, cancelflag, by = "id", all = T)
cancelflag <- NULL

#no reviews indicates no cancels
listings$Cancelflag[is.na(listings$Cancelflag)] <- 0

#### Calendar ####


