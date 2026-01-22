
## Sample code file with annotations

# Load necessary libraries
library(tidyverse)
library(ggplot2)
library(readxl)
library(maps)

## Data import and cleaning

# Import census data
census_data <- read_excel("census_history.xlsx")

# Clean and preprocess data
clean_census_data <- census_data %>%
  mutate(year = as.numeric(year)) %>%
  filter(!is.na(population)) %>%
  arrange(year, state)

## Exploratory

# Summary statistics
summary_stats <- clean_census_data %>%
  group_by(year) %>%
  summarize(
    total_population = sum(population),
    avg_population = mean(population),
    median_population = median(population)
  )

# Visualize population growth over time
ggplot(summary_stats, aes(x = year, y = total_population)) +
  geom_line() +
  labs(title = "US Population Growth Over Time",
       x = "Year", y = "Total Population")

## State-level

# Calculate population change for each state
state_change <- clean_census_data %>%
  group_by(state) %>%
  summarize(
    pop_1800 = population[year == 1800],
    pop_2020 = population[year == 2020],
    percent_change = (pop_2020 - pop_1800) / pop_1800 * 100
  )

# Visualize state-level population change
us_map <- map_data("state")
state_map <- left_join(us_map, state_change, by = c("region" = "state"))

ggplot(state_map, aes(long, lat, group = group, fill = percent_change)) +
  geom_polygon(color = "white") +
  scale_fill_viridis_c() +
  labs(title = "Population Change by State (1800-2020)",
       fill = "Percent Change")

## Demographic shifts

# Analyze demographic shifts (if data available)
demographic_trends <- clean_census_data %>%
  group_by(year) %>%
  summarize(
    percent_urban = sum(urban_population) / sum(population) * 100,
    percent_rural = 100 - percent_urban
  )

# Visualize urban vs. rural population trends
ggplot(demographic_trends, aes(x = year)) +
  geom_line(aes(y = percent_urban, color = "Urban")) +
  geom_line(aes(y = percent_rural, color = "Rural")) +
  labs(title = "Urban vs. Rural Population Trends",
       x = "Year", y = "Percentage", color = "Population Type")

## Analysis

# Perform regression analysis
population_model <- lm(population ~ year + region, data = clean_census_data)
summary(population_model)

# Predict future population (example for 2030)
new_data <- data.frame(year = 2030, region = unique(clean_census_data$region))
predictions_2030 <- predict(population_model, newdata = new_data)

## Export

# Save processed data and results
write_csv(clean_census_data, "processed_census_data.csv")
saveRDS(population_model, "population_model.rds")

# Generate report using R Markdown
# (Create a separate .Rmd file for the report)

