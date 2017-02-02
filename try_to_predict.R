short_chunk <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"), 2000, skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

library(tm)
library(RWeka)
library(dplyr)
library(tidyr)

# Make a test courpus
short_corpus <- VCorpus(VectorSource(short_chunk))

# Remove everything
short_corpus <- tm_map(short_corpus, removeNumbers)
short_corpus <- tm_map(short_corpus, stripWhitespace)
short_corpus <- tm_map(short_corpus, content_transformer(tolower))
# short_corpus <- tm_map(short_corpus, stemDocument)
short_corpus <- tm_map(short_corpus, removePunctuation)
# short_corpus <- tm_map(short_corpus, removeSparseTerms)

# 4-grams
FourGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
four_grams <- TermDocumentMatrix(short_corpus, control = list(tokenize = FourGramTokenizer))

# Get the frequencies of each 4-gram
freqs <- rowSums(as.matrix(four_grams))

freqs[1:10]

combos <- data.frame(keyName=names(freqs), value=freqs, row.names=NULL)
combos <- combos %>% separate(keyName, c("X1", "X2", "X3", "X4"), " ")

test <- combos[combos$X1 == "a", ]
test2 <- aggregate(test$value, list(x2 = test$X2), sum)
test2[order(-test2$x),"x2"][1]

