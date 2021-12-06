### SERVER ###
source("visualization_helpers.R")

server = function(input, output) {
  # displaying selected data set
  output$display_table <- DT::renderDataTable(DT::datatable(eval(parse(text=input$data_set))))
}
