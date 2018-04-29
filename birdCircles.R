`%+=%` = function(e1,e2) eval.parent(substitute(e1 <- e1 + e2))

birdsByVP <- function(bird_data){
  vp_birds <- list()
  viewpoints <- levels(bird_data$PointID)
  for(vp in viewpoints){
    # vp <- viewpoints[i]
    df <- bird_data[bird_data$PointID == vp, ]
    vp_birds[vp] <- list(df)
  }
  return(vp_birds)
}

#vp_birds is list of data frames. Each df is a viewpoint
getBirdFreqs <- function(vp_birds){
  order_map <- read.csv("../Common2Species.csv")
  species <- levels(order_map$BirdSpeciesOrder)
 
  viewpoints <- names(vp_birds) 
  bird_freq <- list()
  for(vp in viewpoints){
    #data frame for this viewpoint
    bird_data <- vp_birds[[vp]]
      
    #data frame of species and freq
    vp_bf <- data.frame(species, freq=integer(length(species)))
   
    if(nrow(bird_data) != 0){
      #parse of bird data to fill bird_freq 
      for(i in 1:nrow(bird_data)){
        bird <- bird_data[i,]
        c_name <- as.character(bird$CommonName)
        s_name <- as.character(order_map[as.character(order_map$CommonName) == c_name, ]$BirdSpeciesOrder)
        vp_bf[as.character(vp_bf$species) == s_name, ]$freq %+=% bird_data$BirdCount[i]
      }
    }
    bird_freq[vp] <- list(vp_bf)
  }
   
  return(bird_freq)
}

#Viewpoints is data frame, bird_freq is list of data frames
getVPCircles <- function(viewpoints, bird_freq){
  circles <- data.frame(species=vector(), lat=vector(), long=vector(), size=vector())
  for(i in 1:nrow(viewpoints)){
    vp_circles <- getCircleCoords(viewpoints$Latitude[i], viewpoints$Longitude[i], bird_freq[[viewpoints$Viewpoint[i]]])
    circles <- rbind(circles, vp_circles)
  }
  return(circles)
}

deg2rad <- function(rad) {(rad * pi) / (180)}

getCircleCoords <- function(viewLat,viewLon,bird){
  
  #remove birds species with zero frequency
  bird <- bird[bird$freq != 0, ]
  
  #distance between speciesMarkers and viewingSpot
  radiusToMarker<-0.0004
  len <- length(bird$species)
  degreesOfSeperation<-360/len
  
  #Initialize Dataframe Vectors
  species <- vector(length = len)
  lat <- vector(length = len)
  long <- vector(length = len) 
  size <- vector(length = len)
  freq <- vector(length = len)
 
  #find lat and lon position of each species
  for (i in 1:len){
    species[i] <- as.character(bird$species[i]) ##SOS IS THIS RIGHT??
    angle <- deg2rad(i*degreesOfSeperation)
    originLat<-radiusToMarker*(sin(angle))
    originLon<-radiusToMarker*(cos(angle))
    lat[i]<-originLat+viewLat
    long[i]<-originLon+viewLon
    freq[i] <- bird$freq[i]
    
    #scale the freq into a span
    radSpanMax<-15
    radSpanMin<-4
    m <- (radSpanMax-radSpanMin) / (max(bird$freq))
    size[i] <- m*(bird$freq[i])+radSpanMin ## NOT SURE IF THIS IS RIGHT!!
    
    i = i+1
  }
  
  circles <- data.frame(species, lat, long, size, freq)
  return(circles)
}