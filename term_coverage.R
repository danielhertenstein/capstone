library(dplyr)
library(tidyr)
library(quanteda)
library(graphics)

coverage <- function(counts, end_point) {
  sum(sort(counts, decreasing = TRUE)[1:end_point]) / sum(counts)
}

news <- readLines(file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "rb"), skipNul = TRUE, encoding = "UTF-8")
closeAllConnections()

news_corpus <- corpus(news)

news_dfm <- dfm(news_corpus, removeNumbers=TRUE, removePunc=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
freqs <- colSums(news_dfm)

top_50 <- names(topfeatures(news_dfm, 200))
top_60 <- names(topfeatures(news_dfm, 550))
top_70 <- names(topfeatures(news_dfm, 1300))
top_80 <- names(topfeatures(news_dfm, 3000))
top_90 <- names(topfeatures(news_dfm, 9000))

# two_grams <- dfm(news_corpus, ngrams=2, removeNumbers=TRUE, removePunc=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
# two_freqs <- colSums(two_grams)
# two_combos <- data.frame(keyName=names(two_freqs), value=two_freqs, row.names=NULL)
# two_combos <- two_combos %>% separate(keyName, c("X1", "X2"), "_")

# two_50 <- two_combos[(two_combos$X1 %in% top_50) & (two_combos$X2 %in% top_50),]
# two_60 <- two_combos[(two_combos$X1 %in% top_60) & (two_combos$X2 %in% top_60),]
# two_70 <- two_combos[(two_combos$X1 %in% top_70) & (two_combos$X2 %in% top_70),]
# two_80 <- two_combos[(two_combos$X1 %in% top_80) & (two_combos$X2 %in% top_80),]
# two_90 <- two_combos[(two_combos$X1 %in% top_90) & (two_combos$X2 %in% top_90),]

three_grams <- dfm(news_corpus, ngrams=3, removeNumbers=TRUE, removePunc=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE)
three_freqs <- colSums(three_grams)

four_grams <- dfm(news_corpus, ngrams=4, removeNumbers=TRUE, removePunc=TRUE, removeSymbols=TRUE, removeTwitter=TRUE, removeURL=TRUE, remove=stopwords("english"))
four_freqs <- colSums(four_grams)

rm(news)
rm(news_corpus)
rm(news_dfm)
rm(freqs)
# rm(two_50)
# rm(two_60)
# rm(two_70)
# rm(two_80)
# rm(two_90)
# rm(two_freqs)
# rm(two_grams)
# rm(two_combos)
rm(three_grams)
rm(four_grams)
gc()

three_combos <- data.frame(keyName=names(three_freqs), value=three_freqs, row.names=NULL)
three_combos <- three_combos %>% separate(keyName, c("X1", "X2", "X3"), "_")
three_50 <- three_combos[(three_combos$X1 %in% top_50) & (three_combos$X2 %in% top_50) & (three_combos$X3 %in% top_50), ]
three_60 <- three_combos[(three_combos$X1 %in% top_60) & (three_combos$X2 %in% top_60) & (three_combos$X3 %in% top_60), ]
three_70 <- three_combos[(three_combos$X1 %in% top_70) & (three_combos$X2 %in% top_70) & (three_combos$X3 %in% top_70), ]
three_80 <- three_combos[(three_combos$X1 %in% top_80) & (three_combos$X2 %in% top_80) & (three_combos$X3 %in% top_80), ]
three_90 <- three_combos[(three_combos$X1 %in% top_90) & (three_combos$X2 %in% top_90) & (three_combos$X3 %in% top_90), ]

rm(three_freqs)
rm(three_combos)
gc()

four_combos <- data.frame(keyName=names(four_freqs), value=four_freqs, row.names=NULL)
four_combos <- four_combos %>% separate(keyName, c("X1", "X2", "X3", "X4"), "_")
four_50 <- four_combos[(four_combos$X1 %in% top_50) & (four_combos$X2 %in% top_50) & (four_combos$X3 %in% top_50) & (four_combos$X4 %in% top_50),]
four_60 <- four_combos[(four_combos$X1 %in% top_60) & (four_combos$X2 %in% top_60) & (four_combos$X3 %in% top_60) & (four_combos$X4 %in% top_60),]
four_70 <- four_combos[(four_combos$X1 %in% top_70) & (four_combos$X2 %in% top_70) & (four_combos$X3 %in% top_70) & (four_combos$X4 %in% top_70),]
four_80 <- four_combos[(four_combos$X1 %in% top_80) & (four_combos$X2 %in% top_80) & (four_combos$X3 %in% top_80) & (four_combos$X4 %in% top_80),]
four_90 <- four_combos[(four_combos$X1 %in% top_90) & (four_combos$X2 %in% top_90) & (four_combos$X3 %in% top_90) & (four_combos$X4 %in% top_90),]

rm(four_freqs)
rm(four_combos)