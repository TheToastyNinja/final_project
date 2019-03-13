library(dplyr)
library(ggplot2)
library(tidyr)
library(shiny)
library(plotly)
library(maps)
library(rsconnect)
options(scipen = 999)


page_one <- tabPanel("Introduction", 
                     textInput("name", "name"),
                     p(strong("hello guys !!!"), "We are penguins!"),
                     textOutput("graph_Demonstration"))

page_two <- tabPanel("Table Graph")

page_three <- tabPanel("Map", 
                        sidebarLayout(
                          sidebarPanel(
                            radioButtons("house_type", "House Type:", c("1-Bed", "2-Bed", "3-Bed", "4-Bed", "5-Bed+", "Condo/Co-op", "Duplex/Triplex", "Single Family Residence (SFR)", "Studio"))
                          ),
                          mainPanel(
                            plotlyOutput(outputId = "country_map")
                          )
                        )
                      )

page_four <- tabPanel("County Level Map", 
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("house_type_county_map", "Choose a house type to observe:", c("1-Bed" = "1bed_2019.01", "2-Bed" = "2bed_2019.01", "3-Bed" = "3bed_2019.01", "4-Bed" = "4bed_2019.01", "5-Bed+" = "5bed_plus_2019.01", "Condo/Co-op" = "condo_coop_2019.01", "Duplex/Triplex" = "duplex_triplex_2019.01", "Single Family Residence (SFR)" = "sfr_2019.01", "Studio" = "studio_2019.01")),
                          selectInput("state_selector", "Choose a state to observe:", state_data$RegionName, selected = "Washington")
                        ),
                        mainPanel(
                          plotlyOutput(outputId = "county_level_state_map", height = "700px")
                        )
                      )
                    )

page_five <- tabPanel("Table Graph")


my_ui <- fluidPage(
    titlePanel(strong("Anonymous Penguin")),
      tabset_panel <- tabsetPanel(
        type = "tabs",
        page_one,
        page_two,
        page_three,
        page_four,
        page_five
      )
  
)
