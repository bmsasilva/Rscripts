# Script made by Bruno M. Silva
# For a detailed explanation see:
# https://geekcologist.wordpress.com/2018/05/10/pdf-scraping-with-r-1-of-3/

library(pdftools)
library(tm)
library(wordcloud)

# Number of words to be displayed on word cloud plots
len <- 50

# Change with the full path of the folder containing the PDF files
path <- "~/Projectos/geekcologist/post1_pdf_scrap_wordclouds/pdf_folder"
setwd(path)

# Import PDF files
files <- list.files(path, full.names = TRUE, pattern = "pdf$")
files_text <- lapply(files, pdf_text)

# Eliminate unicode characters
files_text <- lapply(files_text, 
                     function(x) 
                       gsub(
                         "(\u201c|\u201d|\u2018|\u2019|\u2012|\u2013|\u2014)",
                         "", x))

# Create corpus matrix
corp <- Corpus(VectorSource(files_text))
corp_mat <- TermDocumentMatrix(corp, 
                               control = list(removePunctuation = TRUE,
                                              stripWhitespace = TRUE,
                                              stopwords = TRUE,
                                              tolower = TRUE,
                                              removeNumbers = TRUE,
                                              wordLengths = c(3, Inf)))

# Change column headers to PDF names
corp_mat$dimnames$Docs <- list.files(path, full.names = FALSE, pattern = "pdf$")

# Plot word clouds to file
for (i in seq(corp_mat$dimnames$Docs)){
  png(filename = paste0(corp_mat$dimnames$Docs[i],".png"))
  layout(matrix(c(1, 2), nrow=2), heights= c(1, 10))
  par(mar=rep(0, 4))
  plot.new()
  text(x=0.5, y=0.5, corp_mat$dimnames$Docs[i])
  wordcloud(row.names(corp_mat), as.matrix(corp_mat)[, i], max.words = len)
  dev.off()
}

