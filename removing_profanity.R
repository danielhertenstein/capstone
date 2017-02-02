short_chunk <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r"), 200)
closeAllConnections()

library(tm)

short_corpus <- VCorpus(VectorSource(short_chunk))

# Removing profanity
en_profanity <- readLines(file("en_profanity.txt", "r"))
closeAllConnections()

no_profanity <- tm_map(short_corpus, removeWords, en_profanity)