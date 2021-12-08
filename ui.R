### UI ###
ui <- navbarPage(title="", theme="simplex",
                  
                  tabPanel("Interactive Map",
                           fluidPage(
                              sidebarLayout(
                                sidebarPanel(
                                  selectInput(inputId="colorVar", label="Coloring Against: ",
                                              choices=c("Total Deaths"="total_deaths", "COVID19 Deaths"="covid_deaths",
                                                        "Male C19 deaths"="male", "Female C19 deaths"="female",
                                                        "Adolescent C19 Deaths"="adolescents", "Adult C19 Deaths"="adults",
                                                        "Senior C19 Deaths"="seniors"))
                                ),
                                mainPanel(
                                  plotlyOutput("interactive_map")
                                )
                              )
                           )
                  ),
                  tabPanel("Graphical View",
                           fluidPage(
                             sidebarLayout(
                               sidebarPanel(
                                 selectInput(inputId="stat_one", label="Stat One", choices = c("Race"="race","Sex"="male","Age"="adults"),
                                            selected = "Race", multiple = F),
                                 selectInput(inputId="stat_two", label="Stat Two", choices = c("Race"="race","Sex"="female","Age"="seniors"),
                                             selected = "Sex", multiple = F),
                                 
                                 radioButtons(inputId = "year",label = "Select Year", choices = c("2020"="2020","2021"="2021")),
                                 sliderInput(inputId = "month", label = "Select Months", min = 1, max = 12, value = c(1, 12), step = 1),
                               ),
                               
                               mainPanel(plotlyOutput(outputId = "plot_stat_one"),
                                         plotlyOutput(outputId = "plot_stat_two")
                                 )
                             )
                           )
                  ),
                 ### Data Sets WILL NOT BE SUPPORTED IF WE ONLY HAVE THE COMBINED DATAFRAME ###
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
                            # currently only works if the working directory is Covid19-visualizer (i.e. help_messages/..)
                            shiny::includeMarkdown("help_messages/about_page.md")
                           )
                  )
                ) # end navbarPage
