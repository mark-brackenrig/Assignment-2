

Amenfeatures <- as.data.frame(AmenComp$rotation)[,1:8]

for(i in 1:8){
Amenfeatures1 <- subset(Amenfeatures[order(abs(Amenfeatures[,i]),decreasing =  T),], select = c(paste0("PC",i)))[1:25,]
Amenfeaturesrow <- row.names(Amenfeatures[order(abs(Amenfeatures[,i]),decreasing =  T),][1:25,])

Amenfeaturestemp <- data.frame(Amenities = Amenfeaturesrow, Value =Amenfeatures1 )

Amenfeaturestemp$Amenities <- as.character(Amenfeaturestemp$Amenities)
Amenfeaturestemp$Amenities <- gsub(pattern = "Amenities_",replacement = "",Amenfeaturestemp$Amenities)

assign( paste0("Amenitiesfeatures",i),Amenfeaturestemp)
}


plot_ly(data = Amenitiesfeatures1, y=~Value, x = ~Amenities, type = "bar", hoverinfo = 'text',
        text = ~paste0("Value: ", round(Value,digits = 2),"<br>", "Amenity: ", Amenities), name = "Business Ready")%>%
  layout(title = "Principal Component 1 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
         margin = list(b = 200)
  )%>%
  config(displayModeBar = F)

plot_ly(data = Amenitiesfeatures2, y=~Value, x = ~Amenities, type = "bar", hoverinfo = 'text',
        text = ~paste0("Value: ", round(Value,digits = 2),"<br>", "Amenity: ", Amenities), name = "Business Ready")%>%
  layout(title = "Principal Component 2 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
         margin = list(b = 200)
  )%>%
  config(displayModeBar = F)

plot_ly(data = Amenitiesfeatures3, y=~Value, x = ~Amenities, type = "bar", hoverinfo = 'text',
        text = ~paste0("Value: ", round(Value,digits = 2),"<br>", "Amenity: ", Amenities), name = "Business Ready")%>%
  layout(title = "Principal Component 3 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
         margin = list(b = 200)
  )%>%
  config(displayModeBar = F)

plot_ly(data = Amenitiesfeatures4, y=~Value, x = ~Amenities, type = "bar", hoverinfo = 'text',
        text = ~paste0("Value: ", round(Value,digits = 2),"%<br>", "Amenity: ", Amenities), name = "Business Ready")%>%
  layout(title = "Principal Component 4 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
         margin = list(b = 200)
  )%>%
  config(displayModeBar = F)

plot_ly(data = Amenitiesfeatures5, y=~Value, x = ~Amenities, type = "bar", hoverinfo = 'text',
        text = ~paste0("Value: ", round(Value,digits = 2),"<br>", "Amenity: ", Amenities), name = "Business Ready")%>%
  layout(title = "Principal Component 5 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
         margin = list(b = 200)
  )%>%
  config(displayModeBar = F)

plot_ly(data = Amenitiesfeatures6, y=~Value, x = ~Amenities, type = "bar", hoverinfo = 'text',
        text = ~paste0("Value: ", round(Value,digits = 2),"<br>", "Amenity: ", Amenities), name = "Business Ready")%>%
  layout(title = "Principal Component 6 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
         margin = list(b = 200)
  )%>%
  config(displayModeBar = F)


plot_ly(data = Amenitiesfeatures7, y=~Value, x = ~Amenities, type = "bar", hoverinfo = 'text',
        text = ~paste0("Value: ", round(Value,digits = 2),"<br>", "Amenity: ", Amenities), name = "Business Ready")%>%
  layout(title = "Principal Component 7 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
         margin = list(b = 200)
  )%>%
  config(displayModeBar = F)

plot_ly(data = Amenitiesfeatures8, y=~Value, x = ~Amenities, type = "bar", hoverinfo = 'text',
        text = ~paste0("Value: ", round(Value,digits = 2),"<br>", "Amenity: ", Amenities), name = "Business Ready")%>%
  layout(title = "Principal Component 8 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
         margin = list(b = 200)
  )%>%
  config(displayModeBar = F)


Hostfeatures <- as.data.frame(HostComp$rotation)[,1:2]


  Hostfeatures1 <- subset(Hostfeatures[order(abs(Hostfeatures[,1]),decreasing =  T),], select = c(paste0("PC",1)))[1:25,]
  Hostfeaturesrow <- row.names(Hostfeatures[order(abs(Hostfeatures[,1]),decreasing =  T),][1:25,])
  
  Hostfeaturestemp <- data.frame(Host = Hostfeaturesrow, Value =Hostfeatures1 )
  
  Hostfeaturestemp$Host <- as.character(Hostfeaturestemp$Host)
  Hostfeaturestemp$Host <- gsub(pattern = "host_verification_",replacement = "",Hostfeaturestemp$Host)
  
  plot_ly(data = Hostfeaturestemp, y=~Value, x = ~Host, type = "bar", hoverinfo = 'text',
          text = ~paste0("Value: ", round(Value,digits = 2),"<br>", "Amenity: ", Host), name = "Business Ready")%>%
    layout(title = "Principal Component 1 Value",  yaxis = list(title = "Value of Component"),barmode = "group",
           margin = list(b = 200)
    )%>%
    config(displayModeBar = F)


