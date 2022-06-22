##### First model script ##### -----
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
# Download 2.5 res worldclim V 2.1
P_url <- "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_30s_bio.zip"
download.file(P_url, destfile="wc2.1_30s_bio.zip")
unzip("wc2.1_30s_bio.zip")

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

# download FAO Harmozied world soils land cover layers
P_url <- "http://www.fao.org/fileadmin/user_upload/soils/docs/HWSD/Land_Cover_data/CULT_2000.asc"
download.file(P_url, destfile="CULTRF_2000")
P_url <- "http://www.fao.org/fileadmin/user_upload/soils/docs/HWSD/Land_Cover_data/CULTIR_2000.asc"
download.file(P_url, destfile="CULTIR_2000")
P_url <- "http://www.fao.org/fileadmin/user_upload/soils/docs/HWSD/Land_Cover_data/CULTRF_2000.asc"
download.file(P_url, destfile="CULT_2000")
P_url <- "http://www.fao.org/fileadmin/user_upload/soils/docs/HWSD/Land_Cover_data/FOR_2000.asc"
download.file(P_url, destfile="FOR_2000")
P_url <- "http://www.fao.org/fileadmin/user_upload/soils/HWSD%20Viewer/GRS_2000.asc"
download.file(P_url, destfile="GRS_2000")
P_url <- "http://www.fao.org/fileadmin/user_upload/soils/HWSD%20Viewer/URB_2000.asc"
download.file(P_url, destfile="URB_2000")
P_url <- "http://www.fao.org/fileadmin/user_upload/soils/docs/HWSD/Land_Cover_data/NVG_2000.asc"
download.file(P_url, destfile="NVG_2000")
P_url <- "http://www.fao.org/fileadmin/user_upload/soils/docs/HWSD/Land_Cover_data/WAT_2000.asc"
download.file(P_url, destfile="WAT_2000")

# create rasters of world soils variables
NVG = raster("NVG_2000")
URB = raster("URB_2000")
FOR = raster("FOR_2000")
GRS = raster("GRS_2000")
CULTIR = raster("CULTIR_2000")
CULTRF = raster("CULT_2000")
CULT = raster("CULTRF_2000")
WATER = raster("WAT_2000")

# download and unzip Human Influence Index v2: Last of the Wild (World)
# create raster of Human Influence Index using local file path
HII <- raster("C:\\...\\w001001x.adf") # insert file path at "\\...\\"

# reproject world soils and HII
# world soils variable CRS is set to N/A, use bioclim variables to match soils to WGS84
projection(NVG) <- projection(bio1)
projection(URB) <- projection(bio1)
projection(FOR) <- projection(bio1)
projection(GRS) <- projection(bio1)
projection(CULTIR) <- projection(bio1)
projection(CULTRF) <- projection(bio1)
projection(CULT) <- projection(bio1)
projection(WATER) <- projection(bio1)
projection(HII) <- projection(bio1)

# create raster stacks of related variables
bioclim.var <- stack(bio1, bio2, bio3, bio4, bio5, bio6, bio7, bio8, 
                     bio9, bio10, bio11, bio12, bio13, bio14, bio15, 
                     bio16, bio17, bio18, bio19)
land.use <- stack(NVG, URB, FOR, GRS, CULTIR, CULTRF, CULT, WATER)

# crop rasters
ext <- extent(-130, 160, -30, 65)
bioclim.crop <- crop(bioclim.var, ext)
landuse.crop <- crop(land.use, ext)
HII.crop <- crop(HII, ext)


##### Training Data ###### -----
# load training occurrence data csv into R via "Import Dataset"
# extract predictor values at species record points
data(wrld_simpl)
species.occurrence.train <- species_occurence_training_data
spOcc.lat.lon.train <- species.occurrence.train[ , c("decimallon", "decimallat")]
spOcc.train <- species.occurrence.train[ , c("decimallon", "decimallat")] # for later

# extract bioclim variables for each species record, creating a dataframe
bioclim.extract.train <- raster::extract(bioclim.crop, spOcc.lat.lon.train, method = 'simple')
landuse.extract.train <- raster::extract(landuse.crop, spOcc.lat.lon.train, method = 'simple')
HII.extract.train <- raster::extract(HII.crop, spOcc.lat.lon.train, method = 'simple')

# combine dataframes (coordinates + bioclim values)extra
spOcc.variables.train <- cbind(spOcc.lat.lon.train, bioclim.extract.train, landuse.extract.train, HII.extract.train)

plot(spOcc.variables.train)

# remove N/A values 
spOcc.variables.train <- spOcc.variables.train%>%
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
  filter(!is.na(wc2.1_30s_bio_19))%>%
  filter(!is.na(barren_sparsely_vegetated_land))%>%
  filter(!is.na(built_up_land))%>%
  filter(!is.na(forest_land))%>%
  filter(!is.na(grass_scrub_woodland))%>%
  filter(!is.na(irrigated_cultivated_land))%>%
  filter(!is.na(rain_fed_cultivated_land))%>%
  filter(!is.na(total_cultivated_land))%>%
  filter(!is.na(water_bodies))%>%
  filter(!is.na(HII.extract.train))

# check
summary(spOcc.variables.train)

# create subset without longitude and latitude for correlation
spOcc.cor.data.train <- subset(spOcc.variables.train, select = -c(decimallat, decimallon))

##### Correlation tests ##### -----
# Pearson's correlation test
spOcc.cor.train <- cor(spOcc.cor.data.train, method = "pearson", use = "pairwise.complete.obs")
corrplot(cor(spOcc.cor.train, method = "pearson"))

#creating different visual
pearson.dist <- as.dist(1 - FR.cor.train)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree)
abline(h = 0.3, col = "red", lty = 5)

# VIF
vif <- vifstep(spOcc.cor.data.train, th = 10) # threshold value of 10 
vif



##### Testing Data ##### -----
# load testing data csv into R
# extract predictor values at species record points *remember this is only the training data
species.occurrence.test <- species_occurence_data_test
spOcc.lat.lon.test <- species.occurrence.test[ , c("decimallon", "decimallat")]
spOcc.test <- species.occurrence.test[ , c("decimallon", "decimallat")] # for later

# extract bioclim variables for each species record, creating a dataframe
bioclim.extract.test <- raster::extract(bioclim.crop, FR.lat.lon.test, method = 'simple')
landuse.extract.test <- raster::extract(landuse.crop, FR.lat.lon.test, method = 'simple')
HII.extract.test <- raster::extract(HII.crop, spOcc.lat.lon.test, method = 'simple')

# combine dataframes (coordinates + bioclim values)extra
spOcc.variables.test <- cbind(spOcc.lat.lon.test, bioclim.extract.test, landuse.extract.test, HII.extract.test)

plot(spOcc.variables.test)

# remove N/A values 
spOcc.variables.test <- spOcc.variables.test%>%
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
  filter(!is.na(wc2.1_30s_bio_19))%>%
  filter(!is.na(barren_sparsely_vegetated_land))%>%
  filter(!is.na(built_up_land))%>%
  filter(!is.na(forest_land))%>%
  filter(!is.na(grass_scrub_woodland))%>%
  filter(!is.na(irrigated_cultivated_land))%>%
  filter(!is.na(rain_fed_cultivated_land))%>%
  filter(!is.na(total_cultivated_land))%>%
  filter(!is.na(water_bodies))%>%
  filter(!is.na(HII.extract.test))

# check
summary(spOcc.variables.test)

# create subset without longitude and latitude for correlation
spOcc.cor.data.test <- subset(spOcc.variables.test, select = -c(decimallat, decimallon))

##### Correlation tests ##### -----
# Pearson's correlation test
spOcc.cor.test <- cor(spOcc.cor.data.test, method = "pearson", use = "pairwise.complete.obs")
corrplot(cor(spOcc.cor.test, method = "pearson"))

#creating different visual
pearson.dist <- as.dist(1 - spOcc.cor.test)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree)
abline(h = 0.3, col = "red", lty = 5)

# VIF
vif <- vifstep(spOcc.cor.data.test, th = 10) # threshold value of 10 
vif