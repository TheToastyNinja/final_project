library(dplyr)
library(shiny)
library(ggplot2)
library(tidyr)
library(maps)
library(plotly)
#----------------joining data frames------------------------------
change_colnames_county <- function(df){
  colnames(df)[7:length(colnames(df))] <- paste0(substr(deparse(substitute(df)),3, nchar(deparse(substitute(df)))), "_", substr(colnames(df)[7:length(colnames(df))], 2, nchar(colnames(df)[7:length(colnames(df))])))
  df
}

change_colnames_state <- function(df){
  colnames(df)[3:length(colnames(df))] <- paste0(substr(deparse(substitute(df)),3, nchar(deparse(substitute(df)))), "_", substr(colnames(df)[3:length(colnames(df))], 2, nchar(colnames(df)[3:length(colnames(df))])))
  df
}

c_one_bed <- read.csv("data/County_MedianRentalPrice_1Bedroom.csv", stringsAsFactors = FALSE)
c_two_bed <- read.csv("data/County_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
c_three_bed <- read.csv("data/County_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
c_four_bed <- read.csv("data/County_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
c_five_bed_plus <- read.csv("data/County_MedianRentalPrice_5BedroomOrMore.csv", stringsAsFactors = FALSE)
c_studio <- read.csv("data/County_MedianRentalPrice_Studio.csv", stringsAsFactors = FALSE)
c_sfr <- read.csv("data/County_MedianRentalPrice_Sfr.csv", stringsAsFactors = FALSE)
c_duplex_triplex <- read.csv("data/County_MedianRentalPrice_DuplexTriplex.csv", stringsAsFactors = FALSE)
c_condo_coop <- read.csv("data/County_MedianRentalPrice_CondoCoop.csv", stringsAsFactors = FALSE)

c_1bed_edited <- change_colnames_county(c_one_bed)
c_2bed_edited <- change_colnames_county(c_two_bed)
c_3bed_edited <- change_colnames_county(c_three_bed)
c_4bed_edited <- change_colnames_county(c_four_bed)
c_5bed_plus_edited <- change_colnames_county(c_five_bed_plus)
c_studio_edited <- change_colnames_county(c_studio)
c_sfr_edited <- change_colnames_county(c_sfr)
c_duplex_triplex_edited <- change_colnames_county(c_duplex_triplex)
c_condo_coop_edited <- change_colnames_county(c_condo_coop)


county_data <- left_join(c_1bed_edited, c_2bed_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_3bed_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_4bed_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_5bed_plus_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_studio_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_sfr_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_duplex_triplex_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_condo_coop_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
#------------------------------------states--------------------------------
s_one_bed <- read.csv("data/State_MedianRentalPrice_1Bedroom.csv", stringsAsFactors = FALSE)
s_two_bed <- read.csv("data/State_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
s_three_bed <- read.csv("data/State_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
s_four_bed <- read.csv("data/State_MedianRentalPrice_2Bedroom.csv", stringsAsFactors = FALSE)
s_five_bed_plus <- read.csv("data/State_MedianRentalPrice_5BedroomOrMore.csv", stringsAsFactors = FALSE)
s_studio <- read.csv("data/State_MedianRentalPrice_Studio.csv", stringsAsFactors = FALSE)
s_sfr <- read.csv("data/State_MedianRentalPrice_Sfr.csv", stringsAsFactors = FALSE)
s_duplex_triplex <- read.csv("data/State_MedianRentalPrice_DuplexTriplex.csv", stringsAsFactors = FALSE)
s_condo_coop <- read.csv("data/State_MedianRentalPrice_CondoCoop.csv", stringsAsFactors = FALSE)

s_1bed_edited <- change_colnames_state(s_one_bed)
s_2bed_edited <- change_colnames_state(s_two_bed)
s_3bed_edited <- change_colnames_state(s_three_bed)
s_4bed_edited <- change_colnames_state(s_four_bed)
s_5bed_plus_edited <- change_colnames_state(s_five_bed_plus)
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
state_data <- state_data%>% 
  mutate(
    RegionName = tolower(RegionName)
  )
usa <- map_data("state")
state_map_data <- left_join(state_data, usa, by = c("RegionName" = "region"))

my_labels <- c("0-500", "500-1000", "1000-1500", "1500-2000", "2000-2500", "2500-3000", "3000-3500")

get_interval <- function(house_type) {
  interval = cut(unlist(state_map_data[,house_type]), breaks = c(0, 500, 1000, 1500, 2000, 2500, 3000, 3500), labels = my_labels)
  interval
}

test <- state_map_data %>% 
  mutate(
    interval = interval_vec
  )
colors <- c( "#ffeda0", "#fed976", "#feb24c", "#fd8d3c", "#fc4e2a", "#e31a1c", "#b10026")


#----------------------------------------------------------------


my_server <- function(input, output){
  output$country_map <- renderPlot({
    df <- state_map_data %>% 
      mutate(
        interval = get_interval(input$house_type)
      )
     ggplot(df) +
      geom_polygon(
        mapping = aes_string(x = "long", y = "lat", group = "group", fill = "interval"),
        color = "black",
        size = .1
      ) +
      coord_map() +
      labs(fill = "Rent($)")+
      theme(
      axis.title.x=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks.x=element_blank(),
      axis.title.y=element_blank(),
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank(),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank()) +
      scale_fill_manual(values = colors, na.value = "grey")
  })
 
  
  
  
  
}
