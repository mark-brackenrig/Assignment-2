# Create Modelling Table

Model <- merge(listings, Host_Verifications, by = "id")
Model <- merge(Model, `Opera House by Public Transport`, by = "id")
Model <- merge(Model, Amenities, by = "id")
