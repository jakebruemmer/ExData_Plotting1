library(data.table)
library(lubridate)
library(dplyr)

setwd(getwd())

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "power_consumption.zip")

unzip("power_consumption.zip")

# Read in the file for processing and do some converting for numerical purposes.
hh_power <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")
hh_power <- data.table(hh_power)
colnames(hh_power) <- tolower(colnames(hh_power))
hh_power$date <- dmy(hh_power$date)
hh_power$global_active_power <- as.numeric(as.character(hh_power$global_active_power))
hh_power$sub_metering_1 <- as.numeric(as.character(hh_power$sub_metering_1))
hh_power$sub_metering_2 <- as.numeric(as.character(hh_power$sub_metering_2))
hh_power$sub_metering_3 <- as.numeric(as.character(hh_power$sub_metering_3))
hh_power$global_reactive_power <- as.numeric(as.character(hh_power$global_reactive_power))
hh_power$voltage <- as.numeric(as.character(hh_power$voltage))

# Get the subset
two_days <- subset(hh_power, date == ymd("2007/02/01") | date == ymd("2007/02/02"))
two_days <- two_days %>% mutate(datetime = ymd_hms(paste(date, time)))

# Do the plotting
# Plot 1
png(filename = "plot1.png")
with(two_days, hist(as.numeric(global_active_power), col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))
dev.off()