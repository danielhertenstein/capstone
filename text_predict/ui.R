library(shiny)
library(shinyjs)

# Structure for loading page comes from: https://github.com/daattali/advanced-shiny/blob/master/loading-screen/app.R

appCSS <- "
#loading-content {
position: absolute;
background: #000000;
opacity: 0.9;
z-index: 100;
left: 0;
right: 0;
height: 100%;
text-align: center;
color: #FFFFFF;
}
"

shinyUI(fluidPage(
  useShinyjs(),
  inlineCSS(appCSS),
  
  # Loading message
  div(
    id = "loading-content",
    h2("Please wait while language database is loading...")
  ),
  
  # The main app code goes here
  hidden(
    div(
      id = "app-content",
      
      # Application title
      titlePanel("The 'How are people talking these days?' App for Time Travelers"),
      
      sidebarLayout(
        sidebarPanel(
          # Put the instructions here
          p("This app helps time travelers speak correctly based on the year they time traveled to."),
          p("Just enter a phrase into the text box, hit Submit, and the app will suggest five different ways to continue your sentence in the way the average person of the year would."),
          p("Please note that we currently only support time travel to the 2010's.")
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
    )
  )
))
