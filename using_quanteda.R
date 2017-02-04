library(dplyr)
library(tidyr)
library(quanteda)

set.seed(12)

# Load the news data
news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
samples <- sample(length(news), as.integer(length(news) * 0.2))
train_news <- news[samples]
test_news <- news[-samples]
rm(news)

# Save the test set for later
write(test_news, "test_news.txt")
rm(test_news)

# Repeat the same process for the blog data
blog <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
samples <- sample(length(blog), as.integer(length(blog) * 0.2))
train_blog <- blog[samples]
test_blog <- blog[-samples]
rm(blog)

# Save the test set for later
write(test_blog, "test_blog.txt")
rm(test_blog)

# Repeat the same process for the twitter data
twitter <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

# Grab a sample of 80%
samples <- sample(length(twitter), as.integer(length(twitter) * 0.2))
train_twitter <- twitter[samples]
test_twitter <- twitter[-samples]
rm(twitter)

# Save the test set for later
write(test_twitter, "test_twitter.txt")
rm(test_twitter)

rm(samples)

# Create the corpus
train_corpus <- corpus(train_news) + corpus(train_blog) + corpus(train_twitter)
rm(train_news)
rm(train_blog)
rm(train_twitter)

# Uncomment if you need the memory back. I wish that rm() would free the memory immediately
# gc()

four_grams <- dfm(train_corpus, ngrams=4, removeNumbers=TRUE, removePunc=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)

rm(train_corpus)
# gc()

freqs <- colSums(four_grams)

rm(four_grams)
# gc()

# Create the dataframe that we will traverse
combos <- data.frame(keyName=names(freqs), value=freqs, row.names=NULL)

rm(freqs)
# gc()
combos <- combos %>% separate(keyName, c("X1", "X2", "X3", "X4"), "_")

save(combos, file="en_US.Rda")