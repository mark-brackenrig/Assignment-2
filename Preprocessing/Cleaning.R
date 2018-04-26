#### Data Cleaning ####


#### Listings File ####
##TODO ##
# Remove unnecessary fields
# Convert characters to factor fields where relevent
# remove relevant special characters in text fields
# 

## Price Fields 
    #clean Price fields
    priceclean <- function(x){
      x <- gsub(pattern = "\\$", replacement = "", x)
      x <- gsub(pattern = "\\,", replacement = "", x)
      x <- as.numeric(x)
    }
    
    #Check price fields
    subset(colnames(listings),grepl("price",tolower(colnames(listings)))==T)
    
    #other price fields clean
    listings$price <- priceclean(listings$price)
    listings$weekly_price <- priceclean(listings$weekly_price)
    listings$monthly_price <- priceclean(listings$monthly_price)

#Other price fields    
    listings$security_deposit <- priceclean(listings$security_deposit)
    listings$cleaning_fee <- priceclean(listings$cleaning_fee)
    listings$extra_people <- priceclean(listings$extra_people)
    
    
## Experience
    unique(listings$experiences_offered)
    #No information in this field, lets remove it
    
listings$experiences_offered <- NULL
listings$host_acceptance_rate <- NULL




## Remove URLs
listings <- subset(listings, select = c( subset(colnames(listings),grepl("url",tolower(colnames(listings)))==F)))


#Host response rate
listings$host_response_rate <- gsub(pattern = "\\%", replacement = "", listings$host_response_rate)

#this throws a warning, but its okay, it just coerces "N/A" to NA
listings$host_response_rate <- as.numeric(listings$host_response_rate)



## Convert t/f to factors ##
colnames(listings[,grep(pattern = "is_", colnames(listings))])

#columns with "is_" in them tend are t/f

listings$property_type <- as.factor(listings$property_type)
listings$host_is_superhost <- as.factor(listings$host_is_superhost) 
listings$is_location_exact <- as.factor(listings$is_location_exact) 



#Host Verifications



#### Reviews ####


#### Calendar ####


