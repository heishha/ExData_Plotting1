
## use data table
library(data.table)

## read in data
dataFile <- "household_power_consumption.txt"
dt <- fread( dataFile, na.strings = c("?") )

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

par( mar = c(5.1,5.1,4.1,2.1) )
## draw histogram with red bars, etc
hist( as.numeric( dt$Global_active_power ),
      xlab = "Global Active Power (kilowatts)", ylab = "Frequency",
      main = "Global Active Power",
      col = "red" )
## copy to png
dev.copy( png, file = "plot1.png", width = 480, height = 480, pointsize = 10 )
dev.off()
