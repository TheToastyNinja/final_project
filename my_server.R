library(dplyr)
library(shiny)
library(ggplot2)
library(tidyr)
#----------------joining data frames------------------------------
change_colnames_county <- function(df){
  colnames(df)[7:length(colnames(df))] <- paste0(substr(deparse(substitute(df)),3, nchar(deparse(substitute(df)))), "_", substr(colnames(df)[7:length(colnames(df))], 2, nchar(colnames(df)[7:length(colnames(df))])))
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




c_1bed_edited <- change_colnames(c_1bed)
c_2bed_edited <- change_colnames_county(c_2bed)
c_3bed_edited <- change_colnames_county(c_3bed)
c_4bed_edited <- change_colnames_county(c_4bed)
c_5bed_plus_edited <- change_colnames_county(c_5bed_plus)
c_studio_edited <- change_colnames_county(c_studio)
c_sfr_edited <- change_colnames_county(c_sfr)
c_duplex_triplex_edited <- change_colnames_county(c_duplex_triplex)
c_condo_coop_edited <- change_colnames_county(c_condo_coop)

ncol(change_colnames(c_1bed))
ncol(change_colnames_county(c_2bed))
ncol(change_colnames_county(c_3bed))
ncol(change_colnames_county(c_4bed))
ncol(change_colnames_county(c_5bed_plus))
ncol(change_colnames_county(c_studio))
ncol(change_colnames_county(c_sfr))
ncol(change_colnames_county(c_duplex_triplex))
ncol(change_colnames_county(c_condo_coop))

county_data <- left_join(c_1bed_edited, c_2bed_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_3bed_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_4bed_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_5bed_plus_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_studio_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_sfr_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_duplex_triplex_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))
county_data <- left_join(county_data, c_condo_coop_edited, by = c("RegionName", "State", "Metro", "StateCodeFIPS", "MunicipalCodeFIPS", "SizeRank"))

View(county_data)

#------------------------------------------------------------------


my_server <- function(input, output){
  
}
