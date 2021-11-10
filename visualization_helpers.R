### VISUALIZATION FUNCTIONS ###
<<<<<<< HEAD

###                       🍐  TODO   🍐               ###
###       create the underlying DF needed to rapidly  ###
###         query the data needed for these charts    ###

library(plotly)

# Bar chart for state-grouped deaths by sex, all ages
sexy_bar_chart <- function(year_in=2021, month_in=1, age_in="All Ages") {
  males <- filter(sex_and_age, Age.Group == age_in, Sex == "Male", Year==year_in, Month==month_in)["COVID.19.Deaths"]
  females <- filter(sex_and_age, Age.Group == age_in, Sex =="Female", Year==year_in, Month==month_in)["COVID.19.Deaths"]
  states <- unique(sex_and_age["State"])
  rownames(states) <- c(1:nrow(states))

  data <- data.frame(states=states, males=males, females=females)
  colnames(data) <- c("states", "males", "females")
  ploterino <- plot_ly(data=data, x = ~states, y = ~males, type = "bar", name = "Males") %>%
                       add_trace(y = ~females, name = "Females") %>%
                       layout(yaxis = list(title = "Number of Deaths"), barmode = 'group')
  return(ploterino) 
}

# Bar chart for state-group deaths by race, all ages
racy_bar_chart <- function(year_in=2021, month_in=1, race_in="Hispanic.or.Latino") {
  race_deaths <- filter(race_and_hispanic_origin, Indicator=="Count of COVID-19 deaths",
                        Year==year_in, Month==month_in)[race_in]
  states <- unique(race_and_hispanic_origin["State"])
  
  data <- data.frame(state=states, race_deaths=race_deaths)
  colnames(data) <- c("states", "race_deaths")
  ploterino <- plot_ly(data=data, x = ~states, y = ~race_deaths, type = "bar", name = "Race") %>%
               layout(yaxis = list(title = "Number of Deaths"), barmode = 'group')
  
  return(ploterino)
}

# Bar chart for state-grouped deths by place of death, all ages
placey_bar_chart <- function(year_in=2021, month_in=1, place_in="Total - All Places of Death") {
  place_deaths <- filter(place_of_death_and_age, Year==year_in,
                         Place.of.Death==place_in, Month==month_in)["COVID.19.Deaths"]
  states <- unique(place_of_death_and_age["State"])

  data <- data.frame(state=states, place_deaths=place_deaths)
  data[is.na(data)] <- 0 # replacing NAs with 0, will need to do this for all input tables tbh
  
  colnames(data) <- c("states", "place_deaths")
  ploterino <- plot_ly(data=data, x = ~states, y = ~place_deaths, type = "bar", name = "Place") %>%
    layout(yaxis = list(title = "Number of Deaths"), barmode = 'group')
  
  return(ploterino)
}
=======
# most likely need to import ggplot and some other shenanigans

#Hello 
>>>>>>> befb72cc5cd19ef9d452110730bf9031be2563bb
