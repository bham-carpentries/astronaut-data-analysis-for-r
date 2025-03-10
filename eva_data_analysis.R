library(jsonlite)
library(ggplot2)
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(stringr)

input_file <- "eva-data.json"
output_file <- "eva-data.csv"
graph_file <- "cumulative_eva_graph.png"

eva_data <- fromJSON(input_file, flatten = TRUE) %>%
 mutate(eva = as.numeric(eva)) %>%
 mutate(date = ymd_hms(date)) %>%
 drop_na() %>%
 arrange(date) %>%
 mutate(year = year(date))

write_csv(eva_data, output_file)

time_in_space_plot <- eva_data %>%
  rowwise() %>%
  mutate(duration_hours =
                  sum(as.numeric(str_split_1(duration, "\\:"))/c(1, 60))
  ) %>%
  ungroup() %>%
  mutate(cumulative_time = cumsum(duration_hours)) %>%
  ggplot(aes(x = year, y = cumulative_time)) +
  geom_line(color = "black") +
  labs(
    x = "Year",
    y = "Total time spent in space to date (hours)",
    title = "Cumulative Spacewalk Time" ) +
  theme_minimal()

ggsave(graph_file, width = 8, height = 6, plot = time_in_space_plot)
