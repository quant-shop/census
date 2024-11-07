# 2020 acs5 US Census data via tidycensus

# prior to beginning, you must get an individualized census API key
# request a key here: https://api.census.gov/data/key_signup.html

# resources
# http://walker-data.com/umich-workshop/census-data-in-r/slides/#1 
# https://walker-data.com/tidycensus/articles/spatial-data.html

# packages/libraries
install.packages("tidycensus")
install.packages("tmap")

library(tmap)
library(tidyverse)
library(tidycensus)
library(sf)

# variable list
data_acs5_2020 <- load_variables(2020, "acs5")
View(data_acs5_2020)

# load estimates for Black population by county and state

# tracts in counties
black_fulton_ga <- get_acs(geography = "tract", 
                           state = "GA", 
                           county = "Fulton", 
                           variable = "B02001_003", # Black or AA alone or in combination with one or more races
                           geometry = TRUE)
plot(black_fulton_ga)

# counties in state
ga_black_county_2020 <- get_acs(geography = "county",
                                variables = "B02001_003",
                                year = 2020,
                                survey = "acs5",
                                state = "13", # FIPS code 13 for state GA
                                geometry = TRUE) 

plot(ga_black_county_2020)
