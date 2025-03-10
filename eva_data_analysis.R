library(jsonlite)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(stringr)

# https://data.nasa.gov/resource/eva.json (with modifications)
input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

print("--START--")
print("Reading JSON file")

# Read the data from a JSON file into a Pandas dataframe
eva_data <- fromJSON(input_file, flatten = TRUE) |>
 mutate(eva = as.numeric(eva)) |>
 mutate(date = ymd_hms(date)) |>
 mutate(year = year(date)) |>
 drop_na() |>
 arrange(date)


print("Saving to CSV file")
# Save dataframe to CSV file for later analysis
write_csv(eva_data, output_file)

print("Plotting cumulative spacewalk duration and saving to file")
# Plot cumulative time spent in space over years
time_in_space_plot <- eva_data |>
  rowwise() |>
  mutate(duration_hours =
                  sum(as.numeric(str_split_1(duration, "\\:"))/c(1, 60))
  ) |>
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
