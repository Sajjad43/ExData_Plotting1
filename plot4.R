library(inborutils)
library(dplyr)
library(lubridate)



# converting text file to sqlite
sqlite_file <- "household_consumption.sqlite"
tablename <- "power_consumption"
csv_to_sqlite(csv_file ="household_power_consumption.txt",sqlite_file = sqlite_file,table_name = tablename,delim = ";")

#read the sqlite database
my_db <- src_sqlite(sqlite_file, create = FALSE)

# read the table "Power consumption" from the database
power_consumption <- tbl(my_db,"power_consumption")

#filter the row on the basis of date (1/2/2007)
result1 <- power_consumption %>%  filter(Date=="1/2/2007")
result1 <- as.data.frame(result1)

#filter the row on the basis of date (2/2/2007)
result2 <- power_consumption %>%  filter(Date=="2/2/2007")
result2 <- as.data.frame(result2)

#combine the data
data <- rbind(result1,result2)

#convert and combine string Date and numeric Time  into POSIXct
data$Time <- seconds_to_period(data$Time)
data$timeasString<-sprintf('%02d:%02d:%02d',hour(data$Time), minute(data$Time), second(data$Time))
data$Date <- dmy_hms(paste(data$Date,data$timeasString,sep = " "))


# create a png file with plotting
png(filename ="plot4.png",width = 480,height = 480)

#set the panel 
par(mfrow=c(2,2))

plot(data$Date,data$Global_active_power,type = "l",ylab = "Global Active Power",xlab = "")

plot(data$Date,data$Voltage,type = "l",ylab = "Voltage",xlab = "datetime")

plot(data$Date,data$Sub_metering_1,type = "l",ylab = "Energy sub metering",xlab = "")
lines(data$Date,data$Sub_metering_2,type = "l",col="red")
lines(data$Date,data$Sub_metering_3,type = "l",col="blue")
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col = c("black","red","blue"),lty=1)

plot(data$Date,data$Global_reactive_power,type = "l",ylab = "Global_reactive_power",xlab = "datetime")

dev.off()