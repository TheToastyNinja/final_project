library(dplyr)
library(shiny)
library(ggplot2)
library(tidyr)



my_server <- function(input, output){
  output$plot_one <- renderPlotly({
    mean_plot <- ggplot(data = combined_df,
                        mapping = aes_string(x = "Year", y = one_Bedroom_mean_price)) +
      geom_point()
    mean_plot
  })
}
