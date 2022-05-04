library(shiny)
library(shinyFiles)
library(reticulate)
library(shinycssloaders)
library(tidyverse)
library(shinyjs)

source_python("python_test.py")

ui <- fluidPage(
  useShinyjs(),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Select A Video", accept = ".mov"),
      actionButton('run', 'Load Video'),
      disabled(actionButton('open', "Open Video")),
      textOutput("text"),
    ),
    mainPanel(
      imageOutput("contents") %>% withSpinner(type = 6)
      )
    )
)


server <- function(input, output) {
  
  observeEvent(input$open,{
    shell.exec("C:/Users/Tylers PC/OneDrive/Desktop/Capstone/app_folder/0.mov")
  })
  
  runClass <- eventReactive(input$run,{
    disable("open")
    show("text")
    
    file <- input$file1
    
    req(file)
    
    file.copy(from = file$datapath,
              to   = "C:/Users/Tylers PC/OneDrive/Desktop/Capstone/app_folder")
    
    vid_path = file$datapath
    vid_path2 = file.path('C:/Users/Tylers PC/OneDrive/Desktop/Capstone/app_folder/0.mov')
    
    throw_image = run_class(vid_path,vid_path2)
    hide("text")
    enable("open")
    throw_image = file.path('C:/Users/Tylers PC/OneDrive/Desktop/Capstone/app_folder/throw_image.png')
    
    list(src = throw_image)
  })
  
 
  output$text <- renderText({
    file <- input$file1
    req(file)
    run_time = ceiling(get_frames(file$datapath) * 0.50 + 4)
    paste("Estimated load time: ", run_time, "seconds")
  })
  
  output$contents <- renderImage({
    runClass()
  },deleteFile = F)
  
  
}

shinyApp(ui, server)