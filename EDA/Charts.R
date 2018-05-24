####Charting#####
library(tidyverse)
library(plotly)
#Br Listings

Chart1 <- as.data.frame(prop.table(table(listings$is_business_travel_ready))*100)


plot_ly(data = Chart1, y=~Freq, x = c("Not Business Travel Ready", "Business Travel Ready"), type = "bar", hoverinfo = 'text',
        text = ~paste0("Proportion: ", round(Freq,digits = 2),"%"))%>%
  layout(title = "Number of Properties that are 'Business Travel Ready'",  yaxis = list(title = "Proportion of listings in Sydney")
         )%>%
  config(displayModeBar = F)


plot_ly(data = listings, y=~log(price), x = ~ifelse(is_business_travel_ready=='t', "Business Travel Ready", "Not Business Travel Ready"), type = "box")%>%
  layout(title = "Business Ready (BR) listings by price",  yaxis = list(title = "Natural Logarithm of Price"),xaxis = list(title = " ")  )%>%
  config(displayModeBar = F)


plot_ly(data = Model, y=~Time/3600, x = ~ifelse(is_business_travel_ready=='t', "Business Travel Ready", "Not Business Travel Ready"), type = "box")%>%
  layout(title = "Business Ready (BR) listings by Time to the Opera House",  yaxis = list(title = "Time to the Opera house <br> by Public Transport (in hours)"),xaxis = list(title = " ")  )%>%
  config(displayModeBar = F)

plot_ly(data = Model, y=~log(Distance), x = ~ifelse(is_business_travel_ready=='t', "Business Travel Ready", "Not Business Travel Ready"), type = "box")%>%
  layout(title = "Business Ready (BR) listings by Distance to the Opera House",  yaxis = list(title = "Natural Logarithm of Distance (m) to <br> the Opera house by Public Transport"),xaxis = list(title = " ")  )%>%
  config(displayModeBar = F)
