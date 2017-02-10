library(shiny)
library(dplyr)
library(tidyr)
library(quanteda)

# Load model
# Load profanities

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$prediction <- renderPlot({
    # Get the input string
    in_string <- input$in_string
    
    # Do some sanity checking on the input
    
    # Predict the next word
    my_predict(in_string)
  })
})

# Prediction function
