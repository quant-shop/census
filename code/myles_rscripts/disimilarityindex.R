# da maps 2 boogaloo

library(tidycensus)
library(tidyverse)
library(ggplot2)
library(sf)
library(viridis)
library(scales)

census_api_key("f82508cd291cb6c902d7e0558e5d8962e5900ba5")
# 
# vars <- load_variables(2023, dataset = "acs5")
# 
fulton <- get_acs(
    geography = "tract",
    variables = c(black = "B02001_003", # Black/African American population alone
                  total = "B01001_001" # Total population
    ),
    state = "GA",
    county = "Fulton",
    year = 2023,
    geometry = T,
    output = "wide"
  )
# 
# boston_data <- ma_county %>%
#   filter(NAME == "Boston city, Massachusetts")
# ma_county %>% 
#   head()

fulton_income <- get_acs(
  geography = "tract",
  variables = c(income = "B19013_001" # Black/African American population alone
                # total = "B01001_001" # Total population
  ),
  state = "GA",
  county = "Fulton",
  year = 2023,
  geometry = T,
  output = "wide"
)

# mapping black population!
ggplot(fulton_income) +
  geom_sf(aes(fill = incomeE)) +
  scale_fill_viridis_c(option = "magma", 
                       na.value = "grey50",
                       labels = comma) +
  labs(title = "Estimated Median Household Income by Census Tract in Fulton (2023)",
       fill = "Median Household Income") +
  theme_minimal()


# non-black population!
fulton <- fulton %>% 
  mutate(nonblackE = totalE - blackE) %>% 
  select(GEOID, blackE, nonblackE, totalE)

ggplot(fulton) +
  geom_sf(aes(fill = nonblackE)) +
  scale_fill_viridis_c(option = "magma", 
                       na.value = "grey50",
                       labels = comma) +
  labs(title = "Estimated Non-Black Population by Census Tract in Fulton (2023)",
       fill = "Population") +
  theme_minimal()

fulton_black_pop <- get_acs(
  geography = "tract",
  variables = "B02001_003",  # Black alone
  state = "GA",
  county = "Fulton",
  year = 2023,
  geometry = T
) %>%
  rename(estimate_black = estimate)

# We then grab the total population by tract in DC, we will call it

fulton_total_pop <- get_acs(
  geography = "tract",
  variables = "B01003_001",  # total population
  state = "GA",
  county = "Fulton",
  year = 2023,
  geometry = F # note that we have geometry turned off here
) %>%
  rename(estimate_total = estimate)

# combining black population with total population.
fulton_combined <- left_join(fulton_black_pop, fulton_total_pop, by = "GEOID") %>%
  mutate(estimate_nonblack = estimate_total - estimate_black) %>%
  st_as_sf()

# checking combined data with the other estimates.
fulton_combined %>% 
  relocate(GEOID, estimate_total) %>% 
  arrange(desc(estimate_black)) %>% 
  head()

# calculating proportion of Black people in all suffolk tracts.
total_black <- sum(fulton_combined$estimate_black, na.rm = TRUE)
total_nonblack <- sum(fulton_combined$estimate_nonblack, na.rm = TRUE)

fulton_combined <- fulton_combined %>% 
  mutate(proportion_black = estimate_black / estimate_total)

# Now we can view the top 10 tracts with the highest proportion of Black individuals.

fulton_combined %>%
  mutate(proportion_non_black = 1 - proportion_black) %>% 
  arrange(desc(proportion_black)) %>% 
  select(GEOID, proportion_black, proportion_non_black) %>% 
  head(n = 10)

# calculate proportion of tracts that above a certain threshold of Black only individuals.
fulton_combined %>%
  # Count how many tracts have proportion_black >= 0.75
  summarise(
    total_tracts = n(),
    tracts_above_threshold = sum(proportion_black >= 0.75),
    proportion_above_threshold = mean(proportion_black >= 0.75)
  )

# calculate D (lack of even distribution between Black and non-Black residents across the geographical units of a region G)
dissimilarity_ful = 0.5 * sum(abs(
  (fulton_combined$estimate_black / total_black) -
    (fulton_combined$estimate_nonblack / total_nonblack)
), na.rm = TRUE)
# results
dissimilarity_ful

# proportion of black people map
fulton_combined <- st_as_sf(fulton_combined)

ggplot(fulton_combined) +
  geom_sf(aes(fill = proportion_black), color = "white") +
  scale_fill_viridis_c(option = "plasma", direction = -1) +
  labs(title = "Proportion of Black Residents by Census Tract in Fulton",
       fill = "Proportion Black") +
  theme_minimal()

fulton_combined <- fulton_combined %>%
  mutate(majority_black = proportion_black > 0.5)

# Union geometries by group
union_black <- fulton_combined %>%
  filter(majority_black) %>%
  summarise(geometry = st_union(geometry))

union_nonblack <- fulton_combined %>%
  filter(!majority_black) %>%
  summarise(geometry = st_union(geometry))

boundary_line = 
  st_intersection(st_boundary(union_black), st_boundary(union_nonblack))

ggplot() +
  geom_sf(data = fulton_combined, aes(fill = majority_black), 
          color = "grey40", 
          alpha = 0.5) +
  geom_sf(data = boundary_line,
          color = "red",
          size = 1) +
  labs(title = "Majority Black and Non-Black Areas in Fulton County",
       fill = "Majority Black") +
  theme_minimal()

mapview(
  fulton_combined, 
  zcol = "majority_black",
  alpha.regions = 0.15
) +
  mapview(boundary_line, color = "red", size = 1)


