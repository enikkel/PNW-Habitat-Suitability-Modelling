### GBIF filtering template
# with shiny geranium as an example

# install necessary packages
install.packages("devtools")
install.packages("CoordinateCleaner")
install.packages("countrycode")
install.packages("rnaturalearthdata")
install.packages("maps")
install.packages("spThin")

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
library(spThin)
library(sf)
library(data.table)
library(tidyverse)

## download data from GBIF
species <- "Eichhornia crassipes"
hyacinth.search <- occ_search(scientificName = species, 
                              hasCoordinate = TRUE, 
                              hasGeospatialIssue = FALSE,
                              limit = 21000)

# needs to stay in this format until 'issues' have been dealt with
# to search for issues
hyacinth.search %>% 
  occ_issues(cdiv)
# to remove records with specific issues:
hyacinth.issues.clean <- hyacinth.search %>%
  occ_issues(-bri, -ccm, -cdiv, -cdout, -cdpi, -cdrepf, -cdreps,
             -cdumi, -conti, -cucdmis, -cum, -gdativ, -geodi, 
             -geodu, -iccos, -iddativ, -iddatunl, -indci, -mdativ, 
             -mdatunl, -osifbor, -osu, -preneglat, -preneglon, 
             -preswcd, -rdativ, -rdatm, -rdatunl, -typstativ, 
             -zerocd)

# keep the columns that matter for mapping and cleaning the occurrence data:   
hyacinth.data <- hyacinth.issues.clean$data[ , c("species", "decimalLongitude", "decimalLatitude", 
                                                 "issues", "countryCode", "individualCount", 
                                                 "occurrenceStatus", "coordinateUncertaintyInMeters", 
                                                 "institutionCode", "gbifID", "references", "basisOfRecord", 
                                                 "year", "month", "day", "eventDate", "geodeticDatum", 
                                                 "datasetName", "scientificName", "catalogNumber")]

# Create/view map of raw data points 
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = hyacinth.data, aes(x = decimallongitude, y = decimallatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()+
  print(ggtitle("Hyacinth Occurrences GBIF Raw Data"))

## Clean records 
# remove records without coordinates (should not have been included in download but just in case)
# remove rows with N/A 
hyacinth.data <- hyacinth.data%>%
  filter(!is.na(decimalLongitude))%>%
  filter(!is.na(decimalLatitude))%>%
  filter(!is.na(countryCode))%>%
  filter(!is.na(occurrenceStatus))%>%
  filter(!is.na(coordinateUncertaintyInMeters))%>%
  filter(!is.na(institutionCode))%>%
  filter(!is.na(geodeticDatum))%>%
  filter(occurrenceStatus != "ABSENT") # removes all 'absent' records

# remove records pre-1970 and 2021
hyacinth.data <- hyacinth.data%>%
  filter(between(year, 1970, 2020))

## Clean using CoordinateCleaner
# convert country code from ISO2c to ISO3c (so coordinatecleaner can use it)
hyacinth.data$countryCode <-  countrycode(hyacinth.data$countryCode, 
                                          origin =  'iso2c', 
                                          destination = 'iso3c') # is this necessary?

# identify and remove flag records at the same time 
# to avoid specifying it in each function
names(hyacinth.data)[2:3] <- c("decimallongitude", "decimallatitude")

hyacinth.data.clean <- hyacinth.data%>%
  cc_val()%>% # invalid lat/lon coordinates
  cc_equ()%>% # records with identical lat/lon
  cc_cap()%>% # coordinates in vicinity of country capitals
  cc_cen()%>% # coordinates in vicinity of country or probince centroids
  cc_coun(iso3 = "countryCode")%>% #coordinates outside reported country
  cc_gbif()%>% # coordinates assigned to GBIF headquarters
  cc_inst()%>% # coordinates in the vicinity of biodiversity institutions (botanical gardens, universities, museums)
  cc_sea()%>% # identifies non-terrestrial coordinates *******************************
  cc_zero()%>% # coordinates that are zero 
  ## cc_outl()%>% # coordinates that are geographic outliers in species distribution *probably don't use this one!
  cc_dupl() # duplicate records

# coordinate uncertainty <1000m - to match spatial resolution of 1km or less
hyacinth.data.clean <- coord_uncertain(hyacinth.data.clean, coorduncertainityLimit = 1000)
nrow(hyacinth.data.clean) # leaves 1987 records

# check if there are an 'zero' individual counts through the 'table' function
table(hyacinth.data.clean$individualCount) # remove zeros (if applicable) but NAs are ok

# create map to visualize cleaning
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = hyacinth.data.clean, aes(x = decimallongitude, y = decimallatitude),
             colour = "darkred", size = 0.5)+
  theme_bw()+
  print(ggtitle("Cleaned GBIF Hyacinth Occurrences"))

## Split records into training and testing
hyacinth.data.train <- hyacinth.data.clean%>%
  filter(between(year, 1970, 2000)) # leaves 42 records
hyacinth.data.test <- hyacinth.data.clean%>%
  filter(between(year, 2001, 2020)) # leaves 1945

# map training data
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = hyacinth.data.train, aes(x = decimallongitude, y = decimallatitude),
             colour = "yellow", size = 0.5)+
  theme_bw()+
  print(ggtitle("Train Hyacinth Occurrences"))

# map testing data
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = hyacinth.data.test, aes(x = decimallongitude, y = decimallatitude),
             colour = "orange", size = 0.5)+
  theme_bw()+
  print(ggtitle("Test Hyacinth Occurrences"))

# write to a csv file to save dataset
write.csv(hyacinth.data.clean, "hyacinth.data.clean.csv")
write.csv(hyacinth.data.train, "hyacinth.data.train.csv")
write.csv(hyacinth.data.test, "hyacinth.data.test.csv")


#### Downscaling GBIF ####
# thin dataset to one occurrence/1km
hyacinth.thin <- thin(hyacinth.data.clean, lat.col = "decimallatitude", 
                         long.col = "decimallongitude", spec.col = "species", 
                         thin.par = 1, reps = 1, locs.thinned.list.return = TRUE, write.files = TRUE, 
                         max.files = 1, out.dir = "C:\\Users\\Delia Anderson\\Desktop\\SDM 2021", 
                         out.base = "hyacinth.thinned") # thin par is in km
hyacinth.thin <- setDT(hyacinth.thin[[1]])

wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = hyacinth.thin, aes(x = Longitude, y = Latitude),
             colour = "orange", size = 0.5)+
  theme_bw()+
  print(ggtitle("Thinned GBIF Hyacinth Occurrences"))

#### load EDDMaps geopackage by layers ####
linelayer <- st_read("E:\\SDM 2021\\GIS maps\\QGIS files\\Water Hyacinth\\Water Hyacinth EDDMaps\\observations.gpkg", 
                     layer = "Linelayer",type = 0, promote_to_multi = TRUE, stringsAsFactors = FALSE, as_tibble = TRUE)
pointlayer <- st_read("E:\\SDM 2021\\GIS maps\\QGIS files\\Water Hyacinth\\Water Hyacinth EDDMaps\\observations.gpkg", 
                      layer = "Pointlayer", type = 0, promote_to_multi = TRUE, stringsAsFactors = FALSE, as_tibble = TRUE)
polygonlayer <- st_read("E:\\SDM 2021\\GIS maps\\QGIS files\\Water Hyacinth\\Water Hyacinth EDDMaps\\observations.gpkg",
                        layer = "Polygonlayer", type = 0, promote_to_multi = TRUE, stringsAsFactors = FALSE, as_tibble = TRUE)

# visualize geopackage layers
plot(pointlayer, max.plot = 1)
plot(linelayer, max.plot = 1)
plot(polygonlayer, max.plot = 1)

# remove irrelevant columns
pointlayer <- pointlayer[ , c("SciName", "OccStatus", "Status", "ObsDate", "Latitude", "Longitude", "CoordAcc")]
polygonlayer <- polygonlayer[ , c("SciName", "OccStatus", "Status", "ObsDate", "Latitude", "Longitude", "CoordAcc")]
linelayer <- linelayer[ , c("SciName", "OccStatus", "Status", "ObsDate", "Latitude", "Longitude", "CoordAcc")]

# transform line and polygon layers into multipoint data
polygon.points <- st_cast(polygonlayer, "MULTIPOINT")
line.points <- st_cast(linelayer, "MULTIPOINT")
points <- st_cast(pointlayer, "MULTIPOINT")

# join EDDMaps layers
EDD.points <- dplyr::bind_rows(polygon.points, line.points, points)

#convert x,y variable to numeric
EDD.points$Latitude <- as.numeric(EDD.points$Latitude)
EDD.points$Longitude <- as.numeric(EDD.points$Longitude) 

#visualize transformed layers
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = EDD.points, aes(x = Longitude, y = Latitude),
             colour = "black", size = 0.5)+
  theme_bw()+
  print(ggtitle("EDDMaps Hyacinth Occurrences Raw Data"))

# filter N/A values
EDD.points <- EDD.points%>%
  filter(!is.na(Longitude))%>%
  filter(!is.na(Latitude))%>%
  filter(!is.na(OccStatus))%>%
  filter(!is.na(SciName))%>%
  filter(!is.na(ObsDate))%>%
  filter(Status != "Negative") # removes negative locations

# convert to dataframe 
EDD.points <- as.data.frame(EDD.points)
EDD.points <- subset(EDD.points, select = -c(shape))

# write CSV to edit outside of R
write.csv(EDD.points, "EDD.points.csv")

##########################################################################################################################

# Open in excel, create new column labelled 'year and add the year for each occurrence as taken from the 'ObsDate' column 
# Save as 'EDD.points.yr.csv'

##########################################################################################################################

# import edited csv into R
EDD.points <- read.csv("C:\\Users\\Delia Anderson\\Desktop\\EDD.points.yr.csv")

# filter between 1970 - 2020 and CoordAcc < 1000m
EDD.points <- EDD.points%>%
  filter(between(Year, 1970, 2020))%>%
  filter(is.na(CoordAcc) | CoordAcc <=1000)

# thin EDDMaps layers
EDD.thin <- thin(as.data.frame(EDD.points), lat.col = "Latitude", 
                         long.col = "Longitude", spec.col = "SciName", 
                         thin.par = 1, reps = 1, locs.thinned.list.return = TRUE, write.files = TRUE, 
                         max.files = 1, out.dir = "C:\\Users\\Delia Anderson\\Desktop\\SDM 2021", 
                         out.base = "EDD.thin")
EDD.thin <- setDT(EDD.thin[[1]])

# visualize
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = EDD.thin, aes(x = Longitude, y = Latitude),
             colour = "black", size = 0.5)+
  theme_bw()+
  print(ggtitle("Thinned EDD Hyacinth Occurrences"))

# combine thinned datasets and do final thin
occurrences.thin <- rbind(hyacinth.thin, EDD.thin)
occurrences.thin$SciName <- "Eicchornia crassipes"
occurrences.thin <- thin(as.data.frame(occurrences.thin), lat.col = "Latitude", 
                       long.col = "Longitude", spec.col = "SciName", 
                       thin.par = 1, reps = 1, locs.thinned.list.return = TRUE, write.files = TRUE, 
                       max.files = 1, out.dir = "C:\\Users\\Delia Anderson\\Desktop\\SDM 2021", 
                       out.base = "occurr.thin")
occurrences.thin <- setDT(occurrences.thin[[1]]) 

# visualize
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = occurrences.thin, aes(x = Longitude, y = Latitude),
             colour = "darkblue", size = 0.5)+
  theme_bw()+
  print(ggtitle("All Thinned Hyacinth Occurrences"))

#### start water buffer cleaning ####
# import WAT_2000 raster from Harmoized world soils and reproject to ESPG:4326
WATER = raster("C:\\Users\\Delia Anderson\\Desktop\\SDM 2021\\Rstudio data\\water_bodies.asc")
projection(WATER) <- 4326

# extract values using bilinear method 
WAT.extract <- as.data.frame(raster::extract(WATER, occurrences.thin, method = 'bilinear'))

# merge extract values and x,y coordinates
occurrences.plus.water <- cbind(WAT.extract, occurrences.thin)

# rename water extract values column
occurrences.plus.water <- rename(occurrences.plus.water, 'water' = 'raster::extract(WATER, occurrences.thin, method = "bilinear")')
# filter out occurrences without water value
occurrences.plus.water <- occurrences.plus.water%>%
  filter(water != "0")
# visualize
wm <- borders("world", colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = occurrences.plus.water, aes(x = Longitude, y = Latitude),
             colour = "darkblue", size = 0.5)+
  theme_bw()+
  print(ggtitle("Hyacinth Occurrences Water Buffer Clean"))

# write csv
write.csv(occurrences.plus.water, "Hyacinth.full.clean.csv")

# import raster
climateNA <- raster("C:\\Users\\Delia Anderson\\Downloads\\Normal_1981_2010_MAT.tif")

# reproject climate NA using projectRaster to transform CRS rather than set using projection()<-
climate <- projectRaster(climateNA, WATER)
crs(climate)
plot(climate)
points(occurrences.plus.water$Longitude, occurrences.plus.water$Latitude)

# assign climate values to occurrences and merge lat/lon and value datasets
hyacinth.NA <- occurrences.plus.water[ ,c("Longitude", "Latitude")]
climate.extract <- as.data.frame(raster::extract(climate, hyacinth.NA))
hyacinth.NA <- cbind(hyacinth.NA, climate.extract)

# filter N/A values to reduce dataset to north american occurrences
hyacinth.NA <- rename(hyacinth.NA, 'Climate' = 'raster::extract(climate, hyacinth.NA)')
hyacinth.NA <- hyacinth.NA%>%
  filter(!is.na(Climate))

# plot to check
plot(climate)
points(hyacinth.NA$Longitude, hyacinth.NA$Latitude)

# crop map extent to better visualize layer
ext <- extent(-180, -40, 10, 90)
climate.crop <- crop(climate, ext)
plot(climate.crop, main = "Hyacinth North American Occurrences")
points(hyacinth.NA$Longitude, hyacinth.NA$Latitude)















