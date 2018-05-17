#Primary Research EDA

library(tidyr)
Primary_Research$Row <- NULL

Primary_Research$Something <- NULL
Primary_Research$Survey <- NULL
Primary_Research$Timestamp <- NULL
Primary_Research <- spread(Primary_Research,key = Question, value = Answer) 

Primary_Research <- merge(Primary_Research, Primary_Research_Demographics, by = "ID", all = T)
Primary_Research_Demographics <- NULL

#Cleaning
Primary_Research$age <- 2018-as.numeric(Primary_Research$DOB)
Primary_Research$`How much do you usually spend on accommodation when you travel?` <- factor(Primary_Research$`How much do you usually spend on accommodation when you travel?`, levels = c("0-$50 per night","$51-$100 per night","$101-$150 per night","$151-$250 per night" ,"$251- $350 per night","$351 - $500 per night","$500+ per night"), ordered= T)
Primary_Research$`How much would you, or your company, spend if you were to travel for work?` <- factor(Primary_Research$`How much would you, or your company, spend if you were to travel for work?`,levels = c("$1-$100 per night","$101-$150 per night","$151-$250 per night" ,"$251- $350 per night" ,"$351 - $500 per night" ,"My company would not pay for me to travel interstate"), ordered = T)
Primary_Research$`How often do you review accommodation providers online?` <- as.factor(Primary_Research$`How often do you review accommodation providers online?`)
Primary_Research$`How often do you travel interstate or overseas for leisure?` <- factor(Primary_Research$`How often do you travel interstate or overseas for leisure?`,levels = c("Never",  
            "Rarely (approximately once every 3-4 years or less)",
"Sometimes (once every 1-2 years)", 
"Regularly (at least once a year)",                   
"Often (at least once every six months)"  ), ordered= T)
Primary_Research$`How often do you travel interstate or overseas for work?`


#Boxplots
boxplot(Primary_Research$age~Primary_Research$`How much do you usually spend on accommodation when you travel?`)
boxplot(Primary_Research$age~Primary_Research$`How much would you, or your company, spend if you were to travel for work?`)

boxplot(Primary_Research$age~Primary_Research$`How often do you travel interstate or overseas for work?`)

table(Primary_Research$`How often do you travel interstate or overseas for work?`, Primary_Research$Income)

prop.table(table(Primary_Research$`Would you consider staying at an AirBnB when travelling for work?`, Primary_Research$`How often do you travel interstate or overseas for work?`!="Never"),2)


Chart_1 <- as.data.frame(prop.table(table(Primary_Research$`How much would you, or your company, spend if you were to travel for work?`[Primary_Research$`How much would you, or your company, spend if you were to travel for work?`!="My company would not pay for me to travel interstate"])))
listings$cleaning_fee[is.na(listings$cleaning_fee)]<-0
listings$price_total <- listings$price+listings$cleaning_fee
Chart_1$Var1 <- as.character(Chart_1$Var1)
Chart_1$Var1[Chart_1$Var1=="My company would not pay for me to travel interstate"] <- "$500+ per night"
Chart_1$Var1 <- as.factor(Chart_1$Var1)


listings$price_total_bands <- ifelse(listings$price_total<101,"$1-$100 per night",
                                     ifelse(listings$price_total<151,"$101-$150 per night",
                                            ifelse(       listings$price_total<251,"$151-$250 per night",
                                                          ifelse(listings$price_total<351,"$251-$350 per night",
                                                                 ifelse(listings$price_total<501,"$351-$500 per night","$500+ per night"
                                            )
                                     ))))

Chart_1_list_br <- as.data.frame(prop.table(table(listings$price_total_bands[listings$is_business_travel_ready=='t'])))
Chart_1_list <- as.data.frame(prop.table(table(listings$price_total_bands[listings$is_business_travel_ready=='f'])))
colnames(Chart_1_list_br) <- c("Var1", "BR")
colnames(Chart_1_list) <- c("Var1", "NBR")
levels(Chart_1$Var1) <- levels(Chart_1_list$Var1)

Chart_1 <- merge(Chart_1, Chart_1_list, by = "Var1")
Chart_1 <- merge(Chart_1, Chart_1_list_br, by="Var1")

Sys.setenv("plotly_username"="markbrackenrig")
Sys.setenv("plotly_api_key"="O77hhbbFM2gdMjGC9v8O")



p <- plot_ly(data = Chart_1, x=~Var1, y = ~Freq*100, type = "bar", name = "Traveller Expectations") %>%
  add_trace( y = ~BR*100, name= "business travel ready AirBnB listings") %>%
  layout( barmode = "group",title = "Spending per night", yaxis = list(title = "Percentage", showgrid = F, font = list(size=8)), xaxis = list(title = "Per Night Spend", font = list(size=8)))
p

api_create(p, filename = "pricebar")

Chart2 <- 

p <- plot_ly(listings) %>%
add_boxplot(y=~cleaning_fee, x= ~ifelse(is_business_travel_ready=='t', "Business Ready","Not Business Ready")) %>%
  layout(yaxis = list(range = c(0,500), title = "Cleaning Fee ($)"), xaxis = list(title = "Is the listing Business Ready?"))

p

p <- plot_ly() %>%
  add_trace(data = subset(listings, listings$is_business_travel_ready=='t'),y=~cleaning_fee, x= ~price) %>%
  add_trace(data = subset(listings, listings$is_business_travel_ready=='f'),y=~cleaning_fee, x= ~price) %>%
    layout(yaxis = list(range = c(0,500), title = "Cleaning Fee ($)"), xaxis = list(title = "Price ($)"))

p

listings$cleaning_fee_bands <- ifelse(listings$cleaning_fee<11, "$10 or less",
                                      ifelse(listings$cleaning_fee<26, "$11-$25",
                                             ifelse(listings$cleaning_fee<51, "$26-$50",
                                                    ifelse(listings$cleaning_fee<101, "$51-$100",
                                                           ifelse(listings$cleaning_fee<201, "$101-$200",
                                                                  ifelse(listings$cleaning_fee<301, "$201-$300","More than $300"))))
                                        
                                      ))

Chart3 <- as.data.frame(table(listings$clea))


listings <- merge(bookings, listings, by = "id")


