library(dplyr)
library(tidyr)

# load("en_US.Rda")
# load("cooccurrence_matrix.Rda")

my_predict <- function(in_string) {
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, " "))
  if (length(pieces) == 1) {
    predict_1(pieces)
  }
  else if (length(pieces) == 2) {
    predict_2(pieces)
  }
  else if (length(pieces) > 2) {
    predict_3(pieces)
  }
}

predict_1 <- function(pieces) {
  last_one <- tail(pieces, 1)
  possibilities <- combos[combos$X1 == last_one[1], ]
  if (!nrow(possibilities)) {
    # If we only have one word to go off of and we've never seen it before, go with the most common word
    if (length(pieces) == 1) { return("said") }
    # If we have other words in the sentence, pick the most common word associated with those other words
    names(which.max(rowSums(cooccurrence_matrix[,pieces[pieces %in% colnames(cooccurrence_matrix)]])))
  }
  else {
    combined <- aggregate(possibilities$value, list(x2 = possibilities$X2), sum)
    combined[order(-combined$x),"x2"][1]
  }
}

predict_2 <- function(pieces) {
  last_two <- tail(pieces, 2)
  possibilities <- combos[(combos$X1 == last_two[1]) & (combos$X2 == last_two[2]), ]
  if (!nrow(possibilities)) {
    predict_1(pieces)
  }
  else {
    combined <- aggregate(possibilities$value, list(x3 = possibilities$X3), sum)
    combined[order(-combined$x),"x3"][1]
  }
}

predict_3 <- function(pieces) {
  last_three <- tail(pieces, 3)
  possibilities <- combos[(combos$X1 == last_three[1]) & (combos$X2 == last_three[2]) & (combos$X3 == last_three[3]), ]
  if (!nrow(possibilities)) {
    predict_2(pieces)
  }
  else {
    combined <- aggregate(possibilities$value, list(x4 = possibilities$X4), sum)
    combined[order(-combined$x),"x4"][1]
  }
}

# What to do when two options have the same frequencies. "I want fish" and "I want tacos" appear an equal amount of times.