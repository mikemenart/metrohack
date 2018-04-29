getCircleCords <- function(viewLat,viewLon,bird){
  #distance between speciesMarkers and viewingSpot
  radiusToMarker<-0.001
  len <- length(bird$species)
  degreesOfSeperation<-360/len
  
  #Initialize Dataframe Vectors
  species <- vector(length = len)
  lat <- vector(length = len)
  long < vector(lenght = len) 
  size <- vector(length = len)
  
  #find lat and lon position of each species
  for (i in 1:len){
    species[i] <- bird$species[i] ##SOS IS THIS RIGHT??
    originLat<-radiusToMarker*(sin(i*degreesOfSeperation))
    originLon<-radiusToMarker*(cos(i*degreesOfSeperation))
    lat[i]<-originLat+viewLat
    long[i]<-originLon+viewLon
    
    #scale the freq into a span
    radSpanMax<-15
    radSpanMin<-4
    m <- (radSpanMax-radSpanMin) / (max(bird$freq))
    size[i] <- m*(bird$freq[i])+radSpanMin ## NOT SURE IF THIS IS RIGHT!!
    
    i=i+1
  }
  
  circles <- data.frame(species, lat, long, size)
  return(circles)
}