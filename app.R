rm(list=ls()) # clear all environmental variables 

# temporary file for your boy, you can ignore this line when you run it
setwd("~/Desktop/Covid19-visualizer/")

# load required packages
if (!require(DT)) install.packages("DT")
if (!require(markdown)) install.packages("markdown")
if (!require(shinythemes)) install.packages("shinythemes")
if (!require(RCurl)) install.packages("RCurl") # for webscraping
if (!require(dplyr)) install.packages("dplyr") # for extracting/filtering
if(!require(shiny)) install.packages("shiny") # for webpage
# consider putting in a helper function script
get_csv <- function(download_url) {
  # reads in a csv from an html-formatted download link
  readable_url <- RCurl::getURL(download_url)
  return(read.csv(text=readable_url))
}
# import ui and server

# USEFUL for mapping and graphing

# start, end, state (wrong form), sex, age, year/month
sex_and_age <- get_csv("https://data.cdc.gov/api/views/9bhg-hcku/rows.csv?accessType=DOWNLOAD")

# start, end, state (wrong form), race data, year/month
race_and_hispanic_origin <- get_csv("https://data.cdc.gov/api/views/pj7m-y5uh/rows.csv?accessType=DOWNLOAD")

# start, end, state (wrong form), age, place of death, year/month
place_of_death_and_age <- get_csv("https://data.cdc.gov/api/views/4va6-ph5s/rows.csv?accessType=DOWNLOAD")

# start, end, state (wrong form), place of death, year/month
place_of_death_and_state <- get_csv("https://data.cdc.gov/api/views/uggs-hy5q/rows.csv?accessType=DOWNLOAD")

# USEFUL for graphing only:
# start, end (full pandy), state, county
deaths_by_county <- get_csv("https://data.cdc.gov/api/views/kn79-hsxy/rows.csv?accessType=DOWNLOAD")

# basically sex and age with US totals up to week x (x stuff happened from the start of the pandy all the way up to this week)
week_sex_and_age <- get_csv("https://data.cdc.gov/api/views/vsak-wrfu/rows.csv?accessType=DOWNLOAD")

### RUN APP ###
shinyApp(ui, server)
