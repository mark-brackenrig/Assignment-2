####is there an assication between price and occupancy rates and whether the property has BR status

Model1 <- glm(data = Model,is_business_travel_ready~price+bookings, family = "binomial")

summary(Model1)

#Both are highly significant, are the predictors correlated?

cor(Model$price, Model$bookings)

#No,they are not correlated! hazaa

plot(Model1)


#these plots dont look right. Lets inspect the variables
hist(Model$price)
hist(Model$bookings)


#Wowza!both are very right skew, lets transform

Model2 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1), family = "binomial")


summary(Model2)

#Both are highly signficant predictors
library(AUC)
library(pscl)
boxplot(Model2$fitted.values~Model2$model$is_business_travel_ready)

auc(roc(Model2$fitted.values,Model2$model$is_business_travel_ready))

plot(roc(Model2$fitted.values,Model2$model$is_business_travel_ready))
#Not an amazingly high AUC but still pretty good
pR2(Model2)

#Even though AUC is okay. The McFadden R^2 is low
plot(Model2)

#Still do not look good. Maybe there is an interaction term?

Model3 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(price+0.1)*log(bookings+0.1), family = "binomial")


summary(Model3)


#I need to review the text on this one. But I do not htink the assumptions apply here


#Making Adjustment
#There are other variables that can rerpresent occupancy
Model$reviews_per_month[is.na(Model$reviews_per_month)] <-0
Model4 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(reviews_per_month+0.1), family = "binomial")

summary(Model4)

boxplot(Model4$fitted.values~Model4$model$is_business_travel_ready)

auc(roc(Model4$fitted.values,Model4$model$is_business_travel_ready))

plot(roc(Model4$fitted.values,Model4$model$is_business_travel_ready))

#The ROC is getting there! HAZZAH!

pR2(Model4)

#Even though AUC is goodl. The McFadden R^2 is still reasonably low
plot(Model4)


#Can I include some stuff about Price?
Model5 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(reviews_per_month+0.1)+log(cleaning_fee+0.1), family = "binomial")

summary(Model5)

boxplot(Model5$fitted.values~Model5$model$is_business_travel_ready)

auc(roc(Model5$fitted.values,Model5$model$is_business_travel_ready))

plot(roc(Model5$fitted.values,Model5$model$is_business_travel_ready))

#The ROC is getting there! HAZZAH!

pR2(Model5)


#Lets check correlations
cor(Model5$model[,-1])

#Cleaning fee and price have a correlation >0.3 throw in an interaction

Model6 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(reviews_per_month+0.1)+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1), family = "binomial")

summary(Model6)

boxplot(Model6$fitted.values~Model6$model$is_business_travel_ready)

auc(roc(Model6$fitted.values,Model6$model$is_business_travel_ready))

#AUC is up up and awaayyyyy
plot(roc(Model6$fitted.values,Model6$model$is_business_travel_ready))

#The ROC is getting there! HAZZAH!

pR2(Model6)


### Include availability

#Firstly view availability
hist(Model$availability_30)
hist(Model$availability_60)
hist(Model$availability_90)
hist(Model$availability_365)

#lets covert these to factors

Model$Av30 <- factor(ifelse(Model$availability_30==0,"Zero", ifelse(Model$availability_30==30,"Thirty","One to 29")))

Model6 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(reviews_per_month+0.1)+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1)+log(availability_90+0.1), family = "binomial")

summary(Model6)

boxplot(Model6$fitted.values~Model6$model$is_business_travel_ready)

auc(roc(Model6$fitted.values,Model6$model$is_business_travel_ready))

#AUC is up up and awaayyyyy
plot(roc(Model6$fitted.values,Model6$model$is_business_travel_ready))

#The ROC is getting there! HAZZAH!

pR2(Model6)




#TODO backward model selection


