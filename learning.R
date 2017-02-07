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

# one_grams <- dfm(tokens_ngrams(toks,1))
two_grams <- dfm(tokens_ngrams(toks,2))
# three_grams <- dfm(tokens_ngrams(toks,3))
# four_grams <- dfm(tokens_ngrams(toks,4))

# one_freqs <- colSums(one_grams)
two_freqs <- colSums(two_grams)
# three_freqs <- colSums(three_grams)
# four_freqs <- colSums(four_grams)

relative_frequency <- function(in_string) {
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, " "))
  phrase <- paste(pieces[1], pieces[2], sep='_')
  numerator <- two_freqs[phrase]
  if (is.na(numerator)) { 0 }
  else {
    denominator <- one_freqs[pieces[1]]
    numerator / denominator
  }
}

test_sentences <- char_segment(test, what="sentences")
test_tokens <- tokens(test_sentences, removeNumbers=TRUE, removePunct=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
test_tokens <- tokens_tolower(test_tokens)
test_2_grams <- tokens_ngrams(test_tokens, n=2)
test_2_grams <- unlist(as.list(test_2_grams))
test_2_grams <- unique(test_2_grams)

combos <- data.frame(keyName=names(two_freqs), value=two_freqs, row.names=NULL)
combos <- combos %>% separate(keyName, c("X1", "X2"), "_")

combo_frequency <- function(in_string) {
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, " "))
  possibilities <- combos[combos$X1 == pieces[1], ]
  numerator <- possibilities[possibilities$X2 == pieces[2], "value"]
  denominator <- sum(possibilities$value)
  numerator / denominator
}

predict_next <- function(in_string) {
  in_string <- tolower(in_string)
  pieces <- unlist(strsplit(in_string, "_"))
  possibilities <- combos[combos$X1 == pieces[1], ]
  if (!nrow(possibilities)) {
    prediction <- "the"
  }
  else {
    combined <- aggregate(possibilities$value, list(x2 = possibilities$X2), sum)
    prediction <- combined[order(-combined$x),"x2"][1]
  }
  prediction == pieces[2]
}