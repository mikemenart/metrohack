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
source("../birdData.R")
source("../ogr.R")
source("../slider_range.R")



#####################SERVER######################
function(input, output, session) {
  
  output$bird_map <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>%
      setView(lat=41.54265387, lng=-81.62946395, zoom=16)

  })
  
  #########Bird Clusters########## 
  bird_data <- reactive({
    if(!is.null(input$bird_csv)){
      loadBirdData(input$bird_csv$datapath)
    }
  })
  
  output$date <- renderText({
    date <- NULL
    if(!is.null(bird_data())){
      # browser()
      date <- getDate(input$time, bird_data())
      viewpoints <- getViewpoints(date, bird_data())
      leafletProxy("bird_map", data=viewpoints) %>%
        addMarkers(lng = ~Longitude, lat = ~Latitude, label = ~Viewpoint)
    }
    paste("Selected Date: ", date)
  })
  
  
  #######Feature Rasters######### 
  observeEvent(input$lidar_button, {
    if(!is.null(input$lidar_file)){
      file <- input$lidar_file
      chm <- getCHM(file)
      # browser()
      pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(chm), na.color = "transparent")
      leafletProxy("bird_map", data=chm) %>% 
        addRasterImage(x = chm, colors=pal)
        # addHeatmap(lng = chm$lng, lat = chm$lat, intensity = chm$intensity, blur=20, radius=25, max=200)#max=max(chm$Z))
    }
  })
  
  
  #########Metadata Grid########### 
  observeEvent(input$index_button, {
    # if(!is.null(input$lidar_index)){
    if(!is.null(input$lidar_index)){
      index_folder <- input$lidar_index
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