######## GBIF filtering template ######## USING OCC_DATA
# with shiny geranium as an example

# install necessary packages
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

##### download data from GBIF #####

myspecies <- c("Geranium lucidum")
shiny_geranium_gbif <- occ_data(scientificName = myspecies, 
                                hasCoordinate = TRUE, 
                                hasGeospatialIssue = FALSE, 
                                limit = 45000) #limit based on estimated available on GBIF website
# to view:
shiny_geranium_gbif

# keep the columns that matter for mapping and cleaning the occurrence data:   
Geranium_data <- shiny_geranium_gbif$data[ , c("species", "decimalLongitude", "decimalLatitude", 
                                               "issues", "countryCode", "individualCount", 
                                               "occurrenceStatus", "coordinateUncertaintyInMeters", 
                                               "institutionCode", "gbifID", "references", "basisOfRecord", 
                                               "year", "month", "day", "eventDate", "geodeticDatum", 
                                               "datasetName")] 

##### Create/view map of raw data points #####

wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = Geranium_data, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

##### Clean records #####

# remove records without coordinates (should not have been included in download but just in case)
# remove rows with N/A 
Geranium_data <- Geranium_data%>%
  filter(!is.na(decimalLongitude))%>%
  filter(!is.na(decimalLatitude))%>%
  filter(!is.na(countryCode))%>%
  filter(!is.na(occurrenceStatus))%>%
  filter(!is.na(coordinateUncertaintyInMeters))%>%
  filter(!is.na(institutionCode))%>%
  filter(!is.na(geodeticDatum))%>%
  filter(occurrenceStatus != "ABSENT") # removes all 'absent' records

# remove records pre-1970 and 2021
Geranium_data <- Geranium_data%>%
  filter(between(year, 1970, 2020))

# can create a histogram of year, month, day of each record to find inconsistencies
hist(Geranium_data$year, breaks = 50)
hist(Geranium_data$month, breaks = 12)
hist(Geranium_data$day, breaks = 31) # substantially more records on the 1st or 31st of a given month

# can also check where the values fall using 'table' function
# for example:
table(Geranium_data$year)

##### Clean using CoordinateCleaner #####

# convert country code from ISO2c to ISO3c (so coordinatecleaner can use it)
Geranium_data$countryCode <-  countrycode(Geranium_data$countryCode, 
                                          origin =  'iso2c', 
                                          destination = 'iso3c') # is this necessary?

# warning message shows unidentified country code XK - remove this record
Geranium_data <- filter(countryCode != "XK")

# to discover all flagged records:
# flag problems OR identify and remove flagged records at the same time *below*
Geranium_data <- data.frame(Geranium_data)
flags <- clean_coordinates(x = Geranium_data, 
                           lon = "decimalLongitude", 
                           lat = "decimalLatitude",
                           countries = "countryCode",
                           species = "species",
                           tests = c("capitals", "centroids", "equal","gbif", "institutions",
                                     "zeros", "countries")) # most test are on by default

# identify and remove flag records at the same time 
# to avoid specifying it in each function:
names(Geranium_data)[2:3] <- c("decimallongitude", "decimallatitude")

Geranium_data_clean <- Geranium_data%>%
  cc_val()%>% # invalid lat/lon coordinates
  cc_equ()%>% # records with identical lat/lon
  cc_cap()%>% # coordinates in vicinity of country capitals
  cc_cen()%>% # coordinates in vicinity of country or probince centroids
  cc_coun(iso3 = "countryCode")%>% #coordinates outside reported country
  cc_gbif()%>% # coordinates assigned to GBIF headquarters
  cc_inst()%>% # coordinates in the vicinity of biodiversity institutions (botanical gardens, universities, museums)
  cc_sea()%>% # identifies non-terrestrial coordinates **
  cc_zero()%>% # coordinates that are zero 
  ## cc_outl()%>% # coordinates that are geographic outliers in species distribution *probably don't use this one!
  cc_dupl() # duplicate records


##### MAP to visualize cleaning so far #####

wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = Geranium_data_clean, aes(x = decimallongitude, y = decimallatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

##### Continue Cleaning #####

# coordinate uncertainty <1000m - to match spatial resolution of 1km or less
Geranium_data_clean <- coord_uncertain(Geranium_data_clean, coorduncertainityLimit = 1000)
nrow(Geranium_data_clean) # how many records are left

# check if there are an 'zero' individual counts through the 'table' function
table(Geranium_data_clean$individualCount) # remove zeros (if applicable) but NAs are ok


##### Split records into training and testing #####

Geranium_data_train <- Geranium_data_clean%>%
  filter(between(year, 1970, 2000)) # leaves 2181 records

Geranium_data_test <- Geranium_data_clean%>%
  filter(between(year, 2001, 2020)) # leaves 4019 records

# can check on map!
# training data:
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = Geranium_data_train, aes(x = decimallongitude, y = decimallatitude),
             colour = "yellow", size = 0.5)+
  theme_bw()

# testing data:
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = Geranium_data_test, aes(x = decimallongitude, y = decimallatitude),
             colour = "orange", size = 0.5)+
  theme_bw()

# check problematic issues (from issues column)
Geranium_data_clean %>%
  occ_issues(bri) ### CANNOT FILTER FROM HERE *see other script using occ_search

# write to a csv file to save dataset (and xlsx file?)
write.csv(Geranium_data_clean, "Geranium_data_clean.csv")
write.csv(Geranium_data_train, "Geranium_data_train.csv")
write.csv(Geranium_data_test, "Geranium_data_test.csv")

install.packages("xlsx")
library(xlsx)
write.xlsx(Geranium_data_clean, file = "Geranium_data_clean.xlsx")
write.xlsx(Geranium_data_train, file = "Geranium_data_train.xlsx")
write.xlsx(Geranium_data_test, file = "Geranium_data_test.xlsx")
