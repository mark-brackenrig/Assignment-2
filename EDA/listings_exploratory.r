### EDA ####
library(leaflet)
library(htmltools)
library(RColorBrewer)
library(scales)
Mark <- merge(listings, subset(`Opera House by Public Transport`, is.na(`Opera House by Public Transport`$Time)==F), by = "id")


#Check time and distance against whether it is business travel ready
boxplot(log(Mark$Distance)~Mark$is_business_travel_ready)
boxplot(log(Mark$Time)~Mark$is_business_travel_ready)

#How about price?

#minimal correlation
cor(Mark$Time, Mark$price)

cor(Mark$Distance, Mark$price)

plot(Mark$Time/3600, Mark$price)

plot(Mark$Distance, Mark$price)

cor(Mark$Time[is.na(Mark$square_feet)==F], Mark$square_feet[is.na(Mark$square_feet)==F])


#plot price against sydney

initial_lat = -33.9
initial_lng = 151.18
initial_zoom = 10

pal <-  colorFactor(c("red","green") , Mark$is_business_travel_ready)

leaflet(Mark) %>% addProviderTiles(providers$CartoDB.Positron,
                                   options = providerTileOptions(noWrap = TRUE)
)%>%
  setView(lat = initial_lat, lng = initial_lng, zoom = initial_zoom) %>%
  clearMarkers() %>%
  addCircleMarkers(
    color = ~pal(Mark$is_business_travel_ready),
    radius = ~(price^0.5)/10,
    stroke = FALSE, fillOpacity = 0.5,
    labelOptions= labelOptions(style = list("white-space"= "pre", "font-size"= "14px")))

#It appears things on the east coast are more expensive

cor(Mark$price,Mark$longitude)
cor(Mark$price,Mark$latitude)

test <- lm( Mark$price~Mark$longitude+Mark$latitude)
summary(test)
