### SERVER ###
source("visualization_helpers.R")

server = function(input, output) {
  # displaying selected data set, implemented inline beacuse it's so simple
  output$display_table <- DT::renderDataTable(DT::datatable(get(input$data_set)))
  
  # interactive map
  output$interactive_map <- renderPlotly(create_covid_graph(color_against = input$colorVar))
  
  # bar charts
  output$plot_stat_one <- renderPlotly(
    bar_chart(year_in=input$year, month_in=input$month, dep_var=input$stat_one)
  )
  
  output$plot_stat_two <- renderPlotly(
    bar_chart(year_in=input$year, month_in=input$month, dep_var=input$stat_two)
  )
  
}
