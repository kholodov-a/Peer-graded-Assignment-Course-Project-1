library(sqldf)
library(dplyr)

# Creating variables with names of source (zip) and unziped (txt) files
flName <- "household_power_consumption.txt"
flZip <- paste0(strsplit(flName, split = "[.]")[[1]][1],".zip")

# Check for data and downloading and unzipping in neccesasary 
if (!file.exists(flName)) {
    if (!file.exists(flZip)) { 
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                      destfile = paste0("./", flZip)) }
    unzip(flZip,exdir="./")
}

# Reading the data frame from the source file for period from "2007/02/01" to "2007/02/02"
# Mutating string with Data to Data and string with Time to POSTlt
# Renaming "Time" to "datetime"
smpl <- read.csv.sql(flName, sql = "select * from file where Date Like '2/2/2007' OR Date Like '1/2/2007'", 
                     header = TRUE, sep = ";") %>% 
    mutate(Time = strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S"), Date = as.Date(Date, "%d/%m/%Y")) %>% 
    rename(datetime = Time)

# Culculating labels for x-axis for plots with datetime
startDay <- min(smpl$datetime)
endDay <- max(smpl$datetime)
endDay$mday <- endDay$mday+1; endDay$hour <- 0;  endDay$min <- 0; endDay$sec <- 0

# Plot 2
png(filename = "Plot2.png", width = 480, height = 480, units = "px", bg = "white")
with(smpl, {
    plot(datetime, Global_active_power, xaxt = 'n', lwd =1, type = "l" , ylab = "Global active power (kilowatts)", xlab="")
    axis.POSIXct(1, datetime, format = "%a", at=c(seq(from=startDay,to=endDay,by=24*3600)))
})
dev.off()