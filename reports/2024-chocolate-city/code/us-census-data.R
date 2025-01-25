# ACCESSING US CENSUS DATA

# prior to beginning, you must get an individualized census API key
# request a key here: https://api.census.gov/data/key_signup.html

# install packages
install.packages("tidycensus") # tidy census package for efficient access
install.packages("tmap")

# load libraries
library(tmap)
library(tidyverse)
library(tidycensus)
library(sf)

# spatial data in tidy census
# http://walker-data.com/umich-workshop/census-data-in-r/slides/#1 
# https://walker-data.com/tidycensus/articles/spatial-data.html

# census: state, country, tract, zipcode

# suggestion function
load_variables(2020, "acs5")



data_acs5_2020 <- load_variables(2020, "acs5")
data_acs5_2015 <- load_variables(2015, "acs5")
data_acs1_2021 <- load_variables(2021, "acs1")

View(data_acs1_2021)


data_acs5_2020 %>% 
  filter(grepl('POPULATION', concept)) %>% 
  filter(grepl('WHITE', concept)) %>% 
  filter(grepl('NAME', concept)) %>% 
  filter(grepl('NAME', concept))


# population under 18 years of age in acs1 
children_0_18_acs1 <- get_acs(geography = "state",
                             variables = "B19013B_001",
                             year = 2020)

# data collected for years: 2013 - 2021
# population under 18 years of age in acs5

data_acs5_2020 %>% filter(grepl('SEX|AGE.', concept))

head(blackmedianincome)




# this command gives us a list of variable name
data$name

# this command gives us a list of variable labels
data$label


# centennial use pl
# american community survey acs

# install packages
install.packages("terra")

# initialize your API key
census_api_key("c7d784a095f768d468c885b95e86ab2c1b54b17e", install = TRUE)

# get_acs(): is used to pull data from the American Community Survey (ACS)
# get_decennial(): is used to pull data from the Decennial Census

# explore cities and towns with a population of 5,000 or more
# confirm findings and code with QuickFacts https://www.census.gov/quickfacts prior to further analysis

# 2020 Decennial Census Variables
decennial_2020_vars <- load_variables(
  year = 2020, 
  "pl", 
  cache = TRUE
)# 2010 Decennial Census Variables
decennial_2010_vars <- load_variables(
  year = 2010, 
  "pl", 
  cache = TRUE
)

# 2016 - 2020 5 Year American Community Survey (ACS) Variables
acs_20_vars = load_variables(
  year = 2020, 
  "acs5",
  cache = TRUE
)

View(df)


blackmedianincome <- get_acs(geography = "state",
                             variables = "B19013B_001",
                             year = 2020)
head(blackmedianincome)

desired_vars = c(
  all = "P2_001N",
  hisp = "P2_002N",
  white = "P2_005N",
  baa = "P2_006N",
  amin = "P2_007N",
  asian = "P2_008N",
  nhopi = "P2_009N",
  other = "P2_010N",
  multi = "P2_011N"
)


## AA P1_004N 

black_2020 <- get_decennial(geography = "state",
                            variable = "P1_004N",
                            county = "Fulton",
                             geometry = T,
                             year = 2020)
head(black_2020)

black_2020 %>%
  ggplot(aes(fill = estimate)) +
  geom_sf(color = NA) +
  scale_fill_viridis_c(option = "magma")
  
atlanta %>%
  ggplot(aes(fill = estimate)) + 
  geom_sf(color = NA) + 
  scale_fill_viridis_c(option = "magma") 

census_data = get_decennial(
  geography = "county",
  state = "NC",
  variables = desired_vars, #<---- here is where I am using the list
  summary_var = "P2_001N",# <--- creates a column w/'total' variable
  year = 2020,
  sumfile = "pl"
)


reth_NY_20 = get_decennial(
  geography = "county",
  state = "NY",
  variables = desired_vars,
  summary_var = "P2_001N", # Same as 'All'
  year = 2020
)

# Income Data by County for North Carolina
nc_county_income = get_acs(
  geography = "county",
  state = "NC",
  table = "B19001")## Note that leaving the 'year' argument blank 
# tells the API to return the most recent year available. 
# As of writing this, that is 2020 for both the ACS and Decennial Census.


# Get data set with geometry set to TRUE
# mean housing value
median_housing_value <- get_acs(geography = "tract", state = "GA", 
                        county = "Fulton", 
                        variable = "B25077_001", # median housing value
                        geometry = TRUE)

# Plot the estimate to view a map of the data
plot(median_housing_value["estimate"])




# Get dataset with geometry set to TRUE
# B02009. Black or African American Alone or in Combination with One or More Other Races
# https://www.socialexplorer.com/data/ACS2014/metadata/?ds=ACS14&table=B02009
black <- get_acs(geography = "tract", state = "GA", 
                                county = "Fulton", 
                                variable = "B02009_001", # Black or AA alone or in combination with one or more races
                                geometry = TRUE)
# check social explorer data


black_fulton_ga <- get_acs(geography = "tract", state = "GA", 
                 county = "Fulton", 
                 variable = "B02001_003", # Black or AA alone or in combination with one or more races
                 geometry = TRUE)

# Plot the estimate to view a map of the data
plot(black_fulton_ga["estimate"])


# Get dataset with geometry set to TRUE
# B02003. 	Detailed Race 
# B02003004 Black or African American Alone
# https://www.socialexplorer.com/data/ACS2014/metadata/?ds=ACS14&table=B02003
white_fulton <- get_acs(geography = "tract", state = "13", # State/FIPS code: 13
                 county = "Fulton", # County/FIPS code: 121
                 variable = "B02008_001", # Black or African American Alone
                 geometry = TRUE)

# Plot the estimate to view a map of the data
plot(white_fulton["estimate"])





Var<-c("B19013_001","B25077_001")
## c(Median household Income, Median Housing Value)
ca_df <- get_acs(geography = "county",
                 variables = Var,
                 year = 2020,
                 survey = "acs5",
                 state = "13", # FIPS code 13 for state GA
                 geometry = TRUE) 

plot(ca_df)
                 
                 
                 
                 
## Dissimilarity index in R
# https://search.r-project.org/CRAN/refmans/segregation/html/dissimilarity.html
# Returns the total segregation between group and unit using the Index of Dissimilarity.        

install.packages("seg")
install.packages("dissimiarity")
install.packages("Matrix")
# Example where D and H deviate
m1 <- matrix_to_long(matrix(c(100, 60, 40, 0, 0, 40, 60, 100), ncol = 2))
m2 <- matrix_to_long(matrix(c(80, 80, 20, 20, 20, 20, 80, 80), ncol = 2))
dissimilarity(m1, "group", "unit", weight = "n")
dissimilarity(m2, "group", "unit", weight = "n")




# Variables of interest: White, Black, Asian, Hispanic
race_vars = c("B03002_003", "B03002_004", "B03002_006", "B03002_012")

sfStates = get_acs(
  geography = "state", variables = race_vars, year = 2017, 
  output = "wide", geometry = TRUE
)
sfStates = select(sfStates, state = GEOID, name = NAME, white = B03002_003E, 
                  black = B03002_004E, asian = B03002_006E, hispanic = B03002_012E)
dfTracts = get_acs(
  geography = "tract", vwhite_fulton <- get_acs(geography = "tract", state = "GA", # State/FIPS code: 13
ariables = race_vars, year = 2017, 
  output = "wide", state = sfStates$state
)
dfTracts = transmute(
  dfTracts, state = substr(GEOID, 1, 2), tract = GEOID, 
  name = NAME, white = B03002_003E, black = B03002_004E, asian = B03002_006E, 
  hispanic = B03002_012E
)


white_fulton <- get_acs(geography = "tract", state = "GA", # State/FIPS code: 13,
                         county = "Fulton", # County/FIPS code: 001
                         variable = "B02008_001", # Black or African American Alone
                         geometry = TRUE)
plot(white_fulton["estimate"])


black_pop <- get_ac(geography = "tract", state = "NC", # State/FIPS code: 13,
                    county = )






v20 <- load_variables(2020, "pl", cache = T)
View(v20)
head(v20, 7)
