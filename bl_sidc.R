## Aurhor: Ben Letham (bletham@fb.com)
## Organization: Facebook
## Package: Prophet Michine Learning
## Data: http://sidc.be
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
## 
rm(list=ls())
##
## Set Working Directory
setwd('c:/Users/davidjayjackson/Documents/GitHub/Emacs/')
## Download latest data from SIDC
sidc <-fread("http://sidc.be/silso/DATA/SN_d_tot_V2.0.csv",sep = ';')
colnames(sidc) <- c("Year","Month","Day", "Fdate","Spots", "Sd","Obs" ,"Defin"  )
sidc$Ymd <- as.Date(paste(sidc$Year, sidc$Month, sidc$Day, sep = "-"))
df<-sidc[Ymd>="1850-01-01" ,.(Ymd,Spots),]
colnames(df) <- c("ds","y")
## data <-sidc
# summary(df)
# db <- dbConnect(SQLite(), dbname="../db/solar.sqlite3")
# df$ds <- as.character(df$ds)
# dbWriteTable(db,"sidc",df, row.names=FALSE,overwrite=TRUE)
# df$ds <- as.Date(df$ds)
# dbListTables(db)
## Beginning of Ben's Prophet code
##
m <- prophet(seasonality.mode="multiplicative")
m <- add_seasonality(m, name="cycle_11year", period=365.25 * 11,fourier.order=5)
m <- fit.prophet(m, df)
future <- make_future_dataframe(m,periods=2000,freq="day")
forecast <- predict(m, future)
plot(m, forecast) +ggtitle("SIDC Sunspot Prediction: Jan. 1850 - May. 2019")
forecast <- as.data.table(forecast)
## Current Mininum: 2014 - 2019
forecast1 <- forecast[ds >="2014-01-01",]
ggplot(data=forecast1,aes(x=ds,y=yhat)) +geom_line() + geom_smooth() +
  ggtitle("SIDC Current Mimimum: 2014 -2025")
## 2019 prediction an plot
forecast2 <- forecast[ds >="2019-01-01" & ds <="2021-05-31",]
ggplot(data=forecast2,aes(x=ds,y=yhat)) +geom_line() + geom_smooth() +
    ggtitle("SIDC Sunspots Prediction: 2019-2021")
## Next 24 Months:  prediction an plot
# forecast3 <- forecast[ds >="2019-01-01" & ds <="2021-05-31",]
# ggplot(data=forecast2,aes(x=ds,y=yhat)) +geom_line() + geom_smooth() +
#   ggtitle("SIDC Sunspots Prediction: Jan. 2019 - May 31, 2021")
## Update sidc (sqlite3) database
# db <- dbConnect(SQLite(), dbname="../db/solar.sqlite3")
# forecast$ds <- as.character(forecast$ds)
# dbWriteTable(db,"blsidc",forecast, row.names=FALSE,overwrite=TRUE)
# dbWriteTable(db,"m",m, row.names=FALSE,overwrite=TRUE)
# dbListTables(db)
