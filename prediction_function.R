library(dplyr)
library(tidyr)
library(quanteda)

load("en_US.Rda")
profanities <- readLines(file("en_profanity.txt", "r"))
closeAllConnections()

top_five <<- ""

my_predict <- function(model, in_string) {
  # If the input string is empty, just predict the most common words
  if (in_string == "") { return(predict_0(model, "")) }
  
  # Clean the input string in the same way that was used to build the model to increase the chances of finding a match
  toks <- tokens(in_string, removeNumbers=TRUE, removePunct=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
  toks <- removeFeatures(toks, profanities)
  toks <- tokens_tolower(toks)
  
  pieces <- unlist(as.list(toks))
  if (length(pieces) == 1) {
    predict_1(model, pieces)
  }
  else if (length(pieces) == 2) {
    predict_2(model, pieces)
  }
  else if (length(pieces) > 2) {
    # We only want to use at most the last three words in the input string
    predict_3(model, tail(pieces, 3))
  }
}

predict_0 <- function(model, pieces) { 
  if (top_five == "") {
    top_five <<- aggregate(combos$value, list(x1 = combos$X1), sum)
    top_five <<- top_five[order(-top_five$x),"x1"][1:5]
  }
  return(top_five)
}

predict_1 <- function(model, pieces) {
  possibilities <- model[model$X1 == pieces[1], ]
  
  # If no possible matches, return the most common words.
  if (!nrow(possibilities)) {
    predict_0(model, pieces)
  }
  else {
    possibilities <- possibilities[!(possibilities$X2 %in% stopwords()), ]
    combined <- aggregate(possibilities$value, list(x2 = possibilities$X2), sum)
    combined[order(-combined$x),"x2"][1:5]
  }
}

predict_2 <- function(model, pieces) {
  possibilities <- model[(model$X1 == pieces[1]) & (model$X2 == pieces[2]), ]
  
  # If no possible matches, back off to unigrams.
  if (!nrow(possibilities)) {
    predict_1(model, tail(pieces, 1))
  }
  else {
    possibilities <- possibilities[!(possibilities$X3 %in% stopwords()), ]
    combined <- aggregate(possibilities$value, list(x3 = possibilities$X3), sum)
    combined[order(-combined$x),"x3"][1:5]
  }
}

predict_3 <- function(model, pieces) {
  possibilities <- model[(model$X1 == pieces[1]) & (model$X2 == pieces[2]) & (model$X3 == pieces[3]), ]
  
  # If no possibile matches, back off to bigrams.
  if (!nrow(possibilities)) {
    predict_2(model, tail(pieces, 2))
  }
  else {
    combined <- aggregate(possibilities$value, list(x4 = possibilities$X4), sum)
    combined[order(-combined$x),"x4"][1:5]
  }
}