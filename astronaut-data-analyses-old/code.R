# File paths
data_f <- "data.json"
data_t <- "data.csv"

g_file <- "myplot.png"

fieldnames <- c("eva", "country", "crew", "vehicle", "date", "duration", "purpose")

data <- list()
data_raw <- readLines(data_f, warn = FALSE)  # Read raw JSON lines

# 374
library(jsonlite)
for (i in 1:374) {  # Hardcoded loop like in Python
  line <- data_raw[i]
  print(line)
  data[[i]] <- fromJSON(substr(line, 2, nchar(line)))  # Remove brackets
}

# Initialize empty vectors
time <- c()
dates <- c()
years <- c()

j <- 1
w <- 0
for (i in data) {  # Iterate manually

  if ("duration" %in% names(data[[j]])) {
    tt <- data[[j]]$duration

    if (tt == "") {
      # Do nothing if empty
    } else {
      t_parts <- strsplit(tt, ":")[[1]]
      ttt <- as.numeric(t_parts[1]) + as.numeric(t_parts[2]) / 60  # Convert to hours
      print(ttt)
      time <- c(time, ttt)

      if ("date" %in% names(data[[j]])) {
        date <- as.Date(substr(data[[j]]$date, 1, 10), format = "%Y-%m-%d")
        year <- as.numeric(format(date,"%Y"))
        dates <- c(dates, date)
        years <- c(years, year)
        row_data <- as.data.frame(data[[j]])
      } else {
        time <- time[-1]  # Remove last element if date is missing
      }
    }
  }

  if (exists("row_data")) {
    print(row_data)
    if (w==0) {
      write.table(row_data, data_t, sep = ",", row.names = FALSE, col.names = TRUE, append = FALSE)
    } else {
      # Append new row without column names
      write.table(row_data, data_t, sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE)
    }
    w <- w+1
    rm(row_data)
  }

  j <- j + 1
}

if (!exists("ct")) {ct <- c(0)}

for (k in time) {  # Keep the same manual accumulation loop
  ct <- c(ct, ct[length(ct)] + k)
}

sorted_indices <- order(dates)
years <- years[sorted_indices]
time <- time[sorted_indices]


# target 322354.15
print(sum(ct))

tdf <- data.frame(
  years = years,
  ct = ct[-1]
)

# Plot the data
library(ggplot2)
ggplot(tdf, aes(x = years, y = ct)) + geom_line(color = "black") + geom_point(color = "black") +
  labs( x = "Year", y = "Total time spent in space to date (hours)", title = "Cumulative Spacewalk Time Over Time" ) + theme_minimal() ; ct <- c(100)

# Save plot
ggsave(g_file, width = 8, height = 6)

