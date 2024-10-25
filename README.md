THE CENSUS HISTORY PROJECT

The Census History Project focuses on the exploration, extraction, analysis of U.S. Census data. Our users group takes an historical approach to considering the quantification of population-level data, the methods and measures used to explore and extract and analyze data.

**Ancillary files**:

* `api.R` helps new users generate and store a [US Census API key](https://api.census.gov/data/key_signup.html).

  - You should never share your Census API key. Follow the steps below:
  
    - Set up an environment variable to hold your api key with `usethis::edit_r_environ()`

    - Transfer information into `.Renviron` (pop-up file) 
    
        - Insert `CENSUS_API_KEY='your_api_key'` into the `.Renviron` file
  
    - Insert your census API key via `Sys.getenv("CENSUS_API_KEY")`

#### Group Info

group: census-users

initiated: fall 2022

#### Project PIs
Nathan Alexander (Howard University), Hye Ryeon Jang (Morehouse College), & Christopher Agbonkhese (Bates College)

#### Contributors
Myles Ndiritu (Morehouse College), Zoe Williams (Howard University), Jibek Gupta (Howard University), Maxwell Messiah (Dalton), Bayowa Onabajo (Howard University)

#### Funding

Funding for this project is provided by [Data.org](https://data.org) and the [Alfred P. Sloan Foundation](https://sloan.org).