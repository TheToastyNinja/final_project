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
  navlistPanel(
    tabPanel("Mission",
             br(),
             p("Over the years, the U.S. housing rental market have played an important and influential role in America's economy. As the cities expand and housing prices continue to grow, renting an apartment, instead of buying a home, has become more and more popular, especially among the younger generations and in the metro areas. As people are making one of the largest decisions in anyone's life, which home to buy, it is worth considering that renting can be more beneficial and realistic, due to renting's advantages including lower initial investment, less responsibilities, less tax impact, more rooms for flexible budgeting and so on. Therefore, in this data report, we want to exam how the housing rental market in the U.S. has evolved over time. Using the data provided by Zillow, we examined the  rental markets of one-bedroom apartments, two-bedroom apartments, three-bedroom apartments, four-bedroom apartments, five-bedroom apartments, studios, condo homes, duplex triplex, and single family residences. The analysis is based on how the markets have varied across the nation, differed among various states, and changed over the years. Using our data report, users can ultilize the past data to predict the trends of housing rentals in the future.", style="font-size:130%; margin-bottom:20px;")),
    tabPanel("Data Resource",
             br(),
             p("Zillow, founded by former Microsoft executives, Rich Barton and Lloyd Frink in 2006, is an online real estate database company. Providing data on more than 10 million homes in the United States, Zillow aims to build the largest, the most trusted, and the most vibrant online home-related marketplace. Zillow's services include buying, selling, and renting houses and apartments. Zillow establishes its own advanced and well-organized data base containing information on Home Values, Home Listings and Sales, Rental Values, Rental listings, Forecasts, and other more Metrics. Its data is used and analyzed across the world in different industries. For example, Zillow Home Value Index (ZHVI), an organized and up-to-date measure of the median estimated home value across a given region and housing type, is often used to estimate a home value on a given day. Therefore, the big and well-recorded data it provides is a good representation of how the housing market in different places have changed over time.", style="font-size:140%; margin-bottom:20px;")),
    tabPanel("Members",
             br(),
             p(strong("Alycia Nguyen",
                      br(),
                      "Matthew Young",
                      br(),
                      "Qiming Guan",
                      br(),
                      "Sihan Lu",
                      style="font-size:140%; margin-bottom:10px;"))))
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
  "State Level Map",
  sidebarLayout(
    sidebarPanel(
      radioButtons("house_type", "House Type:", c("1-Bed" = "one_bed_2019.01", "2-Bed" = "two_bed_2019.01", "3-Bed" = "three_bed_2019.01", "4-Bed" = "four_bed_2019.01", "5-Bed+" = "five_bed_plus_2019.01", "Condo/Co-op" = "condo_coop_2019.01", "Duplex/Triplex" = "duplex_triplex_2019.01", "Single Family Residence (SFR)" = "sfr_2019.01", "Studio" = "studio_2019.01")),
      
      br(),
      
      p(strong("How do the rents of types of housings vary among different states within U.S.?")),
      p("The second visualization is a map of the United States of America. We used the data provided by Zillow to show the rental prices from the Jaunary of 2019. With the visualization,user can see how the the rents of all types of housings vary among different states within the U.S. The intensity of colors indicate the level of rental prices: darker the color is, higher the rent is, and vice versa. Certain housing types are more expensive in some states, while other types are moreexpensive in other states. The patterns of how the markets for various housing types in different states are unpredictable. Overall, there are few states that have rental prices for all types of housings higher than others, including New York, California, Washington D.C.. Two of the factors are state's economy and residents' consumption power.")),

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
                          
                          p(strong("How do the rents of types of housings vary among various counties in different states?")),
                          p("The third visualization shows the maps of all counties within the various states in the U.S.. We used the data provided by Zillow to show the rental prices from the January of 2019. From the side bar, users are able to select multiple type of housings and select the desired state to view the data on the map. When user selects a state, the map will change into the map of the selected state, showing the data of its counties. With the visualization,user can see how the the rents of all types of housings vary among different counties within the state. The intensity of colors indicate the level of rental prices: darker the color is, higher the rent is, and vice versa. We have found that the counties near the major cities in the states usually have deeper colors, indicating higher rental prices in different types of housings.")
                          
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
      checkboxGroupInput("types", "Type of houses", choices = names_of_selection),
      
      br(),
      
      ## Sidebar layout with input and output definitions
      sidebarLayout(
        #Sidebar panel for inputs
          p(strong("How did the listed price in each state change from year for different housings?")),
          p("The fourth visualization is a line graph showing the how the market of various types of rental housing in each state have changed over the years. The x_axis represents the timeline from the Freburary of 2010 to the January of 2019. The y-axis represents the listed price. Users can use the side bar to select the state to display its changes in rental housing listed prices. Lines provide good visual representations of market flucuations. We used the data provided by Zillow to display the average rents of different type of housings at specific time frames. Users can select mutiple housings from the checkbox to display the desired data on the graph for comparison. The overall markets of all of the states' all housings experienced different levels of decreases in listed price in 2010 and continual but slow increases from 2011 to 2019. The decrease in 2010 might be the result from the 2008 financial crisis. As the economy is recovering, the rental housing market revives. An exception is the five-bedroom homes whose listed price fluctuates over the years. It is not surprising because of its large size causing its demand on the rental market to be unpredictable. There are a few states that have consistant rent prices over the years, for example, West Virginia and North Dakota. However, there are also a few states that have rapid growth in their rental market, including New York, California, and Oregon.")
          )
    ),
    mainPanel(
      plotlyOutput("draw_lines", height = "800px")
    )
  )
)

my_ui <- fluidPage(
  titlePanel(strong("U.S. Rental Listing Market Analysis")),
  tabset_panel <- tabsetPanel(
    type = "tabs",
    page_one,
    page_two,
    page_three,
    page_four,
    page_five
  )
)
