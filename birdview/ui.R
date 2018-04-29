library(shinydashboard)
library(leaflet)
library(shinyFiles)

source("../slider_range.R")

header <- dashboardHeader(
  title = "BirdView"
)

###########UI#################
body <- dashboardBody(
  fluidRow(
    column(width = 9,
           box(width = NULL, solidHeader = TRUE,
               leafletOutput("bird_map", height = 700)
           )
    ),
    column(width = 3,
           textInput("lidar_index",
                     label = "Path to LiDAR Metadata Folder",
                     value = "C:/Users/mikej/Documents/metrohack/Index"),
           actionButton("index_button",
                        "Load Metadata"),
           textInput("lidar_file",
                     label = "Path to LiDAR file",
                     value = "C:/Users/mikej/Documents/metrohack/metrohack/data/Cuya_0044_1.3.las"),
           actionButton("lidar_button",
                        "Load Lidar File"),
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