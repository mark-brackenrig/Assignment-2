###Sentiment of reviews ###
library(tidyverse)
library(tidytext)
library(tm)
#look at sentiments
sentiments
#get positive and negative words 
sentiment <- subset(sentiments, sentiments$sentiment %in% c("positive", "negative"))

#Remove all of the F-ed characters
rmSpec <- "¬|æ|¿|é|ç|¹|å|«|???|???|.|ª|¤|£|Z|ë|T|¯|®|o|¾|ä|º|???|¥|¼|°|±|???|è|¡|Y|???|???|???|???|???|???|???|???|???|???|???|???|???|???|???|???|???|???|???|???|???|???"
reviews$exclude <- grepl(rmSpec, reviews$comments)

#only include roman characters... avoid all of the other languages
normies <- "q|w|e|r|t|y|u|i|o|p|a|s|d|f|g|h|j|k|l|z|x|c|v|b|n|m"
reviews$include <- grepl(normies, reviews$comments)
reviews$includenames <- grepl(normies, reviews$reviewer_name)
reviews$comments <-removePunctuation(reviews$comments)
reviews$comments <-tolower(reviews$comments)
reviews$comments <-removeWords(reviews$comments, stopwords('english'))
reviews$comments <- removeNumbers(reviews$comments)
reviews$comments <- stripWhitespace(reviews$comments)


reviews <- subset(reviews, reviews$exclude==F&reviews$include==T&reviews$includenames==T)
#Stem the words in both the sentiment and the


#Convert into a corpus
reviewcorpus <- as.VCorpus(as.list(reviews$comments))

#Convert to DTM
reviewdtm <- DocumentTermMatrix(reviewcorpus)
