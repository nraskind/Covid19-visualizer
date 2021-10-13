### UI ###
library(shinythemes)
library(markdown)

ui <- navbarPage(title="", theme="simplex",
                  
                  tabPanel("Interactive Map",
                           fluidPage(
                            h1("Interactive Map will go here")
                           )
                  ),
                  tabPanel("Graphical View",
                           fluidPage(
                            h1("Graphical View will go here")
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
                                          "Comorbities and Conditions" = "comorbities_and_conditions",
                                          "Deaths by County" = "deaths_by_county",
                                          "Deaths by Week and Urbanicity" = "deaths_by_week_and_urbanicity"
                                         )),        
                             DT::dataTableOutput("display_table")
                           )
                  ),
                  tabPanel("About",
                           fluidPage(
                            # currently only works if the working directory is Covid19-visualizer (i.e. help_messages/..)
                            shiny::includeMarkdown("help_messages/about_page.md")
                           )
                  )
                ) # end navbarPage
