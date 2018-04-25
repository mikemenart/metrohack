library(lidR)
#library(sp)
#library(rgdal)

las_merged = readLAS("CLNP_merged_44_62_1.3.las")

#cut out empty space in file
x_min <- min(las_merged@data$X)
x_max <- max(las_merged@data$X)
y_min <- min(las_merged@data$Y)
y_max <- max(las_merged@data$Y)

las_roi = las_merged
las_roi = las_filter()
las_roi@data$X <- las_roi@data$X - x_min
las_roi@data$Y <- las_roi@data$Y - y_min
roi_xmax <- max(las_roi@data$X)
roi_ymax <- max(las_roi@data$Y)
las_clip = lasclipRectangle(las_roi, 0, 0, 500, 500)
chm = grid_tincanopy(las_clip, 0.25, c(0,2,5,10,15), c(0,1) , subcircle = 0.2) #this part seems to be working well
#plot(chm)
chm = as.raster(chm)
kernel = matrix(1,3,3)
chm = raster::focal(chm, w = kernel, fun = median, na.rm = TRUE)
treetops = tree_detection(las_clip, 7, hmin=100) #workigng beter with ws=5, detects other things. Not sure about tree classes?
lastrees_dalponte(las_clip, chm, treetops)
#plot(las_clip, color = "treeID")#, colorPalette = col)
