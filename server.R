library(shiny)
library(ggmap)
library(ggplot2)

#load feature functions
getCHM <- dget("../chm.R")
#loadBirdData <- dget("../loadBirdData.R")
source("../loadBirdData.R")

lat <- c(41.54, 41.5495)
long <- c(-81.645, -81.62)
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

plotBirds <- function(time, file){
  if(is.null(file)){
    return(NULL)
  }
  
  bird_data <- loadBirdData(file$datapath)
  coords <- getCoords(bird_data)
  #Reformat in some way, this currently does nothing
  for(vp in coords$viewpoint){ #[v]iew [p]oint
    vp_data <- bird_data[bird_data$PointID == vp, ]
    
  }
  
  #browser()
  #adding color=CommonName pushes map of plot
  bird_plot <- geom_point(data = bird_data, aes(Longitude, Latitude), size=2, alpha=0.7)  # + labs(color = "Common Name"))
  return(bird_plot)
}

##########Server Function#########
function(input, output) {
  lidar_file <- reactive({input$lidar})
  bird_file <- reactive({input$birds})
  
  feature <- reactive({input$feature})
  
  output$distPlot <- renderPlot({
    ggmap(map) + getOverlay(feature, lidar_file) + plotBirds(input$time, input$birds)
    
    # x    <- faithful$waiting
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    # hist(x, breaks = bins, col = "#75AADB", border = "white",
    #      xlab = "Waiting time to next eruption (in mins)",
    #      main = "Histogram of waiting times")
    
  })
  
  
}