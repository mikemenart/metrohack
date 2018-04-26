library(shinydashboard)
library(leaflet)
library(shiny)
# library(dplyr)
# library(curl) # make the jsonlite suggested dependency explicit


function(input, output, session) {
  
  # Store last zoom button value so we can detect when it's clicked
  lastZoomButtonValue <- NULL
  
  output$bird_map <- renderLeaflet({
    
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng=174.768, lat=-36.852)
  
    # rezoom <- "first"
    # # If zoom button was clicked this time, and store the value, and rezoom
    # if (!identical(lastZoomButtonValue, input$zoomButton)) {
    #   lastZoomButtonValue <<- input$zoomButton
    #   rezoom <- "always"
    # }
    # 
    # map <- map %>% mapOptions(zoomToLimits = rezoom)
    # 
    # map
  })
}