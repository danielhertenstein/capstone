library(dplyr)
library(tidyr)
library(quanteda)

set.seed(12)

news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()
samples <- sample(length(news), as.integer(length(news) * 0.8))
train <- news[samples]
test <- news[-samples]

# test_sentences <- c("I am Sam", "Sam I am", "I do not like green eggs and ham")
# my_corpus <- corpus(test_sentences)
# sentences <- corpus_reshape(my_corpus, to="sentences")

train_sentences <- char_segment(train, what="sentences")
train_corpus <- corpus(train_sentences)

toks <- tokens(train_corpus, removeNumbers=TRUE, removePunct=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
# toks <- removeFeatures(toks, stopwords())
toks <- tokens_tolower(toks)

n <- 4
grams <- dfm(tokens_ngrams(toks,n))
freqs <- colSums(grams)

test_sentences <- char_segment(test, what="sentences")
test_tokens <- tokens(test_sentences, removeNumbers=TRUE, removePunct=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
# test_tokens <- removeFeatures(test_tokens, stopwords())
test_tokens <- tokens_tolower(test_tokens)
test_grams <- tokens_ngrams(test_tokens, n=n)
test_grams <- unlist(as.list(test_grams))
test_grams <- unique(test_grams)

combos <- data.frame(X1=names(freqs), value=freqs, row.names=NULL)
if (n > 1) {
  if (n == 2) { separator <- c("X1", "X2") }
  else if (n == 3) { separator <- c("X1", "X2", "X3") }
  else { separator <- c("X1", "X2", "X3", "X4") }
  combos <- combos %>% separate(X1, separator, "_")
  # multi_hits <- combos[combos$value > 1,]
}

combo_frequency <- function(in_string) {
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, "_"))
  possibilities <- combos[combos$X1 == pieces[1], ]
  numerator <- possibilities[possibilities$X2 == pieces[2], "value"]
  denominator <- sum(possibilities$value)
  numerator / denominator
}

predict_next <- function(in_string) {
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, "_"))
  possibilities <- multi_hits[(multi_hits$X1 == pieces[1]), ]
  if (!nrow(possibilities)) {
    prediction <- "the"
  }
  else {
    combined <- aggregate(possibilities$value, list(x2 = possibilities$X2), sum)
    prediction <- combined[order(-combined$x),"x2"][1]
  }
  prediction == pieces[2]
}

#relative_frequency <- function(in_string) {
#  in_string <- tolower(in_string)
#  pieces <- unlist(strsplit(in_string, " "))
#  phrase <- paste(pieces[1], pieces[2], sep='_')
#  numerator <- two_freqs[phrase]
#  if (is.na(numerator)) { 0 }
#  else {
#    denominator <- one_freqs[pieces[1]]
#    numerator / denominator
#  }
#}

my_predict <- function(in_string) {
  if (in_string == "") { prediction <- predict_0("") }
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, " "))
  if (length(pieces) == 1) {
    prediction <- predict_1(pieces)
  }
  else if (length(pieces) == 2) {
    prediction <- predict_2(pieces)
  }
  else if (length(pieces) > 2) {
    prediction <- predict_3(pieces)
  }
  prediction
}

predict_0 <- function(pieces) {
  as.character(combos[order(-combos[,"value"]),"X1"][1:5])
}

predict_1 <- function(pieces) {
  possibilities <- combos[combos$X1 == pieces[1], ]
  if (!nrow(possibilities)) {
    predict_0(pieces)
  }
  else {
    possibilities <- possibilities[!(possibilities$X2 %in% stopwords()), ]
    combined <- aggregate(possibilities$value, list(x2 = possibilities$X2), sum)
    combined[order(-combined$x),"x2"][1:5]
  }
}

predict_2 <- function(pieces) {
  possibilities <- combos[(combos$X1 == pieces[1]) & (combos$X2 == pieces[2]), ]
  if (!nrow(possibilities)) {
    predict_1(tail(pieces, 1))
  }
  else {
    possibilities <- possibilities[!(possibilities$X3 %in% stopwords()), ]
    combined <- aggregate(possibilities$value, list(x3 = possibilities$X3), sum)
    combined[order(-combined$x),"x3"][1:5]
  }
}

predict_3 <- function(pieces) {
  possibilities <- combos[(combos$X1 == pieces[1]) & (combos$X2 == pieces[2]) & (combos$X3 == pieces[3]), ]
  if (!nrow(possibilities)) {
    predict_2(tail(pieces, 2))
  }
  else {
    possibilities <- possibilities[!(possibilities$X4 %in% stopwords()), ]
    combined <- aggregate(possibilities$value, list(x4 = possibilities$X4), sum)
    combined[order(-combined$x),"x4"][1:5]
  }
}