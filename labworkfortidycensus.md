labwork_tidycensus
================
Bayowa
2024-11-13

# Block to get city details using city codes,variables, data year

``` r
# Load necessary libraries
library(tidycensus)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
# Set your Census API key
census_api_key("e06a3ef2522b01fbf59f0fb986f724a11ed67dd2", overwrite = TRUE)
```

    ## To install your API key for use in future sessions, run this function with `install = TRUE`.

``` r
# Define a helper function to handle state abbreviations, full names, and FIPS codes
get_state_fips <- function(input_states) {
  # Data frame of state names, abbreviations, and FIPS codes
  state_info <- data.frame(
    state_name = c(state.name, "District of Columbia"),
    state_abb = c(state.abb, "DC"),
    fips_code = sprintf("%02d", c(1:51)) # FIPS codes 01 to 51
  )
  
  # Identify if input is FIPS, abbreviation, or full name, and return FIPS code
  fips_codes <- sapply(input_states, function(state) {
    if (state %in% state_info$fips_code) {
      return(state)  # Already a FIPS code
    } else if (state %in% state_info$state_abb) {
      return(state_info$fips_code[state_info$state_abb == state])
    } else if (state %in% state_info$state_name) {
      return(state_info$fips_code[state_info$state_name == state])
    } else {
      stop("Invalid state input: ", state)
    }
  })
  
  return(fips_codes)
}

# Define the states you're interested in, using FIPS codes, abbreviations, or full names
input_states <- c("36", "SC", "Virginia", "48") # Example FIPS, abbreviation, and full name

# Convert input to FIPS codes
fips_states <- get_state_fips(input_states)

# Define the range of years, e.g., 2010 to 2022
years <- 2010:2022

# Initialize an empty dataframe to store results
black_data <- data.frame()

# Loop through each year and get the ACS data for Black median income and Black median age
for (year in years) {
  
  # Skip the year 2020
  if (year == 2020) {
    next  # Skip this iteration of the loop
  }
  
  # Get median household income for Black population
  income_data <- get_acs(geography = "state", 
                         variables = "B19013B_001",  # Median household income for Black
                         state = fips_states, 
                         year = year, 
                         survey = "acs1")  # 1-year estimates for each year
  
  # Add the 'year' column to income data
  income_data <- income_data %>%
    mutate(year = year)  # Add the current year to the dataset
  
  # Get median age for Black population
  age_data <- get_acs(geography = "state", 
                      variables = "B01002B_001",  # Median age for Black
                      state = fips_states, 
                      year = year, 
                      survey = "acs1")
  
  # Add the 'year' column to age data
  age_data <- age_data %>%
    mutate(year = year)  # Add the current year to the dataset
  
  # Combine both datasets for that year
  combined_data <- income_data %>%
    rename(median_income = estimate) %>%
    left_join(age_data %>% rename(median_age = estimate), by = c("GEOID", "NAME", "year"))
  
  # Add the combined data to the overall dataframe
  black_data <- bind_rows(black_data, combined_data)
}
```

    ## Getting data from the 2010 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2010 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2011 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2011 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2012 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2012 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2013 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2013 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2014 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2014 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2015 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2015 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2016 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2016 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2017 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2017 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2018 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2018 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2019 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2019 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2021 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2021 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2022 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

    ## Getting data from the 2022 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

``` r
# View the resulting dataset with all the required years' data
black_data
```

    ##    GEOID         NAME  variable.x median_income moe.x year  variable.y
    ## 1     36     New York B19013B_001         39890   828 2010 B01002B_001
    ## 2     40     Oklahoma B19013B_001         30221  1729 2010 B01002B_001
    ## 3     46 South Dakota B19013B_001         32389 10139 2010 B01002B_001
    ## 4     48        Texas B19013B_001         35640   723 2010 B01002B_001
    ## 5     36     New York B19013B_001         38572  1105 2011 B01002B_001
    ## 6     40     Oklahoma B19013B_001         27847  1803 2011 B01002B_001
    ## 7     46 South Dakota B19013B_001         26218  9803 2011 B01002B_001
    ## 8     48        Texas B19013B_001         35757   746 2011 B01002B_001
    ## 9     36     New York B19013B_001         40955   536 2012 B01002B_001
    ## 10    40     Oklahoma B19013B_001         30005  1596 2012 B01002B_001
    ## 11    46 South Dakota B19013B_001         31111 11770 2012 B01002B_001
    ## 12    48        Texas B19013B_001         37018   582 2012 B01002B_001
    ## 13    36     New York B19013B_001         40522   754 2013 B01002B_001
    ## 14    40     Oklahoma B19013B_001         30043  1799 2013 B01002B_001
    ## 15    46 South Dakota B19013B_001         40083 14418 2013 B01002B_001
    ## 16    48        Texas B19013B_001         37608   756 2013 B01002B_001
    ## 17    36     New York B19013B_001         40912   612 2014 B01002B_001
    ## 18    40     Oklahoma B19013B_001         30003  1454 2014 B01002B_001
    ## 19    46 South Dakota B19013B_001         37242 11457 2014 B01002B_001
    ## 20    48        Texas B19013B_001         39280   968 2014 B01002B_001
    ## 21    36     New York B19013B_001         42652  1253 2015 B01002B_001
    ## 22    40     Oklahoma B19013B_001         31438  1551 2015 B01002B_001
    ## 23    46 South Dakota B19013B_001         22399 10020 2015 B01002B_001
    ## 24    48        Texas B19013B_001         40812   534 2015 B01002B_001
    ## 25    36     New York B19013B_001         45277  1077 2016 B01002B_001
    ## 26    40     Oklahoma B19013B_001         30923  1334 2016 B01002B_001
    ## 27    46 South Dakota B19013B_001         42844 10586 2016 B01002B_001
    ## 28    48        Texas B19013B_001         42582   880 2016 B01002B_001
    ## 29    36     New York B19013B_001         44933  1190 2017 B01002B_001
    ## 30    40     Oklahoma B19013B_001         33464  2281 2017 B01002B_001
    ## 31    46 South Dakota B19013B_001         27054  8964 2017 B01002B_001
    ## 32    48        Texas B19013B_001         45092  1173 2017 B01002B_001
    ## 33    36     New York B19013B_001         48347  1330 2018 B01002B_001
    ## 34    40     Oklahoma B19013B_001         35887  1526 2018 B01002B_001
    ## 35    46 South Dakota B19013B_001         43686 14589 2018 B01002B_001
    ## 36    48        Texas B19013B_001         45545   849 2018 B01002B_001
    ## 37    36     New York B19013B_001         51146   836 2019 B01002B_001
    ## 38    40     Oklahoma B19013B_001         36234  1948 2019 B01002B_001
    ## 39    46 South Dakota B19013B_001         52246  3962 2019 B01002B_001
    ## 40    48        Texas B19013B_001         47428  1001 2019 B01002B_001
    ## 41    36     New York B19013B_001         54443  1643 2021 B01002B_001
    ## 42    40     Oklahoma B19013B_001         39099  2479 2021 B01002B_001
    ## 43    46 South Dakota B19013B_001         39986 28868 2021 B01002B_001
    ## 44    48        Texas B19013B_001         49767  1172 2021 B01002B_001
    ## 45    36     New York B19013B_001         57898  2016 2022 B01002B_001
    ## 46    40     Oklahoma B19013B_001         41135  1424 2022 B01002B_001
    ## 47    46 South Dakota B19013B_001         65453 14510 2022 B01002B_001
    ## 48    48        Texas B19013B_001         55759  1273 2022 B01002B_001
    ##    median_age moe.y
    ## 1        34.5   0.3
    ## 2        31.0   0.7
    ## 3        24.7   5.1
    ## 4        31.7   0.2
    ## 5        34.7   0.2
    ## 6        30.8   0.6
    ## 7        25.0   2.7
    ## 8        32.1   0.3
    ## 9        34.9   0.2
    ## 10       32.1   0.4
    ## 11       23.4   3.3
    ## 12       32.1   0.2
    ## 13       35.0   0.2
    ## 14       31.1   0.6
    ## 15       23.3   5.8
    ## 16       32.4   0.2
    ## 17       35.2   0.2
    ## 18       31.0   0.5
    ## 19       22.5   3.1
    ## 20       32.7   0.2
    ## 21       35.4   0.2
    ## 22       32.5   0.6
    ## 23       27.5   2.3
    ## 24       32.9   0.2
    ## 25       35.7   0.2
    ## 26       31.8   1.0
    ## 27       25.2   2.0
    ## 28       32.7   0.2
    ## 29       36.0   0.3
    ## 30       32.4   0.6
    ## 31       25.8   1.6
    ## 32       33.2   0.2
    ## 33       36.3   0.2
    ## 34       32.2   0.9
    ## 35       26.2   2.9
    ## 36       33.2   0.2
    ## 37       36.5   0.3
    ## 38       32.8   0.9
    ## 39       28.4   2.3
    ## 40       33.9   0.3
    ## 41       37.5   0.4
    ## 42       34.0   1.0
    ## 43       29.0   5.7
    ## 44       34.0   0.3
    ## 45       37.5   0.3
    ## 46       34.1   0.8
    ## 47       32.9  10.2
    ## 48       34.0   0.3

# Block of code to get city details using specific city fips code,abbreviation, variables and dataset year

``` r
# Load necessary libraries
library(tidycensus)
library(dplyr)

# Set your Census API key
census_api_key("e06a3ef2522b01fbf59f0fb986f724a11ed67dd2", overwrite = TRUE)
```

    ## To install your API key for use in future sessions, run this function with `install = TRUE`.

``` r
# Load the correct state information from tidycensus package
state_info <- tigris::fips_codes %>%
  distinct(state, state_code, state_name) %>%
  rename(state_abb = state, fips_code = state_code)

# Function to get state abbreviation from FIPS code or state abbreviation
get_state_abbreviation <- function(input_code) {
  # Check if input is a FIPS code
  if (input_code %in% state_info$fips_code) {
    state_row <- state_info[state_info$fips_code == input_code, ]
  } else if (input_code %in% state_info$state_abb) {  # Check if input is a state abbreviation
    state_row <- state_info[state_info$state_abb == input_code, ]
  } else {
    stop("Invalid FIPS code or state abbreviation provided.")
  }
  
  return(state_row$state_abb)  # Return the state abbreviation
}

# Function to get data for a specific year, FIPS code, or state abbreviation, and variable(s)
get_data_for_year_state_vars <- function(year_input, input_code, variables) {
  
  # Get the state abbreviation from either FIPS code or state abbreviation
  state_input <- get_state_abbreviation(input_code)
  
  # Get data for specified variables
  data <- get_acs(geography = "state",
                  variables = variables,
                  state = state_input,
                  year = year_input,
                  survey = "acs1")
  
  # Add the year column to the data
  data <- data %>%
    mutate(year = year_input)
  
  return(data)
}

# Input FIPS code or state abbreviation and year here
year_input <- 2014
input_code <- "SC"  # FIPS code or state abbreviation here

# Get median household income and median age for Black population
variables <- c("B19013B_001", "B01002B_001")
data <- get_data_for_year_state_vars(year_input, input_code, variables)
```

    ## Getting data from the 2014 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

``` r
print(data)
```

    ## # A tibble: 2 × 6
    ##   GEOID NAME           variable    estimate   moe  year
    ##   <chr> <chr>          <chr>          <dbl> <dbl> <dbl>
    ## 1 45    South Carolina B01002B_001     34.6   0.3  2014
    ## 2 45    South Carolina B19013B_001  30333   648    2014

# Block to get specific variable details using var and year

``` r
# Load necessary libraries
library(tidycensus)
library(dplyr)

# Set your Census API key
census_api_key("e06a3ef2522b01fbf59f0fb986f724a11ed67dd2", overwrite = TRUE)
```

    ## To install your API key for use in future sessions, run this function with `install = TRUE`.

``` r
# Function to retrieve variable details by inputting variable code
get_variable_details <- function(variable_code, year = 2020, dataset = "acs1") {
  
  # Load all available variables for the specified year and dataset
  variables <- load_variables(year = year, dataset = dataset)
  
  # Filter for the specific variable code
  variable_details <- variables %>%
    filter(name == variable_code)
  
  # Check if the variable exists
  if (nrow(variable_details) == 0) {
    message("Variable not found. Please check the variable code and try again.")
  } else {
    return(variable_details)
  }
}

#input var here
variable_code <- "B01002B_001"  # Replace with any variable code you want details for
year <- 2019  # Specify the year of interest
dataset <- "acs1"  # Specify the dataset (e.g., "acs1" for 1-year ACS estimates)

# Get details for the specified variable
variable_info <- get_variable_details(variable_code, year, dataset)
print(variable_info)
```

    ## # A tibble: 1 × 3
    ##   name        label                           concept                           
    ##   <chr>       <chr>                           <chr>                             
    ## 1 B01002B_001 Estimate!!Median age --!!Total: MEDIAN AGE BY SEX (BLACK OR AFRIC…

BLock of code to get table needed with variable details

``` r
# Load necessary libraries
library(tidycensus)
library(dplyr)

# Set your Census API key
census_api_key("e06a3ef2522b01fbf59f0fb986f724a11ed67dd2", overwrite = TRUE)
```

    ## To install your API key for use in future sessions, run this function with `install = TRUE`.

``` r
# Function to retrieve variable details and data for a specific year, FIPS code or state abbreviation, and variable(s)
get_data_with_variable_details <- function(year_input, input_code, variables, dataset = "acs1") {
  
  # Load variable details for the specified year and dataset
  variable_details <- load_variables(year = year_input, dataset = dataset) %>%
    filter(name %in% variables)
  
  # Check if any variables were not found
  if (nrow(variable_details) == 0) {
    stop("One or more variables not found. Please check the variable codes.")
  }
  
  # Get the data for specified variables
  data <- get_acs(geography = "state",
                  variables = variables,
                  state = input_code,
                  year = year_input,
                  survey = dataset) %>%
    mutate(year = year_input)  # Add the year column
  
  # Merge the variable details with the ACS data
  enriched_data <- data %>%
    left_join(variable_details, by = c("variable" = "name")) %>%
    select(GEOID, NAME, year, variable, label, concept, estimate, moe)
  
  return(enriched_data)
}

# Input your year, FIPS code or state abbreviation, and variable codes here
year_input <- 2022
input_code <- "SC"  # You can use a FIPS code or state abbreviation
variables <- c("B19013B_001", "B01002B_001")  # Median household income for Black and median age for Black

# Retrieve data with variable labels and concepts
data_with_details <- get_data_with_variable_details(year_input, input_code, variables)
```

    ## Getting data from the 2022 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

``` r
print(data_with_details)
```

    ## # A tibble: 2 × 8
    ##   GEOID NAME            year variable    label           concept estimate    moe
    ##   <chr> <chr>          <dbl> <chr>       <chr>           <chr>      <dbl>  <dbl>
    ## 1 45    South Carolina  2022 B01002B_001 Estimate!!Medi… Median…     36.4    0.4
    ## 2 45    South Carolina  2022 B19013B_001 Estimate!!Medi… Median…  44187   1854

\#Block of code to get table with variable details using year, state
fips code/abbreviation and var

``` r
# Load necessary libraries
library(tidycensus)
library(dplyr)

# Set your Census API key
census_api_key("e06a3ef2522b01fbf59f0fb986f724a11ed67dd2", overwrite = TRUE)
```

    ## To install your API key for use in future sessions, run this function with `install = TRUE`.

``` r
# Function to retrieve variable details and data for a specific year, FIPS code or state abbreviation, and variable(s)
get_data_with_variable_details <- function(year_input, input_code, variables, dataset = "acs1") {
  
  # Load variable details for the specified year and dataset
  variable_details <- load_variables(year = year_input, dataset = dataset) %>%
    filter(name %in% variables)
  
  # Check if any variables were not found
  if (nrow(variable_details) == 0) {
    stop("One or more variables not found. Please check the variable codes.")
  }
  
  # Get the data for specified variables
  data <- get_acs(geography = "state",
                  variables = variables,
                  state = input_code,
                  year = year_input,
                  survey = dataset) %>%
    mutate(year = year_input)  # Add the year column
  
  # Merge the variable details with the ACS data
  enriched_data <- data %>%
    left_join(variable_details, by = c("variable" = "name")) %>%
    select(NAME, year, label, concept, estimate, moe)  # Exclude variable and GEOID columns here
  
  return(enriched_data)
}

# Input your year, FIPS code or state abbreviation, and variable codes here
year_input <- 2022
input_code <- c("SC", "NC", "MD")  # You can use a FIPS code or state abbreviation
variables <- c("B19013B_001", "B01002B_001")  # Median household income for Black and median age for Black

# Retrieve data with variable labels and concepts
data_with_details <- get_data_with_variable_details(year_input, input_code, variables)
```

    ## Getting data from the 2022 1-year ACS

    ## The 1-year ACS provides data for geographies with populations of 65,000 and greater.

``` r
print(data_with_details)
```

    ## # A tibble: 6 × 6
    ##   NAME            year label                             concept estimate    moe
    ##   <chr>          <dbl> <chr>                             <chr>      <dbl>  <dbl>
    ## 1 Maryland        2022 Estimate!!Median age --!!Total:   Median…     38.7    0.3
    ## 2 Maryland        2022 Estimate!!Median household incom… Median…  77368   2024  
    ## 3 North Carolina  2022 Estimate!!Median age --!!Total:   Median…     36.7    0.3
    ## 4 North Carolina  2022 Estimate!!Median household incom… Median…  50059   1148  
    ## 5 South Carolina  2022 Estimate!!Median age --!!Total:   Median…     36.4    0.4
    ## 6 South Carolina  2022 Estimate!!Median household incom… Median…  44187   1854

\#Block to save as csv file for use in any IDE

``` r
write.csv(data_with_details, file = "data_with_details_output.csv", row.names = FALSE)
```
