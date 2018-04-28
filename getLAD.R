library(lidR)

gridLAS <- function(las, grid_size){
  xmin <- min(las$X)
  xmax <- max(las$X)
  ymin <- min(las$Y)
  ymax <- max(las$Y)
 
  grid <- list() 
  
  for(x in seq(xmin, xmax, grid_size)){
    for(y in seq(ymin, ymax, grid_size)){
      grid[x][y] <- lasClip(las, x, y, x+grid_size, y+grid_size)      
    }
  }
  
  return(unlist(grid))
}

getLAD <- function(file, grid_size, height){
  las <- readLAS(file)
  #z above 100 is outliers
  grid <- lasfilter(las, Z <= 100)
  len <- length(grid)
  lad <- vector(length=len)
  X <- vector(length=len)
  Y <- vector(length=len) 
  
  for(i in 1:len){
      seg <- grid[i]
      lad[i] <- LAD(seg@data$Z)[height]
      X[i] <- (min(seg@data$X)+max(seg@data$X))/2
      Y[i] <- (min(seg@data$Y)+max(seg@data$Y))/2
  }
 
   
   
}