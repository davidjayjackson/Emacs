library(data.table)
library(xts)
library(tseries)
library(ggplot2)
## Set Working Directory
setwd('c:/Users/davidjayjackson/Documents/GitHub/Emacs/')
## Download latest data from SIDC
sidc <-fread("http://sidc.be/silso/DATA/SN_d_tot_V2.0.csv",sep = ';')
colnames(sidc) <- c("Year","Month","Day", "Fdate","Spots", "Sd","Obs" ,"Defin"  )
sidc$Ymd <- as.Date(paste(sidc$Year, sidc$Month, sidc$Day, sep = "-"))            
A<-sidc[Year>=1900 & Year <=2019,.(Ymd,Spots),]
summary(A$Year)
## Start Monthly XTS
A$Ymd <- as.Date(A$Ymd)
isn.xts <- xts(x = A$Spots, order.by = A$Ymd)
str(isn.xts)
isn.monthly<- apply.monthly(isn.xts, sum)
XTSMON <- as.data.table(isn.monthly)
colnames(XTSMON) <- c("Ymd","Spots")
Sunspots <- XTSMON[,.(Ymd,Spots)]
write.csv(Sunspots,file="Sunspots.csv",row.names=T)
## Monthly Mean
ins.xts <- xts(x=A$Spots, order.by=A$Ymd)
isn.monthly <- apply.monthly(ins.xts, mean)
XTSM <- as.data.table(isn.monthly)
colnames(XTSM) <- c("Ymd","Spots")
