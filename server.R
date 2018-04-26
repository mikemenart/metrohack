library(shiny)
library(ggmap)

#load feature functions
getCHM <- dget("../chm.R")

lat <- c(12.9,13.05)
long <- c(77.52,77.7)
region <- make_bbox(long,lat,f=0.05)
myMapType <- "terrain"

map <- get_map(location=region, source="google", maptype=myMapType)

getOverlay <- function(feature, file){
  overlay <- NULL
  if(feature() == 2){
     chm <- getCHM(file)
     
  }
  
  return(overlay)
}

##########Server Function#########
function(input, output) {
  lidar_file <- reactive({input$lidar})
  bird_file <- reactive({input$birds})
  
  feature <- reactive({input$feature})
  
  output$distPlot <- renderPlot({
    ggmap(map) + getOverlay(feature, lidar_file)
    # x    <- faithful$waiting
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    # hist(x, breaks = bins, col = "#75AADB", border = "white",
    #      xlab = "Waiting time to next eruption (in mins)",
    #      main = "Histogram of waiting times")
    
  })
  
  
}