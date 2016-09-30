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

# Plot 4
png(filename = "plot4.png")
par(mfrow = c(2, 2))
with(two_days, plot(global_active_power ~ datetime, type = "l", xlab = "", ylab = "Global Active Power"))
with(two_days, plot(voltage ~ datetime, type = "l", xlab = "datetime", ylab = "Voltage"))
with(two_days, plot(sub_metering_1 ~ datetime, type = "l", ylab = "Energy sub metering", xlab = ""))
with(two_days, lines(sub_metering_2 ~ datetime, col = "red"))
with(two_days, lines(sub_metering_3 ~ datetime, col = "blue"))
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = 1, lwd = 1, bty = "n")
with(two_days, plot(global_reactive_power ~ datetime, type = "l", xlab = "datetime", ylab = "Global_reactive_power"))
dev.off()