library(shiny)
library(shinyjs)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  # Load model
  load("news_and_twitter.Rda", .GlobalEnv)
  
  # Load profanities
  profanities <<- readLines(file("en_profanity.txt", "r"))
  closeAllConnections()
  
  # Load the prediction function
  source("prediction_function.R")
  
  # Set the global variable that lazily contains the top 5 unigrams
  top_five <<- ""
  
  # Hide the loading message when the rest of the server function has executed
  hide(id = "loading-content", anim = TRUE, animType = "fade")    
  shinyjs::show("app-content")
  
  output$prediction <- renderText({
    # Get the input string
    in_string <- input$in_string
    
    # Do some sanity checking on the input
    
    # Predict the next word
    prediction <- my_predict(combo_table, in_string)
    
    paste("Predictions:", paste(prediction, sep="", collapse=" "))
  })
})