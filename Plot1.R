# plot1.R
# Constructing plot1.png

# Function to download and extract data
download_and_extract_data <- function(url, zip_file, dest_folder) {
  tryCatch(
    {
      download.file(url, destfile = zip_file, method = "curl")
      unzip(zip_file, exdir = dest_folder)
    },
    error = function(e) {
      cat("Error during download and extraction:", conditionMessage(e), "\n")
    }
  )
}

# Function to read the data
read_power_consumption_data <- function(file_path, skip_rows, nrows) {
  tryCatch(
    {
      initial <- read.table(file_path, header = TRUE, sep = ";", nrows = 5)
      hpc <- read.table(file_path, header = TRUE, sep = ";", skip = skip_rows,
                        nrows = nrows, col.names = names(initial), na.strings = c("?"),
                        colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric",
                                       "numeric", "numeric", "numeric"))
      hpc$Date <- as.Date(hpc$Date, format = "%d/%m/%Y")
      hpc$Time <- strptime(paste(hpc$Date, hpc$Time), "%F %T")
      return(hpc)
    },
    error = function(e) {
      cat("Error during data reading:", conditionMessage(e), "\n")
      return(NULL)
    }
  )
}

# Function to plot and save histogram
plot_and_save_histogram <- function(data, column, color, title, xlabel, filename) {
  hist(data[[column]], col = color, main = title, xlab = xlabel)
  png(filename, width = 480, height = 480)
  dev.off()
}

# Download and extract data
fileurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zip_file <- "Power_consumption.zip"
dest_folder <- "./"
download_and_extract_data(fileurl, zip_file, dest_folder)

# Read data
hpc <- read_power_consumption_data("household_power_consumption.txt", skip_rows = 66630, nrows = 2900)

if (!is.null(hpc)) {
  # Plot and save histogram
  plot_and_save_histogram(hpc, "Global_active_power", "red", "Global Active Power", "Global Active Power (kilowatts)", "plot1.png")
}