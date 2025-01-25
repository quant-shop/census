# step05 census data

## please be sure to run code in the api.R script at least once prior to beginning extraction
### The api.R script can be found here: https://github.com/quant-shop/fatalv2/blob/main/api.R
### by running the api.R script, you will load your census API key

# install packages / un-comment where needed
install.packages("tidycensus")
install.packages("tidyverse")
install.packages("tidyr")
install.packages(c("survey", "srvyr"))

# load libraries
library(tidycensus)
library(tidyverse)
library(tidyselect)
library(dplyr)
library(tidyr)
library(stringr)
library(survey)
library(srvyr)
library(ggplot2)

# read in cleaned data
fatal <- read.csv("data/fatal_clean.csv")

# census poverty rate by state (2022)
pov2022 <- read.csv("data/poverty/SAIPE_03-18-2024.csv")
pov2022

statepov22 <- pov2022 %>% 
  select(Name, Percent.in.Poverty) %>% 
  mutate(povper = Percent.in.Poverty) %>% 
  as_tibble()

statepov22
statepov22 %>% 
  ggplot(aes(x = povper, y = reorder(Name, povper))) +
  geom_point() + 
  xlab(Poverty Rate) + ylab(State)
  labs(title = "Poverty Rates by US State", subtitle = "2022", caption = "Based on US Decennial Census Data")

# fips codes
fips_codes

#### gist code modified from ehbick01 @ https://gist.github.com/ehbick01/1746d6ef2e9d5f74d0a80b83b75b2a45
library(purrr) 

# state FIPS codes
fips_codes
us <- unique(fips_codes$state)[1:51]
head(us)
tail(us)

ga <- filter(fips_codes, state == "GA") # county codes for GA
head(ga)
tail(ga)

nc <- filter(fips_codes, state == "NC") # county codes for NC
head(nc)
tail(nc)





# median age by state
age2020 <- get_decennial(geography = "state",
                         variables = "P13_001N",
                         year = 2020,
                         sumfile = "dhc")
age2020
head(age2020)
tail(age2020)


age2020 %>% 
  ggplot(aes(x = value, y = reorder(NAME, value))) + 
  geom_point()

# tract-level population 
totalpop <- map_df(us, function(x) {
  get_acs(geography = "tract",
          variables = "B01003_001",
          state = "x")
})

totalpop


# tract-level population for GA
totalpop_ga <- map_df(us, function(x) {
  get_acs(geography = "tract",
          variables = "B01003_001",
          state = "GA")
})

# tract-level poverty populations for GA
totalpov_ga <- map_df(us, function(x) {
  get_acs(geography = "tract",
          variables = "B17001_002",
          state = "GA")
})

## calculate poverty rates

# merge totalpop with totalpov and calculate percentpov for GA
total_data <- totalpop_ga %>%
  rename(total_population = estimate) %>% 
  select(GEOID,
         NAME,
         total_population) %>% 
  left_join(totalpov_ga %>% 
              rename(total_poverty = estimate) %>% 
              select(GEOID,
                     NAME,
                     total_poverty),
            by = c("GEOID",
                   "NAME")) %>%
  mutate(percent_poverty = total_poverty / total_population) %>% 
  filter(percent_poverty >= 0.35)

total_data

### PUMS data (public use micro-area data)


### Generate functions to explore data

# load all variable labels for a specific year
labels <- function(yyyy){
  load_variables(yyyy, "acs5")
}
labels.2020 <- labels(2020)
labels.2020
labels.2015 <- labels(2015)
labels.2015

# select all variables with the same root string
varlist.2020 = data.frame(variable=vars_select(labels.2020$name, starts_with('B01001A')))
varlist.2020 %>% 
  as_tibble() # view the varlist as a tibble
dim(varlist.2020) # note: dimensions = number of labels with root string

# match varlist and labels
df.labels.2020 <- right_join(labels.2020, varlist.2020, by=c('name'='variable'))
df.labels.2020 # note: dimensions should match varlist

# extract information from labels
varlist1 <- labels.2020 %>% 
  separate(label, c("l-pos1", 
                    "l-pos2", 
                    "l-pos3", 
                    "l-pos4", 
                    "l-pos5", 
                    "l-pos6", 
                    "l-pos7")) %>% 
  select(-"l-pos1")
varlist1

# loading variable
var1 <- load_variables(2020, "acs5") %>% 
  filter(name=="B01001A_001")
var1

var.values <- get_acs(geography = "state",
                      variables = varlist,
                      year = 2020)

# sex by age (White alone) in the year 2020
var1.values <- get_acs(geography = "state",
                       variables = "B01001A_001",
                       year = 2020)

# extract information from labels
varlist[c("Label Head", "Label Tail")] <- str_split_i(varlist$label, '!!Total', 2)

varlist1 <- varlist %>% separate(label, c("l-pos1", "l-pos2", "l-pos3", "l-pos4", "l-pos5", "l-pos6", "l-pos7"))

# join data frames
var1.values %>% 
  left_join(var1,
            by = c("variable" = "name")) %>% 
  mutate(year = 2020)

# create years vector
years <- data.frame(years = 2013:2021)
years

for (i in 2013:2021){
  print(i)
}

years = labels(for (i in 2013:2021){
  print(i)
})
years
