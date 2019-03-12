#install.packages("leaflet")
library(leaflet)
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
                         p(strong("How did the listed price change from year for different types of housings?")),
                        p("The first visualization is a scattorplot showing how the national market of various types of rental housing have changed over the years. The x_axis represents the timeline from the Freburary of 2010 to the January of 2019. The y-axis represents the listed price. We used the data provided by Zillow to calculate the national average of different type of housings at specific time frames. Users can select mutiple housings from the checkbox to display the desired data on the graph for comparison. The overall market of all housings experienced different levels of decreases in listed price in 2010 and continual but slow increases from 2011 to 2019. The decrease in 2010 might be the result from the 2008 financial crisis. As the economy is recovering, the rental housing market revives. An exception is the five-bedroom homes whose listed price fluctuates over the years. It is not surprising because of its large size causing its demand on the rental market to be unpredictable.")
                       ),
                       ## Output: Tabset with plot
                       mainPanel("Plot", plotlyOutput("plot_one"), textOutput("plot_text"))
                     )
                   )

page_three <- tabPanel("National Map",
                       ## Sidebar layout with input and output definitions
                       sidebarLayout(
                         #Sidebar panel for inputs
                         sidebarPanel(
                            selectInput("Type", 
                                        label = "Type of houses",
                                        choices = c("Studio", "One Bedroom",
                                                     "Two Bedroom", "Three Bedroom", "Four Bedroom"),
                                        selected = "Studio")),
                         mainPanel("Plot", plotlyOutput("plot_one"), textOutput("plot_text"))
                       ))
page_four <- tabPanel("State Map", 
                      textOutput("table_Demonstration"))

page_five <- tabPanel("Table Graph", 
                      textOutput("table_Demonstration"))


my_ui <- fluidPage(
    titlePanel(strong("Anonymous Penguin")),
    textOutput("name"),
      tabset_panel <- tabsetPanel(
        type = "tabs",
        page_one,
        page_two,
        page_three,
        page_four,
        page_five
      )
)
