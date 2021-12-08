###                🍐 VISUALIZATION FUNCTIONS  🍐        ###

## will replace with just loading CSVs ##
source("create_combined_dataframe.R") 
library(plotly)

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
    style(hoverlabel = label)
  return(covid_graph)
}

###                     ###
###   INTERACTIVE MAP   ###
###                     ###







###                     ###
###      GRAPHICAL      ###
###                     ###

# creates a simple bar chart with states on the x axis :)
bar_chart <- function(year_in = "2021", month_in = c(1, 12), dep_var = "male", dep_var2 = NA) {
  low <- ( 12 * (strtoi(year_in) - 2020) ) + month_in[1]
  high <- low + (month_in[2] - month_in[1])
  data <- filter(combined_dataframe, month_num >= low & month_num <= high)
  plot <- plot_ly(
    data = data,
    x = ~ state,
    y = ~ get(dep_var),
    type = "bar",
    name = dep_var
  )
  
  if (!is.na(dep_var2)) {
    plot <- plot %>% add_trace(y = ~ get(dep_var2), name = dep_var2)
  }
  plot <- plot %>% layout(yaxis = list(title = "Number of COVID-19 Deaths"),
                  barmode = 'group')
    
    return(plot)
}

###                     ###
###      GRAPHICAL      ###
###                     ###

#creates a basic line plot with states on x axis
libary(plotly)

line_plot <- function(year_in = "2021", month_in = c(1, 12), dep_var = "male", dep_var2 = NA) {
  low <- ( 12 * (strtoi(year_in) - 2020) ) + month_in[1]
  high <- low + (month_in[2] - month_in[1])
  data <- filter(combined_dataframe, month_num >= low & month_num <= high) 
  data <- data %>% group_by(state) %>% summarise(x = sum(get(dep_var)))
  plot <- plot_ly(
    data = data,
    x = ~ state,
    y = ~ x,
    type = "scatter", mode = "markers",
    name = dep_var
  )
  return(plot)
}
line_plot(dep_var = "black")  
 
