library(dplyr)
library(tidyr)
library(quanteda)

# Read in the news text and break it up into sentences
news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()
# Splitting the text into sentences prevents the creation of n-grams that span sentences
news_sentences <- char_segment(news, what="sentences")

# Read in the twitter text and break it up into sentencse
twitter <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()
twitter_sentences <- char_segment(twitter, what="sentences")

# Make our corpus of the two sets of text
my_corpus <- corpus(news_sentences) + corpus(twitter_sentences)

# Read in our list of profanities that we're going to filter out
profanities <- readLines(file("en_profanity.txt", "r"))
closeAllConnections()

# Tokenize each sentence into its words. Remove words that are entirely numbers, punctuation not in the middle of words,
# all other symbols, any #'s in front of words, and all URLs. Filter out our list of profanities, and turn all the words
# to lowercase.
toks <- tokens(my_corpus, removeNumbers=TRUE, removePunct=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
toks <- removeFeatures(toks, profanities)
toks <- tokens_tolower(toks)

# Do a quick cleanup before we use a bunch of memory in making all of the 4-grams
rm(news)
rm(twitter)
rm(news_sentences)
rm(twitter_sentences)
rm(my_corpus)
rm(profanities)
gc()

# Make our 4-grams from the tokens in each sentence. Sum up the frequencies of each 4-gram across all sentences
grams <- dfm(tokens_ngrams(toks,4))
freqs <- colSums(grams)

# Do another cleanup before we use a bunch of memory in making our dataframe
rm(toks)
rm(grams)
gc()

# Create a dataframe with columns being the four words of a 4-gram and its number of appearances in texts
# Each row is a unique 4-gram
combos <- data.frame(keyName=names(freqs), value=freqs, row.names=NULL)
combos <- combos %>% separate(keyName, c("X1", "X2", "X3", "X4"), "_")

# Remove stopwords from the final element of all the 4-grams so we don't bother predicting them
combos <- combos[!(combos$X4 %in% stopwords()), ]

# Clean up the freqs vector
rm(freqs)
gc()

# Save our dataset to use with our prediction model
save(combos, file="en_US.Rda")