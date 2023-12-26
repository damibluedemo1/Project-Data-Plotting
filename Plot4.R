# plot4.R
# Constructing plot4.png


# Set the URL for the dataset
fileurl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download the dataset and extract it to the current working directory
download.file(fileurl,destfile=paste0(getwd(),"/Power_consumption.zip"),method = "curl")
unzip("Power_consumption.zip",exdir="./")

# Read the first 5 rows of the dataset to get column names and initial insights
initial<-read.table("household_power_consumption.txt", header=TRUE,sep=";", nrows=5)

# Read a subset of the dataset with specific column types and skip unnecessary rows
hpc<-read.table("household_power_consumption.txt", header=TRUE,sep=";", skip=66630, 
                nrows=2900, col.names=names(initial), na.strings=c("?"),
                colClasses=c("character", "character","numeric","numeric","numeric","numeric",
                             "numeric","numeric","numeric"))

# Convert Date and Time columns to Date and POSIXct formats
hpc$Date<-as.Date(hpc$Date, format = "%d/%m/%Y")
hpc$Time<-strptime(paste(hpc$Date,hpc$Time),"%F %T")

# Subset the data for a specific date range (February 1 and 2, 2007)
hpc<-subset(hpc,hpc$Date %in% as.Date(c("2007-02-01","2007-02-02")))

# Set up the plot parameters and create a 2x2 layout for multiple plots
par(mfcol=c(2,2), mar=c(4.5,5,2,2))

# Plot 4.1: Global Active Power over Time
plot(hpc$Time,hpc$Global_active_power, ylab="Global Active Power (kilowatts)", 
     xlab="", pch =".", type="l")

# Plot 4.2: Energy Sub Metering over Time
plot(hpc$Time,hpc$Sub_metering_1,ylab="Energy sub metering", xlab="", type="l", col="black")
points(hpc$Time,hpc$Sub_metering_2, col="red", type="l")
points(hpc$Time,hpc$Sub_metering_3, col="blue", type="l")
# Add legend to the top-right corner
legend("topright", lwd=1, col=c("black", "red", "blue"), legend=names(hpc[,7:9]), bty="n")

# Plot 4.3: Voltage over Time
plot(hpc$Time,hpc$Voltage, ylab="Voltage", xlab="datetime", type="l")

# Plot 4.4: Global Reactive Power over Time
plot(hpc$Time,hpc$Global_reactive_power, ylab="Global_reactive_power", xlab="datetime", type="l")

# Save the combined plot as a PNG file with specified dimensions
png("plot4.png", width=480, height=480)