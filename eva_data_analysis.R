library(jsonlite)
library(ggplot2)

# https://data.nasa.gov/resource/eva.json (with modifications)
# File paths
input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

fieldnames <- c("eva", "country", "crew", "vehicle", "date", "duration", "purpose")

data <- list()
data_raw <- readLines(input_file, warn = FALSE)

# 374
for (i in 1:374) {
  line <- data_raw[i]
  print(line)
  data[[i]] <- fromJSON(substr(line, 2, nchar(line)))
}

# Initialize empty vectors
time <- c()
dates <- c()
years <- c()

j <- 1
w <- 0
for (i in data) {  # Iterate manually

  if ("duration" %in% names(data[[j]])) {
    time_text <- data[[j]]$duration

    if (time_text == "") {
      # Do nothing if empty
    } else {
      t_parts <- strsplit(time_text, ":")[[1]]
      t_hours <- as.numeric(t_parts[1]) + as.numeric(t_parts[2]) / 60  # Convert to hours
      print(t_hours)
      time <- c(time, t_hours)

      if (("date" %in% names(data[[j]]) & ("eva" %in% names(data[[j]])))) {
        date <- as.Date(substr(data[[j]]$date, 1, 10), format = "%Y-%m-%d")
        year <- as.numeric(format(date,"%Y"))
        dates <- c(dates, date)
        years <- c(years, year)
        row_data <- as.data.frame(data[[j]])
      } else {
        time <- time[-1]
      }
    }
  }

  ## Comment out this bit if you don't want the spreadsheet
  if (exists("row_data")) {
    print(row_data)
    if (w==0) {
      write.table(row_data, output_file, sep = ",", row.names = FALSE, col.names = TRUE, append = FALSE)
    } else {
      write.table(row_data, output_file, sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE)
    }
    w <- w+1
    rm(row_data)
  }

  j <- j + 1
}

if (!exists("cumulative_time")) {cumulative_time <- c(0)}

for (k in time) {
  cumulative_time <- c(cumulative_time, cumulative_time[length(cumulative_time)] + k)
}

sorted_indices <- order(dates)
years <- years[sorted_indices]
time <- time[sorted_indices]

# Print total time in space
print(cumulative_time[length(cumulative_time)])

tdf <- data.frame(
  years = years,
  cumulative_time = cumulative_time[-1]
)


# Plot the data
ggplot(tdf, aes(x = years, y = cumulative_time)) + geom_line(color = "black") + geom_point(color = "black") +
  labs( x = "Year", y = "Total time spent in space to date (hours)", title = "Cumulative Spacewalk Time" ) + theme_minimal()

# Correction for repeatability
cumulative_time <- c(0)

# Save plot
ggsave(graph_file, width = 8, height = 6)

