## shiny geranium GBIF data download and cleaning ----

# load packages 
library(rgbif)
library(scrubr)
library(maps)
library(dplyr)

myspecies <- c("Geranium lucidum")
shiny_geranium_gbif <- occ_data(scientificName = myspecies, hasCoordinate = TRUE, hasGeospatialIssue = FALSE, limit = 40000)
shiny_geranium_gbif
   
Geranium_data <- shiny_geranium_gbif$data[ , c("decimalLongitude", "decimalLatitude", "issues", "individualCount", "occurrenceStatus", 
                                               "coordinateUncertaintyInMeters", "institutionCode", "references", "basisOfRecord", 
                                               "year", "month", "day", "eventDate", "geodeticDatum")] 

                                