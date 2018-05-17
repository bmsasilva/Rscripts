# Script made by Bruno M. Silva
# For a detailed explanation see:
# https://geekcologist.wordpress.com/2018/05/11/pdf-scraping-with-r-3-of-3/

library(pdftools)
library(tm)

# Function
key_search <- function(mat, keywords, stemming = TRUE){
  output <- matrix(NA, nrow = length(keywords), ncol = dim(mat)[2])
  colnames(output) <- colnames(mat)
  if(stemming == TRUE){
    key_corp <-VCorpus(VectorSource(keywords))
    key_corp <-tm_map(key_corp, stemDocument)
    key_new <- as.vector(sapply(key_corp, content))
    rownames(output) <- key_new
  } else {
    rownames(output) <- keywords
    key_new <- keywords
  }
  for(i in seq(length(mat[1, ]))){
    mat_doc <- mat[which(mat[,i] > 0), i]
    mat_words <- names(mat_doc)
    mat_freq <- as.numeric(mat_doc)
    for(j in seq(key_new))
      output[j, i] <- sum(mat_freq[grep(key_new[j], mat_words)])
  }
  output
}

# Replace with desired keywords
keywords <- c("feeding", "kuhlii", "echolocating", "calls")

# Should stemming be used on keywords
stemming <- TRUE

# Change with the full path of the folder containing the PDF files
path <- "~/Projectos/geekcologist/post3_pdf_scrap_keywords/pdf_folder"
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

# Convert to matrix
mat <- as.matrix(corp_mat)
colnames(mat) <- corp_mat$dimnames$Docs

# Keyword search
search <- key_search(mat, keywords, stemming = stemming)

# Keyword frequency barplots
for (i in seq(dim(search)[2])){
  png(filename = paste0(colnames(search2)[i],".png"))
  barplot(height = as.vector(search[, i]), names.arg = rownames(search),
          main = colnames(search)[i])
  dev.off()
}

