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
#' @export
read_json_to_dataframe <- function(input_file) {
  print("Reading JSON file")

  eva_df <- jsonlite::fromJSON(input_file, flatten = TRUE) |>
    dplyr::mutate(eva = as.numeric(eva)) |>
    dplyr::mutate(date = lubridate::ymd_hms(date)) |>
    dplyr::mutate(year = lubridate::year(date)) |>
    tidyr::drop_na() |>
    dplyr::arrange(date)

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
#' @export
text_to_duration <- function(duration) {
  time_parts <- stringr::str_split(duration, ":")[[1]]
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
#' @export
plot_cumulative_time_in_space <- function(tdf, graph_file) {

  time_in_space_plot <- tdf |>
    dplyr::rowwise() |>
    dplyr::mutate(duration_hours = text_to_duration(duration)) |>  # Add duration_hours column
    dplyr::ungroup() |>
    dplyr::mutate(cumulative_time = cumsum(duration_hours)) |>     # Calculate cumulative time
    ggplot2::ggplot(ggplot2::aes(x = date, y = cumulative_time)) +
    ggplot2::geom_line(color = "black") +
    ggplot2::labs(
      x = "Year",
      y = "Total time spent in space to date (hours)",
      title = "Cumulative Spacewalk Time"
    )

  ggplot2::ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)

}
