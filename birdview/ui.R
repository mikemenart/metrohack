library(shinydashboard)
library(leaflet)
library(shinyFiles)

SLIDER_RANGE <- 500

header <- dashboardHeader(
  title = "BirdView"
)

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("bird_map", height = 700)
           )
    ),
    column(width = 3,
           shinyDirButton("lidar_index",
                            label = "Select LiDAR Shape File (.shp)",
                            title = "shape file"),
           # fileInput(inputId = "lidar_index",
           #           label = "Select LiDAR Shape File (.shp)",
           #           multiple = TRUE,
           #           accept=".shp"),
           fileInput(inputId = "bird_csv",
                     label = "Select Bird CSV",
                     multiple = FALSE,
                     accept = ".csv"),
           sliderInput(inputId = "time",
                       label = "Date",
                       min = 1,
                       max = SLIDER_RANGE,
                       value = 1),
           textOutput({"date"}),
           #textInput("set_time", label="Date: (ex 2004-04-05)"),
           
           radioButtons("feature", label = h3("Feature"),
                        choices = list("None" = 1, 
                                       "Leaf Area Density" = 2,
                                       "Canopy Height Model" = 3),
                        selected = 1)
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable = TRUE),
  body
)