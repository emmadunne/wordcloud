library(pdftools)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tm)
library(dplyr)
library(SnowballC)
library(ggsci)


# tell R where PDFs are
files <- list.files("./PDFs/",full.names = T)

# use the ‘Corpus’ function to extract text from the PDF documents.
corp <- Corpus(URISource(files),
               readerControl = list(reader = readPDF))
print(corp)

# create a document-term matrix that describes the frequency of terms that occur in the documents
publications.tdm <- TermDocumentMatrix(corp, 
                                       control = 
                                         list(removePunctuation = TRUE,
                                              stopwords = TRUE,
                                              tolower = TRUE,
                                              stemming = TRUE,
                                              removeNumbers = TRUE,
                                              bounds = list(global = c(3, Inf)))) 


# Convert the output to a matrix
matrix <- as.matrix(publications.tdm) 
head(matrix)

# We then count the frequency of the use of different words
words <- sort(rowSums(matrix),decreasing=TRUE) 
head(words)

# Convert that output to a dataframe
df <- data.frame(word = names(words),freq=words)

# Remove words that we don't want to include in the wordcloud
remove.rows <- which(df$word %in% c('clink','use','includ') )
df <- df[- remove.rows,]


# make edits in Excel
write.csv(df, "./words.csv")
words <- read_csv("words.csv")


wordcloud(words = words$word, freq = words$freq, min.freq = 4,           
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=pal_flatui()(8))

