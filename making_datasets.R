library(dplyr)
library(tidyr)
library(quanteda)

set.seed(12)

blogs <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
#samples <- sample(length(blogs), as.integer(length(blogs) * 0.8))
#train_blogs <- blogs[samples]
#test <- blogs[-samples]

blogs_sentences <- char_segment(blogs, what="sentences")

# Save the test set for later
#write(test, "test_blogs.txt")

news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
#samples <- sample(length(news), as.integer(length(news) * 0.8))
#train_news <- news[samples]
#test <- news[-samples]

news_sentences <- char_segment(news, what="sentences")

# Save the test set for later
#write(test, "test_news.txt")

twitter <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
#samples <- sample(length(twitter), as.integer(length(twitter) * 0.8))
#train_twitter <- twitter[samples]
#test <- twitter[-samples]

twitter_sentences <- char_segment(twitter, what="sentences")

# Save the test set for later
#write(test, "test_twitter.txt")

my_corpus <- corpus(blogs_sentences) + corpus(news_sentences) + corpus(twitter_sentences)

profanities <- readLines(file("en_profanity.txt", "r"))
closeAllConnections()

toks <- tokens(my_corpus, removeNumbers=TRUE, removePunct=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
# toks <- removeFeatures(toks, stopwords())
toks <- removeFeatures(toks, profanities)
toks <- tokens_tolower(toks)

grams <- dfm(tokens_ngrams(toks,4))
freqs <- colSums(grams)

rm(blogs)
rm(news)
rm(twitter)
#rm(train_blogs)
#rm(train_news)
#rm(train_twitter)
rm(blogs_sentences)
rm(news_sentences)
rm(twitter_sentences)
#rm(samples)
#rm(test)
rm(my_corpus)
rm(grams)
gc()

# multi_hits <- freqs[freqs > 1]

combos <- data.frame(keyName=names(freqs), value=freqs, row.names=NULL)
combos <- combos %>% separate(keyName, c("X1", "X2", "X3", "X4"), "_")

save(combos, file="en_US.Rda")
# save(combos, file="news_and_twitter.Rda")