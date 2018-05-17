# Script made by Bruno M. Silva
# For a detailed explanation see:
# https://geekcologist.wordpress.com/2018/05/11/pdf-scraping-with-r-2-of-3/

library(pdftools)
library(tm)

# Number of top words per document to be displayed
len <- 5

# Change with the full path of the folder containing the PDF files
path <- "~/pdf_folder"
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
                                              stemming = TRUE,
                                              wordLengths = c(3, Inf)))

# Change column headers to PDF names
corp_mat$dimnames$Docs <- list.files(path, full.names = FALSE, pattern = "pdf$")

# Find most frequent terms per PDF
freq_terms <- findMostFreqTerms(corp_mat, n = len)

# Frequency barplots
for (i in seq(corp_mat$dimnames$Docs)){
  png(filename = paste0(corp_mat$dimnames$Docs[i],".png"))
  aux <- freq_terms[[i]]
  barplot(height = as.vector(aux), names.arg = names(aux),
          main = corp_mat$dimnames$Docs[i])
  dev.off()
}

