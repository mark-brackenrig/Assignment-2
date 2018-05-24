# Create Modelling Table

#first 15 Principal components of Amenities and first 8 PC of host verfications

Model <- listings

#Remove unnecessary fields

Model <- subset(Model, select =  c("id","host_id","host_since","host_response_time","host_response_rate",              
                                   "host_is_superhost",
                                   "host_listings_count","host_total_listings_count",       
                                   "host_has_profile_pic","host_identity_verified",          
                                   "latitude",
                                   "longitude","is_location_exact",
                                   "property_type","room_type",
                                   "accommodates","bathrooms",
                                   "bedrooms","beds","bed_type","price",
                                   "security_deposit",
                                   "cleaning_fee","guests_included",
                                   "extra_people","minimum_nights",
                                   "maximum_nights","calendar_updated","availability_30","availability_60",
                                   "availability_90","availability_365","number_of_reviews",
                                   "review_scores_rating","review_scores_accuracy",          
                                   "review_scores_cleanliness","review_scores_checkin",           
                                   "review_scores_communication","review_scores_location",          
                                   "review_scores_value","instant_bookable",                
                                   "is_business_travel_ready","cancellation_policy",             
                                   "require_guest_profile_picture","require_guest_phone_verification",
                                   "calculated_host_listings_count","reviews_per_month",               
                                   "Cancelflag"))

table(is.na(Model$host_response_rate), Model$is_business_travel_ready)


Model <- merge(Model, Amenities_comp[,c(1:15,82)])
Model <- merge(Model, Host_comp[,c(1:8,28)])
Model <- merge(Model, bookings)
Model <- merge(Model, `Opera House by Public Transport`)
Model$Status <- NULL

Model <- merge(Cal_Struc, Model, all.y= T)
#Remove unwanted tables 
rm(Host_comp, Host_Verifications, `Opera House by Public Transport`, Primary_Research, Primary_Research_Demographics, reviews, Cal_Struc, calendar, bookings, Amenities, Amenities_comp, Sydney_Business_Parks_and_Conference_Centers, Time_data)


