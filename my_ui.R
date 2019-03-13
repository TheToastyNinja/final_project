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
                     textOutput("graph_Demonstration"),
                     navlistPanel(
                       tabPanel("Mission"),
                       tabPanel("Data Resource"),
                       tabPanel("Members")))

page_two <- tabPanel("Year vs. Prices of various housings of U.S.", 
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

page_five <- tabPanel("Year vs. Prices of various housings of states",
                      textOutput("graph_Demonstration"),
                      ## Sidebar layout with input and output definitions
                      sidebarLayout(
                        #Sidebar panel for inputs
                        sidebarPanel(
                          p(strong("How did the listed price in each state change from year for different housings?")),
                          p("The fourth visualization is a line graph showing the how the market of various types of rental housing in each state have changed over the years.
                            The x_axis represents the timeline from the Freburary of 2010 to the January of 2019. The y-axis represents the listed price. Users can use the side bar to
                            select the state to display its changes in rental housing listed prices. Lines provide good visual representations of market flucuations. We used the data provided by Zillow
                            to display the average rents of different type of housings at specific time frames. Users can select mutiple housings from the checkbox to display the desired data on the 
                            graph for comparison. The overall markets of all of the states' all housings experienced different levels of decreases in listed price in 2010 and continual but slow increases from 2011 to 2019. 
                            The decrease in 2010 might be the result from the 2008 financial crisis. As the economy is recovering, the rental housing market revives. An exception is the five-bedroom homes 
                            whose listed price fluctuates over the years. It is not surprising because of its large size causing its demand on the rental market to be unpredictable. There are a few states that have consistant rent prices
                            over the years, for example, West Virginia and North Dakota. However, there are also a few states that have rapid growth in their rental market, including New York, California, and Oregon.")
                        ),
                          ## Output: Tabset with plot
                        mainPanel(plotlyOutput("plot_one"), textOutput("plot_text"))
                      ))


my_ui <- fluidPage(
    titlePanel(strong("Anonymous Penguin"),img(src = "data/ttt.png")),
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
