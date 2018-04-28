getCircleCords <- function(viewLat,viewLon,bird){
  #distance between speciesMarkers and viewingSpot
  radiusToMarker<-0.001
  len <- length(bird$species)
  degreesOfSeperation<-360/len
  
  #Initialize Dataframe Vectors
  lat <- vector(length = len)
  long < vector(lenght = len) 
  size <- vector(length = len)
  
  #find lat and lon position of each species
  for (i in 1:len){
    originLat<-radiusToMarker*(sin(i*degreesOfSeperation))
    originLon<-radiusToMarker*(cos(i*degreesOfSeperation))
    lat[i]<-originLat+viewLat
    long[i]<-originLon+viewLon
    i=i+1
  }
  
  #scale the freq into 
  #spanMax<-15
  #spanMin<-4
  #m<-
  #size<-m*bird$freq+b
  
  size<-5
  circles <- data.frame(lat, long, size)
  return(circles)
  
}