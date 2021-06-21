######## GBIF filtering template ######## USING OCC_SEARCH
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

myspecies <- c("Butomus umbellatus")
umbellatus_search <- occ_search(scientificName = myspecies, 
                                        hasCoordinate = TRUE, 
                                        hasGeospatialIssue = FALSE, 
                                        limit = 79000) #limit based on estimated available on GBIF website

# needs to stay in this format until 'issues' have been dealt with
# to search for issues:
umbellatus_search %>% 
  occ_issues(cdiv)
# to remove records with specific issues:
umbellatus_issues_clean <- umbellatus_search %>%
  occ_issues(-bri, -ccm, -cdiv, -cdout, -cdpi, -cdrepf, -cdreps,
             -cdumi, -conti, -cucdmis, -cum, -gdativ, -geodi, 
             -geodu, -iccos, -iddativ, -iddatunl, -indci, -mdativ, 
             -mdatunl, -osifbor, -osu, -preneglat, -preneglon, 
             -preswcd, -rdativ, -rdatm, -rdatunl, -typstativ, 
             -zerocd)

# keep the columns that matter for mapping and cleaning the occurrence data:   
umbellatus_data <- umbellatus_issues_clean$data[ , c("species", "decimalLongitude", "decimalLatitude", 
                                                      "issues", "countryCode", "individualCount", 
                                                      "occurrenceStatus", "coordinateUncertaintyInMeters", 
                                                      "institutionCode", "gbifID", "references", "basisOfRecord", 
                                                      "year", "month", "day", "eventDate", "geodeticDatum", 
                                                      "datasetName", "catalogNumber")]

##### Create/view map of raw data points #####

wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = umbellatus_data, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

##### Clean records #####

# remove records without coordinates (should not have been included in download but just in case)
# remove rows with N/A 
umbellatus_data <- umbellatus_data%>%
  filter(!is.na(decimalLongitude))%>%
  filter(!is.na(decimalLatitude))%>%
  filter(!is.na(countryCode))%>%
  filter(!is.na(occurrenceStatus))%>%
  filter(!is.na(coordinateUncertaintyInMeters))%>%
  filter(!is.na(institutionCode))%>%
  filter(!is.na(geodeticDatum))%>%
  filter(occurrenceStatus != "ABSENT") # removes all 'absent' records

# remove records pre-1970 and 2021
umbellatus_data <- umbellatus_data%>%
  filter(between(year, 1970, 2020))

# can create a histogram of year, month, day of each record to find inconsistencies
hist(umbellatus_data$year, breaks = 50)
hist(umbellatus_data$month, breaks = 12)
hist(umbellatus_data$day, breaks = 31) # substantially more records on the 1st or 31st of a given month

# can also check where the values fall using 'table' function
# for example:
table(umbellatus_data$year)

##### Clean using CoordinateCleaner #####

# convert country code from ISO2c to ISO3c (so coordinatecleaner can use it)
umbellatus_data$countryCode <-  countrycode(umbellatus_data$countryCode, 
                                          origin =  'iso2c', 
                                          destination = 'iso3c') 
# warning message shows unidentified country code XK - remove this record
umbellatus_data <- filter(countryCode != "XK")

# identify and remove flag records at the same time 
# to avoid specifying it in each function:
names(umbellatus_data)[2:3] <- c("decimallongitude", "decimallatitude")

umbellatus_data_clean <- umbellatus_data%>%
  cc_val()%>% # invalid lat/lon coordinates
  cc_equ()%>% # records with identical lat/lon
  cc_cap()%>% # coordinates in vicinity of country capitals
  cc_cen()%>% # coordinates in vicinity of country or probince centroids
  cc_coun(iso3 = "countryCode")%>% #coordinates outside reported country
  cc_gbif()%>% # coordinates assigned to GBIF headquarters
  cc_inst()%>% # coordinates in the vicinity of biodiversity institutions (botanical gardens, universities, museums)
  cc_zero()%>% # coordinates that are zero 
  cc_dupl() # duplicate records

##### MAP to visualize cleaning so far #####

wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = umbellatus_data_clean, aes(x = decimallongitude, y = decimallatitude),
             colour = "pink", size = 0.5)+
  theme_bw()

##### Continue Cleaning #####

# coordinate uncertainty <1000m - to match spatial resolution of 1km or less
umbellatus_data_clean <- coord_uncertain(umbellatus_data_clean, coorduncertainityLimit = 1000)
nrow(umbellatus_data_clean) # leaves 11249 records

# check if there are an 'zero' individual counts through the 'table' function
table(umbellatus_data_clean$individualCount) # remove zeros (if applicable) but NAs are ok

##### Split records into training and testing #####

umbellatus_data_train <- umbellatus_data_clean%>%
  filter(between(year, 1970, 2000)) # leaves 3392 records 

umbellatus_data_test <- umbellatus_data_clean%>%
  filter(between(year, 2001, 2020)) # leaves 7857 records 

# can check on map!
# training data:
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = umbellatus_data_train, aes(x = decimallongitude, y = decimallatitude),
             colour = "yellow", size = 0.5)+
  theme_bw()

# testing data:
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = umbellatus_data_test, aes(x = decimallongitude, y = decimallatitude),
             colour = "orange", size = 0.5)+
  theme_bw()

# write to a csv file to save dataset (and xlsx file?)
write.csv(umbellatus_data_clean, "umbellatus_data__clean.csv")
write.csv(umbellatus_data_train, "umbellatus_data__train.csv")
write.csv(umbellatus_data_test, "umbellatus_data__test.csv")

