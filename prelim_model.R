# Import the following libraries to remove some of the log messages
library(sp)
library(terra)
library(lattice)
library(latticeExtra)

# Added
library(dplyr)
library(httr)
# https://github.com/R-ArcGIS/r-bridge
# install.packages("arcgisbinding", repos="https://r.esri.com", type="win.binary")
library(arcgisbinding)  # This is to load adf lifes
arc.check_product()     # define a desktop license

# Original imports
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


gc()

# Download file as `filename` from `url` and extract it to `data` folder without overwriting any files
download_and_extract_dataset <- function(url, filename, force_redownload = FALSE, dest_folder = "data") {
  # Download the file if not downloaded already
  if (!file.exists(filename) || force_redownload)
  {
    print(sprintf("Downloading file %s from %s", filename, url))
    download.file(url, destfile="wc2.1_30s_bio.zip")
  }
  # Extract the file
  print(sprintf("Unzipping file %s", filename))
  unzip("wc2.1_30s_bio.zip", exdir = dest_folder, overwrite = FALSE)

  # Return a list of filepaths
  file_list <- unzip("wc2.1_30s_bio.zip", list = TRUE)
  file_list$Name <- file.path(dest_folder, file_list$Name)
  return(file_list[['Name']])
}

rasterizeProjectAndCrop <- function(f, to_raster, ext = extent(-130, 160, -30, 65)) {
  r <- raster(f)
  resampled <- projectRaster(r, to_raster, method = 'ngb')
  cropped <- crop(resampled, ext)
  return(cropped)
}

# Download 30 second res worldclim V 2.1 (https://www.worldclim.org/data/worldclim21.html)
url <- "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/wc2.1_30s_bio.zip"
filename <- tolower("wc2.1_30s_BIO.zip")
if (endsWith(filename, ".zip")) {
  folder <- substring(filename, 1, nchar(filename) - nchar(".zip"))
} else {
  folder <- filename
}

# Change extract_files_again to TRUE, if you want to extract files again
extract_files_again <- FALSE
# Change force_redownload to TRUE if you want to (re-)download the ZIP file
force_redownload <- FALSE
if (extract_files_again) {
  files <- download_and_extract_dataset(url, filename, force_redownload, folder)
} else{
  files <- list.files(folder)
}

raster_length <- length(files)
stopifnot(raster_length > 0)

# Generate a list of rasters from the files that have been extracted
bio_rasters <- vector("list", raster_length)
for (i in 1:raster_length)
{
  bio_rasters[[i]] <- raster(file.path(folder, files[i]))
}

# create a raster stack of bioclim variables
bioclim.var <- stack(bio_rasters)

# The names of the wc2 data
wc2_names <- names(bioclim.var)

# extract predictor values at species record points *remember this is only the training data
data(wrld_simpl)
shiny.geranium.train <- read.csv(file.path("Shiny Geranium", "CSVs", "Geranium_data_train.csv"))
SG.lat.lon <- shiny.geranium.train[ , c("decimallon", "decimallat")]
SG.occ.train <- shiny.geranium.train[ , c("decimallon", "decimallat")] # for later

# plot(bio_rasters[[1]])
# plot(wrld_simpl, add = TRUE)
# points(SG.lat.lon, col = 'red')

print(bioclim.var)

# Crop rasters and save the data to a file so we don't have to re-compute it next time
# Load the file if it exists
# NOTE: This takes about 30Gb
# cropped_sg_data_filename <- shapefile(system.file("SG_cropped.shp", package="raster"))
cropped_sg_data_filename <- "SG_cropped.grd"
if (file.exists(cropped_sg_data_filename))
{
  SG.crop <- stack(cropped_sg_data_filename)
} else {
  ext <- extent(-130, 160, -30, 65)
  SG.crop <- crop(bioclim.var, ext, cropped_sg_data_filename)
}

# plot points on cropped raster to visualize
# plot(SG.crop)
# plot(SG.crop$wc2.1_30s_bio_1, add = TRUE)
# points(SG.lat.lon, col = 'black')

# Extract bioclim variables for each species record, creating a dataframe
occurence.values <- raster::extract(SG.crop, SG.lat.lon, method = 'simple')
# Combine dataframes (coordinates + bioclim values)
occurence.values.plus.coord <- cbind(SG.lat.lon, occurence.values)
# Rename columns: decimallon -> Longitude, decimallat -> Latitude
occurence.values.plus.coord <- rename(occurence.values.plus.coord, Longitude = decimallon, Latitude = decimallat)

# Plot Occurrences (with coordinates)
# plot(occurence.values.plus.coord)

# Add HII values (csv file created through QGIS)
SG.HII <- read.csv(file.path("Shiny Geranium", "CSVs", "Geranium_HIIvalues.csv"))
# TODO (for Emma) confirm that the only columns you want from Geranium_HIIvalues.csv are: Longitude, Latitude, HII1
SG.HII <- subset(SG.HII, select = c('Latitude', 'Longitude', 'HII1'))  # Select columns you want here instead of removing them later
SG.env.var <- merge(occurence.values.plus.coord, SG.HII, by = c('Latitude', 'Longitude'))
SG.env.var.no.coord <- subset(SG.env.var, select = -c(Longitude, Latitude))

### Add world soils variables *csv file created through QGIS
SG.landcover <- read.csv(file.path("Shiny Geranium", "CSVs", "Geranium_landcover.csv"))
SG.soil <- read.csv(file.path("Shiny Geranium", "CSVs", "Geranium_soilconditions.csv")) # not going to use for now

# Create raster layers of landcover data for later
#   Source: http://www.fao.org/soils-portal/data-hub/soil-maps-and-databases/harmonized-world-soil-database-v12/en/

# Set directory where Land Cover are stored (or to be stored)
land_cover_folder <- "FAO Land Cover"
land_cover_filenames <- list("CULT_2000.asc", "CULTIR_2000.asc", "CULTRF_2000.asc", "FOR_2000.asc", "GRS_2000.asc",
                             "NVG_2000.asc", "URB_2000.asc")

# Download land cover files
redownload_land_cover_files <- FALSE
if (redownload_land_cover_files)
{
  dir.create(land_cover_folder, showWarnings = FALSE)
  for (name in land_cover_filenames)
  {
    url <- sprintf("http://www.fao.org/fileadmin/user_upload/soils/docs/HWSD/Land_Cover_data/%s", name)
    # Check if the URL exists (i.e. points to a file); it the URL status code is not 200, change the URL
    if (status_code(HEAD(url)) != 200) {
      url <- sprintf("http://www.fao.org/fileadmin/user_upload/soils/HWSD%%20Viewer/%s", name)
    }
    download.file(url, destfile=file.path(land_cover_folder, name))
  }
}

# TODO please confirm that only forest, cult, barren, and grass are used
cult <- raster(file.path(land_cover_folder, "CULT_2000.asc"))
# cultIR <- raster(file.path(land_cover_folder, "CULTIR_2000.asc"))
# cultRF <- raster(file.path(land_cover_folder, "CULTRF_2000.asc"))
forest <- raster(file.path(land_cover_folder, "FOR_2000.asc"))
grass <- raster(file.path(land_cover_folder, "GRS_2000.asc"))
barren <- raster(file.path(land_cover_folder, "NVG_2000.asc"))
# urban <- raster(file.path(land_cover_folder, "URB_2000.asc"))

non_wc2_col_names <- c("Longitude", "Latitude", "HII1", "NVG", "URB", "FOR", "GRS", "CULTIR", "CULTRF", "CULT")
all_col_names <- c("Longitude", "Latitude", wc2_names, "HII1", "NVG", "URB", "FOR", "GRS", "CULTIR", "CULTRF", "CULT")

# Combine with other variables
SG.env.vars <- merge(SG.env.var, SG.landcover, by = c('Longitude', 'Latitude'))
SG.env.vars <- subset(SG.env.vars, select = all_col_names)

# Remove NA values from wc2.1_30s_bio_1, wc2.1_30s_bio_2, ... - from: https://dplyr.tidyverse.org/articles/colwise.html
# For more info on all_of(), see: https://tidyselect.r-lib.org/reference/faq-external-vector.html
SG.env.vars <- filter(SG.env.vars, if_all(all_of(wc2_names), ~ !is.na(.x)))

SG.occ.train <- subset(SG.env.vars, select = c(Longitude, Latitude))
summary(SG.occ.train)

# Pearson's correlation test
SG.cor <- cor(SG.env.vars, method = "pearson", use = "pairwise.complete.obs")

#creating different visual
pearson.dist <- as.dist(1 - SG.cor)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree)
abline(h = 0.3, col = "red", lty = 5)

# VIF
# TODO: determine if this error message needs to be addressed:
#       "14 variables from the 29 input variables have collinearity problem:"
vif <- vifstep(SG.env.vars, th = 10) # threshold value of 10


# # ##### ADD Human Influence Index to variables ##### -----
# # *created .csv file with values and read in that way instead*
# # (https://sedac.ciesin.columbia.edu/data/set/wildareas-v2-human-influence-index-geographic/data-download)
# global_human_influence_index <-  as.raster(system.file("input_data", "w001001.adf", package="arcgisbinding")) # Only need this ADF file, not the others
#   # as.raster(file.path("input_data", "w001001.adf"))
# print(head(global_human_influence_index))
# print(typeof(global_human_influence_index))
# print(summary(global_human_influence_index))
global_human_influence_index_1 <- projectRaster(file.path("input_data", "w001001.adf")) # raster(file.path("Shiny Geranium", "CSVs", "Geranium_HIIvalues.csv"))

# # Extract the Coordinate Reference System from one of the bio rasters
# crs_to_use <- crs(bio_rasters[[1]])
#
# # convert HII to coordinate reference system WGS84
# HII84 <- projectRaster(global_human_influence_index, crs = crs_to_use)
#
# # crop HII
# HII.crop <- crop(HII84, ext)
# plot(HII.crop)