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
                            radioButtons("house_type", "House Type:", c("1-Bed" = "one_bed_2019.01", "2-Bed" = "two_bed_2019.01", "3-Bed" = "three_bed_2019.01", "4-Bed" = "four_bed_2019.01", "5-Bed+" = "five_bed_plus_2019.01", "Condo/Co-op" = "condo_coop_2019.01", "Duplex/Triplex" = "duplex_triplex_2019.01", "Single Family Residence (SFR)" = "sfr_2019.01", "Studio" = "studio_2019.01"))
                          ),
                          mainPanel(
                            plotOutput(outputId = "country_map", height = "800px", width = "1200px")
                            
                            
                          )
                        )
                      )

page_four <- tabPanel("Table Graph", 
                      textOutput("table_Demonstration"))

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
