### Price Models
Model$log_price <- log(Model$price)

Model <- subset(Model, is.na(Model$bathrooms)==F&is.na(Model$bedrooms)==F)
Model <- subset(Model, is.infinite(Model$log_price)==F)
Model1 <- lm(data=  Model, log_price~is_business_travel_ready+bedrooms)

summary(Model1)
#plot(Model1)

Model$residuals <- abs(Model1$residuals)

Model <- subset(Model, Model$residuals<10)

Model1 <- lm(data=  Model, log_price~is_business_travel_ready+bedrooms+bathrooms)

summary(Model1)


Model1 <- lm(data=  Model, log_price~is_business_travel_ready+bedrooms+bathrooms+Time+Distance)

summary(Model1)


Model1 <- lm(data=  Model, log_price~is_business_travel_ready+bedrooms+bathrooms+Time+Distance+AmenitiesPC1+AmenitiesPC2+AmenitiesPC3)

summary(Model1)

plot(Model1$fitted.values, Model1$model$log_price)


### Model 2 - lets get messy
Model$reviews_per_month[is.na(Model$reviews_per_month)] <- 0

Model2 <- lm(data=  Model, log_price~is_business_travel_ready+bedrooms+bathrooms+Time+Distance+AmenitiesPC1+
               AmenitiesPC2+AmenitiesPC3+AmenitiesPC4+AmenitiesPC5+
               AmenitiesPC6+AmenitiesPC7+AmenitiesPC8+AmenitiesPC9+AmenitiesPC10+AmenitiesPC11+
               AmenitiesPC12+AmenitiesPC13+AmenitiesPC14+AmenitiesPC15+Cancelflag+cleaning_fee+reviews_per_month+
               host_total_listings_count+HostPC1+HostPC2+HostPC4+HostPC5+HostPC8)

summary(Model2)

plot(Model2)


### 

Model3 <- lm(data=  Model, log_price~is_business_travel_ready+bedrooms+bathrooms+Time+Distance+AmenitiesPC1+
               AmenitiesPC2+AmenitiesPC3+AmenitiesPC4+AmenitiesPC5+
               AmenitiesPC6+AmenitiesPC7+AmenitiesPC8+AmenitiesPC9+AmenitiesPC10+AmenitiesPC11+
               AmenitiesPC12+AmenitiesPC13+AmenitiesPC14+AmenitiesPC15+Cancelflag+cleaning_fee+reviews_per_month+
               host_total_listings_count+HostPC1+HostPC5+HostPC8+Cancelflag+cancellation_policy+instant_bookable+bookings+availability_30+availability_60+availability_90+availability_365+number_of_reviews+extra_people+guests_included+room_type)

summary(Model3)

plot(Model3)

