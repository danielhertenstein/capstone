short_chunk <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r"), 200)
closeAllConnections()

# library(NLP)
# library(openNLP)
# library(tokenizers)
library(tm)

# Make the corpora
full_corpus <- VCorpus(DirSource("./Coursera-SwiftKey/final/en_us/", encoding = "UTF-8"))

# Take a look at it
inspect(full_corpus)
meta(full_corpus[[1]])

# Make a test courpus
short_corpus <- VCorpus(VectorSource(short_chunk))

# A naive term-document matrix
dtm <- DocumentTermMatrix(short_corpus)

# Removing Stopwords first
stop_corpus <- tm_map(short_corpus, removeWords, stopwords("english"))
stop_dtm <- DocumentTermMatrix(stop_corpus)