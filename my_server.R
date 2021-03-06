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

county_data <- full_join(c_1bed_edited, c_2bed_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_3bed_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_4bed_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_5bed_plus_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_studio_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_sfr_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_duplex_triplex_edited, by = c("RegionName", "State"), na.rm = FALSE)
county_data <- full_join(county_data, c_condo_coop_edited, by = c("RegionName", "State"), na.rm = FALSE)

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
state_data <- state_data %>% 
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

colors <- c( "#ffeda0", "#fed976", "#feb24c", "#fd8d3c", "#fc4e2a", "#e31a1c", "#b10026")

counties <- map_data("county")

my_label <- c("0-500", "500-1000", "1000-1500", "1500-2000", "2000-2500", "2500-3000", "3000-3500", "3500-4000", "4000-4500")
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
  
  output$plot_one <- renderPlotly({
    if(!is.null(input$type)) {
      cleaned_df <- combined_df[, c("Year", input$type)]
      mean_plot <- plot_one_function(cleaned_df, input$type)
      mean_plot <- mean_plot + labs(
        title = "Years versus Types of houses",
        x = "Months(from 2010.02 - 2019.01)",
        y = "Price"
      ) + 
        theme(axis.title = element_text(size = 12),
              axis.text.x=element_blank())
      mean_plot
    }
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
        title = paste(input$state_selector, "Prices for SFR 2019 by County"),
        titlefont = list(size = 15),
        xaxis = list(title = "", showgrid = FALSE,
                     zeroline = FALSE, showticklabels = FALSE),
        yaxis = list(title = "", showgrid = FALSE,
                     zeroline = FALSE, showticklabels = FALSE)
      )
  })
  
  output$draw_lines <- renderPlotly({
    if(!is.null(input$types)) {
      data_df <- filter_for_state(input$states)
      lines <- draw_lines(data_df, input$types)
      lines <- lines + labs(
        title = "Years versus Types of houses",
        x = "Months(from 2010.02 - 2019.01)",
        y = "Prices"
      ) +
        theme(axis.title = element_text(size = 12),
              axis.text.x=element_blank())
      lines
    }
  })
}

plot_one_function <- function(df, types) {
  mean_plot <- ggplot(data = df)
  index <- 1
  while(index <= length(types)) {
    mean_plot <- mean_plot + 
      geom_point(mapping = aes_string(x = "Year", y = types[index]), 
                color = color_type[match(types[index], type_of_choices)])
    index <- index + 1
  }
  
  mean_plot
}


filter_for_state <- function(state) {
  df <- combined_state_df %>%
    filter(RegionName == state) %>%
    mutate(
      months = 1:108
    )
  df
}

draw_lines <- function(df, types) {
  lines <- ggplot(data = df)
  index <- 1
  while(index <= length(types)) {
    lines <- lines +
  geom_line(mapping = aes_string(x = "months", y = types[index]),
            color = color_type[match(types[index], names_of_selection)])
  index <- index + 1
  }
  lines
}

