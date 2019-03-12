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

page_two <- tabPanel("Year vs. Prices of various housings", 
                     textOutput("graph_Demonstration"),
                     
                     ## Sidebar layout with input and output definitions
                     sidebarLayout(
                       #Sidebar panel for inputs
                       sidebarPanel(
                         #Input: Slider for the year of observations to generate
                         sliderInput("year_one",
                                     "Year of the observation:",
                                     value = c(2010, 2019),
                                     min = 2010,
                                     max = 2019)
                       ),
                       ## Output: Tabset with plot
                       mainPanel("Plot", plotlyOutput("plot_one"), textOutput("plot_text"))
                     )
                   )

page_three <- tabPanel("National Map", 
                       textOutput("table_Demonstration"))

page_four <- tabPanel("State Map", 
                      textOutput("table_Demonstration"))

page_five <- tabPanel("Table Graph", 
                      textOutput("table_Demonstration"))


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