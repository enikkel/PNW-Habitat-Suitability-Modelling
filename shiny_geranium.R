## shiny geranium GBIF data download and cleaning ----

install.packages("devtools")
install.packages("CoordinateCleaner")
install.packages("countrycode")
install.packages("rnaturalearthdata")

# load packages 
library(rgbif)
library(scrubr)
library(maps)
library(dplyr)
library(sp)
library(raster)
library(maptools)
library(rgdal)
library(dismo)
library(countrycode)
library(CoordinateCleaner)
library(ggplot2)
library(devtools)

myspecies <- c("Geranium lucidum")
shiny_geranium_gbif <- occ_data(scientificName = myspecies, hasCoordinate = TRUE, hasGeospatialIssue = FALSE, limit = 40000)
shiny_geranium_gbif

# get the columns that matter for mapping and cleaning the occurrence data:   
Geranium_data <- shiny_geranium_gbif$data[ , c("species", "decimalLongitude", "decimalLatitude", "issues", "countryCode", "individualCount", "occurrenceStatus", 
                                               "coordinateUncertaintyInMeters", "institutionCode", "gbifID", "references", "basisOfRecord", 
                                               "year", "month", "day", "eventDate", "geodeticDatum", "datasetName")] 

# remove records without coordinates
Geranium_data <- Geranium_data%>%
  filter(!is.na(decimalLongitude))%>%
  filter(!is.na(decimalLatitude))

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

############ALTERNATE MAP 2#############################################
#plot data to get an overview
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = Geranium_data, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

### Cleaning the data ----

head(Geranium_data)
# using CoordinateCleaner
#convert country code from ISO2c to ISO3c (so coordinatecleaner can use it)
Geranium_data$countryCode <-  countrycode(Geranium_data$countryCode, origin =  'iso2c', destination = 'iso3c')

#flag problems
Geranium_data <- data.frame(Geranium_data)
flags <- clean_coordinates(x = Geranium_data, 
                           lon = "decimalLongitude", 
                           lat = "decimalLatitude",
                           countries = "countryCode",
                           species = "species",
                           tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                     "zeros", "countries")) # most test are on by default
# to remove all flagged results
#to avoid specifying it in each function
names(Geranium_data)[2:3] <- c("decimallongitude", "decimallatitude")

clean <- Geranium_data%>%
  cc_val()%>%
  cc_equ()%>%
  cc_cap()%>%
  cc_cen()%>%
  cc_coun(iso3 = "countryCode")%>%
  cc_gbif()%>%
  cc_inst()%>%
  cc_sea()%>%
  cc_zero()%>%
  cc_outl()%>%
  cc_dupl()
# rename
Geranium_data_clean <- clean
# replot world map
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = Geranium_data_clean, aes(x = decimallongitude, y = decimallatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

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

# coordinate uncertainty <1000m
Geranium_data_clean <- coord_uncertain(Geranium_data_clean, coorduncertainityLimit = 1000)
nrow(Geranium_data_clean)

# remove rows with NA 