
## use sqldf
library(sqldf)

## read in data
dataFile <- "household_power_consumption.txt"
sqlStr <- "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007'"
df <- read.csv2.sql( dataFile, sqlStr, sep = ";", stringsAsFactors = FALSE )
## note: in testing, fread from previous tests took about 2.5 seconds,
##  this read.csv2.sql took about 31 seconds, so not faster in this case.
##  maybe the sql method has lower memory requirements, depending on the
##  db impl?

## concatenate date and time strings, add as another column
df$DateTimeStr <- apply( df, 1, function(x) {
  paste( x["Date"], x["Time"], sep = " " )
                  } )
## convert to datetime object, add as another column
df$DateTimeObj <- as.POSIXct( strptime( df$DateTimeStr, 
                                         format = "%d/%m/%Y %H:%M:%S", 
                                         tz = "GMT" ) )

## draw to png file -------------------------------------------------
png( filename = "plot4.png", width = 480, height = 480 )
## left right top down 2x2 grid of plots
par( mfrow = c( 2, 2 ) )
## line plot of global active power
with( df, plot( DateTimeObj, Global_active_power, type = "n",
               ylab = "Global Active Power", xlab = "" ) )
with( df, lines(DateTimeObj,Global_active_power) )
## line plot of voltage
with( df, plot( DateTimeObj, Voltage, type = "n",
                ylab = "Voltage", xlab = "datetime" ) )
with( df, lines(DateTimeObj,Voltage) )

## color-coded line plot of sub metering
with( df, plot( DateTimeObj, Sub_metering_1, type = "n",
      xlab = "", ylab = "Energy sub metering" ) )
with( df, { lines( DateTimeObj, Sub_metering_1, col = "black" )
            lines( DateTimeObj, Sub_metering_2, col = "red" )
            lines( DateTimeObj, Sub_metering_3, col = "blue" )
          } )
legend( "topright", cex = 0.75, bty = "n"
        , c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3" )
        , col = c( "black", "red", "blue" ), lty = c( "solid", "solid", "solid" )
)

## line plot of global reactive power
with( df, plot( DateTimeObj, Global_reactive_power, type = "n",
                ylab = "Global_reactive_power", xlab = "datetime" ) )
with( df, lines(DateTimeObj,Global_reactive_power) )

## end draw to png file ---------------------------------------------
dev.off()
