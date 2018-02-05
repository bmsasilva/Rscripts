# Tutorial adapted from:
# https://datascienceplus.com/building-wordclouds-in-r/

# The dataset used in this tutorial contains around 200k Jeopardy questions and was
# made available by reddit user trexmatt.

#### Data prep ####
library(tm)
library(SnowballC)
library(wordcloud)
jeopQ <- read.csv('./dataFiles/wordCloud.csv', stringsAsFactors = FALSE) # Read the data

# Some operations to simplify the text data are needed
jeopCorpus <- Corpus(VectorSource(jeopQ$Question)) # Create a corpus
jeopCorpus <- tm_map(jeopCorpus, content_transformer(tolower)) # Convert the corpus to lowercase
jeopCorpus <- tm_map(jeopCorpus, PlainTextDocument) # Convert the corpus to a plain text document
jeopCorpus <- tm_map(jeopCorpus, removePunctuation) # Remove all punctuation
jeopCorpus <- tm_map(jeopCorpus, removeWords, stopwords('english')) # Remove stopwords. A full list of stopwords for specific language: stopwords('english').
jeopCorpus <- tm_map(jeopCorpus, removeWords, c('the', 'this', stopwords('english'))) # To remove specific words you can include them in the removeWords function
jeopCorpus <- tm_map(jeopCorpus, stemDocument) # Convert words to their stem (Ex: learning -> learn, walked -> walk). This means that all the words are converted to their stem (Ex: learning -> learn, walked -> walk, etc.). This will ensure that different forms of the word are converted to the same form.

#### Plot word cloud ####
wordcloud(jeopCorpus, max.words = 100, random.order = FALSE)

#### Final notes ####
# wordcloud function parameters:
# scale: This is used to indicate the range of sizes of the words.
# max.words and min.freq: These parameters are used to limit the number of words plotted. max.words will plot the specified number of words and discard least frequent terms, whereas, min.freq will discard all terms whose frequency is below the specified value.
# random.order: By setting this to FALSE, we make it so that the words with the highest frequency are plotted first. If we don’t set this, it will plot the words in a random order, and the highest frequency words may not necessarily appear in the center.
# rot.per: This value determines the fraction of words that are plotted vertically.
# colors: The default value is black. If you want to use different colors based on frequency, you can specify a vector of colors, or use one of the pre-defined color palettes. You can find a list here.
