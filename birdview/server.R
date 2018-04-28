library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(shiny)
library(gsubfn)
library(rgdal)
# library(dplyr)
# library(curl) # make the jsonlite suggested dependency explicit

#load feature functions
getCHM <- dget("../getCHM.R")
#loadBirdData <- dget("../loadBirdData.R")
source("../loadBirdData.R")
source("../ogr.R")

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
  
  output$bird_map <- renderLeaflet({
    index_folder <- "C:/Users/mikej/Documents/metrohack/Index"
    # ogr <- readOGR(index_folder, GDAL1_integer64_policy = TRUE)
    # ogr_wgs <- spTransform(ogr, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
    leaflet() %>% #AD BACK IN wgr_ogs
      addTiles() %>%
      setView(lat=41.54265387, lng=-81.62946395, zoom=16)
      # addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
      #             opacity = 1.0, fillOpacity = 0.2,
      #             highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE),
      #             popup = ~Name)

  })
  
  
  output$date <- renderText({
    date <- NULL
    if(!is.null(input$bird_csv)){
      list[viewpoints,date] <- getViewpoints(input$time, input$bird_csv)
      #browser()
      leafletProxy("bird_map", data=viewpoints) %>%
        addMarkers(lng = ~Longitude, lat = ~Latitude, label = ~Viewpoint)
    }
    paste("Selected Date: ", date)
  })
  
   
  observeEvent(input$lidar_button, {
    if(!is.null(input$lidar_file)){
      file <- input$lidar_file
      chm <- getCHM(file)
      # browser()
      leafletProxy("bird_map", data=chm) %>% 
        addHeatmap(lng = chm$lng, lat = chm$lat, intensity = chm$intensity, blur=20, radius=25, max=200)#max=max(chm$Z))
    }
  })
  
  
  
  observeEvent(input$index_button, {
    # if(!is.null(input$lidar_index)){
    if(!is.null(input$lidar_index)){
      index_folder <- input$lidar_index
      # browser()
      ogr <- readOGR(index_folder, layer = "Cuyahoga_Index", GDAL1_integer64_policy = TRUE)
      ogr_wgs <- spTransform(ogr, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
      leafletProxy("bird_map", data=ogr_wgs) %>%
        addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                    opacity = 1.0, fillOpacity = 0.01,
                    highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE),
                    popup = ~Name)
    }
  })
 
  
  
}