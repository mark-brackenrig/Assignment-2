###
# Profile Image Analysis Processes: see spreadsheet 'Munging.xlsx','Image Analysis' tab for mockup.
###

# This is more of a process instruction rather than a r sni  Extract id and picture_url from listings file
#id	picture_url
#13467416	https://a0.muscache.com/im/pictures/778d441e-2c94-431a-8307-b32eaec69930.jpg?aki_policy=large
#15882089	https://a0.muscache.com/im/pictures/3e9e50cf-2949-4a9e-9782-fecf327ea75a.jpg?aki_policy=large

## Remove '?aki_policy=large' on all picture url to the image direct link
#id	picture_url
#13467416	https://a0.muscache.com/im/pictures/778d441e-2c94-431a-8307-b32eaec69930.jpg
#15882089	https://a0.muscache.com/im/pictures/3e9e50cf-2949-4a9e-9782-fecf327ea75a.jpg
#...

#Process the picture to get the context of each photo to get the context confidencelevel
#id	context	confidencelevel
#13467416	Building	0.923
#13467416	Housing	0.923
#13467416	Apartment Building	0.547
#13467416	Architecture	0.512
#15882089	Building	0.962
#15882089	Housing	0.962
#15882089	Apartment Building	0.511
#16197117	Building	0.505
#16197117	Housing	0.505
#16197117	Apartment	0.505
#22298997	Building	0.798
#22298997	Housing	0.798
#22298997	Apartment	0.798
#....
#....

## Analysis the output and find the most appeared context in this case 'Building' and 'Housing', and some intersting features,  high_rise
#id	context	confidencelevel	Count of context
#13467416	Building	0.923	4
#15882089	Building	0.962	4
#16197117	Building	0.505	4
#22298997	Building	0.798	4
#13467416	Housing	0.923	4
#15882089	Housing	0.962	4
#16197117	Housing	0.505	4
#22298997	Housing	0.798	4
#13467416	Architecture	0.512	2
#15882089	Architecture	0.51	2
#13467416	City	0.587	2
#15882089	City	0.665	2
#13467416	Downtown	0.586	2
#15882089	Downtown	0.665	2
#16197117	Furniture	0.519	2
#22298997	Furniture	0.601	2
#13467416	High Rise	0.587	2
#15882089	High Rise	0.52	2
#...
#...


## Convert the most appeared words into features for adding back to the lising
#id	has_building	has_housing	has_high_rise	has_city
#13467416	1	1	1	1
#15882089	1	1	1	1
#16197117	1	1	0	0
#22298997	1	1	0	0

## R code for Merge new feature columns back to the main listings list for regression analysis
libarry(tidyverse)

image <- read.csv("image.csv")
listings <- read.csv("listings.csv")

listings2 <- merge(listings, image)




