library(tm)
library(RWeka)
library(dplyr)
library(tidyr)

# Read in all of the news data
news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
set.seed(12)
samples <- sample(length(news), as.integer(length(news) * 0.8))
train_news <- news[samples]
test_news <- news[-samples]

# Save the test set for later
write(test_news, "test_news.txt")

# Make a test courpus
train_corpus <- VCorpus(VectorSource(train_news))

# Remove everything
# train_corpus <- tm_map(train_corpus, removeNumbers)
# train_corpus <- tm_map(train_corpus, stripWhitespace)
train_corpus <- tm_map(train_corpus, content_transformer(tolower))
# train_corpus <- tm_map(train_corpus, stemDocument)
# train_corpus <- tm_map(train_corpus, removePunctuation)
# train_corpus <- tm_map(train_corpus, removeSparseTerms)

# 4-grams
FourGramTokenizer <- function(x) NGramTokenizer(x, Weka_control(min = 4, max = 4))
four_grams <- TermDocumentMatrix(train_corpus, control = list(tokenize = FourGramTokenizer,
                                                              removeNumbers = TRUE,
                                                              stripWhitespace = TRUE,
                                                              removePunctuation = TRUE
                                                              )
                                 )

# Get the frequencies of each 4-gram
freqs <- slam::row_sums(four_grams)

# Create the dataframe that we will traverse
combos <- data.frame(keyName=names(freqs), value=freqs, row.names=NULL)
combos <- combos %>% separate(keyName, c("X1", "X2", "X3", "X4"), " ")

save(combos, file="news.Rda")