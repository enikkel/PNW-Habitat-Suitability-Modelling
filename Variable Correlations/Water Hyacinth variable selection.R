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

# create rasters of world soils variables
NVG = raster("C:\\Users\\Delia Anderson\\Desktop\\SDM 2021\\Rstudio data\\barren_sparsely_vegetated_land.asc")
FOR = raster("C:\\Users\\Delia Anderson\\Desktop\\SDM 2021\\Rstudio data\\forest_land.asc")
GRS = raster("C:\\Users\\Delia Anderson\\Desktop\\SDM 2021\\Rstudio data\\grass_scrub_woodland.asc")
WATER = raster("C:\\Users\\Delia Anderson\\Desktop\\SDM 2021\\Rstudio data\\water_bodies.asc")

# create raster of Human Infleunce Index
HII <- raster("C:\\Users\\Delia Anderson\\Desktop\\SDM 2021\\Rstudio data\\w001001x.adf")

# reproject world soils and HII
# world soils variable crs is set to NA, set to WGS84 like bio variables
projection(NVG) <- projection(bio1)
projection(FOR) <- projection(bio1)
projection(GRS) <- projection(bio1)
projection(WATER) <- projection(bio1)
projection(HII) <- projection(bio1)

# create a raster stackS of related variables
bioclim.var <- stack(bio1, bio2, bio3, bio4, bio5, bio6, bio7, bio8, 
                     bio9, bio10, bio11, bio12, bio13, bio14, bio15, 
                     bio16, bio17, bio18, bio19)
land.use <- stack(NVG, FOR, GRS, WATER)

# crop rasters
ext <- extent(-180, -40, 10, 90)
bioclim.crop <- crop(bioclim.var, ext)
landuse.crop <- crop(land.use, ext)
HII.crop <- crop(HII, ext)

# extract predictor values at species record points
data(wrld_simpl)
WH.lat.lon <- hyacinth.NA[ , c("Longitude", "Latitude")]
WH.occ<- hyacinth.NA[ , c("Longitude", "Latitude")] # for later

# extract bioclim variables for each species record, creating a dataframe
bioclim.extract <- raster::extract(bioclim.crop, WH.lat.lon, method = 'simple')
landuse.extract <- raster::extract(landuse.crop, WH.lat.lon, method = 'simple')
HII.extract <- raster::extract(HII.crop, WH.lat.lon, method = 'simple')

# combine dataframes (coordinates + bioclim values)extra
WH.variables <- cbind(WH.lat.lon, bioclim.extract, landuse.extract, HII.extract, hyacinth.landuse)

library(tidyverse)
# remove NA values 
WH.variables <- WH.variables%>%
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
  filter(!is.na(forest_land))%>%
  filter(!is.na(grass_scrub_woodland))%>%
  filter(!is.na(water_bodies))%>%
  filter(!is.na(HII.extract))

# split training/testing 70:30
set.seed(123) # Set Seed so that same sample can be reproduced in future
# Now Selecting 70% of data as sample from total 'n' rows of the data  
sample <- sample.int(n = nrow(WH.variables), size = floor(.70*nrow(WH.variables)), replace = F)
WH.train <- WH.variables[sample, ]
WH.test  <- WH.variables[-sample, ]

## deal with training data first
# check
summary(WH.train)

# create subset without longitude and latitude for correlation
WH.cor.train <- subset(WH.train, select = -c(Longitude, Latitude))

##### Correlation tests ##### -----
# Pearson's correlation test
training.cor <- cor(WH.cor.train, method = "pearson", use = "pairwise.complete.obs")
corrplot(cor(training.cor, method = "pearson"))

#creating different visual
pearson.dist <- as.dist(1 - training.cor)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree)
abline(h = 0.3, col = "red", lty = 5)

# VIF
vif <- vifstep(WH.cor.train, th = 10) # threshold value of 10 
vif

## testing data next
# check
summary(WH.test)

# create subset without longitude and latitude for correlation
WH.cor.test <- subset(WH.test, select = -c(Longitude, Latitude))

##### Correlation tests ##### -----
# Pearson's correlation test
testing.cor <- cor(WH.cor.test, method = "pearson", use = "pairwise.complete.obs")
corrplot(cor(testing.cor, method = "pearson"))

#creating different visual
pearson.dist <- as.dist(1 - testing.cor)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree)
abline(h = 0.3, col = "red", lty = 5)

# VIF
vif <- vifstep(WH.cor.test, th = 10) # threshold value of 10 
vif
