library(rgdal)

getOGRFolder <- function(lidar_index){
  paths <- lidar_index$datapath
  path <- NULL
  for(file in paths){
    if(endsWith(file, ".shp")){
      path <- file
      break
    }
  }
  
  folder <- gsub("/*..shp", "", path)
  return(folder)
}

getPolygons <- function(ogr){
  return(ogr@polygons)
}