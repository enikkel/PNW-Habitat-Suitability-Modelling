## shiny geranium GBIF data download and cleaning ----

install.packages("devtools")
install

# load packages 
library(rgbif)
library(scrubr)
library(maps)
library(dplyr)
library("sp")
library("raster")
library("maptools")
library("rgdal")
library("dismo")

myspecies <- c("Geranium lucidum")
shiny_geranium_gbif <- occ_data(scientificName = myspecies, hasCoordinate = TRUE, hasGeospatialIssue = FALSE, limit = 40000)
shiny_geranium_gbif

# get the columns that matter for mapping and cleaning the occurrence data:   
Geranium_data <- shiny_geranium_gbif$data[ , c("species", "decimalLongitude", "decimalLatitude", "issues", "countryCode", "individualCount", "occurrenceStatus", 
                                               "coordinateUncertaintyInMeters", "institutionCode", "gbifID", "references", "basisOfRecord", 
                                               "year", "month", "day", "eventDate", "geodeticDatum", "datasetName")] 

# map the occurrence data:
map("world", xlim = range(Geranium_data$decimalLongitude), ylim = range(Geranium_data$decimalLatitude))  # if the map doesn't appear right at first, run this command again
points(Geranium_data[ , c("decimalLongitude", "decimalLatitude")], pch = ".")

########## ALTERNATIVE TO 1st MAP ####################
# Determine geographic extent of our data
max.lat <- ceiling(max(Geranium_data$decimalLatitude))
min.lat <- floor(min(Geranium_data$decimalLatitude))
max.lon <- ceiling(max(Geranium_data$decimalLongitude))
min.lon <- floor(min(Geranium_data$decimalLongitude))
geographic.extent <- extent(x = c(min.lon, max.lon, min.lat, max.lat))
# Load the data to use for our base map
data(wrld_simpl)

# Plot the base map
plot(wrld_simpl, 
     xlim = c(min.lon, max.lon),
     ylim = c(min.lat, max.lat),
     axes = TRUE, 
     col = "grey95")

# Add the points for individual observation
points(x = Geranium_data$decimalLongitude, 
       y = Geranium_data$decimalLatitude, 
       col = "olivedrab", 
       pch = 20, 
       cex = 0.75)
# And draw a little box around the graph
box()

#########################################################

### Cleaning the data ----

head(Geranium_data)
# 

# remove records of absence or zero-abundance (if any):
names(Geranium_data)
sort(unique(Geranium_data$individualCount))  # notice if some points correspond to zero abundance
sort(unique(Geranium_data$occurrenceStatus))  # check for different indications of "absent", which could be in different languages! and remember that R is case-sensitive
absence_rows <- which(Geranium_data$individualCount == 0 | Geranium_data$occurrenceStatus %in% c("absent", "Absent", "ABSENT", "ausente", "Ausente", "AUSENTE"))
length(absence_rows)
if (length(absence_rows) > 0) {
  Geranium_data <- Geranium_data[-absence_rows, ]
}

# further data cleaning with functions of the 'scrubr' package (but note this cleaning is not exhaustive!)
nrow(Geranium_data)
Geranium_data <- coord_incomplete(coord_imprecise(coord_impossible(coord_unlikely(Geranium_data))))
nrow(Geranium_data)

# remove rows with NA 