library(quanteda)
library(pluralize)

blogs <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "rb"), n=10, skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"), n=10, skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

all_text <- paste(c(unlist(blogs), unlist(news)), sep='', collapse=' ')

all_words <- unlist(tokenize(all_text))
singulars <- singularize(all_words)
