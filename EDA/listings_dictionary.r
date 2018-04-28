
### data dictionary

# "id" (Unique ID)
# DELETE Feature
max(listings$id) - min(listings$id)
str(listings$id)

listings %>% 
  group_by(id) %>%
  tally() %>%
  filter(n > 1)

# "listing_url" - Listing of the property
# DELETE feature
str(listings$listing_url)

# "last_scraped" - When last sourced
# DELETE feature
unique(listings$last_scraped)
table(listings$last_scraped)

# "scrape_id"
# Only one factor
# DELETE feature
unique(listings$scrape_id)

# "name"           
# Text short description
head(listings$name)

# "summary"
# Text long description
# Multi-lingual
head(listings$summary)

# "space"  - Text description of property
# 10851 missing
sum(is.na(listings$space))

# "description"  
# Text long description similar to summary 24.4% same
sum(listings$summary == listings$description, na.rm=TRUE) / length(listings$summary)

# "experiences_offered"             
# DELETE, all "none"
unique(listings$experiences_offered)

# "neighborhood_overview"            
# Text description of neighbourhood
# 14228 missing
head(listings$neighborhood_overview)
sum(is.na(listings$neighborhood_overview))

# "notes"  
# Text description Extra services, discussion of prices etc
# maybe good for seeing impact of this text
# 19671 missing
head(listings$notes)
sum(is.na(listings$notes))

# "transit"   
# Text description on transport options to the property
head(listings$transit)
sum(is.na(listings$transit))

# "access" 
# Text description on access to the property
# 13450 missing
head(listings$access)
sum(is.na(listings$access))

# "interaction"  
# Text description on how seller will interact, i.e. as a guide, introduce, etc
# 15093 missing
head(listings$interaction, 20)
sum(is.na(listings$interaction))

# "house_rules"    
head(listings$house_rules)
sum(is.na(listings$house_rules))

# "thumbnail_url"    
# Empty DELETE
sum(is.na(listings$thumbnail_url))

# "medium_url"   
# Empty DELETE
sum(is.na(listings$medium_url))

# "picture_url"    
# IMAGE of property, sometimes internal/external etc
head(listings$picture_url)

# "xl_picture_url"   
# Empty DELETE
sum(is.na(listings$xl_picture_url))

# "host_id"  
# 25221 unique id's what is this?
head(listings$host_id)
length(unique(listings$host_id))

# "host_url"   
head(listings$host_url)
sum(is.na(listings$host_url))

# "host_name"   
head(listings$access)
sum(is.na(listings$access))

# "host_since"    
head(listings$access)
sum(is.na(listings$access))

# "host_location"    
head(listings$access)
sum(is.na(listings$access))

# "host_about"     
head(listings$access)
sum(is.na(listings$access))

# "host_response_time"   
head(listings$access)
sum(is.na(listings$access))

# "host_response_rate"   
head(listings$access)
sum(is.na(listings$access))

# "host_acceptance_rate"  
head(listings$access)
sum(is.na(listings$access))

# "host_is_superhost"   
head(listings$access)
sum(is.na(listings$access))

# "host_thumbnail_url"  
head(listings$access)
sum(is.na(listings$access))

# "host_picture_url"   
head(listings$access)
sum(is.na(listings$access))

# "host_neighbourhood"  
head(listings$access)
sum(is.na(listings$access))

# "host_listings_count"  
head(listings$access)
sum(is.na(listings$access))

# "host_total_listings_count"  
head(listings$access)
sum(is.na(listings$access))

# "host_verifications"  
head(listings$access)
sum(is.na(listings$access))

# "host_has_profile_pic"  
head(listings$access)
sum(is.na(listings$access))

# "hosthead(listings$access)
sum(is.na(listings$access))
_identity_verified"  

# "street"     

# "neighbourhood" 

# "neighbourhood_cleansed"        

# "neighbourhood_group_cleansed"   

# "city"                      

# "state"              

# "zipcode"   

# "market"   

# "smart_location"     

# "country_code"   

# "country"        

# "latitude"  

# "longitude"    

# "is_location_exact"  

# "property_type"    

# "room_type"     

# "accommodates"   

# "bathrooms"  

# "bedrooms"   

# "beds"        

# "bed_type"    

# "amenities"  

# "square_feet"     

# "price"           

# "weekly_price"      

# "monthly_price"     

# "security_deposit"    

# "cleaning_fee"   

# "guests_included"       

# "extra_people"         

# "minimum_nights"        

# "maximum_nights"         

# "calendar_updated"     

# "has_availability"         

# "availability_30"          

# "availability_60"      

# "availability_90"    

# "availability_365"     

# "calendar_last_scraped"    

# "number_of_reviews"   

# "first_review"              

# "last_review"           

# "review_scores_rating"        

# "review_scores_accuracy"      

# "review_scores_cleanliness"    

# "review_scores_checkin"          

# "review_scores_communication"     

# "review_scores_location"        

# "review_scores_value"       

# "requires_license"     

# "license"               

# "jurisdiction_names"       

# "instant_bookable"            

# "is_business_travel_ready"       

# "cancellation_policy"        

# "require_guest_profile_picture"   

# "require_guest_phone_verification" 

# "calculated_host_listings_count"   

# "reviews_per_month" 
