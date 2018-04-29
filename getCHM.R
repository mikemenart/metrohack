library(lidR)
#library(sp)
library(rgdal)
library(raster)
library(akima)

#"../data/CLNP_merged_44_62_1.3.las"
#Need to georegister canopy height points
#https://stackoverflow.com/questions/9946630/colour-points-in-a-plot-differently-depending-on-a-vector-of-values on how to color points

NAD3_proj <- CRS("+proj=lcc +lat_1=40.4333333333333 +lat_2=41.7 +lat_0=39.6666666666667 +lon_0=-82.5 +x_0=600000 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=us-ft +no_defs")
WGS84_proj <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
  
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
  latlong <- NAD3toLatLong(chm)
  mat<-latlong@coords
  latlong@coords <- latlong@coords[, 1:2]
  e <- extent(mat[,1:2])
  r <- raster(e, nrows=1000, ncols=1000, crs=WGS84_proj)
  rast <- rasterize(latlong, r, mat[,3], fun=mean)
  rast <- setMinMax(rast)
  return(rast)
  
  ##Add for treetops segmentation##
  #treetops = tree_detection(las_clip, 7, hmin=100) #workigng beter with ws=5, detects other things. Not sure about tree classes?
  #lastrees_dalponte(las_clip, chm, treetops)
  #plot(las_clip, color = "treeID")#, colorPalette = col)
}

# chm <- getCHM("C:/Users/mikej/Documents/metrohack/metrohack/data/Cuya_0044_1.3.las")
