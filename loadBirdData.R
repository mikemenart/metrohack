###STILL NEED TO REMOVE DUPLICATE LABELS (E.G. MERGE CLNP04 AND CLNP04-2014)
loadBirdData <- function(filename){
	bird_data <- read.csv(filename)
	o_bird <- bird_data[with(bird_data, order(PointID)), ]
  #o_bird <- subset(o_bird, select = -c(Latitude, Longitude)) #removing lat/long might be unnecesary
  
	return(o_bird)
}

#bird data ordered by PointID -> PointID/Coordinate pairs
getCoords <- function(bird_data){
  viewpoint <- levels(bird_data$PointID)
  latitude <- unique(bird_data$Latitude)
  longitude <- unique(bird_data$Longitude)
  coords <- data.frame(viewpoint, latitude, longitude)
}