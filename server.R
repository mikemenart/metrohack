library(shiny)
library(ggmap)

lat <- c(12.9,13.05)
long <- c(77.52,77.7)
region <- make_bbox(long,lat,f=0.05)
myMapType <- "terrain"

map <- get_map(location=region, source="google", maptype=myMapType)

function(input, output) {
  
  output$distPlot <- renderPlot({
    ggmap(map)
    # x    <- faithful$waiting
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    # hist(x, breaks = bins, col = "#75AADB", border = "white",
    #      xlab = "Waiting time to next eruption (in mins)",
    #      main = "Histogram of waiting times")
    
  })
  
}