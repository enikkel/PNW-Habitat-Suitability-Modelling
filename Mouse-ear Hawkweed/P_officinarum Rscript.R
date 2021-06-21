######## GBIF filtering template ######## USING OCC_SEARCH

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


##### download data from GBIF as excel sheet#####

## data (191,324 records) exceeds limit (= 100001) so must be downloaded as two packages
myspecies <- c("Pilosella officinarum")
hawkweed_pt1 <- occ_search(scientificName = myspecies,
                           limit = 100001,
                           hasCoordinate = TRUE,
                           hasGeospatialIssue = FALSE,
                           year ='2005,2020') # retrieves 99809 records
hawkweed_pt2 <- occ_search(scientificName = myspecies,
                            hasCoordinate = TRUE,
                            hasGeospatialIssue = FALSE,
                            year ='1970,2004') # retrieves 91515 records


# needs to stay in this format until 'issues' have been dealt with
## could not find a method to combine in this form so both datasets were dealt with separately
# to search for issues:
hawkweed_pt1 %>% occ_issues(cdiv)
hawkweed_pt2 %>% occ_issues(cdiv)

# to remove records with specific issues:
hawkweed_pt1_issues_clean <- hawkweed_pt1 %>%
  occ_issues(-bri, -ccm, -cdiv, -cdout, -cdpi, -cdrepf, -cdreps,
             -cdumi, -conti, -cucdmis, -cum, -gdativ, -geodi, 
             -geodu, -iccos, -iddativ, -iddatunl, -indci, -mdativ, 
             -mdatunl, -osifbor, -osu, -preneglat, -preneglon, 
             -preswcd, -rdativ, -rdatm, -rdatunl, -typstativ, 
             -zerocd)
hawkweed_pt2_issues_clean <- hawkweed_pt2 %>%
  occ_issues(-bri, -ccm, -cdiv, -cdout, -cdpi, -cdrepf, -cdreps,
             -cdumi, -conti, -cucdmis, -cum, -gdativ, -geodi, 
             -geodu, -iccos, -iddativ, -iddatunl, -indci, -mdativ, 
             -mdatunl, -osifbor, -osu, -preneglat, -preneglon, 
             -preswcd, -rdativ, -rdatm, -rdatunl, -typstativ, 
             -zerocd)


# keep the columns that matter for mapping and cleaning the occurrence data:   
hawkweed_pt1 <- hawkweed_pt1_issues_clean$data[ , c("species", "decimalLongitude", "decimalLatitude", 
                                                      "issues", "countryCode", "individualCount", 
                                                      "occurrenceStatus", "coordinateUncertaintyInMeters", 
                                                      "institutionCode", "gbifID", "references", "basisOfRecord", 
                                                      "year", "month", "day", "eventDate", "geodeticDatum", 
                                                      "datasetName", "catalogNumber")] 

hawkweed_pt2 <- hawkweed_pt2_issues_clean$data[ , c("species", "decimalLongitude", "decimalLatitude", 
                                                      "issues", "countryCode", "individualCount", 
                                                      "occurrenceStatus", "coordinateUncertaintyInMeters", 
                                                      "institutionCode", "gbifID", "references", "basisOfRecord", 
                                                      "year", "month", "day", "eventDate", "geodeticDatum", 
                                                      "datasetName")] 


## create merged dataset containing all occurences 1970 - 2020
officinarum_data <- rbind(hawkweed_pt1, hawkweed_pt2) # creates dataset with 188377 occurences


##### Create/view map of raw data points #####

wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = officinarum_data, aes(x = decimalLongitude, y = decimalLatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()

##### Clean records #####

# remove records without coordinates (should not have been included in download but just in case)
# remove rows with N/A 
officinarum_data <- officinarum_data%>%
  filter(!is.na(decimalLongitude))%>%
  filter(!is.na(decimalLatitude))%>%
  filter(!is.na(countryCode))%>%
  filter(!is.na(occurrenceStatus))%>%
  filter(!is.na(coordinateUncertaintyInMeters))%>%
  filter(!is.na(institutionCode))%>%
  filter(!is.na(geodeticDatum))%>%
  filter(occurrenceStatus != "ABSENT") # removes all 'absent' records

# remove records pre-1970 and 2021
## already done in initial data pull, however no harm in a repeat 
officinarum_data <- officinarum_data%>%
  filter(between(year, 1970, 2020))

# can create a histogram of year, month, day of each record to find inconsistencies
hist(officinarum_data$year, breaks = 50)
hist(officinarum_data$month, breaks = 12)
hist(officinarum_data$day, breaks = 31) # substantially more records on the 1st or 31st of a given month

# can also check where the values fall using 'table' function
# for example:
table(officinarum_data$year)

##### Clean using CoordinateCleaner #####

# convert country code from ISO2c to ISO3c (so coordinatecleaner can use it)
officinarum_data$countryCode <-  countrycode(officinarum_data$countryCode, 
                                          origin =  'iso2c', 
                                          destination = 'iso3c')

# identify and remove flag records at the same time 
# to avoid specifying it in each function:
names(officinarum_data)[2:3] <- c("decimallongitude", "decimallatitude")

officinarum_data_clean <- officinarum_data%>%
  cc_val()%>% # invalid lat/lon coordinates
  cc_equ()%>% # records with identical lat/lon
  cc_cap()%>% # coordinates in vicinity of country capitals
  cc_cen()%>% # coordinates in vicinity of country or probince centroids
  cc_coun(iso3 = "countryCode")%>% #coordinates outside reported country
  cc_gbif()%>% # coordinates assigned to GBIF headquarters
  cc_inst()%>% # coordinates in the vicinity of biodiversity institutions (botanical gardens, universities, museums)
  cc_sea()%>% # identifies non-terrestrial coordinates **
  cc_zero()%>% # coordinates that are zero 
  cc_dupl() # duplicate records

##### MAP to visualize cleaning so far #####

wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = officinarum_data_clean, aes(x = decimallongitude, y = decimallatitude),
             colour = "pink", size = 0.5)+
  theme_bw()

##### Continue Cleaning #####

# coordinate uncertainty <1000m - to match spatial resolution of 1km or less
officinarum_data_clean <- coord_uncertain(officinarum_data_clean, coorduncertainityLimit = 1000)
nrow(officinarum_data_clean) # how many records are left

# check if there are an 'zero' individual counts through the 'table' function
table(officinarum_data_clean$individualCount) # remove zeros (if applicable) but NAs are ok


##### Split records into training and testing #####

officinarum_data_train <- officinarum_data_clean%>%
  filter(between(year, 1970, 2000)) # leaves 4860 records 

officinarum_data_test <- officinarum_data_clean%>%
  filter(between(year, 2001, 2020)) # leaves 12963 records 

# can check on map!
# training data:
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = officinarum_data_train, aes(x = decimallongitude, y = decimallatitude),
             colour = "yellow", size = 0.5)+
  theme_bw()

# testing data:
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = officinarum_data_test, aes(x = decimallongitude, y = decimallatitude),
             colour = "orange", size = 0.5)+
  theme_bw()

# write to a csv file to save dataset (and xlsx file?)
write.csv(Geranium_data_clean, "officinarum_data_clean.csv")
write.csv(Geranium_data_train, "officinarum_data_train.csv")
write.csv(Geranium_data_test, "officinarum_data_test.csv")
