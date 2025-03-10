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
  time_parts <- str_split(duration, ":")[[1]]
  hours <- as.numeric(time_parts[1])
  minutes <- as.numeric(time_parts[2])
  duration_hours <- hours + minutes / 60
  return(duration_hours)
}

#' Plot Cumulative Time in Space Over the Years
#'
#' This function plots the cumulative time spent in space over the years based on
#' the data in the dataframe. The cumulative time is calculated by converting the
#' "duration" column into hours, then computing the cumulative sum of the duration.
#' The plot is saved as a PNG file at the specified location.
#'
#' @param tdf A dataframe containing a "duration" column in "HH:MM" format and a "date" column.
#' @param graph_file A character string specifying the path to save the graph.
#'
#' @return NULL
plot_cumulative_time_in_space <- function(tdf, graph_file) {

  time_in_space_plot <- tdf |>
    rowwise() |>
    mutate(duration_hours = text_to_duration(duration)) |>  # Add duration_hours column
    ungroup() |>
    mutate(cumulative_time = cumsum(duration_hours)) |>     # Calculate cumulative time
    ggplot(aes(x = date, y = cumulative_time)) +
    geom_line(color = "black") +
    labs(
      x = "Year",
      y = "Total time spent in space to date (hours)",
      title = "Cumulative Spacewalk Time"
    )

  ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
}
