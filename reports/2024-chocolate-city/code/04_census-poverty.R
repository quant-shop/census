# step04 census data - poverty

# load libraries
require(tidycensus)
require(tidyverse)
require(tidyr)
library(ggplot2)
library(tidyselect)
library(dplyr)
library(stringr)

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
pov2022.plot <- statepov22 %>% 
  ggplot(aes(x = povper, y = reorder(Name, povper))) +
  geom_point() + 
  xlab("Poverty Rate") + ylab("State") +
  labs(title = "Poverty Rates by US State", subtitle = "2022", caption = "Based on US Decennial Census Data")

ggsave("output/plots/pov2022.pdf")
