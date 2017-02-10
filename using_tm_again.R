library(quanteda)

#blogs <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r"), n=100, skipNul = TRUE, encoding = "UTF-8")
#closeAllConnections()
#blogs_sentences <- char_segment(blogs, what="sentences")

#news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r"), n=100, skipNul = TRUE, encoding = "UTF-8")
#closeAllConnections()
#news_sentences <- char_segment(news, what="sentences")

twitter <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r"), n=100, skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()
twitter_sentences <- char_segment(twitter, what="sentences")

# Remove all words that contain digits
no_digits <- stringi::stri_replace_all_regex(test, "", pattern="\\S*[:digit:]+\\S*")