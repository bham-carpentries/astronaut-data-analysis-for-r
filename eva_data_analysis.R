library(jsonlite)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(stringr)

#' Read and Clean EVA Data from JSON
#'
#' This function reads EVA data from a JSON file, cleans it by converting
#' the 'eva' column to numeric, converting data from text to date format,
#. creating a year variable and removing rows with missing values, and sorts
#' the data by the 'date' column.
#'
#' @param input_file A character string specifying the path to the input JSON file.
#'
#' @return A cleaned and sorted data frame containing the EVA data.
#'
read_json_to_dataframe <- function(input_file) {
  print("Reading JSON file")

  eva_df <- fromJSON(input_file, flatten = TRUE) |>
    mutate(eva = as.numeric(eva)) |>
    mutate(date = ymd_hms(date)) |>
    mutate(year = year(date)) |>
    drop_na() |>
    arrange(date)

  return(eva_df)
}

#' Convert Duration from HH:MM Format to Hours
#'
#' This function converts a duration in "HH:MM" format (as a character string)
#' into the total duration in hours (as a numeric value).
#'
#' @details
#' When applied to a vector, it will only process and return the first element
#' so this function must be applied to a data frame rowwise.
#'
#' @param duration A character string representing the duration in "HH:MM" format.
#'
#' @return A numeric value representing the duration in hours.
#'
#' @examples
#' text_to_duration("03:45")  # Returns 3.75 hours
#' text_to_duration("12:30")  # Returns 12.5 hours
text_to_duration <- function(duration) {
  time_parts <- stringr::str_split(duration, ":")[[1]]
  hours <- as.numeric(time_parts[1])
  minutes <- as.numeric(time_parts[2])
  duration_hours <- hours + minutes / 60
  return(duration_hours)
}


# https://data.nasa.gov/resource/eva.json (with modifications)
input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

print("--START--")

# Read the data from a JSON file into a Pandas dataframe
eva_data <- read_json_to_dataframe(input_file)

print("Writing CSV File")
# Save dataframe to CSV file for later analysis
write_csv(eva_data, output_file)

print("Plotting cumulative spacewalk duration and saving to file")
# Plot cumulative time spent in space over years
time_in_space_plot <- eva_data |>
  rowwise() |>
  mutate(duration_hours = text_to_duration(duration)) |>
  ungroup() |>
  # Calculate cumulative time
  mutate(cumulative_time = cumsum(duration_hours)) |>
  ggplot(aes(x = year, y = cumulative_time)) +
  geom_line(color = "black") +
  labs(
    x = "Year",
    y = "Total time spent in space to date (hours)",
    title = "Cumulative Spacewalk Time" ) +
  theme_minimal()

ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
print("--END--")
