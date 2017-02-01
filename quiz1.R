# 2/3
test <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r"))
closeAllConnections()
test_lengths <- sapply(test, nchar, USE.NAMES = FALSE)
max(test_lengths)

# 3
test <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r"))
closeAllConnections()
test_lengths <- sapply(test, nchar, USE.NAMES = FALSE)
max(test_lengths)

test <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r"))
closeAllConnections()
test_lengths <- sapply(test, nchar, USE.NAMES = FALSE)
max(test_lengths)

# 4
test <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r"))
closeAllConnections()
sum(sapply(test, grepl, pattern="love", USE.NAMES = FALSE)) / sum(sapply(test, grepl, pattern="hate", USE.NAMES = FALSE))

# 5
test[grep("biostats", test)]

# 6
length(grep("A computer once beat me at chess, but it was no match for me at kickboxing", test))