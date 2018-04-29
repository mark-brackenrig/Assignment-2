# This is second attempt at sentiment analysis using an on-premise library the technique outlined here:
# http://varianceexplained.org/r/yelp-sentiment/
# Because this is similar to yelp reviews (which is what we want), it proposes a "good enough" model using the tidytext package
# It uses a trick first to predict the number of stars based on the review

install.packages("tidytext")
library(tidytext)
library(tidyverse)




# Get Review Data
reviews_filename = 'G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/reviews.csv'
reviews <- read_csv(reviews_filename)