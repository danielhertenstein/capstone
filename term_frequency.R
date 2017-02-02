short_chunk <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r"), 2000)
closeAllConnections()

library(tm)

# Make a test courpus
short_corpus <- VCorpus(VectorSource(short_chunk))

# A naive term-document matrix
dtm <- DocumentTermMatrix(short_corpus)

# Explore the most frequent words
findFreqTerms(dtm, 10)

# Histogram of word frequency
freqs <- colSums(data.frame(inspect(dtm)))
hist(freqs)

# How many words to hit 50% of total frequency?
sum(sort(freqs, decreasing = TRUE)[1:450]) / sum(freqs)

# 2-grams
library(NLP)
TwoGramTokenizer <- function(x) unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
two_grams <- TermDocumentMatrix(short_corpus, control = list(tokenize = TwoGramTokenizer))

# 3-grams
ThreeGramTokenizer <- function(x) unlist(lapply(ngrams(words(x), 3), paste, collapse = " "), use.names = FALSE)
three_grams <- TermDocumentMatrix(short_corpus, control = list(tokenize = ThreeGramTokenizer))


