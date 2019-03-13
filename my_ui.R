library(dplyr)
library(ggplot2)
library(tidyr)
library(shiny)
library(plotly)
library(maps)
library(rsconnect)
library(scales)
options(scipen = 999)

one_Bedroom <- read.csv("data/State_MedianRentalPrice_1Bedroom.csv", stringsAsFactors = F)
two_Bedroom <- read.csv("data/State_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = F)
three_Bedroom <- read.csv("data/State_MedianRentalPrice_3Bedroom.csv", stringsAsFactors = F)
four_Bedroom <- read.csv("data/State_MedianRentalPrice_4Bedroom.csv", stringsAsFactors = F)
five_Bedroom <- read.csv("data/State_MedianRentalPrice_5BedroomOrMore.csv", stringsAsFactors = F)
Condo_Bedroom <- read.csv("data/State_MedianRentalPrice_CondoCoop.csv", stringsAsFactors = F)
Duplex_Triplex <- read.csv("data/State_MedianRentalPrice_DuplexTriplex.csv", stringsAsFactors = F)
Sfr <- read.csv("data/State_MedianRentalPrice_Sfr.csv", stringsAsFactors = F)
Studio <- read.csv("data/State_MedianRentalPrice_Studio.csv", stringsAsFactors = F)

get_mean <- function(sample_df) {
  length_cols <- length(colnames(sample_df))
  Mean <- as.data.frame(mean(unlist(sample_df[, length_cols]), na.rm = T))
  colnames(Mean)[1] <- colnames(sample_df)[3]
  index <- 4
  while (index <= length_cols) {
    names_sp <- colnames(sample_df)[index]
    Mean <- mutate(Mean,
      names = mean(unlist(sample_df[, index]), na.rm = T)
    )
    colnames(Mean)[index - 2] <- names_sp
    index <- index + 1
  }
  type_name <- paste0(deparse(substitute(sample_df)), "_mean_price")

  Mean <- gather(Mean,
    key = "Year",
    value = type_name
  )
  colnames(Mean)[2] <- type_name
  Mean
}


combined_df <- get_mean(one_Bedroom) %>%
  left_join(get_mean(two_Bedroom), by = "Year") %>%
  left_join(get_mean(three_Bedroom), by = "Year") %>%
  left_join(get_mean(four_Bedroom), by = "Year") %>%
  left_join(get_mean(five_Bedroom), by = "Year") %>%
  left_join(get_mean(Condo_Bedroom), by = "Year") %>%
  left_join(get_mean(Duplex_Triplex), by = "Year") %>%
  left_join(get_mean(Sfr), by = "Year") %>%
  left_join(get_mean(Studio), by = "Year")

color_type <- c(
  "gray16", "deepskyblue2", "darkorchid3",
  "blue1", "green4", "sienna3",
  "violetred", "aquamarine1", "firebrick2"
)
combined_df$Year <- substr(combined_df$Year, 2, nchar(combined_df$Year))
type_of_choices <- colnames(combined_df)[2:10]
names_of_selection <- substr(type_of_choices, 1, nchar(type_of_choices) - 11)
state_choices <- one_Bedroom$RegionName

get_state_df <- function(df, index) {
  df <- df %>%
    select(-SizeRank) %>%
    gather(
      key = "Year",
      value = types,
      -RegionName
    )
  colnames(df)[3] <- type_of_choices[index]
  df
}

combined_state_df <- get_state_df(one_Bedroom, 1) %>%
  full_join(get_state_df(two_Bedroom, 2), by = c("Year", "RegionName")) %>%
  full_join(get_state_df(three_Bedroom, 3), by = c("Year", "RegionName")) %>%
  full_join(get_state_df(four_Bedroom, 4), by = c("Year", "RegionName")) %>%
  full_join(get_state_df(five_Bedroom, 5), by = c("Year", "RegionName")) %>%
  full_join(get_state_df(Condo_Bedroom, 6), by = c("Year", "RegionName")) %>%
  full_join(get_state_df(Duplex_Triplex, 7), by = c("Year", "RegionName")) %>%
  full_join(get_state_df(Sfr, 8), by = c("Year", "RegionName")) %>%
  full_join(get_state_df(Studio, 9), by = c("Year", "RegionName"))

colnames(combined_state_df)[3:11] <- names_of_selection

page_one <- tabPanel(
  "Introduction",
  textInput("name", "name"),
  p(strong("hello guys !!!"), "We are penguins!"),
  textOutput("graph_Demonstration")
)


page_two <- tabPanel(
  "Year vs. Prices of various housings",

  ## Sidebar layout with input and output definitions
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      # Input: Slider for the year of observations to generate
      checkboxGroupInput("type", "Type of houses", choices = type_of_choices),


      br(),


      p(strong("How did the listed price change from year for different types of housings?")),
      p("The first visualization is a scattorplot showing how the national market of various types of rental housing have changed over the years. The x_axis represents the timeline from the Freburary of 2010 to the January of 2019. The y-axis represents the listed price. We used the data provided by Zillow to calculate the national average of different type of housings at specific time frames. Users can select mutiple housings from the checkbox to display the desired data on the graph for comparison. The overall market of all housings experienced different levels of decreases in listed price in 2010 and continual but slow increases from 2011 to 2019. The decrease in 2010 might be the result from the 2008 financial crisis. As the economy is recovering, the rental housing market revives. An exception is the five-bedroom homes whose listed price fluctuates over the years. It is not surprising because of its large size causing its demand on the rental market to be unpredictable.")
    ),
    ## Output: Tabset with plot
    mainPanel(plotlyOutput(outputId = "plot_one", height = "800px"))
  )
)



page_three <- tabPanel(
  "Map",
  sidebarLayout(
    sidebarPanel(
      radioButtons("house_type", "House Type:", c("1-Bed" = "one_bed_2019.01", "2-Bed" = "two_bed_2019.01", "3-Bed" = "three_bed_2019.01", "4-Bed" = "four_bed_2019.01", "5-Bed+" = "five_bed_plus_2019.01", "Condo/Co-op" = "condo_coop_2019.01", "Duplex/Triplex" = "duplex_triplex_2019.01", "Single Family Residence (SFR)" = "sfr_2019.01", "Studio" = "studio_2019.01")),
      
      p("How do the rents of types of housings vary among various counties in different states? The third visualization shows the maps of all counties within the various states in the U.S.. We used the data provided by Zillow to show the rental prices from the January of 2019. From the side bar, users are able to select multiple type of housings and select the desired state to view the data on the map. When user selects a state, the map will change into the map of the selected state, showing the data of its counties. With the visualization,user can see how the the rents of all types of housings vary among different counties within the state. The intensity of colors indicate the level of rental prices: darker the color is, higher the rent is, and vice versa. We have found that the counties near the major cities in the states usually have deeper colors, indicating higher rental prices in different types of housings.")
      
    ),
    mainPanel(
      plotOutput(outputId = "country_map", height = "800px", width = "1200px")
    )
  )
)

page_four <- tabPanel("County Level Map", 
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("house_type_county_map", "Choose a house type to observe:", c("1-Bed" = "one_bed_2019.01", "2-Bed" = "two_bed_2019.01", "3-Bed" = "three_bed_2019.01", "4-Bed" = "four_bed_2019.01", "5-Bed+" = "five_bed_plus_2019.01", "Condo/Co-op" = "condo_coop_2019.01", "Duplex/Triplex" = "duplex_triplex_2019.01", "Single Family Residence (SFR)" = "sfr_2019.01", "Studio" = "studio_2019.01")),
                          selectInput("state_selector", "Choose a state to observe:", state_choices, selected = "Washington"),
                          
                          p("How do the rents of types of housings vary among various counties in different states?
                              The third visualization shows the maps of all counties within the various states in the U.S.. We used the data provided by Zillow to show the rental prices from the January of 2019. From the side bar, users are able to select multiple type of housings and select the desired state to view the data on the map. When user selects a state, the map will change into the map of the selected state, showing the data of its counties. With the visualization,user can see how the the rents of all types of housings vary among different counties within the state. The intensity of colors indicate the level of rental prices: darker the color is, higher the rent is, and vice versa. We have found that the counties near the major cities in the states usually have deeper colors, indicating higher rental prices in different types of housings.")
                          
                        ),
                        mainPanel(
                          plotlyOutput(outputId = "county_level_state_map", height = "700px")
                        )
                      )
)

page_five <- tabPanel(
  "Year vs. Prices of various housing of states",
  sidebarLayout(
    sidebarPanel(
      selectInput("states", "State", choices = state_choices, selected = state_choices[1]),
      checkboxGroupInput("types", "Type of houses", choices = names_of_selection)
    ),
    mainPanel(
      plotlyOutput("draw_lines", height = "800px")
    )
  )
)

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
