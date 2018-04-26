library(shinydashboard)
library(leaflet)

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
           fileInput(inputId = "lidar",
                     label = "Select LiDAR Point Cloud",
                     multiple = FALSE,
                     accept = ".las"),
           fileInput(inputId = "birds",
                     label = "Select Bird CSV",
                     multiple = FALSE,
                     accept = ".csv"),
           sliderInput(inputId = "time",
                       label = "Time:",
                       min = 1,
                       max = 1000,
                       value = 30),
           
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