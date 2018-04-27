# UPDATE
# This method is not workable - there is over 350,000 reviews
# Costs are in range of 1500-2000 dollars to source this data.
# Running across multiple free API's for sentiment still cannot process same amount.
# Move to using on-premise sentiment tool

# Notes:
# This function is intended to get sentiment data for the reviews from AIRBNB
# The purpose is to feature engineer a new feature against each airbnb listing to understand the overall
# sentiment against that listing. 
#
# API Notes:
# The API is a RESTFul webservice using JSON as data format exchange.
# There is a max of 5k per month uses
# Need to distribute around team to run

# Load Libraries
library(tidyverse)
library(httr)       # For constructing POST request
library(jsonlite)   # For converting JSON to data frame
library(data.table)
library(dplyr)

# Params for API update
# Can only run 5000 Queries per month, so each person needs to update the start and end to distribute.
start = 0
end = 5000

# Get Review Data
reviews_filename = 'G:/Team Drives/STDS - Assignment 2 - 3MDL/Dataset/AirBnB/reviews.csv'
reviews <- read_csv(reviews_filename)

df <- reviews[start:end,c('id','comments')]

# Azure API expects request format params of 'id' and 'text'
df <- rename(df, text = comments)
data <-list(documents=df)

# Call Sentiment API
api_key = '71efd21c43984d6685105508e235dc8b'
sentiment_api_url = "https://westcentralus.api.cognitive.microsoft.com/text/analytics/v2.0/sentiment"

# Call API
response <- POST(sentiment_api_url, 
                 add_headers(`Ocp-Apim-Subscription-Key`=api_key),
                 body=toJSON(data))
# Get Response
response_content <- content(response, as="text", encoding = "utf-8")

# convert JSON to data.frame
fromJSON(response_content)$documents %>%
  mutate(id=as.numeric(id)) ->
  responses

# Create table with Review ID and Sentiment Score only
df %>% left_join(responses, by = 'id') %>% select(c('id', 'score')) -> dfs

# Write out which records of dataset were done so not overlapping
write_csv(dfs, sprintf("data\\review_sentiment_start_%s_end_%s.csv",start,end))


