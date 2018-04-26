###STILL NEED TO REMOVE DUPLICATE LABELS (E.G. MERGE CLNP04 AND CLNP04-2014)
loadBirdData <- function(filename){
	bird_data <- read.csv(filename)
	o_bird <- bird_data[with(bird_data, order(PointID)), ]
  #o_bird <- subset(o_bird, select = -c(Latitude, Longitude)) #removing lat/long might be unnecesary
  
	return(o_bird)
}

dateFilter <- function(time, bird_data){
  origin <- as.POSIXct("1970-01-01") #default POSIX origin
  dates <- as.POSIXct(levels(bird_data$SurveyDate))
  date_nums <- as.numeric(dates, origin=origin)
  range <- max(date_nums) - min(date_nums)
  
  slide_date <- as.POSIXct(min(date_nums) + (time/100)*range, origin=origin)
  filter_id <- which(abs(dates-slide_date) == abs(min(dates-slide_date)))
  filter_date <- dates[filter_id]
  
  time_filtered <- (bird_data[as.POSIXct(bird_data$SurveyDate) == filter_date, ])
  return(time_filtered)
}

#bird data ordered by PointID -> PointID/Coordinate pairs
getCoords <- function(time, bird_data){
  date_birds <- dateFilter(time, bird_data)
  #browser()
  Viewpoint <- levels(date_birds$PointID)
  Latitude <- vector(length=length(Viewpoint)) #unique(date_birds$Latitude)
  Longitude <- vector(length=length(Viewpoint)) #unique(date_birds$Longitude)
  for(i in 1:length(Viewpoint)){
    vp <- Viewpoint[i]
    entry <- date_birds[date_birds$PointID == vp, ][1,]
    Latitude[i] <- entry$Latitude
    Longitude[i] <- entry$Longitude
  }
  
  return(data.frame(Viewpoint, Latitude, Longitude))
}