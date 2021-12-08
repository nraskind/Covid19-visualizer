library(plotly)
###                🍐 VISUALIZATION FUNCTIONS  🍐        ###

## will replace with just loading CSVs ##
source("create_combined_dataframe.R") 

###                     ###
###   INTERACTIVE MAP   ###
###                     ###

graph_properties <- list(
  scope = 'usa',
  showland = TRUE,
  landcolor = toRGB("white"),
  color = toRGB("white")
)

font = list(family = "DM Sans",
            size = 15,
            color = "black")

label = list(bgcolor = "#EEEEEE",
             bordercolor = "transparent",
             font = font)

create_covid_graph <- function(color_against="covid_deaths") {
  covid_graph <- plot_geo(combined_dataframe,
                          locationmode = "USA-states",
                          frame = ~ month_num) %>%
    add_trace(
      locations = ~ code,
      z = ~ get(color_against),
      # z will be whatever they want to measure against, same with color
      zmin = 0,
      color = ~ get(color_against),
      text = ~ hover,
      hoverinfo = 'text'
    ) %>% 
    layout(geo = graph_properties,
           title = "Pandemic Statistics in the US (By Month)") %>%
    config(displayModeBar = FALSE) %>%
    style(hoverlabel = label) %>%
    colorbar(title = color_against)
  return(covid_graph)
}

###                     ###
###   INTERACTIVE MAP   ###
###                     ###







###                     ###
###      GRAPHICAL      ###
###                     ###

# returns choices
get_choices <- function(statistic) {
  return (switch(
    statistic,
    "race" = c(
      "Hispanic" = "hispanic_deaths",
      "White" = "white_deaths",
      "Black" = "black_deaths",
      "Asian" = "asian_deaths",
      "Other" = "other_deaths"
    ),
    "sex" = c("Male" = "male", "Female" = "female"),
    "age" = c(
      "Adolescent" = "adolescents",
      "Adult" = "adults",
      "Senior" = "seniors"
    )
  ))
}

# creates a simple bar chart with states on the x axis :)
bar_chart <- function(year_in = "2021", month_in = c(1, 12), dep_var = "male", dep_var_two = NA) {
  low <- ( 12 * (strtoi(year_in) - 2020) ) + month_in[1]
  high <- low + (month_in[2] - month_in[1])
  data <- filter(combined_dataframe, month_num >= low & month_num <= high) %>%
    group_by(state) %>% summarise(x = sum(get(dep_var)))
  plot <- plot_ly(
    data = data,
    x = ~ state,
    y = ~ x,
    type = "bar",
    name = dep_var
  )
  
  if (!is.na(dep_var_two)) {
    plot <- plot %>% add_trace(y = ~ get(dep_var_two), name = dep_var_two)
  }
  
  plot <- plot %>% layout(yaxis = list(title = "Number of COVID-19 Deaths"),
                  barmode = 'group')
    
    return(plot)
}

# creates a basic line plot with states on x axis
line_plot <- function(year_in = "2021", month_in = c(1, 12), dep_var = "male", dep_var2 = NA) {
  low <- (12 * (strtoi(year_in) - 2020)) + month_in[1]
  high <- low + (month_in[2] - month_in[1])
  data <- filter(combined_dataframe, month_num >= low & month_num <= high) %>%
    group_by(state) %>% summarise(x = sum(get(dep_var)))
  plot <- plot_ly(
    data = data,
    x = ~ state,
    y = ~ x,
    type = "scatter",
    mode = "markers",
    name = dep_var
  )
  return(plot)
}

###                     ###
###      GRAPHICAL      ###
###                     ###
