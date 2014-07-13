## use data table
library(data.table)

## read in data
dataFile <- "household_power_consumption.txt"
dt <- fread( dataFile, na.strings = c("?") )


## concatenate date and time strings, convert to datetime object, 
##  add as another column
dt[,DateTimeObj := as.POSIXct( strptime( paste( Date, Time, sep = " " ), 
                                         format = "%d/%m/%Y %H:%M:%S", 
                                         tz = "GMT" ) )
   ]
##  filter by date to between 2007-02-01 and 2007-02-02 inclusive
dt[,DateObj := { as.Date( dt$Date, format = "%d/%m/%Y", tz="GMT") }]
dt <- dt[dt$DateTimeObj >= as.POSIXct( as.Date( "2007-02-01") ),]
dt <- dt[dt$DateTimeObj < as.POSIXct( as.Date( "2007-02-03") ),]
## note: this filtering less resource efficient than plot1.R

par( mar = c(5.1,5.1,4.1,2.1) )
## draw line plot
with(dt, plot( DateTimeObj, Global_active_power, type = "n",
               ylab = "Global Active Power (kilowatts)", xlab = "" ) )
lines(dt$DateTimeObj,dt$Global_active_power )
## copy to png
dev.copy( png, file = "plot2.png", width = 480, height = 480, pointsize = 10 )
dev.off()
