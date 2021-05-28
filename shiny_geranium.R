## shiny geranium GBIF data download and cleaning ----

# load packages 
library(rgbif)
library(scrubr)
library(maps)

myspecies <- c("Geranium lucidum")
shiny_geranium_gbif <- occ_data(scientificName = myspecies, hasCoordinate = TRUE)

                                