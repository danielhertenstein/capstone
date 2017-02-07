library(dplyr)
library(tidyr)
library(quanteda)

set.seed(12)

blogs <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
samples <- sample(length(blogs), as.integer(length(blogs) * 0.8))
train_blogs <- blogs[samples]
test <- blogs[-samples]

# Save the test set for later
write(test, "test_blogs.txt")

news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
samples <- sample(length(news), as.integer(length(news) * 0.8))
train_news <- news[samples]
test <- news[-samples]

# Save the test set for later
write(test, "test_news.txt")

twitter <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
samples <- sample(length(twitter), as.integer(length(twitter) * 0.8))
train_twitter <- twitter[samples]
test <- twitter[-samples]

# Save the test set for later
write(test, "test_twitter.txt")

my_corpus <- corpus(train_blogs) + corpus(train_news) + corpus(train_twitter)
# my_corpus <- corpus(train_news) + corpus(train_twitter)

four_grams <- dfm(my_corpus, ngrams=4, removeNumbers=TRUE, removePunc=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
freqs <- colSums(four_grams)

rm(blogs)
rm(news)
rm(twitter)
rm(train_blogs)
rm(train_news)
rm(train_twitter)
rm(samples)
rm(test)
rm(my_corpus)
rm(four_grams)
gc()

multi_hits <- freqs[freqs > 1]

combos <- data.frame(keyName=names(multi_hits), value=multi_hits, row.names=NULL)
combos <- combos %>% separate(keyName, c("X1", "X2", "X3", "X4"), "_")

save(combos, file="en_US.Rda")
# save(combos, file="news_and_twitter.Rda")