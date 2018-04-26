library(shiny)

ui <- fluidPage(
  
  #titlePanel("Hello Shiny!"),
  
  sidebarLayout(
    
    sidebarPanel(
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
      
      
    ),
    
    mainPanel(
      
      plotOutput(outputId = "distPlot")
      
    )
  )
)

server <- dget("../server.R")

# Create Shiny app ----
shinyApp(ui = ui, server = server)