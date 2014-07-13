
## use data table
library(data.table)

## read in data
dataFile <- "household_power_consumption.txt"
dt <- fread( dataFile, na.strings = c("?"), stringsAsFactors = FALSE )
## note: in testing, fread took about 2.5 seconds, read.table 35 seconds,
##  each numeric conversion below less than 2 seconds each,
##  so fread well worth it in this case

## convert date string into date object, then
##  use to filter by date to between 2007-02-01 and 2007-02-02 inclusive
dt[,DateObj := { as.Date( dt$Date, format = "%d/%m/%Y", tz="GMT") }]
dt <- dt[dt$DateObj >= as.Date( "2007-02-01"),]
dt <- dt[dt$DateObj < as.Date( "2007-02-03"),]
## concatenate date and time strings, convert to datetime object, 
##  add as another column
dt[,DateTimeObj := as.POSIXct( strptime( paste( Date, Time, sep = " " ), 
                                         format = "%d/%m/%Y %H:%M:%S", 
                                         tz = "GMT" ) )
   ]
## convert columns to numerics because fread is fast but bad at na.strings
dt$Sub_metering_1 <- as.numeric( dt$Sub_metering_1 )
dt$Sub_metering_2 <- as.numeric( dt$Sub_metering_2 )
dt$Sub_metering_3 <- as.numeric( dt$Sub_metering_3 )

## draw to png file
png( filename = "plot3.png", width = 480, height = 480, pointsize = 12 )
## draw plot and color-coded lines
plot( dt$DateTimeObj, dt$Sub_metering_1, type = "n",
      xlab = "", ylab = "Energy sub metering" )
lines( dt$DateTimeObj, dt$Sub_metering_1, col = "black" )
lines( dt$DateTimeObj, dt$Sub_metering_2, col = "red" )
lines( dt$DateTimeObj, dt$Sub_metering_3, col = "blue" )
## legend
legend( "topright"
      , c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3" )
      , col = c( "black", "red", "blue" ), lty = c( "solid", "solid", "solid" )
      )
dev.off()
