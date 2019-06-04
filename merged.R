##  Read db tables from /db/solar.sqlite3
## use R merged functions to create summary table
library(ggplot2)
library(data.table)
library(RSQLite)
# Pull data:
db <- dbConnect(SQLite(), dbname="../db/solar.sqlite3")
key<- dbGetQuery(db, "SELECT ds,y  FROM sidc")
kanzel<- dbGetQuery(db, "SELECT ds,yhat FROM blkanzel")
sidc<- dbGetQuery(db, "SELECT ds,yhat FROM blsidc")
aavso<- dbGetQuery(db, "SELECT ds,yhat FROM  blaavso")
## change col names:
colnames(key) <- c("Ymd","Report")
colnames(kanzel)  <-c("Ymd","kanzel")
colnames(sidc) <- c("Ymd","sidc")
colnames(aavso) <- c("Ymd","aavso")
## Convert date field to Date format
key$Ymd <-as.Date(key$Ymd)
kanzel$Ymd <- as.Date(kanzel$Ymd)
sidc$Ymd <- as.Date(sidc$Ymd)
aavso$Ymd <- as.Date(aavso$Ymd)
## Begin Merging df.
merged.aa <- merge(key,kanzel,all.x=TRUE)

