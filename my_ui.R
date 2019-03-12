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
                            plotOutput(outputId = "country_map")
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
