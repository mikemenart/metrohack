function(filename){
	birddata <- read.csv(filename)
	# aszSurveyDate <- birddata[c(1)]
	# aszPointId <- birddata[c(2)]
	# aiBirdCount <- birddata[c(3)]
	# aszPointTime <- birddata[c(4)]
	# aszCommonName <- birddata[c(5)]
	# aszOnLake <- birddata[c(6)]
	# aszFlyBy <- birddata[c(7)]
	# aszObservationNotes <- birddata[c(8)]
	# adLatitude <- birddata[c(9)]
	# adLongitute <- birddata[c(10)]
	# BirdDataVars <- data.frame(aszSurveyDate,aszPointId,aiBirdCount,
	# 				aszPointTime,aszCommonName,aszOnLake,aszFlyBy,
	# 				aszObservationNotes,adLatitude,adLongitute)	
	# return(BirdDataVars)
	return(birddata)
}