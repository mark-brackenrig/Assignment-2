###Sentiment of reviews ###
library(tidyverse)
library(tidytext)
library(tm)
#look at sentiments
sentiments
#get positive and negative words 
sentiment <- subset(sentiments, sentiments$sentiment %in% c("positive", "negative"))

reviews$comments <-removePunctuation(reviews$comments)
reviews$comments <-tolower(reviews$comments)
reviews$comments <-removeWords(reviews$comments, stopwords('english'))
reviews$comments <- removeNumbers(reviews$comments)
reviews$comments <- stripWhitespace(reviews$comments)

#Remove all of the F-ed characters
rmSpec <- "¬|æ|¿|é|ç|¹|å|«|ª|¤|£|ë|¯|®|¾|ä|º|¥|¼|°|±|è|¡|<U+|???|???|???|???|???|???|ë|¬|¸|í|T|"|ì"

reviews$exclude <- grepl(rmSpec, tolower(reviews$comments))

#only include roman characters... avoid all of the other languages
normies <- "a|e|i|o|u|y"
reviews$include <- grepl(normies, tolower(reviews$comments))
reviews$includenames <- grepl(normies, reviews$reviewer_name)
reviewIDforexclusion <- read_excel("G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/reviewIDforexclusion.xlsx")

reviews <- subset(reviews, reviews$exclude==F&reviews$include==T&reviews$includenames==T&!reviews$id%in%reviewIDforexclusion$review_id)
#Stem the words in both the sentiment and the


#Convert into a corpus
reviewcorpus <- as.VCorpus(as.list(reviews$comments))

#Convert to DTM
reviewdtm <- DocumentTermMatrix(reviewcorpus)
