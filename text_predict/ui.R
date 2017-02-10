library(shiny)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("The 'How are people talking these days?' App for Time Travelers"),
  
  sidebarLayout(
    sidebarPanel(
      # Put the instructions here
      h4("This app helps time travelers speak correctly based on the year they time traveled to. Just enter a phrase into the text box, hit Submit, and the app will suggest five different ways to continue your sentence in the way the average person of the year would. Please note that we currently only support time travel to the 2010's.")
    ),
    mainPanel(
      # Input text box
      textInput("in_string", label="Enter your phrase here", value = "", width = NULL, placeholder = NULL),
      
      # Submit button
      submitButton("Submit"),
      
      # Prediciton text
      h3(textOutput("prediction"))
    )
  )
))
