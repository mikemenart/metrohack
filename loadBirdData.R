###STILL NEED TO REMOVE DUPLICATE LABELS (E.G. MERGE CLNP04 AND CLNP04-2014)
loadBirdData <- function(filename){
	bird_data <- read.csv(filename)
	o_bird <- bird_data[with(bird_data, order(PointID)), ]
  #o_bird <- subset(o_bird, select = -c(Latitude, Longitude)) #removing lat/long might be unnecesary
  
	return(o_bird)
}


#bird data ordered by PointID -> PointID/Coordinate pairs
getCoords <- function(time, bird_data){
  #browser()
  Viewpoint <- levels(bird_data$PointID)
  Latitude <- vector(length=length(Viewpoint)) #unique(bird_data$Latitude)
  Longitude <- vector(length=length(Viewpoint)) #unique(bird_data$Longitude)
  for(i in 1:length(Viewpoint)){
    vp <- Viewpoint[i]
    entry <- bird_data[bird_data$PointID == vp, ][1,]
    Latitude[i] <- entry$Latitude
    Longitude[i] <- entry$Longitude
  }
  
  return(data.frame(Viewpoint, Latitude, Longitude))
}