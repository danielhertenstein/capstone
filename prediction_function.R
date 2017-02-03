library(dplyr)
library(tidyr)

# load("news.Rda")

my_predict <- function(in_string) {
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
  combined <- aggregate(possibilities$value, list(x3 = possibilities$X3), sum)
  combined[order(-combined$x),"x3"][1]
}

predict_3 <- function(pieces) {
  possibilities <- combos[(combos$X1 == pieces[1]) & (combos$X2 == pieces[2]) & (combos$X3 == pieces[3]), ]
  combined <- aggregate(possibilities$value, list(x4 = possibilities$X4), sum)
  combined[order(-combined$x),"x4"][1]
}

# Can we use corrleation between words in the sentence for unknown n-grams?