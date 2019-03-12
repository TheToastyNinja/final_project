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

color_type <- c("gray16", "deepskyblue2", "darkorchid3",
                "olivedrab2", "cyan2", "sienna3",
                "purple1", "aquamarine1", "firebrick2")
combined_df$Year <- substr(combined_df$Year, 2, nchar(combined_df$Year))
type_of_choices <- colnames(combined_df)[2:10]


page_one <- tabPanel("Introduction", 
                     textInput("name", "name"),
                     p(strong("hello guys !!!"), "We are penguins!"),
                     textOutput("graph_Demonstration"))

page_two <- tabPanel(
  "Year vs. Prices of various housings",
  
  ## Sidebar layout with input and output definitions
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      # Input: Slider for the year of observations to generate
      checkboxGroupInput("type", "Type of houses", choices = type_of_choices)
    ),
    ## Output: Tabset with plot
    mainPanel(plotlyOutput(outputId = "plot_one", height = "800px"), textOutput("plot_text"))
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

page_four <- tabPanel("Table Graph")

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
