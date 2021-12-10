library(shiny)
library(shinythemes)
library(markdown)
library(plotly)

ui <- navbarPage(title="", theme="simplex",
                  tabPanel("Interactive Map",
                           fluidPage(
                              fluidRow(
                                  selectInput(inputId="colorVar", label="Coloring Against: ",
                                              choices=c("Total Deaths"="total_deaths", "COVID19 Deaths"="covid_deaths",
                                                        "Male C19 deaths"="male", "Female C19 deaths"="female",
                                                        "Adolescent C19 Deaths"="adolescents", "Adult C19 Deaths"="adults",
                                                        "Senior C19 Deaths"="seniors"))
                                ),
                              fluidRow(
                                  plotly::plotlyOutput("interactive_map")
                                )
                              )
                           ),
                  tabPanel("Graphical View",
                           fluidPage(
                             sidebarLayout(
                               sidebarPanel(
                                 selectInput(inputId="stat_one", label="Stat One", choices = c("Race"="race","Sex"="sex","Age"="age"),
                                            selected = "Age", multiple = F),
                                 selectInput(inputId="dep_var", label="Specific", choices = c("Adolescent"="adolescents",
                                                                                                       "Adult"="adults",
                                                                                                       "Senior"="seniors"),
                                             selected = "Adult", multiple=F, width="50%"),
                                 
                                 selectInput(inputId="stat_two", label="Stat Two", choices = c("Race"="race","Sex"="sex","Age"="age"),
                                             selected = "Age", multiple = F),
                                 selectInput(inputId="dep_var_two", label="Specific", choices = c("Adolescent"="adolescents",
                                                                                                  "Adult"="adults",
                                                                                                  "Senior"="seniors"),
                                             selected = "Adult", multiple=F, width="50%"),
                                 
                                 radioButtons(inputId = "year",label = "Select Year", choices = c("2020"="2020","2021"="2021")),
                                 sliderInput(inputId = "month", label = "Select Months", min = 1, max = 12, value = c(1, 12), step = 1),
                                 selectInput(inputId="graph_type", label="Graph Type", choices = c("Bar"="bar", "Line"="line"),
                                             selected = "Bar", multiple=F)
                               ),
                               
                               mainPanel(plotly::plotlyOutput(outputId = "plot_stat_one"),
                                         plotly::plotlyOutput(outputId = "plot_stat_two")
                                 )
                             )
                           )
                  ),
                  tabPanel("Data Sets",
                           fluidPage(
                             selectInput("data_set", "Choose a data set:",
                                        c("Sex and Age" = "sex_and_age",
                                          "Sex and Age Weekly" = "week_sex_and_age",
                                          "Race and Hispanic Origin" = "race_and_hispanic_origin",
                                          "Place of Death and Age" = "place_of_death_and_age",
                                          "Place of Death and State" = "place_of_death_and_state",
                                          "Deaths by County" = "deaths_by_county",
                                          "Filtered Data" = "combined_dataframe"
                                         )),        
                             DT::dataTableOutput("display_table")
                           )
                  ),
                  tabPanel("About",
                           fluidPage(
                            shiny::includeMarkdown("help_messages/about_page.md")
                           )
                  )
                )
