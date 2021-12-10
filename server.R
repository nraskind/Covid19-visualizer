library(DT)

source("visualization_helpers.R") # includes plotly library

### SERVER ###

server = function(input, output, session) {
  # displaying selected data set, implemented inline beacuse it's so simple
  output$display_table <- DT::renderDataTable(DT::datatable(get(input$data_set)))
  
  # interactive map
  output$interactive_map <- renderPlotly(create_covid_graph(color_against = input$colorVar))
  
  # Update possible choices based on statistic
  observe({
    stat_one_choices = get_choices(input$stat_one)
    updateSelectInput(session, "dep_var", choices = stat_one_choices)
  })
  
  # split into two because otherwise the choice for one is reset when the other changes
  observe({
    stat_two_choices = get_choices(input$stat_two)
    updateSelectInput(session, "dep_var_two", choices = stat_two_choices)
  })
  
  output$plot_stat_one <- renderPlotly(
    if (input$graph_type == "bar") {
      bar_chart(year_in=input$year, month_in=input$month, dep_var=input$dep_var)
    } else {
      line_plot(year_in=input$year, month_in=input$month, dep_var=input$dep_var)
    }
  )
  
  output$plot_stat_two <- renderPlotly(
    if (input$graph_type == "bar") {
      bar_chart(year_in=input$year, month_in=input$month, dep_var=input$dep_var_two)
    } else {
      line_plot(year_in=input$year, month_in=input$month, dep_var=input$dep_var_two)
    }
  )
  
}
