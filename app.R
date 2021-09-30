rm(list=ls()) # clear all environmental variables

# load required packages
if (!require(RCurl)) install.packages("RCurl") # for webscraping
if (!require(dplyr)) install.packages("dplyr") # for extracting/filtering
if(!require(shiny)) install.packages("shiny") # for webpage

# consider putting in a helper function script
get_csv <- function(download_url) {
  # reads in a csv from an html-formatted download link
  readable_url <- RCurl::getURL(download_url)
  return(read.csv(text=readable_url))
}

# All data was retrieved from the [CDC Official Website](https://www.cdc.gov/nchs/nvss/vsrr/covid_weekly/)
sex_and_age <- get_csv("https://data.cdc.gov/api/views/9bhg-hcku/rows.csv?accessType=DOWNLOAD")
week_sex_and_age <- get_csv("https://data.cdc.gov/api/views/vsak-wrfu/rows.csv?accessType=DOWNLOAD")
race_and_hispanic_origin <- get_csv("https://data.cdc.gov/api/views/pj7m-y5uh/rows.csv?accessType=DOWNLOAD")
place_of_death_and_age <- get_csv("https://data.cdc.gov/api/views/4va6-ph5s/rows.csv?accessType=DOWNLOAD")
place_of_death_and_state <- get_csv("https://data.cdc.gov/api/views/uggs-hy5q/rows.csv?accessType=DOWNLOAD")
comorbities_and_conditions <- get_csv("https://data.cdc.gov/api/views/hk9y-quqm/rows.csv?accessType=DOWNLOAD")
deaths_by_county <- get_csv("https://data.cdc.gov/api/views/kn79-hsxy/rows.csv?accessType=DOWNLOAD")
deaths_by_week_and_urbanicity <- get_csv("https://data.cdc.gov/api/views/hkhc-f7hg/rows.csv?accessType=DOWNLOAD")

### RUN APP ###
# shinyApp(ui, server)