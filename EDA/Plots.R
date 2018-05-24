#Calculate Straight Line distance

Mark$distancestraight <- sqrt((Mark$latitude+33.8568)^2+(Mark$longitude-151.2153)^2)

Mark$distancestraightnormal[is.na(Mark$distancestraight)==F] <- (Mark$distancestraight[is.na(Mark$distancestraight)==F]-mean(Mark$distancestraight[is.na(Mark$distancestraight)==F]))/sd(Mark$distancestraight[is.na(Mark$distancestraight)==F])

cor(Mark$distancestraight[is.na(Mark$distancestraight)==F], Mark$Distance[is.na(Mark$distancestraight)==F])

Plot1 <- subset(Mark,Mark$is_business_travel_ready=="t"&is.na(Mark$Time)==F)
Plot1$Timenormal <- (Plot1$Time-mean(Plot1$Time))/sd(Plot1$Time)

pal <-  colorNumeric(c("green","yellow","red","red","red","red2") , Plot1$Time/60)

leaflet(Plot1) %>% addProviderTiles(providers$CartoDB.Positron,options = providerTileOptions(noWrap = TRUE))%>%
  setView(lat = initial_lat, lng = initial_lng, zoom = initial_zoom) %>%
  clearMarkers() %>%
  addLegend("bottomright", pal = pal, values = ~c(10,30,50,70,90),
            title = "Time to Opera House <br> by Public Transport",
            labFormat = labelFormat(suffix = "min"),
            opacity = 1) %>%
  addCircleMarkers(
    color = ~pal(Plot1$Time/60),
    radius = 3,
    stroke = FALSE, fillOpacity = 0.5,
    labelOptions= labelOptions(style = list("white-space"= "pre", "font-size"= "14px")))
 

