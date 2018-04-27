library(shinydashboard)
library(leaflet)
library(shiny)
library(gsubfn)
# library(dplyr)
# library(curl) # make the jsonlite suggested dependency explicit

#load feature functions
getCHM <- dget("../chm.R")
#loadBirdData <- dget("../loadBirdData.R")
source("../loadBirdData.R")

SLIDER_RANGE <- 500

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

getViewpoints <- function(time, file){
  if(is.null(file)){
    return(NULL)
  }
  
  bird_data <- loadBirdData(file$datapath)
  filter_date <- getDate(time, bird_data)
  filtered_birds <- (bird_data[as.POSIXct(bird_data$SurveyDate) == filter_date, ])
  viewpoints <- getCoords(time, filtered_birds)
  
  return(list(viewpoints,filter_date))
}

# dateFromSlider <- function(time, file){
#   #Reloading bird data inefficient
#   bird_data <- loadBirdData(file$datapath)
#   return(getDate(time,bird_data))
# }

function(input, output, session) {
  
  # Store last zoom button value so we can detect when it's clicked
  lastZoomButtonValue <- NULL
  
  output$bird_map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(lat=41.54265387, lng=-81.62946395)

  })

  #bird_data <- reactive({getBirdData(input$bird_csv)})
  
  #observe({
  output$date <- renderText({
    if(!is.null(input$bird_csv)){
      list[viewpoints,date] <- getViewpoints(input$time, input$bird_csv)
      leafletProxy("bird_map", data=viewpoints) %>%
        addMarkers(lng = ~Longitude, lat = ~Latitude, label = ~Viewpoint)  
      paste("Selected Date: ", date)
    }
  })
  
  
}