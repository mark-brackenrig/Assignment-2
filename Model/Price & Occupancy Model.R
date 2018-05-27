####is there an assication between price and occupancy rates and whether the property has BR status
library(AUC)
library(pscl)

set.seed(42)
Sample <- sample(x = nrow(Model),nrow(Model)*0.7)

train <- Model[Sample,]
test <- Model[-Sample,]

Model1 <- glm(data = train,is_business_travel_ready~price+bookings, family = "binomial")

summary(Model1)

#Both are highly significant, are the predictors correlated?


#these plots dont look right. Lets inspect the variables
hist(Model$price)
hist(Model$bookings)



#Wowza!both are very right skew, lets transform

Model2 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1), family = "binomial")


summary(Model2)

#Both are highly signficant predictors

boxplot(Model2$fitted.values~Model2$model$is_business_travel_ready)

auc(roc(Model2$fitted.values,Model2$model$is_business_travel_ready))

plot(roc(Model2$fitted.values,Model2$model$is_business_travel_ready))
#Not an amazingly high AUC but still pretty good
pR2(Model2)

#Even though AUC is okay. The McFadden R^2 is low
#plot(Model2)

#Still do not look good. Maybe there is an interaction term?

#Model3 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(price+0.1)*log(bookings+0.1), family = "binomial")


#summary(Model3)


#I need to review the text on this one. But I do not htink the assumptions apply here


#Making Adjustment
#There are other variables that can rerpresent occupancy
Model3 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(reviews_per_month+0.1), family = "binomial")

summary(Model3)

boxplot(Model3$fitted.values~Model3$model$is_business_travel_ready)

auc(roc(Model3$fitted.values,Model3$model$is_business_travel_ready))

plot(roc(Model3$fitted.values,Model3$model$is_business_travel_ready))

#The ROC is getting there! HAZZAH!



pR2(Model3)

#Even though AUC is goodl. The McFadden R^2 is still reasonably low
#plot(Model4)






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

Model6 <- glm(data = train,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(reviews_per_month+0.1)+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1)+log(availability_90+0.1), family = "binomial")

summary(Model6)

boxplot(Model6$fitted.values~Model6$model$is_business_travel_ready)

auc(roc(Model6$fitted.values,Model6$model$is_business_travel_ready))

#AUC is up up and awaayyyyy
plot(roc(Model6$fitted.values,Model6$model$is_business_travel_ready))

#The ROC is getting there! HAZZAH!

pR2(Model6)




Model7 <- glm(data = train,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(reviews_per_month+0.1)+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1)+log(availability_90+0.1)+log(number_of_reviews+0.1), family = "binomial")

summary(Model7)

boxplot(Model7$fitted.values~Model7$model$is_business_travel_ready)

auc(roc(Model7$fitted.values,Model7$model$is_business_travel_ready))

#AUC is up up and awaayyyyy
plot(roc(Model7$fitted.values,Model7$model$is_business_travel_ready))


Model8 <- glm(data = train,is_business_travel_ready~log(price+0.1)+log(reviews_per_month+0.1)+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1)+log(number_of_reviews+0.1)+log(reviews_per_month+0.1):log(number_of_reviews+0.1), family = "binomial")

summary(Model8)

boxplot(Model8$fitted.values~Model8$model$is_business_travel_ready)

auc(roc(Model8$fitted.values,Model8$model$is_business_travel_ready))




test$model8predict <- predict(Model8, test,type = "response")
train$model8predict <- predict(Model8, train,type = "response")

auc(roc(train$model8predict,train$is_business_travel_ready))

auc(roc(test$model8predict,test$is_business_travel_ready))
plot(roc(test$model8predict,test$is_business_travel_ready))

#TODO backward model selection

#Model1 <- subset(Model, Model$is_business_travel_ready=='f')[sample(x = nrow(subset(Model, Model$is_business_travel_ready=='f')),size =nrow(subset(Model, Model$is_business_travel_ready=='f'))*0.1 ),]

#Model1 <- rbind(Model1,subset(Model, Model$is_business_travel_ready=='t'))


#Model7 <- glm(data = Model1,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+log(reviews_per_month+0.1)+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1)+log(availability_90+0.1), family = "binomial")

#summary(Model7)

#auc(roc(Model7$fitted.values,Model7$model$is_business_travel_ready))

#boxplot(Model7$fitted.values~Model7$model$is_business_travel_ready)


#Model$reviewflag <- ifelse(Model$reviews_per_month==0,"Zero",
#                           ifelse(Model$reviews_per_month>0&Model$reviews_per_month<1,"between 0 and 1", "More than one"))

#Model$reviewflag <- factor(Model$reviewflag, levels = c("Zero", "between 0 and 1", "More than one"), ordered = T)
#Model8 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+reviewflag+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1)+log(availability_90+0.1), family = "binomial")

#summary(Model8)

#auc(roc(Model8$fitted.values,Model8$model$is_business_travel_ready))


#Model <- subset(Model, abs(Model$residuals)<10)


#Model9 <- glm(data = Model,is_business_travel_ready~log(price+0.1)+log(bookings+0.1)+reviewflag+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1)+log(availability_90+0.1), family = "binomial")

#summary(Model9)


#auc(roc(Model9$fitted.values,Model9$model$is_business_travel_ready))

#boxplot(Model9$fitted.values~Model9$model$is_business_travel_ready)

#sum(residuals(Model6, type = "deviance")^2)/Model6$df.residual

Model9 <- glm(data = train,is_business_travel_ready~log(price+0.1)+log(reviews_per_month+0.1)+log(cleaning_fee+0.1)+log(cleaning_fee+0.1):log(price+0.1)+log(number_of_reviews+0.1)+log(reviews_per_month+0.1):log(number_of_reviews+0.1)+Cancelflag+AmenitiesPC1+AmenitiesPC2+AmenitiesPC3+AmenitiesPC5+AmenitiesPC6+AmenitiesPC7+HostPC1+host_is_superhost, family = "binomial")

summary(Model9)

auc(roc(Model9$fitted.values,Model9$model$is_business_travel_ready))


test$model9predict <- predict(Model9, test,type = "response")
train$model9predict <- predict(Model9, train,type = "response")

auc(roc(train$model9predict,train$is_business_travel_ready))

auc(roc(test$model9predict,test$is_business_travel_ready))

