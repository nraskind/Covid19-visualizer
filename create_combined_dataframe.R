######################################
######################################
######################################
###      FETCH DATA FROM CDC       ###
######################################
######################################
######################################
###  RUN THIS SCRIPT ONCE A WEEK   ###
###  STORE ALL DATA AS CSVS THEN   ###
###  YOU CAN SIMPLY LOAD THEM WHEN ###
###        LAUNCHING THE APP       ### 
######################################
######################################
######################################

library(dplyr) # for filtration
library(RCurl) # for fetching CSVs

get_csv <- function(download_url) {
  # reads in a csv from an html-formatted download link
  readable_url <- RCurl::getURL(download_url)
  return(read.csv(text=readable_url))
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
state_abbreviations <- read.csv("data/state_abbreviations.csv") 

### metadata (date, state) ###
sa_by_month <- filter(sex_and_age,
                      Group == "By Month",
                      Sex == "All Sexes",
                      !(State %in% c("Puerto Rico", "New York City", "United States")))

codes <- data.frame(codes = state_abbreviations["Code"])
rownames(codes) <- state_abbreviations["State"][1:51, 1]
meta <- filter(sa_by_month,
               Age.Group == "All Ages") %>%
  select(c("Year", "Month", "State")) %>%
  mutate(month_num = 12 * (Year - 2020) + Month,
         code = codes[State, 1],
  )


### TOTALS ###
total_deaths <- filter(sa_by_month, Age.Group=="All Ages")["Total.Deaths"]
covid_deaths <- filter(sa_by_month, Age.Group=="All Ages")["COVID.19.Deaths"]

### AGE STATS ###
adolescents <- filter(sa_by_month, Age.Group == "0-17 years")["COVID.19.Deaths"]

adults <- filter(sa_by_month,
                 Age.Group %in% c("18-29 years",
                                  "30-39 years",
                                  "40-49 years",
                                  "50-64 years"))["COVID.19.Deaths"] %>%
  rowsum(rep (1:(nrow(.) / 4), each = 4))

seniors <- filter(sa_by_month,
                  Age.Group %in% c("65-74 years",
                                   "75-84 years",
                                   "85 years and over"))["COVID.19.Deaths"] %>%
  rowsum(rep(1:(nrow(.) / 3), each = 3))

### RACE STATS ###
race_by_month <- filter(race_and_hispanic_origin,
                        Group=="By Month",
                        Indicator=="Unweighted distribution of population (%)",
                        !(State %in% c("New York City", "United States")))

white <- race_by_month["Non.Hispanic.White"]
black <- race_by_month["Non.Hispanic.Black.or.African.American"]
hispanic <- race_by_month["Hispanic.or.Latino"]
asian <- race_by_month["Non.Hispanic.Asian"]
other <- rowSums(
                  select(race_by_month, 
                          c("Non.Hispanic.American.Indian.or.Alaska.Native",
                            "Non.Hispanic.more.than.one.race",
                            "Non.Hispanic.Native.Hawaiian.or.Other.Pacific.Islander"),
                        ),
                 na.rm=TRUE)

### SEX STATS ###
male <- filter(sex_and_age,
               Group=="By Month",
               Age.Group=="All Ages",
               Sex=="Male",
               !(State %in% c("Puerto Rico", "New York City", "United States")))["COVID.19.Deaths"]
female <- filter(sex_and_age,
               Group=="By Month",
               Age.Group=="All Ages",
               Sex=="Female",
               !(State %in% c("Puerto Rico", "New York City", "United States")))["COVID.19.Deaths"]

combined_dataframe <- data.frame(
  "year" = meta["Year"],
  "month" = meta["Month"],
  "state" = meta["State"],
  "month_num" = meta["month_num"],
  "code" = meta["code"],
  "male"=male,
  "female"=female,
  "adolescents" = adolescents,
  "adults" = adults,
  "seniors" = seniors,
  "total_deaths" = total_deaths,
  "covid_deaths" = covid_deaths,
  "white" = white,
  "black" = black,
  "hispanic" = hispanic,
  "asian" = asian,
  "other race" = other
)

colnames(combined_dataframe) <- c("year",
                                  "month",
                                  "state",
                                  "month_num",
                                  "code",
                                  "male",
                                  "female",
                                  "adolescents",
                                  "adults",
                                  "seniors",
                                  "total_deaths",
                                  "covid_deaths",
                                  "white",
                                  "black",
                                  "hispanic",
                                  "asian",
                                  "other race")

# replace NAs with 0s
combined_dataframe[is.na(combined_dataframe)] <- 0

combined_dataframe <- mutate(combined_dataframe, 
                             hover=paste0("Total Number of Deaths: ", total_deaths,
                                          "\nTotal Number of COVID19 Deaths: ", covid_deaths,
                                          "\n\nWhite: ", white,
                                          "\nBlack: ", black,
                                          "\nHispanic: ", hispanic,
                                          "\nAsian: ", asian,
                                          "\nOther: ", `other`,
                                          "\n\nAdolescents: ", adolescents,
                                          "\nAdult (Ages 18-64): ", adults,
                                          "\nSeniors (Ages 65+): ", seniors
                             )
                      )

return(combined_dataframe)
}
combined_dataframe <- create_combined_dataframe()
