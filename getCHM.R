library(lidR)
#library(sp)
library(rgdal)

#"../data/CLNP_merged_44_62_1.3.las"
#Need to georegister canopy height points
#https://stackoverflow.com/questions/9946630/colour-points-in-a-plot-differently-depending-on-a-vector-of-values on how to color points

NAD3toLatLong <- function(chm){
  points <- data.frame(X=chm$X, Y=chm$Y, Z=chm$Z)
  NAD3_proj <- "+proj=lcc +lat_1=40.4333333333333 +lat_2=41.7 +lat_0=39.6666666666667 +lon_0=-82.5 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=us-ft +no_defs" 
  sp_points <- SpatialPoints(points, CRS(NAD3_proj))
  latlong <- spTransform(sp_points, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))
  return(latlong)
}

function(file){
  las <- readLAS(file)
 
  xmin <- min(las@data$X)
  ymin <- min(las@data$Y)

  #TODO: allow user to clip las segment  
  las <- lasclipRectangle(las, 0, 0, xmin+100, ymin+100)
  chm <- grid_tincanopy(las, 0.25, c(0,2,5,10,15), c(0,1) , subcircle = 0.2) #this part seems to be working well
  chm <- NAD3toLatLong(chm) 
  chm_df <- data.frame(lng=chm$X,lat=chm$Y, intensity=chm$Z)
  # plot(chm)
  # chm <- as.raster(chm)
  # kernel <- matrix(1,3,3)
  # chm <- raster::focal(chm, w = kernel, fun = median, na.rm = TRUE)
  return(chm_df)
  
  ##Add for treetops segmentation##
  #treetops = tree_detection(las_clip, 7, hmin=100) #workigng beter with ws=5, detects other things. Not sure about tree classes?
  #lastrees_dalponte(las_clip, chm, treetops)
  #plot(las_clip, color = "treeID")#, colorPalette = col)
}

#chm <- getCHM("C:/Users/mikej/Documents/metrohack/metrohack/data/Cuya_0044_1.3.las")
