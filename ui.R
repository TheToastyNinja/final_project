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
                     textOutput("raph_Demonstration"))

page_two <- tabPanel("Table Graph", 
                     textOutput("graph_Demonstration"))

page_three <- tabPanel("Table Graph", 
                       textOutput("table_Demonstration"))

page_four <- tabPanel("Table Graph", 
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