function(filename){
	bird_data <- read.csv(filename)
	o_bird <- bird_data[with(bird_data, order(PointID)), ]
  viewpoint <- levels(o_bird$PointID)
  latitude <- unique(o_bird$Latitude)
  longitude <- unique(o_bird$Longitude)
  coords <- data.frame(viewpoint, latitude, longitude)
  o_bird <- subset(o_bird, select = -c(Latitude, Longitude)) #removign lat/long might be unnecesary
  
	return(list(o_bird, coords))
}