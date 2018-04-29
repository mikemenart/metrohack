source("../slider_range.R")

#TODO: Handle duplciate labels? e.g. CLNP_04 and CLNP_04-2014
loadBirdData <- function(filename){
	bird_data <- read.csv(filename)
	o_bird <- bird_data[with(bird_data, order(PointID)), ]
  #o_bird <- subset(o_bird, select = -c(Latitude, Longitude)) #removing lat/long might be unnecesary
  
	return(o_bird)
}


#bird data ordered by PointID -> PointID/Coordinate pairs
getViewCoords <- function(time, bird_data){
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

getDate <- function(time, bird_data){
  origin <- as.POSIXct("1970-01-01") #default POSIX origin
  dates <- as.POSIXct(levels(bird_data$SurveyDate))
  date_nums <- as.numeric(dates, origin=origin)
  range <- max(date_nums) - min(date_nums)
  
  slide_date <- as.POSIXct(min(date_nums) + (time/SLIDER_RANGE)*range, origin=origin)
  filter_id <- which.min(abs(dates-slide_date))
  filter_date <- dates[filter_id]
  
  return(filter_date)
}

getViewpoints <- function(filter_date, bird_data){
  filtered_birds <- (bird_data[as.POSIXct(bird_data$SurveyDate) == filter_date, ])
  viewpoints <- getViewCoords(time, filtered_birds)
  
  return(viewpoints)
}