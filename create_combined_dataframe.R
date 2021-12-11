######################################
######################################
###      FETCH DATA FROM CDC       ###
######################################
###  RUN THIS SCRIPT ONCE A WEEK   ###
###  STORE ALL DATA AS CSVS THEN   ###
###  YOU CAN SIMPLY LOAD THEM WHEN ###
###        LAUNCHING THE APP       ###
######################################
######################################

library(dplyr) # for filtration
library(RCurl) # for fetching CSVs

# reads in a csv from an html-formatted download link
get_csv <- function(download_url) {
  readable_url <- RCurl::getURL(download_url)
  return(read.csv(text = readable_url))
}

sex_and_age <- get_csv("https://data.cdc.gov/api/views/9bhg-hcku/rows.csv?accessType=DOWNLOAD")
race_and_hispanic_origin <- get_csv("https://data.cdc.gov/api/views/pj7m-y5uh/rows.csv?accessType=DOWNLOAD")
place_of_death_and_age <- get_csv("https://data.cdc.gov/api/views/4va6-ph5s/rows.csv?accessType=DOWNLOAD")
place_of_death_and_state <- get_csv("https://data.cdc.gov/api/views/uggs-hy5q/rows.csv?accessType=DOWNLOAD")
deaths_by_county <- get_csv("https://data.cdc.gov/api/views/kn79-hsxy/rows.csv?accessType=DOWNLOAD")
week_sex_and_age <- get_csv("https://data.cdc.gov/api/views/vsak-wrfu/rows.csv?accessType=DOWNLOAD")

### MAY NEED TO ADD NYC DATA TO NY DATA IN ORDER TO AVOID LOSS OF INFO ###
create_combined_dataframe <- function() {
  # state abbreviations for plotly
  state_abbreviations <- read.csv("data/state_abbreviations.csv", row.names = 1)
  
  ### metadata (date, state) ###
  sa_by_month <- filter(sex_and_age,
                        Group == "By Month",
                        Sex == "All Sexes",!(State %in% c(
                          "Puerto Rico", "New York City", "United States"
                        )))
  
  # added state codes so that we could use plotly geo_map with our data
  meta <- filter(sa_by_month, Age.Group == "All Ages") %>%
    select(c(
      year = "Year",
      month = "Month",
      state = "State"
    )) %>%
    mutate(month_num = 12 * (year - 2020) + month,
           code = state_abbreviations[state, 1])
  
  ### TOTALS ###
  total_and_covid_deaths <- filter(sa_by_month, Age.Group == "All Ages") %>%
    select(c(total_deaths = "Total.Deaths", covid_deaths = "COVID.19.Deaths"))
  
  ### AGE STATS ###
  age <- data.frame(adolescents = sa_by_month[sa_by_month$Age.Group == "0-17 years", "COVID.19.Deaths"],
    adults = sa_by_month[sa_by_month$Age.Group %in% c("18-29 years",
                                                      "30-39 years",
                                                      "40-49 years",
                                                      "50-64 years"), "COVID.19.Deaths"] %>%
      matrix(nrow = 4) %>% colSums,
    seniors = sa_by_month[sa_by_month$Age.Group %in% c("65-74 years",
                                                       "75-84 years",
                                                       "85 years and over"), "COVID.19.Deaths"] %>%
      matrix(nrow = 3) %>% colSums
  )
  
  ### RACE STATS ###
  race <- filter(race_and_hispanic_origin,
                 Group == "By Month", !(State %in% c("New York City", "United States"))) %>%
    mutate(
        other = Non.Hispanic.American.Indian.or.Alaska.Native +
        Non.Hispanic.more.than.one.race +
        Non.Hispanic.Native.Hawaiian.or.Other.Pacific.Islander
    ) %>% select(
      c("Indicator",
        white = "Non.Hispanic.White",
        black = "Non.Hispanic.Black.or.African.American",
        hispanic = "Hispanic.or.Latino",
        asian = "Non.Hispanic.Asian",
        "other")
    )
  
  race_death_weights <- filter(race, Indicator == "Weighted distribution of population (%)")[,-1]
  race_death_counts <- filter(race, Indicator == "Count of COVID-19 deaths") %>%
    select(
      c(white_deaths = "white",
        black_deaths = "black",
        hispanic_deaths = "hispanic",
        asian_deaths = "asian",
        other_deaths = "other"
      )
    )
  ### SEX STATS ###
  sex <- filter(sex_and_age,
                Group == "By Month",
                Age.Group == "All Ages",
                !(State %in% c(
                  "Puerto Rico", "New York City", "United States"
                ))) %>% select(c("Sex", "COVID.19.Deaths"))
  
  combined_dataframe <- data.frame(
    meta,
    male = sex[sex$Sex == "Male", "COVID.19.Deaths"],
    female = sex[sex$Sex == "Female", "COVID.19.Deaths"],
    age,
    total_and_covid_deaths,
    race_death_weights,
    race_death_counts
  ) %>% mutate(
    hover = paste0("Total Number of Deaths: ", total_deaths,
      "\nTotal Number of COVID19 Deaths: ", covid_deaths,
      "\n\nWhite: ", white,
      "\nBlack: ", black,
      "\nHispanic: ", hispanic,
      "\nAsian: ", asian,
      "\nOther: ", other,
      "\n\nAdolescents: ", adolescents,
      "\nAdult (Ages 18-64): ", adults,
      "\nSeniors (Ages 65+): ", seniors)
  )
  
  # replace NAs with 0s
  combined_dataframe[is.na(combined_dataframe)] <- 0
  
  return(combined_dataframe)
}

combined_dataframe <- create_combined_dataframe()

### WRITE CSVS TO DATA PAGE ###
upload_csv <- function(dataframe) {
  write.csv(get(dataframe), paste0("data/", dataframe, ".csv"), row.names=FALSE)
}

upload_csv("combined_dataframe")
upload_csv("sex_and_age")
upload_csv("race_and_hispanic_origin")
upload_csv("place_of_death_and_age")
upload_csv("place_of_death_and_state")
upload_csv("deaths_by_county")
upload_csv("week_sex_and_age")
### WRITE CSVS TO DATA PAGE ###
