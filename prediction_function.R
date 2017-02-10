library(dplyr)
library(tidyr)
library(quanteda)

load("news_and_twitter.Rda")
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
    top_five <<- model[, .(value=sum(value)), X4][order(-value)][1:5, X4]
  }
  return(top_five)
}

predict_1 <- function(model, pieces) {
  possibilities <- model[X3 == pieces[1], .(value=sum(value)), X4]
  
  # If no possible matches, return the most common words.
  if (!nrow(possibilities)) {
    predict_0(model, pieces)
  }
  else {
    # Break ties by the number of 4-grams that each possibility completes
    possibilities$N <- combo_table[X4 %in% possibilities$X4, .N, X4][,N]
    return(possibilities[order(-value, -N)][1:5, X4])
  }
}

predict_2 <- function(model, pieces) {
  possibilities <- model[X3 == pieces[2] & X2 == pieces[1], .(value=sum(value)), X4]
  
  # If no possible matches, back off to unigrams.
  if (!nrow(possibilities)) {
    predict_1(model, tail(pieces, 1))
  }
  else {    
    # Break ties by the number of 4-grams that each possibility completes
    possibilities$N <- combo_table[X4 %in% possibilities$X4, .N, X4][,N]
    return(possibilities[order(-value, -N)][1:5, X4])
  }
}

predict_3 <- function(model, pieces) {
  possibilities <- model[X3 == pieces[3] & X2 == pieces[2] & X1 == pieces[1], .(value=sum(value)), X4]
  
  # If no possibile matches, back off to bigrams.
  if (!nrow(possibilities)) {
    predict_2(model, tail(pieces, 2))
  }
  else {
    # Break ties by the number of 4-grams that each possibility completes
    possibilities$N <- combo_table[X4 %in% possibilities$X4, .N, X4][,N]
    return(possibilities[order(-value, -N)][1:5, X4])
  }
}