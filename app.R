rm(list=ls()) # clear all environmental variables 

# temporary file for your boy, you can ignore this line when you run it
setwd("~/Desktop/Projects/Covid19-visualizer/")

# load required packages
if (!require(DT)) install.packages("DT")
if (!require(markdown)) install.packages("markdown")
if (!require(shinythemes)) install.packages("shinythemes")
if (!require(RCurl)) install.packages("RCurl") # for webscraping
if (!require(dplyr)) install.packages("dplyr") # for extracting/filtering
if(!require(shiny)) install.packages("shiny") # for webpage

### RUN APP ###
shinyApp(ui, server)
