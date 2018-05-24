#model Prep
library(DataExplorer)
library(AUC)

library(pscl)
Model$skew[is.nan(Model$skew)] <- 0

#Random look at everything
Model1 <- glm(data = Model, is_business_travel_ready~., family = "binomial")
roc(Model1$fitted.values, Model1$data$is_business_travel_ready)
summary(Model1)
pR2(Model1)

#lets look at only host related stuff
Model2 <- glm(data = Model, is_business_travel_ready~ is.na(host_response_rate) + 
                host_is_superhost+
                host_identity_verified+ HostPC1+HostPC2+                          
                HostPC3+HostPC4+HostPC6+HostPC8    , family = "binomial")
summary(Model2)
pR2(Model2)
auc(roc(Model2$fitted.values, Model2$data$is_business_travel_ready)
)

#Lets add in the amenities PCs
Model3 <- glm(data = Model, is_business_travel_ready~ is.na(host_response_rate) + 
                host_is_superhost+host_identity_verified+ HostPC1+HostPC2+                          
                HostPC3+HostPC4+HostPC6+HostPC8+AmenitiesPC1+AmenitiesPC2+AmenitiesPC3+AmenitiesPC4+AmenitiesPC5+
                AmenitiesPC6+AmenitiesPC7+AmenitiesPC8+AmenitiesPC9+AmenitiesPC10+AmenitiesPC11+
                AmenitiesPC12+AmenitiesPC13+AmenitiesPC14+AmenitiesPC15   , family = "binomial")
summary(Model3)
pR2(Model3)
auc(roc(Model3$fitted.values, Model3$data$is_business_travel_ready)
)


## Lets remove the non-significant variables,, 1 at a time

Model3 <- glm(data = Model, is_business_travel_ready~ is.na(host_response_rate) + 
                host_is_superhost+ HostPC1+HostPC4+AmenitiesPC1+AmenitiesPC2+AmenitiesPC3+AmenitiesPC4+AmenitiesPC5+
                AmenitiesPC6+AmenitiesPC8+AmenitiesPC10+AmenitiesPC11+
                AmenitiesPC12+AmenitiesPC13+AmenitiesPC14+AmenitiesPC15   , family = "binomial")
summary(Model3)
pR2(Model3)
auc(roc(Model3$fitted.values, Model3$data$is_business_travel_ready)
)
plot(Model3)


## Lets add some other stuff, like what is in 

Model4 <- glm(data = Model, is_business_travel_ready~ is.na(host_response_rate) + 
                host_is_superhost+ AmenitiesPC1+AmenitiesPC2+AmenitiesPC3+AmenitiesPC4+AmenitiesPC5+
                AmenitiesPC6+AmenitiesPC8+AmenitiesPC10+AmenitiesPC11+
                AmenitiesPC12+AmenitiesPC13+AmenitiesPC14+AmenitiesPC15+review_scores_rating+review_scores_accuracy+review_scores_cleanliness+review_scores_checkin+review_scores_communication         
              +instant_bookable , family = "binomial")
summary(Model4)
pR2(Model4)
auc(roc(Model4$fitted.values, Model4$data$is_business_travel_ready[is.na(Model4$data$review_scores_accuracy)==F])
)

plot(roc(Model4$fitted.values, Model4$data$is_business_travel_ready[is.na(Model4$data$review_scores_accuracy)==F])
)
plot(Model4)


Model4 <- randomForest(data = Model, is_business_travel_ready~host_response_rate + 
                host_is_superhost+ AmenitiesPC1+AmenitiesPC2+AmenitiesPC3+AmenitiesPC4+AmenitiesPC5+
                AmenitiesPC6+AmenitiesPC8+AmenitiesPC10+AmenitiesPC11+
                AmenitiesPC12+AmenitiesPC13+AmenitiesPC14+AmenitiesPC15+review_scores_rating+review_scores_accuracy+review_scores_cleanliness+review_scores_checkin+review_scores_communication         
              +instant_bookable , na.action = na.omit, do.trace=10)
