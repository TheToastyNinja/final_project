library(dplyr)
library(shiny)
library(ggplot2)
library(tidyr)



my_server <- function(input, output){
  output$raph_Demonstration <- renderText({
    mess <- paste0("HAHAHAH", input$name)
    mess
  })
}
