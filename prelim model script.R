##### First model script #####

# install and load packages

install.packages("dismo")
install.packages("maptools")
install.packages("rgdal")
install.packages("Rtools")
install.packages("raster")
install.packages("sp")
install.packages("biomod2")
install.packages("usdm")
install.packages("corrplot")
install.packages(c("FactoMineR", "factoextra"))
install.packages("spatialEco")
install.packages("tidyverse")


library(rgdal)
library(raster)
library(sp)
library(dismo)
library(biomod2)
library(usdm)
library(maptools)
library(corrplot)
library(ggplot2)
library(FactoMineR)
library(factoextra)
library(readr)
library(gridExtra)
library(rasterVis)
library(spatialEco)
library(tidyverse)

##### Download environmental variables ##### -----

# Download 30 second res worldclim V 2.1 (https://www.worldclim.org/data/worldclim21.html)
P_url <- "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_30s_bio.zip"
download.file(P_url, destfile="wc2.1_30s_bio.zip")
unzip("wc2.1_30s_bio.zip")

### Only download cropped variables [extent of species in question] to save space???

# create rasters of all bioclimatic variables
bio1 <- raster("wc2.1_30s_bio_1.tif")
bio2 <- raster("wc2.1_30s_bio_2.tif")
bio3 <- raster("wc2.1_30s_bio_3.tif")
bio4 <- raster("wc2.1_30s_bio_4.tif")
bio5 <- raster("wc2.1_30s_bio_5.tif")
bio6 <- raster("wc2.1_30s_bio_6.tif")
bio7 <- raster("wc2.1_30s_bio_7.tif")
bio8 <- raster("wc2.1_30s_bio_8.tif")
bio9 <- raster("wc2.1_30s_bio_9.tif")
bio10 <- raster("wc2.1_30s_bio_10.tif")
bio11 <- raster("wc2.1_30s_bio_11.tif")
bio12 <- raster("wc2.1_30s_bio_12.tif")
bio13 <- raster("wc2.1_30s_bio_13.tif")
bio14 <- raster("wc2.1_30s_bio_14.tif")
bio15 <- raster("wc2.1_30s_bio_15.tif")
bio16 <- raster("wc2.1_30s_bio_16.tif")
bio17 <- raster("wc2.1_30s_bio_17.tif")
bio18 <- raster("wc2.1_30s_bio_18.tif")
bio19 <- raster("wc2.1_30s_bio_19.tif")


# create a raster stack of bioclim variables
bioclim.var <- stack(bio1, bio2, bio3, bio4, bio5, bio6, bio7, bio8, 
                     bio9, bio10, bio11, bio12, bio13, bio14, bio15, 
                     bio16, bio17, bio18, bio19)

# extract predictor values at species record points *remember this is only the training data

data(wrld_simpl)
shiny.geranium.train <- read.csv("Geranium_data_train.csv")
SG.lat.lon <- shiny.geranium.train[ , c("decimallon", "decimallat")]
SG.occ.train <- shiny.geranium.train[ , c("decimallon", "decimallat")] # for later

plot(bio1)
plot(wrld_simpl, add = TRUE)
points(SG.lat.lon, col = 'red')

# crop rasters
ext <- extent(-130, 160, -30, 65)
SG.crop <- crop(bioclim.var, ext)

# plot points on cropped raster to visualize
plot(SG.crop)
plot(SG.crop$wc2.1_30s_bio_1, add = TRUE)
points(SG.lat.lon, col = 'black')

# extract bioclim variables for each species record, creating a dataframe
occurence.values <- raster::extract(SG.crop, SG.lat.lon, method = 'simple')
# combine dataframes (coordinates + bioclim values)
occurence.values.plus.coord <- cbind(SG.lat.lon, occurence.values)

plot(occurence.values.plus.coord)
# rename columns to match
names(occurence.values.plus.coord)[names(occurence.values.plus.coord) == "decimallon"] <- "Longitude"
names(occurence.values.plus.coord)[names(occurence.values.plus.coord) == "decimallat"] <- "Latitude"

### download and add HII values *csv file created through QGIS
SG.HII <- read.csv("Geranium_HIIvalues.csv")
SG.env.var <- merge(occurence.values.plus.coord, SG.HII, by = c('Longitude', 'Latitude'))
SG.env.var <- subset(SG.env.var, select = -c(field_1, fid, SciName, issues, countryCod, individual, 
                                             occurrence, coordinate, institutio, gbifID, references, 
                                             basisOfRec, year, month, day, eventDate, geodeticDa, 
                                             datasetNam, layer, path))
SG.env.var.no.coord <- subset(SG.env.var, select = -c(Longitude, Latitude))

### download and add world soils variables *csv file created through QGIS

SG.landcover <- read.csv("Geranium_landcover.csv")
SG.soil <- read.csv("Geranium_soilconditions.csv") # not going to use for now

# create raster layers of landcover data for later (http://www.fao.org/soils-portal/data-hub/soil-maps-and-databases/harmonized-world-soil-database-v12/en/)
cult <- raster("CULT_2000.asc")
cultIR <- raster("CULTIR_2000.asc")
cultRF <- raster("CULTRF_2000.asc")
forest <- raster("FOR_2000.asc")
grass <- raster("GRS_2000.asc")
barren <- raster("NVG_2000.asc")
urban <- raster("URB_2000.asc")

# combine with other variables
SG.env.vars <- merge(SG.env.var, SG.landcover, by = c('Longitude', 'Latitude'))
SG.env.vars <- subset(SG.env.vars, select = c(Longitude, Latitude, wc2.1_30s_bio_1, wc2.1_30s_bio_2, wc2.1_30s_bio_3, 
                                              wc2.1_30s_bio_4, wc2.1_30s_bio_5, wc2.1_30s_bio_6, 
                                              wc2.1_30s_bio_7, wc2.1_30s_bio_8, wc2.1_30s_bio_9, 
                                              wc2.1_30s_bio_10, wc2.1_30s_bio_11, wc2.1_30s_bio_12, 
                                              wc2.1_30s_bio_13, wc2.1_30s_bio_14, wc2.1_30s_bio_15, 
                                              wc2.1_30s_bio_16, wc2.1_30s_bio_17, wc2.1_30s_bio_18, 
                                              wc2.1_30s_bio_19, HII1, NVG, URB, FOR, GRS, CULTIR, CULTRF,
                                              CULT))
# remove NA values 
SG.env.vars <- SG.env.vars%>%
  filter(!is.na(wc2.1_30s_bio_1))%>%
  filter(!is.na(wc2.1_30s_bio_2))%>%
  filter(!is.na(wc2.1_30s_bio_3))%>%
  filter(!is.na(wc2.1_30s_bio_4))%>%
  filter(!is.na(wc2.1_30s_bio_5))%>%
  filter(!is.na(wc2.1_30s_bio_6))%>%
  filter(!is.na(wc2.1_30s_bio_7))%>%
  filter(!is.na(wc2.1_30s_bio_8))%>%
  filter(!is.na(wc2.1_30s_bio_9))%>%
  filter(!is.na(wc2.1_30s_bio_10))%>%
  filter(!is.na(wc2.1_30s_bio_11))%>%
  filter(!is.na(wc2.1_30s_bio_12))%>%
  filter(!is.na(wc2.1_30s_bio_13))%>%
  filter(!is.na(wc2.1_30s_bio_14))%>%
  filter(!is.na(wc2.1_30s_bio_15))%>%
  filter(!is.na(wc2.1_30s_bio_16))%>%
  filter(!is.na(wc2.1_30s_bio_17))%>%
  filter(!is.na(wc2.1_30s_bio_18))%>%
  filter(!is.na(wc2.1_30s_bio_19))

# check
summary(SG.env.vars.test)
# SG.occ.train has 1575 obs but SG.env.vars now has 1550 (25 NAs removed) so we need to bring SG.occ.train down 
# to 1550 as well (25 obs don't have explanatory variables) ### update: now down to 1357
SG.occ.train <- subset(SG.env.vars, select = c(Longitude, Latitude))

# make sure coordinate systems match?

##### Correlation tests ##### -----

# Pearson's correlation test
SG.cor <- cor(SG.env.vars, method = "pearson", use = "pairwise.complete.obs")


#creating different visual
pearson.dist <- as.dist(1 - SG.cor)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree)
abline(h = 0.3, col = "red", lty = 5)

# VIF
vif <- vifstep(SG.env.vars, th = 10) # threshold value of 10 
vif

##### ADD Human Influence Index to variables ##### -----
# *created .csv file with values and read in that way instead*
# (https://sedac.ciesin.columbia.edu/data/set/wildareas-v2-human-influence-index-geographic/data-download)
var1 <- raster("dblbnd.adf")
var2 <- raster("hdr.adf")
var3 <- raster("prj.adf")
var4 <- raster("sta.adf")
var5 <- raster("vat.adf")
var6 <- raster("w001001.adf") # only used this one
var7 <- raster("w001001x.adf")

# convert HII to coordinate reference system WGS84
HII84 <- projectRaster(var6, crs = crs(bio1))

# crop HII
HII.crop <- crop(HII84, ext)
plot(HII.crop)

##### prep variables to join in rasterstack -----
# same crs, ext, resolution

# world soils variable crs is set to NA, set to WGS84 like bio variables
projection(forest) <- projection(bio2)
projection(cult) <- projection(forest)
projection(barren) <- projection(forest)
projection(grass) <- projection(forest)


# crop to ext
bio2.crop <- crop(bio2, ext)
bio3.crop <- crop(bio3, ext)
bio8.crop <- crop(bio8, ext)
bio9.crop <- crop(bio9, ext)
bio10.crop <- crop(bio10, ext)
bio15.crop <- crop(bio15, ext)
bio18.crop <- crop(bio18, ext)

# resample resolution
forest.resampled <- projectRaster(forest, bio2.crop, method = 'ngb')
cult.resampled <- projectRaster(cult, bio2.crop, method = 'ngb')
barren.resampled <- projectRaster(barren, bio2.crop, method = 'ngb')
grass.resampled <- projectRaster(grass, bio2.crop, method = 'ngb')

# resume cropping
forest.resampled.crop <- crop(forest.resampled, ext)
cult.resampled.crop <- crop(cult.resampled, ext)
barren.resampled.crop <- crop(barren.resampled, ext)
grass.resampled.crop <- crop(grass.resampled, ext)
HII84.crop <- crop(HII84, ext)

# can plot to check 
plot(stack(bio2.crop, forest.resampled.crop))

# need to round the extent numbers in HII.crop
HII84.crop <- resample(HII84.crop, forest.resampled.crop) # can resample because values are so close

# if error: "Error in `names<-`(`*tmp*`, value = c("calibration", "validation")) : 
# incorrect number of layer names"
# check to see if there are NA values in the variable rasters:
# example - summary(bio2.crop)
# or: table(is.na(forest.resampled.crop[])) - will relay a TRUE or FALSE statement
# convert NAs to zeros if it will not impact the variable (check each one)
# for example: bio variables have a lot of NA values but they are all the ocean space so 
# unnecessary for the species records (aka can be changed to zeros)

### this did not fix 'incorrect number of layer names' error but still run it

HII84.crop[is.na(HII84.crop)] <- 0
bio2.crop[is.na(bio2.crop)] <- 0
bio3.crop[is.na(bio3.crop)] <- 0
bio8.crop[is.na(bio8.crop)] <- 0
bio9.crop[is.na(bio9.crop)] <- 0
bio10.crop[is.na(bio10.crop)] <- 0
bio15.crop[is.na(bio15.crop)] <- 0
bio18.crop[is.na(bio18.crop)] <- 0

##### USING BIOMOD2 ##### ------

# need occ records 
summary(SG.occ.train)
# add presence record column
SG.occ.train$Geranium.lucidum <- 1

# need environmental variables as rasterstack
SG.variables <- stack(bio2.crop, bio3.crop, bio8.crop, bio9.crop, bio10.crop, bio15.crop, bio18.crop, 
                      forest.resampled.crop, cult.resampled.crop, barren.resampled.crop, 
                      grass.resampled.crop, HII84.crop)
SG.variables

# do the same for the testing data set
# values have not been extracted for these records yet so do those steps first
shiny.geranium.test <- read.csv("Geranium_data_test.csv")
# change column names from 'decimallon' to 'Longitude'
names(shiny.geranium.test)[names(shiny.geranium.test) == "decimallon"] <- "Longitude"
names(shiny.geranium.test)[names(shiny.geranium.test) == "decimallat"] <- "Latitude"
SG.occ.test <- shiny.geranium.test[ , c("Longitude", "Latitude")]

test.occurence.values <- raster::extract(SG.crop, SG.occ.test, method = 'simple')

# to double check correlation stats on the test data
test.occurence.values.plus.coord <- cbind(SG.occ.test, test.occurence.values)

SG.env.vars.test <- merge(test.occurence.values.plus.coord, SG.landcover, by = c('Longitude', 'Latitude'))
SG.env.vars.test <- merge(SG.env.vars.test, SG.HII, by = c('Longitude', 'Latitude'))
SG.env.vars.test <- subset(SG.env.vars.test, select = c(Longitude, Latitude, wc2.1_30s_bio_1, wc2.1_30s_bio_2, 
                                                        wc2.1_30s_bio_3, wc2.1_30s_bio_4, wc2.1_30s_bio_5, 
                                                        wc2.1_30s_bio_6, wc2.1_30s_bio_7, wc2.1_30s_bio_8, 
                                                        wc2.1_30s_bio_9, wc2.1_30s_bio_10, wc2.1_30s_bio_11, 
                                                        wc2.1_30s_bio_12, wc2.1_30s_bio_13, wc2.1_30s_bio_14, 
                                                        wc2.1_30s_bio_15, wc2.1_30s_bio_16, wc2.1_30s_bio_17, 
                                                        wc2.1_30s_bio_18, wc2.1_30s_bio_19, HII1, NVG, URB, FOR, 
                                                        GRS, CULTIR, CULTRF, CULT))
# remove NA values 
SG.env.vars.test <- SG.env.vars.test%>%
  filter(!is.na(wc2.1_30s_bio_1))%>%
  filter(!is.na(wc2.1_30s_bio_2))%>%
  filter(!is.na(wc2.1_30s_bio_3))%>%
  filter(!is.na(wc2.1_30s_bio_4))%>%
  filter(!is.na(wc2.1_30s_bio_5))%>%
  filter(!is.na(wc2.1_30s_bio_6))%>%
  filter(!is.na(wc2.1_30s_bio_7))%>%
  filter(!is.na(wc2.1_30s_bio_8))%>%
  filter(!is.na(wc2.1_30s_bio_9))%>%
  filter(!is.na(wc2.1_30s_bio_10))%>%
  filter(!is.na(wc2.1_30s_bio_11))%>%
  filter(!is.na(wc2.1_30s_bio_12))%>%
  filter(!is.na(wc2.1_30s_bio_13))%>%
  filter(!is.na(wc2.1_30s_bio_14))%>%
  filter(!is.na(wc2.1_30s_bio_15))%>%
  filter(!is.na(wc2.1_30s_bio_16))%>%
  filter(!is.na(wc2.1_30s_bio_17))%>%
  filter(!is.na(wc2.1_30s_bio_18))%>%
  filter(!is.na(wc2.1_30s_bio_19))

# check
summary(SG.env.vars.test)
# SG.occ.test has 3195 obs but SG.env.vars.test now has 3162 (33 NAs removed) so we need to bring SG.occ.test down 
# to 3162 as well (33 obs don't have explanatory variables) ### updated: now 2697
SG.occ.test <- subset(SG.env.vars.test, select = c(Longitude, Latitude))

# run pearson's and compare
SG.cor.test <- cor(SG.env.vars.test, method = "pearson", use = "pairwise.complete.obs")
# use tree visualization
pearson.dist.test <- as.dist(1 - SG.cor.test)
pearson.tree.test <- hclust(pearson.dist.test, method="complete")
plot(pearson.tree.test)
abline(h = 0.3, col = "red", lty = 5)

# VIF
vif.test <- vifstep(SG.env.vars.test, th = 10)
vif.test

#######  prepping the data for modeling ------ BIOMOD2 ######

# add presence record column
SG.occ.test$Geranium.lucidum <- 1

# need to create pseudo-absence data for the evaluation dataset (or both?)
# prepare coordinates and proj4string
coords <- SG.occ.test[ , c("Longitude", "Latitude")]   # coordinates
crs    <- CRS("+proj=longlat +datum=WGS84") # proj4string of coords

# make the SpatialPointsDataFrame object
SG.test.sp <- SpatialPoints(coords = coords, proj4string = crs)

mask <- raster('wc2.1_30s_bio_2.tif')
pseudo.absence <- randomPoints(mask, 3162, p = SG.test.sp, ext = ext, extf = 1.0)

plot(!is.na(mask), legend=FALSE)
plot(ext, add = TRUE)
points(pseudo.absence, cex=0.5)

# change 'pseudo.absence' from matrix to data.frame
pseudo.absence <- as.data.frame(pseudo.absence)
# then add absence record column
pseudo.absence$Geranium.lucidum <- 0
# rename columns to match SG.occ.test
names(pseudo.absence)[names(pseudo.absence) == "x"] <- "Longitude"
names(pseudo.absence)[names(pseudo.absence) == "y"] <- "Latitude"
# combine pseudo.absence with testing data
SG.test.data <- rbind(SG.occ.test, pseudo.absence)

# pseudo-absence data for the training dataset
# repeat previous steps 
# prepare coordinates and proj4string
coords2 <- SG.occ.train[ , c("Longitude", "Latitude")]   # coordinates
crs    <- CRS("+proj=longlat +datum=WGS84") # proj4string of coords

# make the SpatialPointsDataFrame object
SG.train.sp <- SpatialPoints(coords = coords2, proj4string = crs)

mask <- raster('wc2.1_30s_bio_2.tif')
# number of PA = 3x the number of species records (1575)
pseudo.absence.train <- randomPoints(mask, 4650, p = SG.train.sp, ext = ext, extf = 1.0)

plot(!is.na(mask), legend=FALSE)
plot(ext, add = TRUE)
points(pseudo.absence.train, cex=0.5)

# change 'pseudo.absence' from matrix to data.frame
pseudo.absence.train <- as.data.frame(pseudo.absence.train)
# then add absence record column
pseudo.absence.train$Geranium.lucidum <- 0
# rename columns to match SG.occ.test
names(pseudo.absence.train)[names(pseudo.absence.train) == "x"] <- "Longitude"
names(pseudo.absence.train)[names(pseudo.absence.train) == "y"] <- "Latitude"
# combine pseudo.absence with testing data
SG.train.data <- rbind(SG.occ.train, pseudo.absence.train)

### format the data -----
geranium_data <- 
  BIOMOD_FormatingData(
    resp.var = SG.occ.train['Geranium.lucidum'],
    resp.xy = SG.occ.train[, c('Longitude', 'Latitude')],
    expl.var = SG.variables, 
    resp.name = "geranium_data",
    eval.resp.var = SG.test.data['Geranium.lucidum'], # these eval arguments are for the test data set
    eval.expl.var = SG.variables, 
    eval.resp.xy = SG.test.data[, c('Longitude', 'Latitude')], 
    PA.nb.rep = 10, 
    PA.nb.absences = 4650, # 3x the number of training species occurrence records
    PA.strategy = 'random',
    na.rm = TRUE
  )

# Error: 
# Error in `names<-`(`*tmp*`, value = c("calibration", "validation")) : 
# incorrect number of layer names


### simplified version ### TESTS ### (*these work but the output is blank*)

geranium_data_1 <- 
  BIOMOD_FormatingData(
    resp.var = SG.clean.data['Geranium.lucidum'], 
    resp.xy = SG.clean.data[, c('decimallon', 'decimallat')], 
    expl.var = SG.variables, 
    resp.name = 'geranium',
    PA.nb.rep = 1
  )

geranium_data_1
plot(geranium_data_1)

geranium_data_2 <- 
  BIOMOD_FormatingData(
    resp.var = SG.clean.data['Geranium.lucidum'], 
    resp.xy = SG.clean.data[, c('decimallon', 'decimallat')], 
    expl.var = SG.variables, 
    resp.name = 'geranium'
  )

geranium_data_3 <- 
  BIOMOD_FormatingData(
    resp.var = SG.occ.train['Geranium.lucidum'], 
    resp.xy = SG.occ.train[, c('Longitude', 'Latitude')], 
    expl.var = SG.variables, 
    resp.name = 'geranium'
  )

# tried following the example given by the package developers:
myRespName <- 'Geranium.lucidum'
myResp <- as.numeric(SG.occ.train[,myRespName])
myRespXY <- SG.occ.train[,c("Longitude","Latitude")]
myExpl <- stack(bio2.crop, bio3.crop, bio8.crop, bio9.crop, bio10.crop, bio15.crop, bio18.crop, 
                forest.resampled.crop, cult.resampled.crop, barren.resampled.crop, 
                grass.resampled.crop, HII84.crop)

geranium_data_4 <- 
  BIOMOD_FormatingData(
    resp.var = myResp,
    expl.var = myExpl,
    resp.xy = myRespXY,
    resp.name = myRespName,
    PA.nb.rep = 3
    )
# runs without errors but output is blank, or all 'undifined', with no presence or absence points

###################### DISMO ################################
install.packages("JGR") # trying to fix rJava error
install.packages("rJava")

library(dismo)
library(maptools)
library(ecospat)
library(colorRamps)
library(raster)
library(JGR)
library(rJava)

# species records
head(SG.occ.train)
SG.occ.train <- SG.occ.train[,1:2]

# env data - raster stack
plot(SG.variables)

# lets plot the data 
data(wrld_simpl)
plot(SG.variables, 1)
plot(wrld_simpl, add=TRUE)
# with the points function, "add" is implicit
points(SG.occ.train, cex=0.5, pch=20, col='blue')

# extract the environmental values at each of the occurrence locations.
presvals <- raster::extract(SG.variables, SG.occ.train) # presence values
head(presvals)

# Create background data #
# setting a random seed to always create the same random set of points
set.seed(0)
# create 1550 random background points 
backgr <- randomPoints(mask, 1357, ext = ext, extf = 1.0)
# and then extract env data at the background points
absvals <- raster::extract(SG.variables, backgr)
# make a vector of 1's and 0's to match the presence records and the background data
# See ?rep
pb <- c(rep(1, nrow(presvals)), rep(0, nrow(absvals)))
# now we bind everything together into a data.frame
sdmdata <- data.frame(cbind(pb, rbind(presvals, absvals)))
# and have a look at the data
head(sdmdata)
tail(sdmdata)
summary(sdmdata)

# background points
SG.occ.test <- SG.occ.test[,1:2]
set.seed(0)

pres_train <- SG.occ.train
pres_test <- SG.occ.test
colnames(pres_train) = c('lon', 'lat')
colnames(pres_test) = c('lon', 'lat')

set.seed(10)
backg <- randomPoints(mask, n=2697, ext = ext, extf = 1.0 )
colnames(backg) = c('lon', 'lat')
colnames(backgr) = c('lon', 'lat')

backg_train <- backgr
backg_test <- backg

r <- raster(SG.variables, 1)
plot(!is.na(r), col=c('white', 'light grey'), legend=FALSE)
plot(ext, add=TRUE, col='black', lwd=2)
points(backg_train, pch=20, cex=0.5, col='yellow')
points(backg_test, pch=20, cex=0.5, col='black')
points(pres_train, pch= '+', col='red') 
points(pres_test, pch='+', col='blue')

### alternative with all occurrence points ###
SG.occ <- rbind(SG.occ.train, SG.occ.test)

set.seed(0)
pres.group <- kfold(SG.occ, k=5) # 5 groups = 80/20 split
all.pres.train <- SG.occ[group != 1, ]
all.pres.test <- SG.occ[group == 1, ]

set.seed(10)
all.backg <- randomPoints(mask, n=4054, ext=ext, extf = 1.0)
colnames(all.backg) = c('lon', 'lat')
group <- kfold(all.backg, 5)
all.backg.train <- all.backg[group != 1, ]
all.backg.test <- all.backg[group == 1, ]

r <- raster(SG.variables, 1)
plot(!is.na(r), col=c('white', 'light grey'), legend=FALSE)
plot(ext, add=TRUE, col='black', lwd=2)
points(all.backg.train, pch=20, cex=0.5, col='yellow')
points(all.backg.test, pch=20, cex=0.5, col='black')
points(all.pres.train, pch= '+', col='red') 
points(all.pres.test, pch='+', col='blue')

## Fit MaxEnt 
maxent()
filePath <- "~/R projects/SDM"
mx <- maxent(SG.variables, # env data as a raster stack
             all.pres.train, # presence data
             path = filePath) # where to save all the output
plot(mx)

## current error:
## Error: Error reading species file
## Error in rJava::.jcall(mxe, "S", "fit", c("autorun", "-e", afn, "-o",  : 
                                          # java.awt.HeadlessException

#################### Ensemble modeling using SSDM ######################## (DISREGARD)
install.packages("SSDM")
install.packages("rJava")
library(SSDM)
library(rJava)


# see ?ensemble_modelling for details on each argument
# ssdm does not have an argument for a separate evaluation dataset so create one combined
# updated dataset
SG.clean.data <- read.csv("Geranium_data_clean.csv")
# check for NAs with summary() function, remove any
SG.clean.data <- SG.clean.data%>%
  filter(!is.na(coordinate))
# only keep Latitude and Longitude
SG.clean.data <- subset(SG.clean.data, select = c(decimallon, decimallat))
SG.clean.data$Geranium.lucidum <- 1


geranium.ensemble <- ensemble_modelling(algorithms = c('GLM', 'GAM', 'MARS', 'RF', 'ANN'), 
                                        Occurrences = SG.clean.data, 
                                        Env = SG.variables, 
                                        Xcol = 'decimallat',
                                        Ycol = 'decimallon',
                                        Pcol = 'Geranium.lucidum', 
                                        rep = 1, 
                                        save = TRUE, 
                                        path = "~/R projects/SDM", 
                                        PA = NULL, 
                                        cv = 'holdout', 
                                        metric = 'SES', 
                                        axes.metric = 'Pearson', 
                                        uncertainty = TRUE, 
                                        tmp = FALSE, 
                                        ensemble.metric = c('AUC'),
                                        ensemble.thresh = c(0.75)
)

# single algorithm
geranium.glm <- modelling(algorithm = 'GLM',
                          Occurrences = SG.clean.data, 
                          Env = SG.variables, 
                          Xcol = 'decimallat', 
                          Ycol = 'decimallon', 
                          Pcol = NULL, 
                          name = 'geranium.glm', 
                          PA = NULL, 
                          cv = 'holdout', 
                          cv.param = c(0.7, 2),
                          thresh = 1001, 
                          metric = 'SES', 
                          axes.metric = 'Pearson', 
                          select = FALSE, 
                          select.metric = c('AUC'), 
                          select.thresh = c(0.75)
                          )

geranium.mars <- modelling(algorithm = 'MARS',
                          Occurrences = SG.clean.data, 
                          Env = SG.variables, 
                          Xcol = 'decimallat', 
                          Ycol = 'decimallon', 
                          Pcol = NULL,  
                          name = 'geranium.mars', 
                          PA = NULL, 
                          cv = 'holdout', 
                          cv.param = c(0.7, 2),
                          thresh = 1001, 
                          metric = 'SES', 
                          axes.metric = 'Pearson', 
                          select = FALSE, 
                          select.metric = c('AUC'), 
                          select.thresh = c(0.75)
                          )
