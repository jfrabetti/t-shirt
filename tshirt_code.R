# jo f. with thanks to:
# http://is-r.tumblr.com/post/46821313005/to-plot-them-is-my-real-test
# http://stackoverflow.com/questions/12918367/in-r-how-to-plot-with-a-png-as-background
# http://students.washington.edu/mclarkso/documents/figure%20layout%20Ver1.R
# http://georeferenced.wordpress.com/2013/01/15/rwordcloud/

# Load libraries
rm(list=ls())
doInstall <- FALSE
toInstall <- c("stringr", "jpeg", "RCurl", "wordcloud", "tm")
if(doInstall){install.packages(toInstall, repos = "http://cran.us.r-project.org")}
lapply(toInstall, library, character.only = TRUE)

if(TRUE) {
  if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

  BiocManager::install("EBImage")
}
sapply(c("stringr", "jpeg", "RCurl", "EBImage", "wordcloud", "tm"),library, character.only=TRUE)


# Obtain R logo and Cereal Guy meme images from web
allImageURLs <- c("http://upload.wikimedia.org/wikipedia/commons/c/c1/Rlogo.png",
				  "https://downloadhdwallpapers.in/wp-content/uploads/2018/02/Cereal-Funny-Meme-Download-Guy-Funny-Meme-Download-Big-Funny-Meme-Download-Squint.png",
				  "https://gartic.com.br/imgs/mural/_c/_casper/cereal-spitting.png")
imageList <- list()
for(imageURL in allImageURLs) {
	print(imageURL)
   tempName <- str_extract(imageURL,"([[:alnum:]_-]+)([[:punct:]])([[:alnum:]]+)$")
   print(tempName)
   tempImage <- readImage(imageURL) 
   imageList[[tempName]] <- tempImage 
}

# Create t-shirt
jpeg(file="t-shirt.jpg")
par(mfrow=c(2,2), mar = c(.2, .2, .2, .2))	
plot(0:10, 0:10, type="n", axes=F, ann=FALSE)
rasterImage(imageList[[1]],1,1,10,10)
box("figure", col="black", lwd=2)
plot(0:10, 0:10, type="n", axes=F, ann=FALSE)
rasterImage(imageList[[2]],1,1,10,10)
box("figure", col="black", lwd=2)

# Create a word cloud of useR! website text; statis files for now
# TODO: scrape website
useR <- Corpus (DirSource("./useRdir"))
removeHyphen <- function(x) gsub("–","",x)
useR <- tm_map(useR, removeHyphen)
useR <- tm_map(useR, stripWhitespace)
useR <- tm_map(useR, tolower)
useR <- tm_map(useR, removeWords, stopwords('english'))

wordcloud(useR, max.words=100, random.order=FALSE, rot.per=0.35, use.r.layout=FALSE, scale=c(3,.5),colors=brewer.pal(8,'Dark2'))
box("figure", col="black", lwd=2)
plot(0:10, 0:10, type="n", axes=F, ann=FALSE)
rasterImage(imageList[[3]],1,1,10,10)
box("figure", col="black", lwd=2)
dev.off()