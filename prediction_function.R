my_predict <- function(in_string) {
  pieces <- unlist(strsplit(in_string, " "))
  switch(length(pieces),
         1 = predict_1(pieces),
         2 = predict_2(pieces),
         3 = predict_3(pieces)
  )
}

predict_1 <- function(pieces) {
  pieces
}

predict_2 <- function(pieces) {
  pieces
}

predict_3 <- function(pieces) {
  pieces
}