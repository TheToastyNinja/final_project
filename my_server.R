library(dplyr)
library(shiny)
library(ggplot2)
library(tidyr)
library(maps)
library(plotly)
options(scipen = 999)
#----------------joining data frames------------------------------
change_colnames_county <- function(df){
  colnames(df)[7:length(colnames(df))] <- paste0(substr(deparse(substitute(df)),3, nchar(deparse(substitute(df)))), "_", substr(colnames(df)[7:length(colnames(df))], 2, nchar(colnames(df)[7:length(colnames(df))])))
  df
}

change_colnames_state <- function(df){
  colnames(df)[3:length(colnames(df))] <- paste0(substr(deparse(substitute(df)),3, nchar(deparse(substitute(df)))), "_", substr(colnames(df)[3:length(colnames(df))], 2, nchar(colnames(df)[3:length(colnames(df))])))
  df
}

c_1bed <- read.csv("data/County_MedianRentalPrice_1Bedroom.csv", stringsAsFactors = FALSE)
c_2bed <- read.csv("data/County_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
c_3bed <- read.csv("data/County_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
c_4bed <- read.csv("data/County_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
c_5bed_plus <- read.csv("data/County_MedianRentalPrice_5BedroomOrMore.csv", stringsAsFactors = FALSE)
c_studio <- read.csv("data/County_MedianRentalPrice_Studio.csv", stringsAsFactors = FALSE)
c_sfr <- read.csv("data/County_MedianRentalPrice_Sfr.csv", stringsAsFactors = FALSE)
c_duplex_triplex <- read.csv("data/County_MedianRentalPrice_DuplexTriplex.csv", stringsAsFactors = FALSE)
c_condo_coop <- read.csv("data/County_MedianRentalPrice_CondoCoop.csv", stringsAsFactors = FALSE)

c_1bed_edited <- change_colnames_county(c_1bed)
c_2bed_edited <- change_colnames_county(c_2bed)
c_3bed_edited <- change_colnames_county(c_3bed)
c_4bed_edited <- change_colnames_county(c_4bed)
c_5bed_plus_edited <- change_colnames_county(c_5bed_plus)
c_studio_edited <- change_colnames_county(c_studio)
c_sfr_edited <- change_colnames_county(c_sfr)
c_duplex_triplex_edited <- change_colnames_county(c_duplex_triplex)
c_condo_coop_edited <- change_colnames_county(c_condo_coop)

nrow(change_colnames_county(c_1bed)) +
nrow(change_colnames_county(c_2bed)) +
nrow(change_colnames_county(c_3bed)) +
nrow(change_colnames_county(c_4bed)) +
nrow(change_colnames_county(c_5bed_plus)) +
nrow(change_colnames_county(c_studio)) +
nrow(change_colnames_county(c_sfr)) +
nrow(change_colnames_county(c_duplex_triplex)) +
nrow(change_colnames_county(c_condo_coop))

county_data <- full_join(c_1bed_edited, c_2bed_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_3bed_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_4bed_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_5bed_plus_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_studio_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_sfr_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_duplex_triplex_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_condo_coop_edited, by = c("RegionName", "State"), na.rm = FALSE)

#------------------------------------states--------------------------------
s_1bed <- read.csv("data/State_MedianRentalPrice_1Bedroom.csv", stringsAsFactors = FALSE)
s_2bed <- read.csv("data/State_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
s_3bed <- read.csv("data/State_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
s_4bed <- read.csv("data/State_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
s_5bed_plus <- read.csv("data/State_MedianRentalPrice_5BedroomOrMore.csv", stringsAsFactors = FALSE)
s_studio <- read.csv("data/State_MedianRentalPrice_Studio.csv", stringsAsFactors = FALSE)
s_sfr <- read.csv("data/State_MedianRentalPrice_Sfr.csv", stringsAsFactors = FALSE)
s_duplex_triplex <- read.csv("data/State_MedianRentalPrice_DuplexTriplex.csv", stringsAsFactors = FALSE)
s_condo_coop <- read.csv("data/State_MedianRentalPrice_CondoCoop.csv", stringsAsFactors = FALSE)

s_1bed_edited <- change_colnames_state(s_1bed)
s_2bed_edited <- change_colnames_state(s_2bed)
s_3bed_edited <- change_colnames_state(s_3bed)
s_4bed_edited <- change_colnames_state(s_4bed)
s_5bed_plus_edited <- change_colnames_state(s_5bed_plus)
s_studio_edited <- change_colnames_state(s_studio)
s_sfr_edited <- change_colnames_state(s_sfr)
s_duplex_triplex_edited <- change_colnames_state(s_duplex_triplex)
s_condo_coop_edited <- change_colnames_state(s_condo_coop)

state_data <- left_join(s_1bed_edited, s_2bed_edited, by = c("RegionName", "SizeRank"))
state_data <- left_join(state_data, s_3bed_edited, by = c("RegionName", "SizeRank"))
state_data <- left_join(state_data, s_4bed_edited, by = c("RegionName", "SizeRank"))
state_data <- left_join(state_data, s_5bed_plus_edited, by = c("RegionName", "SizeRank"))
state_data <- left_join(state_data, s_studio_edited, by = c("RegionName", "SizeRank"))
state_data <- left_join(state_data, s_sfr_edited, by = c("RegionName", "SizeRank"))
state_data <- left_join(state_data, s_duplex_triplex_edited, by = c("RegionName", "SizeRank"))
state_data <- left_join(state_data, s_condo_coop_edited, by = c("RegionName", "SizeRank"))

#----------------------creating country map----------------------

usa <- map_data("state")

counties <- map_data("county")

my_label <- c("0-500", "500-1000", "1000-1500", "1500-2000", "2000-2500", "2500-3000", "3000-3500", "3500-4000", "4000-4500")
#----------------------------------------------------------------
my_server <- function(input, output){
  output$country_map <- renderPlot({
    ggplot(data = state_data)
  })
  
  output$county_level_state_map <- renderPlotly({
    my_county <- counties %>% 
      filter(region == tolower(input$state_selector))
    
    my_house_type <- county_data %>% 
    filter(State == state.abb[which(state.name == input$state_selector)])
    my_house_type <- my_house_type[, c("RegionName", input$house_type_county_map)]
    names(my_house_type)[2] <- "prices" 
    
    my_house_type$RegionName <- tolower(my_house_type$RegionName)
    my_house_type$RegionName <- gsub(" county", "", my_house_type$RegionName)
    
    my_county_house_info <- full_join(my_county, my_house_type, by = c("subregion" = "RegionName"))
    Max <- max(my_county_house_info$prices)
    Min <- min(my_county_house_info$prices)
    my_county_house_info$house_price <- cut(my_county_house_info$prices, breaks = c(seq(0, 4500, by = 500)), labels = my_label)
    
    my_county_house_info %>%
      group_by(group) %>%
      plot_ly(
        x = ~long, 
        y = ~lat, 
        color = ~house_price, 
        colors = c('#ffeda0','#f03b20'),
        text = ~subregion, 
        hoverinfo = 'text'
      ) %>%
      add_polygons(
        line = list(width = 0.4)
      ) %>%
      add_polygons(
        fillcolor = 'transparent',
        line = list(color = 'black', width = 0.5),
        showlegend = FALSE, 
        hoverinfo = 'none'
      ) %>%
      layout(
        title = "WA Prices for SFR 2019 by County",
        titlefont = list(size = 15),
        xaxis = list(title = "", showgrid = FALSE,
                     zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(title = "", showgrid = FALSE,
                     zeroline = FALSE, showticklabels = FALSE)
      )
  })
}
