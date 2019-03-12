library(dplyr)
library(ggplot2)
library(tidyr)
library(shiny)
library(plotly)
library(maps)
library(rsconnect)
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


combined_df <- get_mean(one_Bedroom) %>%
  left_join(get_mean(two_Bedroom), by = "Year") %>%
  left_join(get_mean(three_Bedroom), by = "Year") %>%
  left_join(get_mean(four_Bedroom), by = "Year") %>%
  left_join(get_mean(five_Bedroom), by = "Year") %>%
  left_join(get_mean(Condo_Bedroom), by = "Year") %>%
  left_join(get_mean(Duplex_Triplex), by = "Year") %>%
  left_join(get_mean(Sfr), by = "Year") %>%
  left_join(get_mean(Studio), by = "Year")

combined_df$Year <- substr(combined_df$Year, 2, nchar(combined_df$Year))

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


page_one <- tabPanel(
  "Introduction",
  textInput("name", "name"),
  p(strong("hello guys !!!"), "We are penguins!"),
  textOutput("graph_Demonstration")
)

page_two <- tabPanel(
  "Year vs. Prices of various housings",
  textOutput("graph_Demonstration"),

  ## Sidebar layout with input and output definitions
  sidebarLayout(
    # Sidebar panel for inputs
    sidebarPanel(
      # Input: Slider for the year of observations to generate
      sliderInput("year_one",
        "Year of the observation:",
        value = c(2010, 2019),
        min = 2010,
        max = 2019
      )
    ),
    ## Output: Tabset with plot
    mainPanel("Plot", plotlyOutput("plot_one"), textOutput("plot_text"))
  )
)

page_three <- tabPanel(
  "National Map",
  textOutput("table_Demonstration")
)

page_four <- tabPanel(
  "State Map",
  textOutput("table_Demonstration")
)

page_five <- tabPanel(
  "Table Graph",
  textOutput("table_Demonstration")
)


my_ui <- fluidPage(
  titlePanel(strong("Anonymous Penguin")),
  plotlyOutput("sample"),
  tabset_panel <- tabsetPanel(
    type = "tabs",
    page_one,
    page_two,
    page_three,
    page_four,
    page_five
  )
)
