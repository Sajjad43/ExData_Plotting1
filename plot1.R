library(inborutils)
library(dplyr)



#converting text file to sqlite
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

# create a png file with plotting
png(filename ="plot1.png",width = 480,height = 480 )
hist(data$Global_active_power,col = "red",main = "Global Active Power",xlab = "Global Active Power(kilowatts)",ylab = "Frequency")
dev.off()

