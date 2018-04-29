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
source("../birdCircles.R")
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
      date <- getDate(input$time, bird_data())
      filtered_birds <- birdFilter(date, input$include, bird_data())
      viewpoints <- getViewpoints(filtered_birds)
      vp_birds <- birdsByVP(filtered_birds) 
      bird_freq <- getBirdFreqs(vp_birds)
      circles <- getVPCircles(viewpoints, bird_freq)
      
      #Marker Customization
      lab_opt <- labelOptions(noHide = FALSE)
      pal <- colorFactor(COLORS, domain = SPECIES)
      leafletProxy("bird_map", data=viewpoints) %>%
        clearMarkers() %>%
        addMarkers(lng = ~Longitude, lat = ~Latitude, label = ~Viewpoint) %>%
        addCircleMarkers(data=circles, lng = ~long, lat = ~lat, radius = ~size, 
                         label = ~paste(as.character(species), " ", freq), labelOptions = lab_opt,
                         color = ~pal(as.character(species)), fillOpacity = 1) %>%
        addLegend("bottomright", pal=pal, values = ~as.character(circles$species),
                  title = "Bird Species", opacity=1)
    }
    paste("Selected Date: ", date)
  })
  
  
  #######Feature Rasters######### 
  observeEvent(input$lidar_button, {
    if(!is.null(input$lidar_file)){
      if(input$feature == 3){
      file <- input$lidar_file
      chm <- getCHM(file)
      pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(chm), na.color = "transparent")
      leafletProxy("bird_map", data=chm) %>% 
        addRasterImage(x = chm, colors=pal, opacity=1)
        # addHeatmap(lng = chm$lng, lat = chm$lat, intensity = chm$intensity, blur=20, radius=25, max=200)#max=max(chm$Z))
      }
      else if(input$feature == 2){
        showModal(modalDialog(
          title = "Feature in development",
          "Leaf area density not yet supported. See LAD.R",
          easyClose = TRUE,
          footer = NULL
        ))
      }
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