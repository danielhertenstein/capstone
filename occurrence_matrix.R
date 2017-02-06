library(dplyr)
library(tidyr)
library(quanteda)

set.seed(12)

news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

samples <- sample(length(news), as.integer(length(news) * 0.8))
news <- news[samples]

twitter <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

samples <- sample(length(twitter), as.integer(length(twitter) * 0.8))
twitter <- twitter[samples]

my_corpus <- corpus(news) + corpus(twitter)

toks <- tokens(my_corpus, removeNumbers=TRUE, removePunct=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
toks <- removeFeatures(toks, stopwords())
toks <- tokens_tolower(toks)

my_fcm <- fcm(toks)

my_dfm <- dfm(my_corpus, removeNumbers=TRUE, removePunc=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE, remove=stopwords())
freqs <- colSums(my_dfm)

coverage <- function(counts, end_point) {
  sum(sort(counts, decreasing = TRUE)[1:end_point]) / sum(counts)
}

top_90 <- names(topfeatures(my_dfm, 16815))

top_occurrences <- my_fcm[top_90]
which.max(colSums(top_occurrences[c("hello", "bat", "apple")]))

for (feature in top_90) {top_occurrences[feature, feature]}