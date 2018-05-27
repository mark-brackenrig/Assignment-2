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
  layout(title = "Business Ready (BR) listings by <br> Distance to the Opera House",  yaxis = list(title = "Natural Logarithm of Distance (m) to <br> the Opera house by Public Transport"),xaxis = list(title = " ")  )%>%
  config(displayModeBar = F)

plot_ly(data = Model, y=~reviews_per_month, x = ~ifelse(is_business_travel_ready=='t', "Business Travel Ready", "Not Business Travel Ready"), type = "box")%>%
  layout(title = "Business Ready (BR) listings by Reviews Per Month",  yaxis = list(title = "Reviews per Month"),xaxis = list(title = " ")  )%>%
  config(displayModeBar = F)

plot_ly(data = Model, y=~reviews_per_month, x = ~ifelse(is_business_travel_ready=='t', "Business Travel Ready", "Not Business Travel Ready"), type = "box")%>%
  layout(title = "Business Ready (BR) listings by Reviews Per Month",  yaxis = list(title = "Reviews per Month"),xaxis = list(title = " ")  )%>%
  config(displayModeBar = F)


plot_ly(data = subset(Model,Model$is_business_travel_ready=='f'), y=~log(reviews_per_month), x = ~log(price), type = "scatter", name = "Not Business Travel Ready", marker = list(color = c("red")), opacity = 0.6)%>%
    add_trace(data = subset(Model,Model$is_business_travel_ready=='t'), y=~log(reviews_per_month), x = ~log(price), type = "scatter", name = "Business Travel Ready", marker = list(color = c("blue")), opacity = 0.8)%>%
  add_trace( x=4.95, y = c(-4,4), type = "scatter", mode= "lines", line = list(color = c("black")), marker = list(color = c("black"), size = 0), opacity = 1, name = "Average Log(Price)")%>%
  add_trace( x=c(2,10), y =-0.57, type = "scatter", mode= "lines", line = list(color = c("black")), marker = list(color = c("black"), size = 0), opacity = 1, name = "Aerage Log(Reviews per Month)")%>%
  layout(title = "Reviews Per Month by Price",  yaxis = list(title = "Natural Logarithm of Reviews per Month", showgrid = F, zeroline = F),xaxis = list(title = "Natural Logarithm of Price", showgrid = F)  )%>%
  config(displayModeBar = F)

plot_ly(data = subset(Model,Model$is_business_travel_ready=='f'), y=~log(reviews_per_month), x = ~Cancelflag, type = "scatter", name = "Not Business Travel Ready", marker = list(color = c("red")), opacity = 0.6)%>%
  add_trace(data = subset(Model,Model$is_business_travel_ready=='t'), y=~log(reviews_per_month), x = ~Cancelflag, type = "scatter", name = "Business Travel Ready", marker = list(color = c("blue")), opacity = 0.8)%>%
  layout(title = "Reviews Per Month by Cancel Flag",  yaxis = list(title = "Natural Logarithm of Reviews per Month", showgrid = F, zeroline = F),xaxis = list(title = "Cancel Flag", showgrid = F,zeroline = F)  )%>%
  config(displayModeBar = F)

Chart2 <- as.data.frame(prop.table(table(Model$reviewflag, Model$is_business_travel_ready),2))


plot_ly(data = subset(Chart2, Chart2$Var2=="t"), y=~Freq*100, x = ~Var1, type = "bar", hoverinfo = 'text',
        text = ~paste0("Proportion: ", round(Freq,digits = 2),"%"), name = "Business Ready")%>%
  add_trace(data = subset(Chart2, Chart2$Var2=="f"), y=~Freq*100, x = ~Var1 ,type = "bar", hoverinfo = 'text',
          text = ~paste0("Proportion: ", round(Freq,digits = 2),"%"), name = "Not Buiness Ready")%>%
  layout(title = "Number of Properties that are 'Business Travel Ready'",  yaxis = list(title = "Proportion of listings in Sydney"),barmode = "group"
  )%>%
  config(displayModeBar = F)

plot_ly(data = subset(Model,Model$is_business_travel_ready=='f'), y=~AmenitiesPC2, x = ~AmenitiesPC1, type = "scatter", name = "Not Business Travel Ready", marker = list(color = c("red")), opacity = 0.6)%>%
  add_trace(data = subset(Model,Model$is_business_travel_ready=='t'), y=~AmenitiesPC2, x = ~AmenitiesPC1, type = "scatter", name = "Business Travel Ready", marker = list(color = c("blue")), opacity = 0.8)%>%
  layout(title = "Amenities Principal Components",  yaxis = list(title = "Second Principal Component", showgrid = F, zeroline = F),xaxis = list(title = "First Principal Component", showgrid = F)  )%>%
  config(displayModeBar = F)


plot_ly(data = Model, y=~HostPC1, x = ~ifelse(is_business_travel_ready=='t', "Business Travel Ready", "Not Business Travel Ready"), type = "box")%>%
  layout(title = "First PC of Host Verifications",  yaxis = list(title = "First Principal Component of Host Verification"),xaxis = list(title = " ")  )%>%
  config(displayModeBar = F)


