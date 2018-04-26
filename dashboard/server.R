library(shinydashboard)
library(leaflet)
library(shiny)
# library(dplyr)
# library(curl) # make the jsonlite suggested dependency explicit

#load feature functions
getCHM <- dget("../chm.R")
#loadBirdData <- dget("../loadBirdData.R")
source("../loadBirdData.R")

getViewpoints <- function(time, file){
  if(is.null(file)){
    return(NULL)
  }
  
  bird_data <- loadBirdData(file$datapath)
  viewpoints <- getCoords(time, bird_data)
  
  return(viewpoints)
}

function(input, output, session) {
  
  # Store last zoom button value so we can detect when it's clicked
  lastZoomButtonValue <- NULL
  
  output$bird_map <- renderLeaflet({
    #browser()
    leaflet() %>%
      addTiles() %>%
      addMarkers(lat=41.54265387, lng=-81.62946395)

  })

  #bird_data <- reactive({getBirdData(input$bird_csv)})
  
  observe({
    if(!is.null(input$bird_csv)){
      viewpoints <- getViewpoints(input$time, input$bird_csv)
      leafletProxy("bird_map", data=viewpoints) %>%
        addMarkers(lng = ~Longitude, lat = ~Latitude, label = ~Viewpoint)  
    }
  })
}