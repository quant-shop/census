CENSUS HISTORY PROJECT

Various analyses and reports that take on an historical approach to population-level data analysis and database development.

**Ancillary files**:

* `api.R` helps new users generate and store a [US Census API key](https://api.census.gov/data/key_signup.html).

  - You should never share your Census API key. Follow the steps below:
  
    - Set up an environment variable to hold your api key with `usethis::edit_r_environ()`

    - Transfer information into `.Renviron` (pop-up file) 
    
        - Insert `CENSUS_API_KEY='your_api_key'` into the `.Renviron` file
  
    - Insert your census API key via `Sys.getenv("CENSUS_API_KEY")`
    
    
#### Project PIs
Nathan Alexander (Howard University), Hye Ryeon Jang (Morehouse College), & Christopher Agbonkhese (Bates College)

#### Contributors
Myles Ndiritu (Morehouse College), Zoe Williams (Howard University), Jibek Gupta (Howard University), Maxwell Messiah (Dalton), Bayowa Onabajo (Howard University)