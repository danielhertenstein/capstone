library(dplyr)
library(tidyr)

load("en_US.Rda")

my_predict <- function(in_string) {
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, " "))
  switch(length(pieces),
         predict_1(pieces),
         predict_2(pieces),
         predict_3(pieces)
  )
}

predict_1 <- function(pieces) {
  possibilities <- combos[combos$X1 == pieces[1], ]
  combined <- aggregate(possibilities$value, list(x2 = possibilities$X2), sum)
  combined[order(-combined$x),"x2"][1]
}

predict_2 <- function(pieces) {
  possibilities <- combos[(combos$X1 == pieces[1]) & (combos$X2 == pieces[2]), ]
  if (!nrow(possibilities)) {
    predict_1(pieces[2])
  }
  else {
    combined <- aggregate(possibilities$value, list(x3 = possibilities$X3), sum)
    combined[order(-combined$x),"x3"][1]
  }
}

predict_3 <- function(pieces) {
  possibilities <- combos[(combos$X1 == pieces[1]) & (combos$X2 == pieces[2]) & (combos$X3 == pieces[3]), ]
  if (!nrow(possibilities)) {
    predict_2(pieces[2:3])
  }
  else {
    combined <- aggregate(possibilities$value, list(x4 = possibilities$X4), sum)
    combined[order(-combined$x),"x4"][1]
  }
}

# Can we use corrleation between words in the sentence for unknown n-grams?
# Replace the first occurrence of every word with <UNK>, then process as normal.
# Adding <S> and </S> to the beginning and ending of every sentence.
# Adding 1 to every frequency.
# What to do when two options have the same frequencies. "I want fish" and "I want tacos" appear an equal amount of times.