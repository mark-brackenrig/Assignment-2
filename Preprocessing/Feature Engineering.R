## Feature Engineering ##
library(caret)

####Amenities####

# I removed a number of columns that have a very low number of positives (less than 2%)
Amenities <- Amenities[,c(keep)]

findCorrelation(cor(Amenities[,-1]), cutoff = 0.3)
#there is a  number of correlations in the data set above 0.3, This would suggest conducting PCA

AmenComp <- prcomp(Amenities[,-1])


screeplot(AmenComp,type = c("lines"))

#From the visual method it is hard to determine the number of Principal components to select

summary(AmenComp)

#using the prop variance >60% We may wish to extract the firstt 15 principal components

#Inspect Principal Components

Amenities_comp <- as.data.frame(predict(AmenComp, Amenities))
Amenities_comp <- cbind(Amenities$id, Amenities_comp)
Amenities_comp$id <- Amenities_comp$`Amenities$id`
Amenities_comp$`Amenities$id` <- NULL
colnames(Amenities_comp) <- c(paste0("Amenities", colnames(Amenities_comp[,-82])), "id")


#### Host Verifications ####
findCorrelation(cor(Host_Verifications[,-1]), cutoff = 0.3) #A number of correlations are above .3

HostComp <- prcomp(Host_Verifications[,-1])


screeplot(HostComp,type = c("lines"))

#visual method looks like 8 Pr comps

summary(HostComp)
print(HostComp)
# 8 principal components accounts for much of the variance, we could get away with 5.
Host_comp <- as.data.frame(predict(HostComp, Host_Verifications))
Host_comp <- cbind(Host_comp, Host_Verifications$id)
Host_comp$id <- Host_comp$`Host_Verifications$id`
Host_comp$`Host_Verifications$id` <- NULL
colnames(Host_comp) <- c(paste0("Host", colnames(Host_comp[,-28])), "id")

#I do not have enough mmoney in my account ot do this, I could use my work one but I need to get permission

####Reviews####
library(googleLanguageR)

#gl_auth("Insert JSON file Here")

#Reviews_NLP <- gl_nlp(reviews$comments)

#Reviews_Sentiment <- as.data.frame(Reviews_NLP$documentSentiment)

#Reviews_language <- as.data.frame(Reviews_NLP$language) 

####Calendar####
library(timeDate)
Cal_Strucmean <- aggregate(calendar$price[calendar$available=='t'], by = list(calendar$listing_id[calendar$available=='t']),mean)
Cal_Strucmin <- aggregate(calendar$price[calendar$available=='t'], by = list(calendar$listing_id[calendar$available=='t']),min)
Cal_Strucmax <- aggregate(calendar$price[calendar$available=='t'], by = list(calendar$listing_id[calendar$available=='t']),mean)
Cal_Strucskew <- aggregate(calendar$price[calendar$available=='t'], by = list(calendar$listing_id[calendar$available=='t']),skewness)
Cal_Strucsd <- aggregate(calendar$price[calendar$available=='t'], by = list(calendar$listing_id[calendar$available=='t']),sd)

colnames(Cal_Strucmean) <- c("id","mean")
colnames(Cal_Strucmin) <- c("id","min")
colnames(Cal_Strucmax) <- c("id","max")
colnames(Cal_Strucskew) <- c("id","skew")
colnames(Cal_Strucsd) <- c("id","sd")

Cal_Struc <- merge(merge(Cal_Strucmean,Cal_Strucmin), merge(merge(Cal_Strucmax,Cal_Strucskew), Cal_Strucsd), by = "id")

rm("Cal_Strucmean","Cal_Strucmin","Cal_Strucmax","Cal_Strucskew","Cal_Strucsd")


