ngram_colloc <- function(model, collocs, in_string) {
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, " "))
  possibilities <- my_predict(model, pieces)
  print(possibilities)
  colloc_ranks <- collocs[(collocs$word1 %in% pieces) & (colocs$word2 %in% possibilities), ]
  print(head(colloc_ranks[order(-colloc_ranks$dice), ], 5))
  print(head(colloc_ranks[order(-colloc_ranks$G2), ], 5))
  print(head(colloc_ranks[order(-colloc_ranks$X2), ], 5))
  print(head(colloc_ranks[order(-colloc_ranks$pmi), ], 5))
}

my_predict <- function(model, in_string) {
  if (in_string == "") { prediction <- predict_0(model, "") }
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, " "))
  if (length(pieces) == 1) {
    prediction <- predict_1(model, pieces)
  }
  else if (length(pieces) == 2) {
    prediction <- predict_2(model, pieces)
  }
  else if (length(pieces) > 2) {
    prediction <- predict_3(model, pieces)
  }
  prediction
}

predict_0 <- function(model, pieces) {
  as.character(model[order(-model[,"value"]),"X1"][1:5])
}

predict_1 <- function(model, pieces) {
  possibilities <- model[model$X1 == pieces[1], ]
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
  if (!nrow(possibilities)) {
    predict_2(model, tail(pieces, 2))
  }
  else {
    combined <- aggregate(possibilities$value, list(x4 = possibilities$X4), sum)
    combined <- combined[order(-combined$x), ]
    if (nrow(combined) > 5) {
      min_freq <- combined[5, "x"]
      combined[combined$x >= min_freq, "x4"]
    }
    else {
      combined$x4
    }
  }
}