# plotly map using combined dataframe
library(plotly)
library(dplyr)

covid_graph <- plot_geo(
    combined_dataframe,
    locationmode = "USA-states",
    frame = ~ month_num
  ) %>%
    add_trace(
      locations = ~ code,
      z = ~ get(combined_dataframe$)covid_deaths,
      # z will be whatever they want to measure against, same with color
      zmin = 0,
      color = ~ covid_deaths,
      text = ~ hover,
      hoverinfo = 'text'
    ) %>%
    layout(geo = graph_properties,
           title = "Pandemic Statistics in the US (By Month)") %>%
    config(displayModeBar = FALSE) %>%
    style(hoverlabel = label)

covid_graph
