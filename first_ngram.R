library(ngram)

short_chunk <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r"), 200)
closeAllConnections()

str <- concatenate(short_chunk)
str2 <- preprocess(str, case = 'lower', remove.punct = TRUE, fix.spacing = TRUE)

uni_gram <- ngram(str2, n=1, sep= " ")
bi_ngram <- ngram(str2, n=2, sep=" ")
tri_ngram <- ngram(str2, n=3, sep = " ")
four_ngram <- ngram(str2, n=4, sep = " ")