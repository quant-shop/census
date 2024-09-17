# ACCESSING US CENSUS DATA

# prior to beginning, you must get an individualized census API key
# request a key here: https://api.census.gov/data/key_signup.html

# set up an environment variable to hold your census api key
usethis::edit_r_environ()

# transfer information into your `.Renviron`
CENSUS_API_KEY="a876b48cdd106e0c2ce01a0ce6e5735eab0f3ac7"

# insert your census API key
Sys.getenv(CENSUS_API_KEY)

# run your api key
census_api_key(CENSUS_API_KEY)

# install packages
install.packages("tidycensus")

# load tidycensus package
library(tidycensus)

# check access
## load variable lists from the American Community Survey (ACS) 5-year estimates files
load_variables(2021, "acs5")
load_variables(2020, "acs5")
load_variables(2019, "acs5")
load_variables(2018, "acs5")
load_variables(2017, "acs5")
load_variables(2016, "acs5")
load_variables(2015, "acs5")
load_variables(2014, "acs5")
load_variables(2013, "acs5")