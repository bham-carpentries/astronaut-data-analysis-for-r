library(spacewalks2)
library(dplyr)
library(readr)

run_analysis <- function(input_file, output_file, graph_file) {
  print("--START--\n")

  eva_data <- read_json_to_dataframe(input_file)
  write_csv(eva_data, output_file)
  plot_cumulative_time_in_space(eva_data, graph_file)

  print("--END--\n")
}


input_file <- 'analysis/data/raw_data/eva-data.json'
output_file <- 'analysis/data/derived_data/eva-data.csv'
graph_file <- 'analysis/figures/cumulative_eva_graph.png'
run_analysis(input_file, output_file, graph_file)
