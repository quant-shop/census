
# generating map of black population in SC - focus on largest planatation

install.packages("segregation", repos = "http://cran.us.r-project.org")
library(tidycensus)
library(tidyverse)
library(segregation)
library(tigris)
library(sf)

library(dplyr)

# Get California tract data by race/ethnicity
sc_acs_data <- get_acs(
  geography = "tract",
  variables = c(
    white = "B03002_003",
    black = "B03002_004",
    asian = "B03002_006",
    hispanic = "B03002_012"
  ), 
  state = "SC", # FIPS code is 45
  geometry = TRUE,
  year = 2020
) 

# identify statistics for Georgetown county

df <- sc_acs_data
View(df)
df %>% 
  filter(NAME ~ "Georgetown")

# we want to filter the data so that we can generate a map of 
# Georgetown and then use that to discuss the region around the plantation


sc_urban_data %>%
  filter(variable %in% c("white", "hispanic")) %>%
  group_by(urban_name) %>%
  group_modify(~
                 dissimilarity(.x,
                               group = "variable",
                               unit = "GEOID",
                               weight = "estimate"
                 )
  ) %>% 
  arrange(desc(est))

mutual_within(
  data = ca_urban_data,
  group = "variable",
  unit = "GEOID",
  weight = "estimate",
  within = "urban_name",
  wide = TRUE
)


# joshua john ward owned the largest number of slaves prior to his death in 1853

# filter out Census tract for the plantation
georgetown_race_estimate <- df %>% 
  filter(NAME == "Census Tract 9205.02, Georgetown County, South Carolina")
georgetown

df %>%
  as_tibble() %>% 
  mutate(as.numeric(df$estimate)) %>% 
  sum(df$estimate)

sc_local_seg <- df %>%
  filter(NAME == "Census Tract 9205.10, Georgetown County, South Carolina") %>%
  mutual_local(
    group = "variable",
    unit = "GEOID",
    weight = "estimate", 
    wide = TRUE
  )

# create LA tracts to compute dissimilarity matrix
sc_tracts_seg <- tracts("SC", cb = TRUE, year = 2020) %>%
  inner_join(sc_local_seg, by = "GEOID") 

la_tracts_seg %>%
  ggplot(aes(fill = ls)) + 
  geom_sf(color = NA) + 
  coord_sf(crs = 26946) + 
  scale_fill_viridis_c(option = "inferno") + 
  theme_void() + 
  labs(fill = "Local\nsegregation index")




