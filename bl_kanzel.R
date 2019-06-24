## Aurhor: Ben Letham (bletham@fb.com)
## Organization: Facebook
## Package: Prophet Michine Learning
## Data: 
## Date: 2019-05-31
## Purpose: To combine Sunspots data and R + Prophet(ML) to predict Sunspots/Miniumim activity.
## Challenge: Was to take into account 11 year solor mim/max cycles
## Documentions: 
## https://facebook.github.io/prophet/docs/seasonality,_holiday_effects,_and_regressors.html#specifying-custom-seasonalities
## My data import and cleaning code:
##
library(data.table)
library(ggplot2)
library(prophet)
library(RSQLite)
library(plotly)
db <- dbConnect(SQLite(), dbname="../db/solar.sqlite3")
## Observatory Kanzelhöhe for solar and environmental research
rm(list=ls())
##
## Set Working Directory
## setwd('c:/Users/davidjayjackson/Documents/GitHub/Emacs/')
## Download latest data from SIDC
kanzel <-fread("../db/kh_spots.csv")
kanzel$Ymd <- as.Date(kanzel$Ymd)
kanzel$Ymd <- as.character(kanzel$Ymd)
dbWriteTable(db,"kanzel",kanzel, row.names=FALSE,overwrite=TRUE)
kanzel$Ymd <- as.Date(kanzel$Ymd)
kanzel <- kanzel[,.(Ymd,R)]
df <- kanzel
colnames(df) <- c("ds","y")
##
m <- prophet(seasonality.mode="multiplicative")
m <- add_seasonality(m, name="cycle_11year", period=365.25 * 11,fourier.order=5)
m <- fit.prophet(m, df)
future <- make_future_dataframe(m,periods=4000,freq="day")
forecast <- predict(m, future)
plot(m,forecast) +ggtitle("NOAA/AAVSO Sunspot Predictions:1945 - 2025")
## Complete Sunspot prediction: 1945 - 2019
## Begin Calc for Knazel  Northern Hempishere sunspots

# ggplot(data=forecast,aes(x=ds,y=yhat)) + geom_line() +geom_smooth() +
#   ggtitle("Kanzel Northern Sunspot Prediction: Jan.1 2014 - May 31, 2019")


# ## Update sidc (sqlite3) database
db <- dbConnect(SQLite(), dbname="../db/solar.sqlite3")
forecast$ds <- as.character(forecast$ds)
dbWriteTable(db,"blkanzel",forecast, row.names=FALSE,overwrite=TRUE)
kanzel$ds <- as.character(kanzel$ds)
dbWriteTable(db,"kanzel",kanzel, row.names=FALSE,overwrite=TRUE)
dbListTables(db)
