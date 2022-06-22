library(sp)
library(rgdal)
library(raster)
library(tidyverse)

########## Creating formated variable data files ######################

setwd("D:/MastersProject/ClimateNA")

############# download environmental variables ############## 
# download ClimateNA climate normals variables
# https://adaptwest.databasin.org/pages/adaptwest-climatena/
MAT <- raster("Normal_1981_2010_MAT.tif") # mean annual temperature (C)
MWMT <- raster("Normal_1981_2010_MWMT.tif") # mean temperature of the warmest month
MCMT <- raster("Normal_1981_2010_MCMT.tif") # mean temperature of the coldest month
TD <- raster("Normal_1981_2010_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MAP <- raster("Normal_1981_2010_MAP.tif") # mean annual precipitation (mm)
MSP <- raster("Normal_1981_2010_MSP.tif") # mean summer (may to sept) precipitation
AHM <- raster("Normal_1981_2010_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
SHM <- raster("Normal_1981_2010_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
DD_0 <- raster("Normal_1981_2010_DD_0.tif") # degree-days below 0 C (chilling degree days)
DD5 <- raster("Normal_1981_2010_DD5.tif") # degree-days above 5 C (growing degree days)
DD_18 <- raster("Normal_1981_2010_DD_18.tif") # degree-days below 18 C
DD18 <- raster("Normal_1981_2010_DD18.tif") # degree-days above 18 C
NFFD <- raster("Normal_1981_2010_NFFD.tif") # the number of frost-free days
FFP <- raster("Normal_1981_2010_FFP.tif") # frost-free period
bFFP <- raster("Normal_1981_2010_bFFP.tif") # the julian date on which the frost-free period begins
eFFP <- raster("Normal_1981_2010_eFFP.tif") # the julian date on which the frost-free period ends
PAS <- raster("Normal_1981_2010_PAS.tif") # precipitation as snow (mm)
EMT <- raster("Normal_1981_2010_EMT.tif") # extreme minimum temperature over 30 years
EXT <- raster("Normal_1981_2010_EXT.tif") # extreme maximum temperature over 30 years
Eref <- raster("Normal_1981_2010_Eref.tif") # Hargreave's reference evaporation
CMD <- raster("Normal_1981_2010_CMD.tif") # Hargreave's climatic moisture index
MAR <- raster("Normal_1981_2010_MAR.tif") # mean annual solar radiation
RH <- raster("Normal_1981_2010_RH.tif") # mean annual relative humidity (%)
CMI <- raster("Normal_1981_2010_CMI.tif") # Hogg's climate moisture index (mm)
DD1040 <- raster("Normal_1981_2010_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
Tave_wt <- raster("Normal_1981_2010_Tave_wt.tif") # winter (Dec to Feb) mean temperature
Tave_sp <- raster("Normal_1981_2010_Tave_sp.tif") # spring (Mar to May) mean temperature
Tave_sm <- raster("Normal_1981_2010_Tave_sm.tif") # summer (Jun to Aug) mean temperature
Tave_at <- raster("Normal_1981_2010_Tave_at.tif") # autumn (Sep to Nov) mean temperature
PPT_wt <- raster("Normal_1981_2010_PPT_wt.tif") # winter precipitation
PPT_sp <- raster("Normal_1981_2010_PPT_sp.tif") # spring precipitation
PPT_sm <- raster("Normal_1981_2010_PPT_sm.tif") # summer precipitation
PPT_at <- raster("Normal_1981_2010_PPT_at.tif") # autumn precipitation

############## download Human Influence Index ######################
# v2: Last of the Wild (World) - North America
# https://sedac.ciesin.columbia.edu/data/set/wildareas-v2-human-influence-index-geographic/data-download
# create raster of Human Influence Index using local file path
setwd("D:/MastersProject/Raw variables/HII")
HII <- raster("w001001.adf")

################ Projections and CRS ########################
setwd("D:/MastersProject/Raw variables")
# method = 'ngb' for categorical variables, 'bilinear' for continuous
# reproject variables to 30s resolution
# using worldclim bio1 as the input projection
bio1 <- raster("wc2.1_30s_bio_1.tif")
ext <- extent(-170, -50, 12, 75)
bio1 <- crop(bio1, ext)
# HII_gcs <- projectRaster(HII, bio1, method = 'ngb', filename = "HII_NA.tif")
HII_gcs <- raster("HII_NA.tif")

setwd("D:/MastersProject/Formatted variables/")
MAT.NA <- projectRaster(MAT, HII_gcs, method = 'bilinear', filename = "MAT_current.tif")
MWMT.NA <- projectRaster(MWMT, HII_gcs, method = 'bilinear', filename = "MWMT_current.tif")
MCMT.NA <- projectRaster(MCMT, HII_gcs, method = 'bilinear', filename = "MCMT_current.tif")
TD.NA <- projectRaster(TD, HII_gcs, method = 'bilinear', filename = "TD_current.tif")
MAP.NA <- projectRaster(MAP, HII_gcs, method = 'bilinear', filename = "MAP_current.tif")
MSP.NA <- projectRaster(MSP, HII_gcs, method = 'bilinear', filename = "MSP_current.tif")
AHM.NA <- projectRaster(AHM, HII_gcs, method = 'bilinear', filename = "AHM_current.tif")
SHM.NA <- projectRaster(SHM, HII_gcs, method = 'bilinear', filename = "SHM_current.tif")
DD_0.NA <- projectRaster(DD_0, HII_gcs, method = 'bilinear', filename = "DD_0_current.tif")
DD5.NA <- projectRaster(DD5, HII_gcs, method = 'bilinear', filename = "DD5_current.tif")
DD_18.NA <- projectRaster(DD_18, HII_gcs, method = 'bilinear', filename = "DD_18_current.tif")
DD18.NA <- projectRaster(DD18, HII_gcs, method = 'bilinear', filename = "DD18_current.tif")
NFFD.NA <- projectRaster(NFFD, HII_gcs, method = 'bilinear', filename = "NFFD_current.tif")
FFP.NA <- projectRaster(FFP, HII_gcs, method = 'bilinear', filename = "FFP_current.tif")
bFFP.NA <- projectRaster(bFFP, HII_gcs, method = 'bilinear', filename = "bFFP_current.tif")
eFFP.NA <- projectRaster(eFFP, HII_gcs, method = 'bilinear', filename = "eFFP_current.tif")
PAS.NA <- projectRaster(PAS, HII_gcs, method = 'bilinear', filename = "PAS_current.tif")
EMT.NA <- projectRaster(EMT, HII_gcs, method = 'bilinear', filename = "EMT_current.tif")
EXT.NA <- projectRaster(EXT, HII_gcs, method = 'bilinear', filename = "EXT_current.tif")
Eref.NA <- projectRaster(Eref, HII_gcs, method = 'bilinear', filename = "Eref_current.tif")
CMD.NA <- projectRaster(CMD, HII_gcs, method = 'bilinear', filename = "CMD_current.tif")
MAR.NA <- projectRaster(MAR, HII_gcs, method = 'bilinear', filename = "MAR_current.tif", overwrite = TRUE)
RH.NA <- projectRaster(RH, HII_gcs, method = 'bilinear', filename = "RH_current.tif")
CMI.NA <- projectRaster(CMI, HII_gcs, method = 'bilinear', filename = "CMI_current.tif")
DD1040.NA <- projectRaster(DD1040, HII_gcs, method = 'bilinear', filename = "DD1040_current.tif")
Tave_wt.NA <- projectRaster(Tave_wt, HII_gcs, method = 'bilinear', filename = "Tave_wt_current.tif")
Tave_sp.NA <- projectRaster(Tave_sp, HII_gcs, method = 'bilinear', filename = "Tave_sp_current.tif")
Tave_sm.NA <- projectRaster(Tave_sm, HII_gcs, method = 'bilinear', filename = "Tave_sm_current.tif")
Tave_at.NA <- projectRaster(Tave_at, HII_gcs, method = 'bilinear', filename = "Tave_at_current.tif")
PPT_wt.NA <- projectRaster(PPT_wt, HII_gcs, method = 'bilinear', filename = "PPT_wt_current.tif")
PPT_sp.NA <- projectRaster(PPT_sp, HII_gcs, method = 'bilinear', filename = "PPT_sp_current.tif")
PPT_sm.NA <- projectRaster(PPT_sm, HII_gcs, method = 'bilinear', filename = "PPT_sm_current.tif")
PPT_at.NA <- projectRaster(PPT_at, HII_gcs, method = 'bilinear', filename = "PPT_at_current.tif")

################# download world soils land cover variables ###################
# http://www.fao.org/soils-portal/data-hub/soil-maps-and-databases/harmonized-world-soil-database-v12/en/
# create rasters of world soils variables
NVG <- raster("NVG_2000") # barren
URB <- raster("URB_2000") # urban
FOR <- raster("FOR_2000") # forest
GRS <- raster("GRS_2000") # grassland
CULTIR <- raster("CULTIR_2000") # cultivated irrigated
CULTRF <- raster("CULTRF_2000") # cultivated rain-red
CULT <- raster("CULT_2000") # all cultivated
WATER <- raster("WAT_2000") # water

# error stating input crs value is 'NA', therefore add crs (already in WGS84, just not listed)
crs(NVG) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(URB) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(FOR) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(GRS) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(CULTIR) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(CULTRF) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(CULT) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(WATER) <- "+proj=longlat +datum=WGS84 +no_defs"

ext <- extent(-180, -40, 10, 90) # North America

NVG.NA <- NVG %>%
  crop(ext) %>%
  projectRaster(HII_gcs, method = 'ngb', filename = "barren_landcover.tif")

URB.NA <- URB %>%
  crop(ext) %>% 
  projectRaster(HII_gcs, method = 'ngb', filename = "urban_landcover.tif")

FOR.NA <- FOR %>%
  crop(ext) %>% 
  projectRaster(HII_gcs, method = 'ngb', filename = "forest_landcover.tif")

GRS.NA <- GRS %>%
  crop(ext) %>% 
  projectRaster(HII_gcs, method = 'ngb', filename = "grass_landcover.tif")

CULTIR.NA <- CULTIR %>% 
  crop(ext) %>% 
  projectRaster(HII_gcs, method = 'ngb', filename = "cultIR_landcover.tif")

CULTRF.NA <- CULTRF %>%
  crop(ext) %>% 
  projectRaster(HII_gcs, method = 'ngb', filename = "cultRF_landcover.tif")

CULT.NA <- CULT %>%
  crop(ext) %>% 
  projectRaster(HII_gcs, method = 'ngb', filename = "cultivated_landcover.tif")

WATER.NA <- WATER %>%
  crop(ext) %>% 
  projectRaster(HII_gcs, method = 'ngb', filename = "water_landcover.tif")


################## Future Climate #################

# set working directory
setwd("D:/MastersProject/Formatted variables")
HII_gcs <- raster("HII_NA.tif")

############# MPI ##########
########### MPI 4.5 2050s ############
setwd("D:/MastersProject/ClimateNA/MPI_4.5_2050s")

MPI_4.5_2050s_TD <- raster("MPI-ESM1-2-HR_ssp245_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MPI_4.5_2050s_SHM <- raster("MPI-ESM1-2-HR_ssp245_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MPI_4.5_2050s_DD_0 <- raster("MPI-ESM1-2-HR_ssp245_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
MPI_4.5_2050s_DD18 <- raster("MPI-ESM1-2-HR_ssp245_2041_DD18.tif") # degree-days above 18 C
MPI_4.5_2050s_eFFP <- raster("MPI-ESM1-2-HR_ssp245_2041_eFFP.tif") # the julian date on which the frost-free period ends
MPI_4.5_2050s_MAR <- raster("MPI-ESM1-2-HR_ssp245_2041_MAR.tif") # mean annual solar radiation
MPI_4.5_2050s_RH <- raster("MPI-ESM1-2-HR_ssp245_2041_RH.tif") # mean annual relative humidity (%)
MPI_4.5_2050s_PPT_wt <- raster("MPI-ESM1-2-HR_ssp245_2041_PPT_wt.tif") # winter precipitation
MPI_4.5_2050s_PPT_sm <- raster("MPI-ESM1-2-HR_ssp245_2041_PPT_sm.tif") # summer precipitation
MPI_4.5_2050s_MAT <- raster("MPI-ESM1-2-HR_ssp245_2041_MAT.tif") # mean annual temperature (C)
MPI_4.5_2050s_MWMT <- raster("MPI-ESM1-2-HR_ssp245_2041_MWMT.tif") # mean temperature of the warmest month
MPI_4.5_2050s_MCMT <- raster("MPI-ESM1-2-HR_ssp245_2041_MCMT.tif") # mean temperature of the coldest month
MPI_4.5_2050s_MAP <- raster("MPI-ESM1-2-HR_ssp245_2041_MAP.tif") # mean annual precipitation (mm)
MPI_4.5_2050s_MSP <- raster("MPI-ESM1-2-HR_ssp245_2041_MSP.tif") # mean summer (may to sept) precipitation
MPI_4.5_2050s_AHM <- raster("MPI-ESM1-2-HR_ssp245_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MPI_4.5_2050s_DD5 <- raster("MPI-ESM1-2-HR_ssp245_2041_DD5.tif") # degree-days above 5 C (growing degree days)
MPI_4.5_2050s_DD_18 <- raster("MPI-ESM1-2-HR_ssp245_2041_DD_18.tif") # degree-days below 18 C
MPI_4.5_2050s_NFFD <- raster("MPI-ESM1-2-HR_ssp245_2041_NFFD.tif") # the number of frost-free days
MPI_4.5_2050s_FFP <- raster("MPI-ESM1-2-HR_ssp245_2041_FFP.tif") # frost-free period
MPI_4.5_2050s_bFFP <- raster("MPI-ESM1-2-HR_ssp245_2041_bFFP.tif") # the julian date on which the frost-free period begins
MPI_4.5_2050s_PAS <- raster("MPI-ESM1-2-HR_ssp245_2041_PAS.tif") # precipitation as snow (mm)
MPI_4.5_2050s_EMT <- raster("MPI-ESM1-2-HR_ssp245_2041_EMT.tif") # extreme minimum temperature over 30 years
MPI_4.5_2050s_EXT <- raster("MPI-ESM1-2-HR_ssp245_2041_EXT.tif") # extreme maximum temperature over 30 years
MPI_4.5_2050s_Eref <- raster("MPI-ESM1-2-HR_ssp245_2041_Eref.tif") # Hargreave's reference evaporation
MPI_4.5_2050s_CMD <- raster("MPI-ESM1-2-HR_ssp245_2041_CMD.tif") # Hargreave's climatic moisture index
MPI_4.5_2050s_CMI <- raster("MPI-ESM1-2-HR_ssp245_2041_CMI.tif") # Hogg's climate moisture index (mm)
MPI_4.5_2050s_DD1040 <- raster("MPI-ESM1-2-HR_ssp245_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MPI_4.5_2050s_Tave_wt <- raster("MPI-ESM1-2-HR_ssp245_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MPI_4.5_2050s_Tave_sp <- raster("MPI-ESM1-2-HR_ssp245_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
MPI_4.5_2050s_Tave_sm <- raster("MPI-ESM1-2-HR_ssp245_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MPI_4.5_2050s_Tave_at <- raster("MPI-ESM1-2-HR_ssp245_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MPI_4.5_2050s_PPT_sp <- raster("MPI-ESM1-2-HR_ssp245_2041_PPT_sp.tif") # spring precipitation
MPI_4.5_2050s_PPT_at <- raster("MPI-ESM1-2-HR_ssp245_2041_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
MPI_4.5_2050_TD <- projectRaster(MPI_4.5_2050s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MPI_4.5_2050.tif")
MPI_4.5_2050_SHM <- projectRaster(MPI_4.5_2050s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MPI_4.5_2050.tif")
MPI_4.5_2050_DD_0 <- projectRaster(MPI_4.5_2050s_DD_0, HII_gcs, method = 'bilinear', 
                         filename = "DD_0_MPI_4.5_2050.tif")
MPI_4.5_2050_DD18 <- projectRaster(MPI_4.5_2050s_DD18, HII_gcs, method = 'bilinear', 
                         filename = "DD18_MPI_4.5_2050.tif")
MPI_4.5_2050_eFFP <- projectRaster(MPI_4.5_2050s_eFFP, HII_gcs, method = 'bilinear', 
                         filename = "eFFP_MPI_4.5_2050.tif")
MPI_4.5_2050_MAR <- projectRaster(MPI_4.5_2050s_MAR, HII_gcs, method = 'bilinear', 
                        filename = "MAR_MPI_4.5_2050.tif")
MPI_4.5_2050_RH <- projectRaster(MPI_4.5_2050s_RH, HII_gcs, method = 'bilinear', 
                       filename = "RH_MPI_4.5_2050.tif")
MPI_4.5_2050_PPT_wt <- projectRaster(MPI_4.5_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                           filename = "PPT_wt_MPI_4.5_2050.tif")
MPI_4.5_2050_PPT_sm <- projectRaster(MPI_4.5_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                           filename = "PPT_sm_MPI_4.5_2050.tif")
MPI_4.5_2050_MAT <- projectRaster(MPI_4.5_2050s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MPI_4.5_2050.tif")
MPI_4.5_2050_MWMT <- projectRaster(MPI_4.5_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MPI_4.5_2050.tif")
MPI_4.5_2050_MCMT <- projectRaster(MPI_4.5_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MPI_4.5_2050.tif")
MPI_4.5_2050_MAP <- projectRaster(MPI_4.5_2050s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MPI_4.5_2050.tif")
MPI_4.5_2050_MSP <- projectRaster(MPI_4.5_2050s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MPI_4.5_2050.tif")
MPI_4.5_2050_AHM <- projectRaster(MPI_4.5_2050s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MPI_4.5_2050.tif")
MPI_4.5_2050_DD5 <- projectRaster(MPI_4.5_2050s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MPI_4.5_2050.tif")
MPI_4.5_2050_DD_18 <- projectRaster(MPI_4.5_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MPI_4.5_2050.tif")
MPI_4.5_2050_NFFD <- projectRaster(MPI_4.5_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MPI_4.5_2050.tif")
MPI_4.5_2050_FFP <- projectRaster(MPI_4.5_2050s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MPI_4.5_2050.tif")
MPI_4.5_2050_bFFP <- projectRaster(MPI_4.5_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MPI_4.5_2050.tif")
MPI_4.5_2050_PAS <- projectRaster(MPI_4.5_2050s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MPI_4.5_2050.tif")
MPI_4.5_2050_EMT <- projectRaster(MPI_4.5_2050s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MPI_4.5_2050.tif")
MPI_4.5_2050_EXT <- projectRaster(MPI_4.5_2050s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MPI_4.5_2050.tif")
MPI_4.5_2050_Eref <- projectRaster(MPI_4.5_2050s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MPI_4.5_2050.tif")
MPI_4.5_2050_CMD <- projectRaster(MPI_4.5_2050s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MPI_4.5_2050.tif")
MPI_4.5_2050_CMI <- projectRaster(MPI_4.5_2050s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MPI_4.5_2050.tif")
MPI_4.5_2050_DD1040 <- projectRaster(MPI_4.5_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MPI_4.5_2050.tif")
MPI_4.5_2050_Tave_wt <- projectRaster(MPI_4.5_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MPI_4.5_2050.tif")
MPI_4.5_2050_Tave_sp <- projectRaster(MPI_4.5_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_4.5_2050.tif")
MPI_4.5_2050_Tave_sm <- projectRaster(MPI_4.5_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MPI_4.5_2050.tif")
MPI_4.5_2050_Tave_at <- projectRaster(MPI_4.5_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MPI_4.5_2050.tif")
MPI_4.5_2050_PPT_sp <- projectRaster(MPI_4.5_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MPI_4.5_2050.tif")
MPI_4.5_2050_PPT_at <- projectRaster(MPI_4.5_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MPI_4.5_2050.tif")

############ MPI 4.5 2080s ##############
setwd("D:/MastersProject/ClimateNA/MPI_4.5_2080s")
MPI_4.5_2080s_TD <- raster("MPI-ESM1-2-HR_ssp245_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MPI_4.5_2080s_SHM <- raster("MPI-ESM1-2-HR_ssp245_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MPI_4.5_2080s_DD_0 <- raster("MPI-ESM1-2-HR_ssp245_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
MPI_4.5_2080s_DD18 <- raster("MPI-ESM1-2-HR_ssp245_2071_DD18.tif") # degree-days above 18 C
MPI_4.5_2080s_eFFP <- raster("MPI-ESM1-2-HR_ssp245_2071_eFFP.tif") # the julian date on which the frost-free period ends
MPI_4.5_2080s_MAR <- raster("MPI-ESM1-2-HR_ssp245_2071_MAR.tif") # mean annual solar radiation
MPI_4.5_2080s_RH <- raster("MPI-ESM1-2-HR_ssp245_2071_RH.tif") # mean annual relative humidity (%)
MPI_4.5_2080s_PPT_wt <- raster("MPI-ESM1-2-HR_ssp245_2071_PPT_wt.tif") # winter precipitation
MPI_4.5_2080s_PPT_sm <- raster("MPI-ESM1-2-HR_ssp245_2071_PPT_sm.tif") # summer precipitation
MPI_4.5_2080s_MAT <- raster("MPI-ESM1-2-HR_ssp245_2071_MAT.tif") # mean annual temperature (C)
MPI_4.5_2080s_MWMT <- raster("MPI-ESM1-2-HR_ssp245_2071_MWMT.tif") # mean temperature of the warmest month
MPI_4.5_2080s_MCMT <- raster("MPI-ESM1-2-HR_ssp245_2071_MCMT.tif") # mean temperature of the coldest month
MPI_4.5_2080s_MAP <- raster("MPI-ESM1-2-HR_ssp245_2071_MAP.tif") # mean annual precipitation (mm)
MPI_4.5_2080s_MSP <- raster("MPI-ESM1-2-HR_ssp245_2071_MSP.tif") # mean summer (may to sept) precipitation
MPI_4.5_2080s_AHM <- raster("MPI-ESM1-2-HR_ssp245_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MPI_4.5_2080s_DD5 <- raster("MPI-ESM1-2-HR_ssp245_2071_DD5.tif") # degree-days above 5 C (growing degree days)
MPI_4.5_2080s_DD_18 <- raster("MPI-ESM1-2-HR_ssp245_2071_DD_18.tif") # degree-days below 18 C
MPI_4.5_2080s_NFFD <- raster("MPI-ESM1-2-HR_ssp245_2071_NFFD.tif") # the number of frost-free days
MPI_4.5_2080s_FFP <- raster("MPI-ESM1-2-HR_ssp245_2071_FFP.tif") # frost-free period
MPI_4.5_2080s_bFFP <- raster("MPI-ESM1-2-HR_ssp245_2071_bFFP.tif") # the julian date on which the frost-free period begins
MPI_4.5_2080s_PAS <- raster("MPI-ESM1-2-HR_ssp245_2071_PAS.tif") # precipitation as snow (mm)
MPI_4.5_2080s_EMT <- raster("MPI-ESM1-2-HR_ssp245_2071_EMT.tif") # extreme minimum temperature over 30 years
MPI_4.5_2080s_EXT <- raster("MPI-ESM1-2-HR_ssp245_2071_EXT.tif") # extreme maximum temperature over 30 years
MPI_4.5_2080s_Eref <- raster("MPI-ESM1-2-HR_ssp245_2071_Eref.tif") # Hargreave's reference evaporation
MPI_4.5_2080s_CMD <- raster("MPI-ESM1-2-HR_ssp245_2071_CMD.tif") # Hargreave's climatic moisture index
MPI_4.5_2080s_CMI <- raster("MPI-ESM1-2-HR_ssp245_2071_CMI.tif") # Hogg's climate moisture index (mm)
MPI_4.5_2080s_DD1040 <- raster("MPI-ESM1-2-HR_ssp245_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MPI_4.5_2080s_Tave_wt <- raster("MPI-ESM1-2-HR_ssp245_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MPI_4.5_2080s_Tave_sp <- raster("MPI-ESM1-2-HR_ssp245_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
MPI_4.5_2080s_Tave_sm <- raster("MPI-ESM1-2-HR_ssp245_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MPI_4.5_2080s_Tave_at <- raster("MPI-ESM1-2-HR_ssp245_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MPI_4.5_2080s_PPT_sp <- raster("MPI-ESM1-2-HR_ssp245_2071_PPT_sp.tif") # spring precipitation
MPI_4.5_2080s_PPT_at <- raster("MPI-ESM1-2-HR_ssp245_2071_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
MPI_4.5_2080_TD <- projectRaster(MPI_4.5_2080s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MPI_4.5_2080.tif")
MPI_4.5_2080_SHM <- projectRaster(MPI_4.5_2080s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MPI_4.5_2080.tif")
MPI_4.5_2080_DD_0 <- projectRaster(MPI_4.5_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MPI_4.5_2080.tif")
MPI_4.5_2080_DD18 <- projectRaster(MPI_4.5_2080s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MPI_4.5_2080.tif")
MPI_4.5_2080_eFFP <- projectRaster(MPI_4.5_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MPI_4.5_2080.tif")
MPI_4.5_2080_MAR <- projectRaster(MPI_4.5_2080s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MPI_4.5_2080.tif")
MPI_4.5_2080_RH <- projectRaster(MPI_4.5_2080s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MPI_4.5_2080.tif")
MPI_4.5_2080_PPT_wt <- projectRaster(MPI_4.5_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MPI_4.5_2080.tif")
MPI_4.5_2080_PPT_sm <- projectRaster(MPI_4.5_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MPI_4.5_2080.tif")
MPI_4.5_2080_MAT <- projectRaster(MPI_4.5_2080s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MPI_4.5_2080.tif")
MPI_4.5_2080_MWMT <- projectRaster(MPI_4.5_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MPI_4.5_2080.tif")
MPI_4.5_2080_MCMT <- projectRaster(MPI_4.5_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MPI_4.5_2080.tif")
MPI_4.5_2080_MAP <- projectRaster(MPI_4.5_2080s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MPI_4.5_2080.tif")
MPI_4.5_2080_MSP <- projectRaster(MPI_4.5_2080s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MPI_4.5_2080.tif")
MPI_4.5_2080_AHM <- projectRaster(MPI_4.5_2080s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MPI_4.5_2080.tif")
MPI_4.5_2080_DD5 <- projectRaster(MPI_4.5_2080s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MPI_4.5_2080.tif")
MPI_4.5_2080_DD_18 <- projectRaster(MPI_4.5_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MPI_4.5_2080.tif")
MPI_4.5_2080_NFFD <- projectRaster(MPI_4.5_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MPI_4.5_2080.tif")
MPI_4.5_2080_FFP <- projectRaster(MPI_4.5_2080s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MPI_4.5_2080.tif")
MPI_4.5_2080_bFFP <- projectRaster(MPI_4.5_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MPI_4.5_2080.tif")
MPI_4.5_2080_PAS <- projectRaster(MPI_4.5_2080s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MPI_4.5_2080.tif")
MPI_4.5_2080_EMT <- projectRaster(MPI_4.5_2080s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MPI_4.5_2080.tif")
MPI_4.5_2080_EXT <- projectRaster(MPI_4.5_2080s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MPI_4.5_2080.tif")
MPI_4.5_2080_Eref <- projectRaster(MPI_4.5_2080s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MPI_4.5_2080.tif")
MPI_4.5_2080_CMD <- projectRaster(MPI_4.5_2080s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MPI_4.5_2080.tif")
MPI_4.5_2080_CMI <- projectRaster(MPI_4.5_2080s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MPI_4.5_2080.tif")
MPI_4.5_2080_DD1040 <- projectRaster(MPI_4.5_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MPI_4.5_2080.tif")
MPI_4.5_2080_Tave_wt <- projectRaster(MPI_4.5_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MPI_4.5_2080.tif")
MPI_4.5_2080_Tave_sp <- projectRaster(MPI_4.5_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_4.5_2080.tif")
MPI_4.5_2080_Tave_sm <- projectRaster(MPI_4.5_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MPI_4.5_2080.tif")
MPI_4.5_2080_Tave_at <- projectRaster(MPI_4.5_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MPI_4.5_2080.tif")
MPI_4.5_2080_PPT_sp <- projectRaster(MPI_4.5_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MPI_4.5_2080.tif")
MPI_4.5_2080_PPT_at <- projectRaster(MPI_4.5_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MPI_4.5_2080.tif")

############### MPI 7.0 2050s ##################
setwd("D:/MastersProject/ClimateNA/MPI_7.0_2050s")
MPI_7.0_2050s_TD <- raster("MPI-ESM1-2-HR_ssp370_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MPI_7.0_2050s_SHM <- raster("MPI-ESM1-2-HR_ssp370_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MPI_7.0_2050s_DD_0 <- raster("MPI-ESM1-2-HR_ssp370_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
MPI_7.0_2050s_DD18 <- raster("MPI-ESM1-2-HR_ssp370_2041_DD18.tif") # degree-days above 18 C
MPI_7.0_2050s_eFFP <- raster("MPI-ESM1-2-HR_ssp370_2041_eFFP.tif") # the julian date on which the frost-free period ends
MPI_7.0_2050s_MAR <- raster("MPI-ESM1-2-HR_ssp370_2041_MAR.tif") # mean annual solar radiation
MPI_7.0_2050s_RH <- raster("MPI-ESM1-2-HR_ssp370_2041_RH.tif") # mean annual relative humidity (%)
MPI_7.0_2050s_PPT_wt <- raster("MPI-ESM1-2-HR_ssp370_2041_PPT_wt.tif") # winter precipitation
MPI_7.0_2050s_PPT_sm <- raster("MPI-ESM1-2-HR_ssp370_2041_PPT_sm.tif") # summer precipitation
MPI_7.0_2050s_MAT <- raster("MPI-ESM1-2-HR_ssp370_2041_MAT.tif") # mean annual temperature (C)
MPI_7.0_2050s_MWMT <- raster("MPI-ESM1-2-HR_ssp370_2041_MWMT.tif") # mean temperature of the warmest month
MPI_7.0_2050s_MCMT <- raster("MPI-ESM1-2-HR_ssp370_2041_MCMT.tif") # mean temperature of the coldest month
MPI_7.0_2050s_MAP <- raster("MPI-ESM1-2-HR_ssp370_2041_MAP.tif") # mean annual precipitation (mm)
MPI_7.0_2050s_MSP <- raster("MPI-ESM1-2-HR_ssp370_2041_MSP.tif") # mean summer (may to sept) precipitation
MPI_7.0_2050s_AHM <- raster("MPI-ESM1-2-HR_ssp370_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MPI_7.0_2050s_DD5 <- raster("MPI-ESM1-2-HR_ssp370_2041_DD5.tif") # degree-days above 5 C (growing degree days)
MPI_7.0_2050s_DD_18 <- raster("MPI-ESM1-2-HR_ssp370_2041_DD_18.tif") # degree-days below 18 C
MPI_7.0_2050s_NFFD <- raster("MPI-ESM1-2-HR_ssp370_2041_NFFD.tif") # the number of frost-free days
MPI_7.0_2050s_FFP <- raster("MPI-ESM1-2-HR_ssp370_2041_FFP.tif") # frost-free period
MPI_7.0_2050s_bFFP <- raster("MPI-ESM1-2-HR_ssp370_2041_bFFP.tif") # the julian date on which the frost-free period begins
MPI_7.0_2050s_PAS <- raster("MPI-ESM1-2-HR_ssp370_2041_PAS.tif") # precipitation as snow (mm)
MPI_7.0_2050s_EMT <- raster("MPI-ESM1-2-HR_ssp370_2041_EMT.tif") # extreme minimum temperature over 30 years
MPI_7.0_2050s_EXT <- raster("MPI-ESM1-2-HR_ssp370_2041_EXT.tif") # extreme maximum temperature over 30 years
MPI_7.0_2050s_Eref <- raster("MPI-ESM1-2-HR_ssp370_2041_Eref.tif") # Hargreave's reference evaporation
MPI_7.0_2050s_CMD <- raster("MPI-ESM1-2-HR_ssp370_2041_CMD.tif") # Hargreave's climatic moisture index
MPI_7.0_2050s_CMI <- raster("MPI-ESM1-2-HR_ssp370_2041_CMI.tif") # Hogg's climate moisture index (mm)
MPI_7.0_2050s_DD1040 <- raster("MPI-ESM1-2-HR_ssp370_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MPI_7.0_2050s_Tave_wt <- raster("MPI-ESM1-2-HR_ssp370_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MPI_7.0_2050s_Tave_sp <- raster("MPI-ESM1-2-HR_ssp370_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
MPI_7.0_2050s_Tave_sm <- raster("MPI-ESM1-2-HR_ssp370_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MPI_7.0_2050s_Tave_at <- raster("MPI-ESM1-2-HR_ssp370_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MPI_7.0_2050s_PPT_sp <- raster("MPI-ESM1-2-HR_ssp370_2041_PPT_sp.tif") # spring precipitation
MPI_7.0_2050s_PPT_at <- raster("MPI-ESM1-2-HR_ssp370_2041_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
MPI_7.0_2050_TD <- projectRaster(MPI_7.0_2050s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MPI_7.0_2050.tif")
MPI_7.0_2050_SHM <- projectRaster(MPI_7.0_2050s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MPI_7.0_2050.tif")
MPI_7.0_2050_DD_0 <- projectRaster(MPI_7.0_2050s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MPI_7.0_2050.tif")
MPI_7.0_2050_DD18 <- projectRaster(MPI_7.0_2050s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MPI_7.0_2050.tif")
MPI_7.0_2050_eFFP <- projectRaster(MPI_7.0_2050s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MPI_7.0_2050.tif")
MPI_7.0_2050_MAR <- projectRaster(MPI_7.0_2050s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MPI_7.0_2050.tif")
MPI_7.0_2050_RH <- projectRaster(MPI_7.0_2050s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MPI_7.0_2050.tif")
MPI_7.0_2050_PPT_wt <- projectRaster(MPI_7.0_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MPI_7.0_2050.tif")
MPI_7.0_2050_PPT_sm <- projectRaster(MPI_7.0_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MPI_7.0_2050.tif")
MPI_7.0_2050_MAT <- projectRaster(MPI_7.0_2050s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MPI_7.0_2050.tif")
MPI_7.0_2050_MWMT <- projectRaster(MPI_7.0_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MPI_7.0_2050.tif")
MPI_7.0_2050_MCMT <- projectRaster(MPI_7.0_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MPI_7.0_2050.tif")
MPI_7.0_2050_MAP <- projectRaster(MPI_7.0_2050s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MPI_7.0_2050.tif")
MPI_7.0_2050_MSP <- projectRaster(MPI_7.0_2050s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MPI_7.0_2050.tif")
MPI_7.0_2050_AHM <- projectRaster(MPI_7.0_2050s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MPI_7.0_2050.tif")
MPI_7.0_2050_DD5 <- projectRaster(MPI_7.0_2050s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MPI_7.0_2050.tif")
MPI_7.0_2050_DD_18 <- projectRaster(MPI_7.0_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MPI_7.0_2050.tif")
MPI_7.0_2050_NFFD <- projectRaster(MPI_7.0_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MPI_7.0_2050.tif")
MPI_7.0_2050_FFP <- projectRaster(MPI_7.0_2050s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MPI_7.0_2050.tif")
MPI_7.0_2050_bFFP <- projectRaster(MPI_7.0_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MPI_7.0_2050.tif")
MPI_7.0_2050_PAS <- projectRaster(MPI_7.0_2050s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MPI_7.0_2050.tif")
MPI_7.0_2050_EMT <- projectRaster(MPI_7.0_2050s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MPI_7.0_2050.tif")
MPI_7.0_2050_EXT <- projectRaster(MPI_7.0_2050s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MPI_7.0_2050.tif")
MPI_7.0_2050_Eref <- projectRaster(MPI_7.0_2050s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MPI_7.0_2050.tif")
MPI_7.0_2050_CMD <- projectRaster(MPI_7.0_2050s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MPI_7.0_2050.tif")
MPI_7.0_2050_CMI <- projectRaster(MPI_7.0_2050s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MPI_7.0_2050.tif")
MPI_7.0_2050_DD1040 <- projectRaster(MPI_7.0_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MPI_7.0_2050.tif")
MPI_7.0_2050_Tave_wt <- projectRaster(MPI_7.0_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MPI_7.0_2050.tif")
MPI_7.0_2050_Tave_sp <- projectRaster(MPI_7.0_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_7.0_2050.tif")
MPI_7.0_2050_Tave_sm <- projectRaster(MPI_7.0_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MPI_7.0_2050.tif")
MPI_7.0_2050_Tave_at <- projectRaster(MPI_7.0_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MPI_7.0_2050.tif")
MPI_7.0_2050_PPT_sp <- projectRaster(MPI_7.0_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MPI_7.0_2050.tif")
MPI_7.0_2050_PPT_at <- projectRaster(MPI_7.0_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MPI_7.0_2050.tif")


########### MPI 7.0 2080s ################
setwd("D:/MastersProject/ClimateNA/MPI_7.0_2080s")
MPI_7.0_2080s_TD <- raster("MPI-ESM1-2-HR_ssp370_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MPI_7.0_2080s_SHM <- raster("MPI-ESM1-2-HR_ssp370_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MPI_7.0_2080s_DD_0 <- raster("MPI-ESM1-2-HR_ssp370_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
MPI_7.0_2080s_DD18 <- raster("MPI-ESM1-2-HR_ssp370_2071_DD18.tif") # degree-days above 18 C
MPI_7.0_2080s_eFFP <- raster("MPI-ESM1-2-HR_ssp370_2071_eFFP.tif") # the julian date on which the frost-free period ends
MPI_7.0_2080s_MAR <- raster("MPI-ESM1-2-HR_ssp370_2071_MAR.tif") # mean annual solar radiation
MPI_7.0_2080s_RH <- raster("MPI-ESM1-2-HR_ssp370_2071_RH.tif") # mean annual relative humidity (%)
MPI_7.0_2080s_PPT_wt <- raster("MPI-ESM1-2-HR_ssp370_2071_PPT_wt.tif") # winter precipitation
MPI_7.0_2080s_PPT_sm <- raster("MPI-ESM1-2-HR_ssp370_2071_PPT_sm.tif") # summer precipitation
MPI_7.0_2080s_MAT <- raster("MPI-ESM1-2-HR_ssp370_2071_MAT.tif") # mean annual temperature (C)
MPI_7.0_2080s_MWMT <- raster("MPI-ESM1-2-HR_ssp370_2071_MWMT.tif") # mean temperature of the warmest month
MPI_7.0_2080s_MCMT <- raster("MPI-ESM1-2-HR_ssp370_2071_MCMT.tif") # mean temperature of the coldest month
MPI_7.0_2080s_MAP <- raster("MPI-ESM1-2-HR_ssp370_2071_MAP.tif") # mean annual precipitation (mm)
MPI_7.0_2080s_MSP <- raster("MPI-ESM1-2-HR_ssp370_2071_MSP.tif") # mean summer (may to sept) precipitation
MPI_7.0_2080s_AHM <- raster("MPI-ESM1-2-HR_ssp370_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MPI_7.0_2080s_DD5 <- raster("MPI-ESM1-2-HR_ssp370_2071_DD5.tif") # degree-days above 5 C (growing degree days)
MPI_7.0_2080s_DD_18 <- raster("MPI-ESM1-2-HR_ssp370_2071_DD_18.tif") # degree-days below 18 C
MPI_7.0_2080s_NFFD <- raster("MPI-ESM1-2-HR_ssp370_2071_NFFD.tif") # the number of frost-free days
MPI_7.0_2080s_FFP <- raster("MPI-ESM1-2-HR_ssp370_2071_FFP.tif") # frost-free period
MPI_7.0_2080s_bFFP <- raster("MPI-ESM1-2-HR_ssp370_2071_bFFP.tif") # the julian date on which the frost-free period begins
MPI_7.0_2080s_PAS <- raster("MPI-ESM1-2-HR_ssp370_2071_PAS.tif") # precipitation as snow (mm)
MPI_7.0_2080s_EMT <- raster("MPI-ESM1-2-HR_ssp370_2071_EMT.tif") # extreme minimum temperature over 30 years
MPI_7.0_2080s_EXT <- raster("MPI-ESM1-2-HR_ssp370_2071_EXT.tif") # extreme maximum temperature over 30 years
MPI_7.0_2080s_Eref <- raster("MPI-ESM1-2-HR_ssp370_2071_Eref.tif") # Hargreave's reference evaporation
MPI_7.0_2080s_CMD <- raster("MPI-ESM1-2-HR_ssp370_2071_CMD.tif") # Hargreave's climatic moisture index
MPI_7.0_2080s_CMI <- raster("MPI-ESM1-2-HR_ssp370_2071_CMI.tif") # Hogg's climate moisture index (mm)
MPI_7.0_2080s_DD1040 <- raster("MPI-ESM1-2-HR_ssp370_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MPI_7.0_2080s_Tave_wt <- raster("MPI-ESM1-2-HR_ssp370_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MPI_7.0_2080s_Tave_sp <- raster("MPI-ESM1-2-HR_ssp370_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
MPI_7.0_2080s_Tave_sm <- raster("MPI-ESM1-2-HR_ssp370_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MPI_7.0_2080s_Tave_at <- raster("MPI-ESM1-2-HR_ssp370_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MPI_7.0_2080s_PPT_sp <- raster("MPI-ESM1-2-HR_ssp370_2071_PPT_sp.tif") # spring precipitation
MPI_7.0_2080s_PPT_at <- raster("MPI-ESM1-2-HR_ssp370_2071_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
MPI_7.0_2080_TD <- projectRaster(MPI_7.0_2080s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MPI_7.0_2080.tif")
MPI_7.0_2080_SHM <- projectRaster(MPI_7.0_2080s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MPI_7.0_2080.tif")
MPI_7.0_2080_DD_0 <- projectRaster(MPI_7.0_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MPI_7.0_2080.tif")
MPI_7.0_2080_DD18 <- projectRaster(MPI_7.0_2080s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MPI_7.0_2080.tif")
MPI_7.0_2080_eFFP <- projectRaster(MPI_7.0_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MPI_7.0_2080.tif")
MPI_7.0_2080_MAR <- projectRaster(MPI_7.0_2080s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MPI_7.0_2080.tif")
MPI_7.0_2080_RH <- projectRaster(MPI_7.0_2080s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MPI_7.0_2080.tif")
MPI_7.0_2080_PPT_wt <- projectRaster(MPI_7.0_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MPI_7.0_2080.tif")
MPI_7.0_2080_PPT_sm <- projectRaster(MPI_7.0_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MPI_7.0_2080.tif")
MPI_7.0_2080_MAT <- projectRaster(MPI_7.0_2080s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MPI_7.0_2080.tif")
MPI_7.0_2080_MWMT <- projectRaster(MPI_7.0_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MPI_7.0_2080.tif")
MPI_7.0_2080_MCMT <- projectRaster(MPI_7.0_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MPI_7.0_2080.tif")
MPI_7.0_2080_MAP <- projectRaster(MPI_7.0_2080s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MPI_7.0_2080.tif")
MPI_7.0_2080_MSP <- projectRaster(MPI_7.0_2080s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MPI_7.0_2080.tif")
MPI_7.0_2080_AHM <- projectRaster(MPI_7.0_2080s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MPI_7.0_2080.tif")
MPI_7.0_2080_DD5 <- projectRaster(MPI_7.0_2080s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MPI_7.0_2080.tif")
MPI_7.0_2080_DD_18 <- projectRaster(MPI_7.0_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MPI_7.0_2080.tif")
MPI_7.0_2080_NFFD <- projectRaster(MPI_7.0_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MPI_7.0_2080.tif")
MPI_7.0_2080_FFP <- projectRaster(MPI_7.0_2080s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MPI_7.0_2080.tif")
MPI_7.0_2080_bFFP <- projectRaster(MPI_7.0_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MPI_7.0_2080.tif")
MPI_7.0_2080_PAS <- projectRaster(MPI_7.0_2080s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MPI_7.0_2080.tif")
MPI_7.0_2080_EMT <- projectRaster(MPI_7.0_2080s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MPI_7.0_2080.tif")
MPI_7.0_2080_EXT <- projectRaster(MPI_7.0_2080s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MPI_7.0_2080.tif")
MPI_7.0_2080_Eref <- projectRaster(MPI_7.0_2080s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MPI_7.0_2080.tif")
MPI_7.0_2080_CMD <- projectRaster(MPI_7.0_2080s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MPI_7.0_2080.tif")
MPI_7.0_2080_CMI <- projectRaster(MPI_7.0_2080s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MPI_7.0_2080.tif")
MPI_7.0_2080_DD1040 <- projectRaster(MPI_7.0_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MPI_7.0_2080.tif")
MPI_7.0_2080_Tave_wt <- projectRaster(MPI_7.0_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MPI_7.0_2080.tif")
MPI_7.0_2080_Tave_sp <- projectRaster(MPI_7.0_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_7.0_2080.tif")
MPI_7.0_2080_Tave_sm <- projectRaster(MPI_7.0_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MPI_7.0_2080.tif")
MPI_7.0_2080_Tave_at <- projectRaster(MPI_7.0_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MPI_7.0_2080.tif")
MPI_7.0_2080_PPT_sp <- projectRaster(MPI_7.0_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MPI_7.0_2080.tif")
MPI_7.0_2080_PPT_at <- projectRaster(MPI_7.0_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MPI_7.0_2080.tif")


########### MPI 8.5 2050s #################
setwd("D:/MastersProject/ClimateNA/MPI_8.5_2050s")

MPI_8.5_2050s_TD <- raster("MPI-ESM1-2-HR_ssp585_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MPI_8.5_2050s_SHM <- raster("MPI-ESM1-2-HR_ssp585_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MPI_8.5_2050s_DD_0 <- raster("MPI-ESM1-2-HR_ssp585_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
MPI_8.5_2050s_DD18 <- raster("MPI-ESM1-2-HR_ssp585_2041_DD18.tif") # degree-days above 18 C
MPI_8.5_2050s_eFFP <- raster("MPI-ESM1-2-HR_ssp585_2041_eFFP.tif") # the julian date on which the frost-free period ends
MPI_8.5_2050s_MAR <- raster("MPI-ESM1-2-HR_ssp585_2041_MAR.tif") # mean annual solar radiation
MPI_8.5_2050s_RH <- raster("MPI-ESM1-2-HR_ssp585_2041_RH.tif") # mean annual relative humidity (%)
MPI_8.5_2050s_PPT_wt <- raster("MPI-ESM1-2-HR_ssp585_2041_PPT_wt.tif") # winter precipitation
MPI_8.5_2050s_PPT_sm <- raster("MPI-ESM1-2-HR_ssp585_2041_PPT_sm.tif") # summer precipitation
MPI_8.5_2050s_MAT <- raster("MPI-ESM1-2-HR_ssp585_2041_MAT.tif") # mean annual temperature (C)
MPI_8.5_2050s_MWMT <- raster("MPI-ESM1-2-HR_ssp585_2041_MWMT.tif") # mean temperature of the warmest month
MPI_8.5_2050s_MCMT <- raster("MPI-ESM1-2-HR_ssp585_2041_MCMT.tif") # mean temperature of the coldest month
MPI_8.5_2050s_MAP <- raster("MPI-ESM1-2-HR_ssp585_2041_MAP.tif") # mean annual precipitation (mm)
MPI_8.5_2050s_MSP <- raster("MPI-ESM1-2-HR_ssp585_2041_MSP.tif") # mean summer (may to sept) precipitation
MPI_8.5_2050s_AHM <- raster("MPI-ESM1-2-HR_ssp585_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MPI_8.5_2050s_DD5 <- raster("MPI-ESM1-2-HR_ssp585_2041_DD5.tif") # degree-days above 5 C (growing degree days)
MPI_8.5_2050s_DD_18 <- raster("MPI-ESM1-2-HR_ssp585_2041_DD_18.tif") # degree-days below 18 C
MPI_8.5_2050s_NFFD <- raster("MPI-ESM1-2-HR_ssp585_2041_NFFD.tif") # the number of frost-free days
MPI_8.5_2050s_FFP <- raster("MPI-ESM1-2-HR_ssp585_2041_FFP.tif") # frost-free period
MPI_8.5_2050s_bFFP <- raster("MPI-ESM1-2-HR_ssp585_2041_bFFP.tif") # the julian date on which the frost-free period begins
MPI_8.5_2050s_PAS <- raster("MPI-ESM1-2-HR_ssp585_2041_PAS.tif") # precipitation as snow (mm)
MPI_8.5_2050s_EMT <- raster("MPI-ESM1-2-HR_ssp585_2041_EMT.tif") # extreme minimum temperature over 30 years
MPI_8.5_2050s_EXT <- raster("MPI-ESM1-2-HR_ssp585_2041_EXT.tif") # extreme maximum temperature over 30 years
MPI_8.5_2050s_Eref <- raster("MPI-ESM1-2-HR_ssp585_2041_Eref.tif") # Hargreave's reference evaporation
MPI_8.5_2050s_CMD <- raster("MPI-ESM1-2-HR_ssp585_2041_CMD.tif") # Hargreave's climatic moisture index
MPI_8.5_2050s_CMI <- raster("MPI-ESM1-2-HR_ssp585_2041_CMI.tif") # Hogg's climate moisture index (mm)
MPI_8.5_2050s_DD1040 <- raster("MPI-ESM1-2-HR_ssp585_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MPI_8.5_2050s_Tave_wt <- raster("MPI-ESM1-2-HR_ssp585_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MPI_8.5_2050s_Tave_sp <- raster("MPI-ESM1-2-HR_ssp585_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
MPI_8.5_2050s_Tave_sm <- raster("MPI-ESM1-2-HR_ssp585_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MPI_8.5_2050s_Tave_at <- raster("MPI-ESM1-2-HR_ssp585_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MPI_8.5_2050s_PPT_sp <- raster("MPI-ESM1-2-HR_ssp585_2041_PPT_sp.tif") # spring precipitation
MPI_8.5_2050s_PPT_at <- raster("MPI-ESM1-2-HR_ssp585_2041_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
MPI_8.5_2050_TD <- projectRaster(MPI_8.5_2050s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MPI_8.5_2050.tif")
MPI_8.5_2050_SHM <- projectRaster(MPI_8.5_2050s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MPI_8.5_2050.tif")
MPI_8.5_2050_DD_0 <- projectRaster(MPI_8.5_2050s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MPI_8.5_2050.tif")
MPI_8.5_2050_DD18 <- projectRaster(MPI_8.5_2050s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MPI_8.5_2050.tif")
MPI_8.5_2050_eFFP <- projectRaster(MPI_8.5_2050s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MPI_8.5_2050.tif")
MPI_8.5_2050_MAR <- projectRaster(MPI_8.5_2050s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MPI_8.5_2050.tif")
MPI_8.5_2050_RH <- projectRaster(MPI_8.5_2050s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MPI_8.5_2050.tif")
MPI_8.5_2050_PPT_wt <- projectRaster(MPI_8.5_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MPI_8.5_2050.tif")
MPI_8.5_2050_PPT_sm <- projectRaster(MPI_8.5_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MPI_8.5_2050.tif")
MPI_8.5_2050_MAT <- projectRaster(MPI_8.5_2050s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MPI_8.5_2050.tif")
MPI_8.5_2050_MWMT <- projectRaster(MPI_8.5_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MPI_8.5_2050.tif")
MPI_8.5_2050_MCMT <- projectRaster(MPI_8.5_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MPI_8.5_2050.tif")
MPI_8.5_2050_MAP <- projectRaster(MPI_8.5_2050s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MPI_8.5_2050.tif")
MPI_8.5_2050_MSP <- projectRaster(MPI_8.5_2050s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MPI_8.5_2050.tif")
MPI_8.5_2050_AHM <- projectRaster(MPI_8.5_2050s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MPI_8.5_2050.tif")
MPI_8.5_2050_DD5 <- projectRaster(MPI_8.5_2050s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MPI_8.5_2050.tif")
MPI_8.5_2050_DD_18 <- projectRaster(MPI_8.5_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MPI_8.5_2050.tif")
MPI_8.5_2050_NFFD <- projectRaster(MPI_8.5_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MPI_8.5_2050.tif")
MPI_8.5_2050_FFP <- projectRaster(MPI_8.5_2050s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MPI_8.5_2050.tif")
MPI_8.5_2050_bFFP <- projectRaster(MPI_8.5_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MPI_8.5_2050.tif")
MPI_8.5_2050_PAS <- projectRaster(MPI_8.5_2050s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MPI_8.5_2050.tif")
MPI_8.5_2050_EMT <- projectRaster(MPI_8.5_2050s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MPI_8.5_2050.tif")
MPI_8.5_2050_EXT <- projectRaster(MPI_8.5_2050s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MPI_8.5_2050.tif")
MPI_8.5_2050_Eref <- projectRaster(MPI_8.5_2050s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MPI_8.5_2050.tif")
MPI_8.5_2050_CMD <- projectRaster(MPI_8.5_2050s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MPI_8.5_2050.tif")
MPI_8.5_2050_CMI <- projectRaster(MPI_8.5_2050s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MPI_8.5_2050.tif")
MPI_8.5_2050_DD1040 <- projectRaster(MPI_8.5_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MPI_8.5_2050.tif")
MPI_8.5_2050_Tave_wt <- projectRaster(MPI_8.5_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MPI_8.5_2050.tif")
MPI_8.5_2050_Tave_sp <- projectRaster(MPI_8.5_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_8.5_2050.tif")
MPI_8.5_2050_Tave_sm <- projectRaster(MPI_8.5_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MPI_8.5_2050.tif")
MPI_8.5_2050_Tave_at <- projectRaster(MPI_8.5_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MPI_8.5_2050.tif")
MPI_8.5_2050_PPT_sp <- projectRaster(MPI_8.5_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MPI_8.5_2050.tif")
MPI_8.5_2050_PPT_at <- projectRaster(MPI_8.5_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MPI_8.5_2050.tif")

####### MPI 8.5 2080s ######################
setwd("D:/MastersProject/ClimateNA/MPI_8.5_2080s")

MPI_8.5_2080s_TD <- raster("MPI-ESM1-2-HR_ssp585_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MPI_8.5_2080s_SHM <- raster("MPI-ESM1-2-HR_ssp585_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MPI_8.5_2080s_DD_0 <- raster("MPI-ESM1-2-HR_ssp585_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
MPI_8.5_2080s_DD18 <- raster("MPI-ESM1-2-HR_ssp585_2071_DD18.tif") # degree-days above 18 C
MPI_8.5_2080s_eFFP <- raster("MPI-ESM1-2-HR_ssp585_2071_eFFP.tif") # the julian date on which the frost-free period ends
MPI_8.5_2080s_MAR <- raster("MPI-ESM1-2-HR_ssp585_2071_MAR.tif") # mean annual solar radiation
MPI_8.5_2080s_RH <- raster("MPI-ESM1-2-HR_ssp585_2071_RH.tif") # mean annual relative humidity (%)
MPI_8.5_2080s_PPT_wt <- raster("MPI-ESM1-2-HR_ssp585_2071_PPT_wt.tif") # winter precipitation
MPI_8.5_2080s_PPT_sm <- raster("MPI-ESM1-2-HR_ssp585_2071_PPT_sm.tif") # summer precipitation
MPI_8.5_2080s_MAT <- raster("MPI-ESM1-2-HR_ssp585_2071_MAT.tif") # mean annual temperature (C)
MPI_8.5_2080s_MWMT <- raster("MPI-ESM1-2-HR_ssp585_2071_MWMT.tif") # mean temperature of the warmest month
MPI_8.5_2080s_MCMT <- raster("MPI-ESM1-2-HR_ssp585_2071_MCMT.tif") # mean temperature of the coldest month
MPI_8.5_2080s_MAP <- raster("MPI-ESM1-2-HR_ssp585_2071_MAP.tif") # mean annual precipitation (mm)
MPI_8.5_2080s_MSP <- raster("MPI-ESM1-2-HR_ssp585_2071_MSP.tif") # mean summer (may to sept) precipitation
MPI_8.5_2080s_AHM <- raster("MPI-ESM1-2-HR_ssp585_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MPI_8.5_2080s_DD5 <- raster("MPI-ESM1-2-HR_ssp585_2071_DD5.tif") # degree-days above 5 C (growing degree days)
MPI_8.5_2080s_DD_18 <- raster("MPI-ESM1-2-HR_ssp585_2071_DD_18.tif") # degree-days below 18 C
MPI_8.5_2080s_NFFD <- raster("MPI-ESM1-2-HR_ssp585_2071_NFFD.tif") # the number of frost-free days
MPI_8.5_2080s_FFP <- raster("MPI-ESM1-2-HR_ssp585_2071_FFP.tif") # frost-free period
MPI_8.5_2080s_bFFP <- raster("MPI-ESM1-2-HR_ssp585_2071_bFFP.tif") # the julian date on which the frost-free period begins
MPI_8.5_2080s_PAS <- raster("MPI-ESM1-2-HR_ssp585_2071_PAS.tif") # precipitation as snow (mm)
MPI_8.5_2080s_EMT <- raster("MPI-ESM1-2-HR_ssp585_2071_EMT.tif") # extreme minimum temperature over 30 years
MPI_8.5_2080s_EXT <- raster("MPI-ESM1-2-HR_ssp585_2071_EXT.tif") # extreme maximum temperature over 30 years
MPI_8.5_2080s_Eref <- raster("MPI-ESM1-2-HR_ssp585_2071_Eref.tif") # Hargreave's reference evaporation
MPI_8.5_2080s_CMD <- raster("MPI-ESM1-2-HR_ssp585_2071_CMD.tif") # Hargreave's climatic moisture index
MPI_8.5_2080s_CMI <- raster("MPI-ESM1-2-HR_ssp585_2071_CMI.tif") # Hogg's climate moisture index (mm)
MPI_8.5_2080s_DD1040 <- raster("MPI-ESM1-2-HR_ssp585_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MPI_8.5_2080s_Tave_wt <- raster("MPI-ESM1-2-HR_ssp585_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MPI_8.5_2080s_Tave_sp <- raster("MPI-ESM1-2-HR_ssp585_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
MPI_8.5_2080s_Tave_sm <- raster("MPI-ESM1-2-HR_ssp585_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MPI_8.5_2080s_Tave_at <- raster("MPI-ESM1-2-HR_ssp585_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MPI_8.5_2080s_PPT_sp <- raster("MPI-ESM1-2-HR_ssp585_2071_PPT_sp.tif") # spring precipitation
MPI_8.5_2080s_PPT_at <- raster("MPI-ESM1-2-HR_ssp585_2071_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
MPI_8.5_2080_TD <- projectRaster(MPI_8.5_2080s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MPI_8.5_2080.tif")
MPI_8.5_2080_SHM <- projectRaster(MPI_8.5_2080s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MPI_8.5_2080.tif")
MPI_8.5_2080_DD_0 <- projectRaster(MPI_8.5_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MPI_8.5_2080.tif")
MPI_8.5_2080_DD18 <- projectRaster(MPI_8.5_2080s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MPI_8.5_2080.tif")
MPI_8.5_2080_eFFP <- projectRaster(MPI_8.5_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MPI_8.5_2080.tif")
MPI_8.5_2080_MAR <- projectRaster(MPI_8.5_2080s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MPI_8.5_2080.tif")
MPI_8.5_2080_RH <- projectRaster(MPI_8.5_2080s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MPI_8.5_2080.tif")
MPI_8.5_2080_PPT_wt <- projectRaster(MPI_8.5_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MPI_8.5_2080.tif")
MPI_8.5_2080_PPT_sm <- projectRaster(MPI_8.5_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MPI_8.5_2080.tif")
MPI_8.5_2080_MAT <- projectRaster(MPI_8.5_2080s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MPI_8.5_2080.tif")
MPI_8.5_2080_MWMT <- projectRaster(MPI_8.5_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MPI_8.5_2080.tif")
MPI_8.5_2080_MCMT <- projectRaster(MPI_8.5_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MPI_8.5_2080.tif")
MPI_8.5_2080_MAP <- projectRaster(MPI_8.5_2080s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MPI_8.5_2080.tif")
MPI_8.5_2080_MSP <- projectRaster(MPI_8.5_2080s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MPI_8.5_2080.tif")
MPI_8.5_2080_AHM <- projectRaster(MPI_8.5_2080s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MPI_8.5_2080.tif")
MPI_8.5_2080_DD5 <- projectRaster(MPI_8.5_2080s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MPI_8.5_2080.tif")
MPI_8.5_2080_DD_18 <- projectRaster(MPI_8.5_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MPI_8.5_2080.tif")
MPI_8.5_2080_NFFD <- projectRaster(MPI_8.5_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MPI_8.5_2080.tif")
MPI_8.5_2080_FFP <- projectRaster(MPI_8.5_2080s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MPI_8.5_2080.tif")
MPI_8.5_2080_bFFP <- projectRaster(MPI_8.5_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MPI_8.5_2080.tif")
MPI_8.5_2080_PAS <- projectRaster(MPI_8.5_2080s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MPI_8.5_2080.tif")
MPI_8.5_2080_EMT <- projectRaster(MPI_8.5_2080s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MPI_8.5_2080.tif")
MPI_8.5_2080_EXT <- projectRaster(MPI_8.5_2080s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MPI_8.5_2080.tif")
MPI_8.5_2080_Eref <- projectRaster(MPI_8.5_2080s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MPI_8.5_2080.tif")
MPI_8.5_2080_CMD <- projectRaster(MPI_8.5_2080s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MPI_8.5_2080.tif")
MPI_8.5_2080_CMI <- projectRaster(MPI_8.5_2080s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MPI_8.5_2080.tif")
MPI_8.5_2080_DD1040 <- projectRaster(MPI_8.5_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MPI_8.5_2080.tif")
MPI_8.5_2080_Tave_wt <- projectRaster(MPI_8.5_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MPI_8.5_2080.tif")
MPI_8.5_2080_Tave_sp <- projectRaster(MPI_8.5_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_8.5_2080.tif")
MPI_8.5_2080_Tave_sm <- projectRaster(MPI_8.5_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MPI_8.5_2080.tif")
MPI_8.5_2080_Tave_at <- projectRaster(MPI_8.5_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MPI_8.5_2080.tif")
MPI_8.5_2080_PPT_sp <- projectRaster(MPI_8.5_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MPI_8.5_2080.tif")
MPI_8.5_2080_PPT_at <- projectRaster(MPI_8.5_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MPI_8.5_2080.tif")


############# UK ###############

################# UK 4.5 2050s #################
setwd("D:/MastersProject/ClimateNA/UK_4.5_2050s")
UK_4.5_2050s_TD <- raster("UKESM1-0-LL_ssp245_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
UK_4.5_2050s_SHM <- raster("UKESM1-0-LL_ssp245_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
UK_4.5_2050s_DD_0 <- raster("UKESM1-0-LL_ssp245_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
UK_4.5_2050s_DD18 <- raster("UKESM1-0-LL_ssp245_2041_DD18.tif") # degree-days above 18 C
UK_4.5_2050s_eFFP <- raster("UKESM1-0-LL_ssp245_2041_eFFP.tif") # the julian date on which the frost-free period ends
UK_4.5_2050s_MAR <- raster("UKESM1-0-LL_ssp245_2041_MAR.tif") # mean annual solar radiation
UK_4.5_2050s_RH <- raster("UKESM1-0-LL_ssp245_2041_RH.tif") # mean annual relative humidity (%)
UK_4.5_2050s_PPT_wt <- raster("UKESM1-0-LL_ssp245_2041_PPT_wt.tif") # winter precipitation
UK_4.5_2050s_PPT_sm <- raster("UKESM1-0-LL_ssp245_2041_PPT_sm.tif") # summer precipitation
UK_4.5_2050s_MAT <- raster("UKESM1-0-LL_ssp245_2041_MAT.tif") # mean annual temperature (C)
UK_4.5_2050s_MWMT <- raster("UKESM1-0-LL_ssp245_2041_MWMT.tif") # mean temperature of the warmest month
UK_4.5_2050s_MCMT <- raster("UKESM1-0-LL_ssp245_2041_MCMT.tif") # mean temperature of the coldest month
UK_4.5_2050s_MAP <- raster("UKESM1-0-LL_ssp245_2041_MAP.tif") # mean annual precipitation (mm)
UK_4.5_2050s_MSP <- raster("UKESM1-0-LL_ssp245_2041_MSP.tif") # mean summer (may to sept) precipitation
UK_4.5_2050s_AHM <- raster("UKESM1-0-LL_ssp245_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
UK_4.5_2050s_DD5 <- raster("UKESM1-0-LL_ssp245_2041_DD5.tif") # degree-days above 5 C (growing degree days)
UK_4.5_2050s_DD_18 <- raster("UKESM1-0-LL_ssp245_2041_DD_18.tif") # degree-days below 18 C
UK_4.5_2050s_NFFD <- raster("UKESM1-0-LL_ssp245_2041_NFFD.tif") # the number of frost-free days
UK_4.5_2050s_FFP <- raster("UKESM1-0-LL_ssp245_2041_FFP.tif") # frost-free period
UK_4.5_2050s_bFFP <- raster("UKESM1-0-LL_ssp245_2041_bFFP.tif") # the julian date on which the frost-free period begins
UK_4.5_2050s_PAS <- raster("UKESM1-0-LL_ssp245_2041_PAS.tif") # precipitation as snow (mm)
UK_4.5_2050s_EMT <- raster("UKESM1-0-LL_ssp245_2041_EMT.tif") # extreme minimum temperature over 30 years
UK_4.5_2050s_EXT <- raster("UKESM1-0-LL_ssp245_2041_EXT.tif") # extreme maximum temperature over 30 years
UK_4.5_2050s_Eref <- raster("UKESM1-0-LL_ssp245_2041_Eref.tif") # Hargreave's reference evaporation
UK_4.5_2050s_CMD <- raster("UKESM1-0-LL_ssp245_2041_CMD.tif") # Hargreave's climatic moisture index
UK_4.5_2050s_CMI <- raster("UKESM1-0-LL_ssp245_2041_CMI.tif") # Hogg's climate moisture index (mm)
UK_4.5_2050s_DD1040 <- raster("UKESM1-0-LL_ssp245_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
UK_4.5_2050s_Tave_wt <- raster("UKESM1-0-LL_ssp245_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
UK_4.5_2050s_Tave_sp <- raster("UKESM1-0-LL_ssp245_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
UK_4.5_2050s_Tave_sm <- raster("UKESM1-0-LL_ssp245_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
UK_4.5_2050s_Tave_at <- raster("UKESM1-0-LL_ssp245_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
UK_4.5_2050s_PPT_sp <- raster("UKESM1-0-LL_ssp245_2041_PPT_sp.tif") # spring precipitation
UK_4.5_2050s_PPT_at <- raster("UKESM1-0-LL_ssp245_2041_PPT_at.tif") # autumn precipitation

setwd("D:/MastersProject/Formatted variables")
UK_4.5_2050_TD <- projectRaster(UK_4.5_2050s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_UK_4.5_2050.tif")
UK_4.5_2050_SHM <- projectRaster(UK_4.5_2050s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_UK_4.5_2050.tif")
UK_4.5_2050_DD_0 <- projectRaster(UK_4.5_2050s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_UK_4.5_2050.tif")
UK_4.5_2050_DD18 <- projectRaster(UK_4.5_2050s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_UK_4.5_2050.tif")
UK_4.5_2050_eFFP <- projectRaster(UK_4.5_2050s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_UK_4.5_2050.tif")
UK_4.5_2050_MAR <- projectRaster(UK_4.5_2050s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_UK_4.5_2050.tif")
UK_4.5_2050_RH <- projectRaster(UK_4.5_2050s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_UK_4.5_2050.tif")
UK_4.5_2050_PPT_wt <- projectRaster(UK_4.5_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_UK_4.5_2050.tif")
UK_4.5_2050_PPT_sm <- projectRaster(UK_4.5_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_UK_4.5_2050.tif")
UK_4.5_2050_EXT <- projectRaster(UK_4.5_2050s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_UK_4.5_2050.tif")
UK_4.5_2050_MAT <- projectRaster(UK_4.5_2050s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_UK_4.5_2050.tif")
UK_4.5_2050_MWMT <- projectRaster(UK_4.5_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_UK_4.5_2050.tif")
UK_4.5_2050_MCMT <- projectRaster(UK_4.5_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_UK_4.5_2050.tif")
UK_4.5_2050_MAP <- projectRaster(UK_4.5_2050s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_UK_4.5_2050.tif")
UK_4.5_2050_MSP <- projectRaster(UK_4.5_2050s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_UK_4.5_2050.tif")
UK_4.5_2050_AHM <- projectRaster(UK_4.5_2050s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_UK_4.5_2050.tif")
UK_4.5_2050_DD5 <- projectRaster(UK_4.5_2050s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_UK_4.5_2050.tif")
UK_4.5_2050_DD_18 <- projectRaster(UK_4.5_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_UK_4.5_2050.tif")
UK_4.5_2050_NFFD <- projectRaster(UK_4.5_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_UK_4.5_2050.tif")
UK_4.5_2050_FFP <- projectRaster(UK_4.5_2050s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_UK_4.5_2050.tif")
UK_4.5_2050_bFFP <- projectRaster(UK_4.5_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_UK_4.5_2050.tif")
UK_4.5_2050_PAS <- projectRaster(UK_4.5_2050s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_UK_4.5_2050.tif")
UK_4.5_2050_EMT <- projectRaster(UK_4.5_2050s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_UK_4.5_2050.tif")
UK_4.5_2050_Eref <- projectRaster(UK_4.5_2050s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_UK_4.5_2050.tif")
UK_4.5_2050_CMD <- projectRaster(UK_4.5_2050s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_UK_4.5_2050.tif")
UK_4.5_2050_CMI <- projectRaster(UK_4.5_2050s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_UK_4.5_2050.tif")
UK_4.5_2050_DD1040 <- projectRaster(UK_4.5_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_UK_4.5_2050.tif")
UK_4.5_2050_Tave_wt <- projectRaster(UK_4.5_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_UK_4.5_2050.tif")
UK_4.5_2050_Tave_sp <- projectRaster(UK_4.5_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_UK_4.5_2050.tif")
UK_4.5_2050_Tave_sm <- projectRaster(UK_4.5_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_UK_4.5_2050.tif")
UK_4.5_2050_Tave_at <- projectRaster(UK_4.5_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_UK_4.5_2050.tif")
UK_4.5_2050_PPT_sp <- projectRaster(UK_4.5_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_UK_4.5_2050.tif")
UK_4.5_2050_PPT_at <- projectRaster(UK_4.5_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_UK_4.5_2050.tif")


############ UK 4.5 2080s #################
setwd("D:/MastersProject/ClimateNA/UK_4.5_2080s")
UK_4.5_2080s_TD <- raster("UKESM1-0-LL_ssp245_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
UK_4.5_2080s_SHM <- raster("UKESM1-0-LL_ssp245_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
UK_4.5_2080s_DD_0 <- raster("UKESM1-0-LL_ssp245_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
UK_4.5_2080s_DD18 <- raster("UKESM1-0-LL_ssp245_2071_DD18.tif") # degree-days above 18 C
UK_4.5_2080s_eFFP <- raster("UKESM1-0-LL_ssp245_2071_eFFP.tif") # the julian date on which the frost-free period ends
UK_4.5_2080s_MAR <- raster("UKESM1-0-LL_ssp245_2071_MAR.tif") # mean annual solar radiation
UK_4.5_2080s_RH <- raster("UKESM1-0-LL_ssp245_2071_RH.tif") # mean annual relative humidity (%)
UK_4.5_2080s_PPT_wt <- raster("UKESM1-0-LL_ssp245_2071_PPT_wt.tif") # winter precipitation
UK_4.5_2080s_PPT_sm <- raster("UKESM1-0-LL_ssp245_2071_PPT_sm.tif") # summer precipitation
UK_4.5_2080s_MAT <- raster("UKESM1-0-LL_ssp245_2071_MAT.tif") # mean annual temperature (C)
UK_4.5_2080s_MWMT <- raster("UKESM1-0-LL_ssp245_2071_MWMT.tif") # mean temperature of the warmest month
UK_4.5_2080s_MCMT <- raster("UKESM1-0-LL_ssp245_2071_MCMT.tif") # mean temperature of the coldest month
UK_4.5_2080s_MAP <- raster("UKESM1-0-LL_ssp245_2071_MAP.tif") # mean annual precipitation (mm)
UK_4.5_2080s_MSP <- raster("UKESM1-0-LL_ssp245_2071_MSP.tif") # mean summer (may to sept) precipitation
UK_4.5_2080s_AHM <- raster("UKESM1-0-LL_ssp245_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
UK_4.5_2080s_DD5 <- raster("UKESM1-0-LL_ssp245_2071_DD5.tif") # degree-days above 5 C (growing degree days)
UK_4.5_2080s_DD_18 <- raster("UKESM1-0-LL_ssp245_2071_DD_18.tif") # degree-days below 18 C
UK_4.5_2080s_NFFD <- raster("UKESM1-0-LL_ssp245_2071_NFFD.tif") # the number of frost-free days
UK_4.5_2080s_FFP <- raster("UKESM1-0-LL_ssp245_2071_FFP.tif") # frost-free period
UK_4.5_2080s_bFFP <- raster("UKESM1-0-LL_ssp245_2071_bFFP.tif") # the julian date on which the frost-free period begins
UK_4.5_2080s_PAS <- raster("UKESM1-0-LL_ssp245_2071_PAS.tif") # precipitation as snow (mm)
UK_4.5_2080s_EMT <- raster("UKESM1-0-LL_ssp245_2071_EMT.tif") # extreme minimum temperature over 30 years
UK_4.5_2080s_EXT <- raster("UKESM1-0-LL_ssp245_2071_EXT.tif") # extreme maximum temperature over 30 years
UK_4.5_2080s_Eref <- raster("UKESM1-0-LL_ssp245_2071_Eref.tif") # Hargreave's reference evaporation
UK_4.5_2080s_CMD <- raster("UKESM1-0-LL_ssp245_2071_CMD.tif") # Hargreave's climatic moisture index
UK_4.5_2080s_CMI <- raster("UKESM1-0-LL_ssp245_2071_CMI.tif") # Hogg's climate moisture index (mm)
UK_4.5_2080s_DD1040 <- raster("UKESM1-0-LL_ssp245_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
UK_4.5_2080s_Tave_wt <- raster("UKESM1-0-LL_ssp245_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
UK_4.5_2080s_Tave_sp <- raster("UKESM1-0-LL_ssp245_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
UK_4.5_2080s_Tave_sm <- raster("UKESM1-0-LL_ssp245_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
UK_4.5_2080s_Tave_at <- raster("UKESM1-0-LL_ssp245_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
UK_4.5_2080s_PPT_sp <- raster("UKESM1-0-LL_ssp245_2071_PPT_sp.tif") # spring precipitation
UK_4.5_2080s_PPT_at <- raster("UKESM1-0-LL_ssp245_2071_PPT_at.tif") # autumn precipitation

setwd("D:/MastersProject/Formatted variables")
UK_4.5_2080_TD <- projectRaster(UK_4.5_2080s_TD, HII_gcs, method = 'bilinear', 
                                filename = "TD_UK_4.5_2080.tif")
UK_4.5_2080_SHM <- projectRaster(UK_4.5_2080s_SHM, HII_gcs, method = 'bilinear', 
                                 filename = "SHM_UK_4.5_2080.tif")
UK_4.5_2080_DD_0 <- projectRaster(UK_4.5_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                  filename = "DD_0_UK_4.5_2080.tif")
UK_4.5_2080_DD18 <- projectRaster(UK_4.5_2080s_DD18, HII_gcs, method = 'bilinear', 
                                  filename = "DD18_UK_4.5_2080.tif")
UK_4.5_2080_eFFP <- projectRaster(UK_4.5_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                  filename = "eFFP_UK_4.5_2080.tif")
UK_4.5_2080_MAR <- projectRaster(UK_4.5_2080s_MAR, HII_gcs, method = 'bilinear', 
                                 filename = "MAR_UK_4.5_2080.tif")
UK_4.5_2080_RH <- projectRaster(UK_4.5_2080s_RH, HII_gcs, method = 'bilinear', 
                                filename = "RH_UK_4.5_2080.tif")
UK_4.5_2080_PPT_wt <- projectRaster(UK_4.5_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_wt_UK_4.5_2080.tif")
UK_4.5_2080_PPT_sm <- projectRaster(UK_4.5_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sm_UK_4.5_2080.tif")
UK_4.5_2080_EXT <- projectRaster(UK_4.5_2080s_EXT, HII_gcs, method = 'bilinear', 
                                 filename = "EXT_UK_4.5_2080.tif")
UK_4.5_2080_MAT <- projectRaster(UK_4.5_2080s_MAT, HII_gcs, method = 'bilinear', 
                                 filename = "MAT_UK_4.5_2080.tif")
UK_4.5_2080_MWMT <- projectRaster(UK_4.5_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                  filename = "MWMT_UK_4.5_2080.tif")
UK_4.5_2080_MCMT <- projectRaster(UK_4.5_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                  filename = "MCMT_UK_4.5_2080.tif")
UK_4.5_2080_MAP <- projectRaster(UK_4.5_2080s_MAP, HII_gcs, method = 'bilinear', 
                                 filename = "MAP_UK_4.5_2080.tif")
UK_4.5_2080_MSP <- projectRaster(UK_4.5_2080s_MSP, HII_gcs, method = 'bilinear', 
                                 filename = "MSP_UK_4.5_2080.tif")
UK_4.5_2080_AHM <- projectRaster(UK_4.5_2080s_AHM, HII_gcs, method = 'bilinear', 
                                 filename = "AHM_UK_4.5_2080.tif")
UK_4.5_2080_DD5 <- projectRaster(UK_4.5_2080s_DD5, HII_gcs, method = 'bilinear', 
                                 filename = "DD5_UK_4.5_2080.tif")
UK_4.5_2080_DD_18 <- projectRaster(UK_4.5_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                   filename = "DD_18_UK_4.5_2080.tif")
UK_4.5_2080_NFFD <- projectRaster(UK_4.5_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                  filename = "NFFD_UK_4.5_2080.tif")
UK_4.5_2080_FFP <- projectRaster(UK_4.5_2080s_FFP, HII_gcs, method = 'bilinear', 
                                 filename = "FFP_UK_4.5_2080.tif")
UK_4.5_2080_bFFP <- projectRaster(UK_4.5_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                  filename = "bFFP_UK_4.5_2080.tif")
UK_4.5_2080_PAS <- projectRaster(UK_4.5_2080s_PAS, HII_gcs, method = 'bilinear', 
                                 filename = "PAS_UK_4.5_2080.tif")
UK_4.5_2080_EMT <- projectRaster(UK_4.5_2080s_EMT, HII_gcs, method = 'bilinear', 
                                 filename = "EMT_UK_4.5_2080.tif")
UK_4.5_2080_Eref <- projectRaster(UK_4.5_2080s_Eref, HII_gcs, method = 'bilinear', 
                                  filename = "Eref_UK_4.5_2080.tif")
UK_4.5_2080_CMD <- projectRaster(UK_4.5_2080s_CMD, HII_gcs, method = 'bilinear', 
                                 filename = "CMD_UK_4.5_2080.tif")
UK_4.5_2080_CMI <- projectRaster(UK_4.5_2080s_CMI, HII_gcs, method = 'bilinear', 
                                 filename = "CMI_UK_4.5_2080.tif")
UK_4.5_2080_DD1040 <- projectRaster(UK_4.5_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                    filename = "DD1040_UK_4.5_2080.tif")
UK_4.5_2080_Tave_wt <- projectRaster(UK_4.5_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_wt_UK_4.5_2080.tif")
UK_4.5_2080_Tave_sp <- projectRaster(UK_4.5_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sp_UK_4.5_2080.tif")
UK_4.5_2080_Tave_sm <- projectRaster(UK_4.5_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sm_UK_4.5_2080.tif")
UK_4.5_2080_Tave_at <- projectRaster(UK_4.5_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_at_UK_4.5_2080.tif")
UK_4.5_2080_PPT_sp <- projectRaster(UK_4.5_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sp_UK_4.5_2080.tif")
UK_4.5_2080_PPT_at <- projectRaster(UK_4.5_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_at_UK_4.5_2080.tif")

############## UK 7.0 2050s #################
setwd("D:/MastersProject/ClimateNA/UK_7.0_2050s") 
UK_7.0_2050s_TD <- raster("UKESM1-0-LL_ssp370_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
UK_7.0_2050s_SHM <- raster("UKESM1-0-LL_ssp370_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
UK_7.0_2050s_DD_0 <- raster("UKESM1-0-LL_ssp370_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
UK_7.0_2050s_DD18 <- raster("UKESM1-0-LL_ssp370_2041_DD18.tif") # degree-days above 18 C
UK_7.0_2050s_eFFP <- raster("UKESM1-0-LL_ssp370_2041_eFFP.tif") # the julian date on which the frost-free period ends
UK_7.0_2050s_MAR <- raster("UKESM1-0-LL_ssp370_2041_MAR.tif") # mean annual solar radiation
UK_7.0_2050s_RH <- raster("UKESM1-0-LL_ssp370_2041_RH.tif") # mean annual relative humidity (%)
UK_7.0_2050s_PPT_wt <- raster("UKESM1-0-LL_ssp370_2041_PPT_wt.tif") # winter precipitation
UK_7.0_2050s_PPT_sm <- raster("UKESM1-0-LL_ssp370_2041_PPT_sm.tif") # summer precipitation
UK_7.0_2050s_MAT <- raster("UKESM1-0-LL_ssp370_2041_MAT.tif") # mean annual temperature (C)
UK_7.0_2050s_MWMT <- raster("UKESM1-0-LL_ssp370_2041_MWMT.tif") # mean temperature of the warmest month
UK_7.0_2050s_MCMT <- raster("UKESM1-0-LL_ssp370_2041_MCMT.tif") # mean temperature of the coldest month
UK_7.0_2050s_MAP <- raster("UKESM1-0-LL_ssp370_2041_MAP.tif") # mean annual precipitation (mm)
UK_7.0_2050s_MSP <- raster("UKESM1-0-LL_ssp370_2041_MSP.tif") # mean summer (may to sept) precipitation
UK_7.0_2050s_AHM <- raster("UKESM1-0-LL_ssp370_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
UK_7.0_2050s_DD5 <- raster("UKESM1-0-LL_ssp370_2041_DD5.tif") # degree-days above 5 C (growing degree days)
UK_7.0_2050s_DD_18 <- raster("UKESM1-0-LL_ssp370_2041_DD_18.tif") # degree-days below 18 C
UK_7.0_2050s_NFFD <- raster("UKESM1-0-LL_ssp370_2041_NFFD.tif") # the number of frost-free days
UK_7.0_2050s_FFP <- raster("UKESM1-0-LL_ssp370_2041_FFP.tif") # frost-free period
UK_7.0_2050s_bFFP <- raster("UKESM1-0-LL_ssp370_2041_bFFP.tif") # the julian date on which the frost-free period begins
UK_7.0_2050s_PAS <- raster("UKESM1-0-LL_ssp370_2041_PAS.tif") # precipitation as snow (mm)
UK_7.0_2050s_EMT <- raster("UKESM1-0-LL_ssp370_2041_EMT.tif") # extreme minimum temperature over 30 years
UK_7.0_2050s_EXT <- raster("UKESM1-0-LL_ssp370_2041_EXT.tif") # extreme maximum temperature over 30 years
UK_7.0_2050s_Eref <- raster("UKESM1-0-LL_ssp370_2041_Eref.tif") # Hargreave's reference evaporation
UK_7.0_2050s_CMD <- raster("UKESM1-0-LL_ssp370_2041_CMD.tif") # Hargreave's climatic moisture index
UK_7.0_2050s_CMI <- raster("UKESM1-0-LL_ssp370_2041_CMI.tif") # Hogg's climate moisture index (mm)
UK_7.0_2050s_DD1040 <- raster("UKESM1-0-LL_ssp370_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
UK_7.0_2050s_Tave_wt <- raster("UKESM1-0-LL_ssp370_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
UK_7.0_2050s_Tave_sp <- raster("UKESM1-0-LL_ssp370_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
UK_7.0_2050s_Tave_sm <- raster("UKESM1-0-LL_ssp370_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
UK_7.0_2050s_Tave_at <- raster("UKESM1-0-LL_ssp370_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
UK_7.0_2050s_PPT_sp <- raster("UKESM1-0-LL_ssp370_2041_PPT_sp.tif") # spring precipitation
UK_7.0_2050s_PPT_at <- raster("UKESM1-0-LL_ssp370_2041_PPT_at.tif") # autumn precipitation

setwd("D:/MastersProject/Formatted variables")
UK_7.0_2050_TD <- projectRaster(UK_7.0_2050s_TD, HII_gcs, method = 'bilinear', 
                                filename = "TD_UK_7.0_2050.tif")
UK_7.0_2050_SHM <- projectRaster(UK_7.0_2050s_SHM, HII_gcs, method = 'bilinear', 
                                 filename = "SHM_UK_7.0_2050.tif")
UK_7.0_2050_DD_0 <- projectRaster(UK_7.0_2050s_DD_0, HII_gcs, method = 'bilinear', 
                                  filename = "DD_0_UK_7.0_2050.tif")
UK_7.0_2050_DD18 <- projectRaster(UK_7.0_2050s_DD18, HII_gcs, method = 'bilinear', 
                                  filename = "DD18_UK_7.0_2050.tif")
UK_7.0_2050_eFFP <- projectRaster(UK_7.0_2050s_eFFP, HII_gcs, method = 'bilinear', 
                                  filename = "eFFP_UK_7.0_2050.tif")
UK_7.0_2050_MAR <- projectRaster(UK_7.0_2050s_MAR, HII_gcs, method = 'bilinear', 
                                 filename = "MAR_UK_7.0_2050.tif")
UK_7.0_2050_RH <- projectRaster(UK_7.0_2050s_RH, HII_gcs, method = 'bilinear', 
                                filename = "RH_UK_7.0_2050.tif")
UK_7.0_2050_PPT_wt <- projectRaster(UK_7.0_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_wt_UK_7.0_2050.tif")
UK_7.0_2050_PPT_sm <- projectRaster(UK_7.0_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sm_UK_7.0_2050.tif")
UK_7.0_2050_EXT <- projectRaster(UK_7.0_2050s_EXT, HII_gcs, method = 'bilinear', 
                                 filename = "EXT_UK_7.0_2050.tif")
UK_7.0_2050_MAT <- projectRaster(UK_7.0_2050s_MAT, HII_gcs, method = 'bilinear', 
                                 filename = "MAT_UK_7.0_2050.tif")
UK_7.0_2050_MWMT <- projectRaster(UK_7.0_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                  filename = "MWMT_UK_7.0_2050.tif")
UK_7.0_2050_MCMT <- projectRaster(UK_7.0_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                  filename = "MCMT_UK_7.0_2050.tif")
UK_7.0_2050_MAP <- projectRaster(UK_7.0_2050s_MAP, HII_gcs, method = 'bilinear', 
                                 filename = "MAP_UK_7.0_2050.tif")
UK_7.0_2050_MSP <- projectRaster(UK_7.0_2050s_MSP, HII_gcs, method = 'bilinear', 
                                 filename = "MSP_UK_7.0_2050.tif")
UK_7.0_2050_AHM <- projectRaster(UK_7.0_2050s_AHM, HII_gcs, method = 'bilinear', 
                                 filename = "AHM_UK_7.0_2050.tif")
UK_7.0_2050_DD5 <- projectRaster(UK_7.0_2050s_DD5, HII_gcs, method = 'bilinear', 
                                 filename = "DD5_UK_7.0_2050.tif")
UK_7.0_2050_DD_18 <- projectRaster(UK_7.0_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                   filename = "DD_18_UK_7.0_2050.tif")
UK_7.0_2050_NFFD <- projectRaster(UK_7.0_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                  filename = "NFFD_UK_7.0_2050.tif")
UK_7.0_2050_FFP <- projectRaster(UK_7.0_2050s_FFP, HII_gcs, method = 'bilinear', 
                                 filename = "FFP_UK_7.0_2050.tif")
UK_7.0_2050_bFFP <- projectRaster(UK_7.0_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                  filename = "bFFP_UK_7.0_2050.tif")
UK_7.0_2050_PAS <- projectRaster(UK_7.0_2050s_PAS, HII_gcs, method = 'bilinear', 
                                 filename = "PAS_UK_7.0_2050.tif")
UK_7.0_2050_EMT <- projectRaster(UK_7.0_2050s_EMT, HII_gcs, method = 'bilinear', 
                                 filename = "EMT_UK_7.0_2050.tif")
UK_7.0_2050_Eref <- projectRaster(UK_7.0_2050s_Eref, HII_gcs, method = 'bilinear', 
                                  filename = "Eref_UK_7.0_2050.tif")
UK_7.0_2050_CMD <- projectRaster(UK_7.0_2050s_CMD, HII_gcs, method = 'bilinear', 
                                 filename = "CMD_UK_7.0_2050.tif")
UK_7.0_2050_CMI <- projectRaster(UK_7.0_2050s_CMI, HII_gcs, method = 'bilinear', 
                                 filename = "CMI_UK_7.0_2050.tif")
UK_7.0_2050_DD1040 <- projectRaster(UK_7.0_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                    filename = "DD1040_UK_7.0_2050.tif")
UK_7.0_2050_Tave_wt <- projectRaster(UK_7.0_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_wt_UK_7.0_2050.tif")
UK_7.0_2050_Tave_sp <- projectRaster(UK_7.0_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sp_UK_7.0_2050.tif")
UK_7.0_2050_Tave_sm <- projectRaster(UK_7.0_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sm_UK_7.0_2050.tif")
UK_7.0_2050_Tave_at <- projectRaster(UK_7.0_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_at_UK_7.0_2050.tif")
UK_7.0_2050_PPT_sp <- projectRaster(UK_7.0_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sp_UK_7.0_2050.tif")
UK_7.0_2050_PPT_at <- projectRaster(UK_7.0_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_at_UK_7.0_2050.tif")

########### UK 7.0 2080s ################
setwd("D:/MastersProject/ClimateNA/UK_7.0_2080s")
UK_7.0_2080s_TD <- raster("UKESM1-0-LL_ssp370_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
UK_7.0_2080s_SHM <- raster("UKESM1-0-LL_ssp370_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
UK_7.0_2080s_DD_0 <- raster("UKESM1-0-LL_ssp370_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
UK_7.0_2080s_DD18 <- raster("UKESM1-0-LL_ssp370_2071_DD18.tif") # degree-days above 18 C
UK_7.0_2080s_eFFP <- raster("UKESM1-0-LL_ssp370_2071_eFFP.tif") # the julian date on which the frost-free period ends
UK_7.0_2080s_MAR <- raster("UKESM1-0-LL_ssp370_2071_MAR.tif") # mean annual solar radiation
UK_7.0_2080s_RH <- raster("UKESM1-0-LL_ssp370_2071_RH.tif") # mean annual relative humidity (%)
UK_7.0_2080s_PPT_wt <- raster("UKESM1-0-LL_ssp370_2071_PPT_wt.tif") # winter precipitation
UK_7.0_2080s_PPT_sm <- raster("UKESM1-0-LL_ssp370_2071_PPT_sm.tif") # summer precipitation
UK_7.0_2080s_MAT <- raster("UKESM1-0-LL_ssp370_2071_MAT.tif") # mean annual temperature (C)
UK_7.0_2080s_MWMT <- raster("UKESM1-0-LL_ssp370_2071_MWMT.tif") # mean temperature of the warmest month
UK_7.0_2080s_MCMT <- raster("UKESM1-0-LL_ssp370_2071_MCMT.tif") # mean temperature of the coldest month
UK_7.0_2080s_MAP <- raster("UKESM1-0-LL_ssp370_2071_MAP.tif") # mean annual precipitation (mm)
UK_7.0_2080s_MSP <- raster("UKESM1-0-LL_ssp370_2071_MSP.tif") # mean summer (may to sept) precipitation
UK_7.0_2080s_AHM <- raster("UKESM1-0-LL_ssp370_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
UK_7.0_2080s_DD5 <- raster("UKESM1-0-LL_ssp370_2071_DD5.tif") # degree-days above 5 C (growing degree days)
UK_7.0_2080s_DD_18 <- raster("UKESM1-0-LL_ssp370_2071_DD_18.tif") # degree-days below 18 C
UK_7.0_2080s_NFFD <- raster("UKESM1-0-LL_ssp370_2071_NFFD.tif") # the number of frost-free days
UK_7.0_2080s_FFP <- raster("UKESM1-0-LL_ssp370_2071_FFP.tif") # frost-free period
UK_7.0_2080s_bFFP <- raster("UKESM1-0-LL_ssp370_2071_bFFP.tif") # the julian date on which the frost-free period begins
UK_7.0_2080s_PAS <- raster("UKESM1-0-LL_ssp370_2071_PAS.tif") # precipitation as snow (mm)
UK_7.0_2080s_EMT <- raster("UKESM1-0-LL_ssp370_2071_EMT.tif") # extreme minimum temperature over 30 years
UK_7.0_2080s_EXT <- raster("UKESM1-0-LL_ssp370_2071_EXT.tif") # extreme maximum temperature over 30 years
UK_7.0_2080s_Eref <- raster("UKESM1-0-LL_ssp370_2071_Eref.tif") # Hargreave's reference evaporation
UK_7.0_2080s_CMD <- raster("UKESM1-0-LL_ssp370_2071_CMD.tif") # Hargreave's climatic moisture index
UK_7.0_2080s_CMI <- raster("UKESM1-0-LL_ssp370_2071_CMI.tif") # Hogg's climate moisture index (mm)
UK_7.0_2080s_DD1040 <- raster("UKESM1-0-LL_ssp370_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
UK_7.0_2080s_Tave_wt <- raster("UKESM1-0-LL_ssp370_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
UK_7.0_2080s_Tave_sp <- raster("UKESM1-0-LL_ssp370_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
UK_7.0_2080s_Tave_sm <- raster("UKESM1-0-LL_ssp370_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
UK_7.0_2080s_Tave_at <- raster("UKESM1-0-LL_ssp370_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
UK_7.0_2080s_PPT_sp <- raster("UKESM1-0-LL_ssp370_2071_PPT_sp.tif") # spring precipitation
UK_7.0_2080s_PPT_at <- raster("UKESM1-0-LL_ssp370_2071_PPT_at.tif") # autumn precipitation

setwd("D:/MastersProject/Formatted variables")
UK_7.0_2080_TD <- projectRaster(UK_7.0_2080s_TD, HII_gcs, method = 'bilinear', 
                                filename = "TD_UK_7.0_2080.tif")
UK_7.0_2080_SHM <- projectRaster(UK_7.0_2080s_SHM, HII_gcs, method = 'bilinear', 
                                 filename = "SHM_UK_7.0_2080.tif")
UK_7.0_2080_DD_0 <- projectRaster(UK_7.0_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                  filename = "DD_0_UK_7.0_2080.tif")
UK_7.0_2080_DD18 <- projectRaster(UK_7.0_2080s_DD18, HII_gcs, method = 'bilinear', 
                                  filename = "DD18_UK_7.0_2080.tif")
UK_7.0_2080_eFFP <- projectRaster(UK_7.0_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                  filename = "eFFP_UK_7.0_2080.tif")
UK_7.0_2080_MAR <- projectRaster(UK_7.0_2080s_MAR, HII_gcs, method = 'bilinear', 
                                 filename = "MAR_UK_7.0_2080.tif")
UK_7.0_2080_RH <- projectRaster(UK_7.0_2080s_RH, HII_gcs, method = 'bilinear', 
                                filename = "RH_UK_7.0_2080.tif")
UK_7.0_2080_PPT_wt <- projectRaster(UK_7.0_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_wt_UK_7.0_2080.tif")
UK_7.0_2080_PPT_sm <- projectRaster(UK_7.0_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sm_UK_7.0_2080.tif")
UK_7.0_2080_EXT <- projectRaster(UK_7.0_2080s_EXT, HII_gcs, method = 'bilinear', 
                                 filename = "EXT_UK_7.0_2080.tif")
UK_7.0_2080_MAT <- projectRaster(UK_7.0_2080s_MAT, HII_gcs, method = 'bilinear', 
                                 filename = "MAT_UK_7.0_2080.tif")
UK_7.0_2080_MWMT <- projectRaster(UK_7.0_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                  filename = "MWMT_UK_7.0_2080.tif")
UK_7.0_2080_MCMT <- projectRaster(UK_7.0_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                  filename = "MCMT_UK_7.0_2080.tif")
UK_7.0_2080_MAP <- projectRaster(UK_7.0_2080s_MAP, HII_gcs, method = 'bilinear', 
                                 filename = "MAP_UK_7.0_2080.tif")
UK_7.0_2080_MSP <- projectRaster(UK_7.0_2080s_MSP, HII_gcs, method = 'bilinear', 
                                 filename = "MSP_UK_7.0_2080.tif")
UK_7.0_2080_AHM <- projectRaster(UK_7.0_2080s_AHM, HII_gcs, method = 'bilinear', 
                                 filename = "AHM_UK_7.0_2080.tif")
UK_7.0_2080_DD5 <- projectRaster(UK_7.0_2080s_DD5, HII_gcs, method = 'bilinear', 
                                 filename = "DD5_UK_7.0_2080.tif")
UK_7.0_2080_DD_18 <- projectRaster(UK_7.0_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                   filename = "DD_18_UK_7.0_2080.tif")
UK_7.0_2080_NFFD <- projectRaster(UK_7.0_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                  filename = "NFFD_UK_7.0_2080.tif")
UK_7.0_2080_FFP <- projectRaster(UK_7.0_2080s_FFP, HII_gcs, method = 'bilinear', 
                                 filename = "FFP_UK_7.0_2080.tif")
UK_7.0_2080_bFFP <- projectRaster(UK_7.0_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                  filename = "bFFP_UK_7.0_2080.tif")
UK_7.0_2080_PAS <- projectRaster(UK_7.0_2080s_PAS, HII_gcs, method = 'bilinear', 
                                 filename = "PAS_UK_7.0_2080.tif")
UK_7.0_2080_EMT <- projectRaster(UK_7.0_2080s_EMT, HII_gcs, method = 'bilinear', 
                                 filename = "EMT_UK_7.0_2080.tif")
UK_7.0_2080_Eref <- projectRaster(UK_7.0_2080s_Eref, HII_gcs, method = 'bilinear', 
                                  filename = "Eref_UK_7.0_2080.tif")
UK_7.0_2080_CMD <- projectRaster(UK_7.0_2080s_CMD, HII_gcs, method = 'bilinear', 
                                 filename = "CMD_UK_7.0_2080.tif")
UK_7.0_2080_CMI <- projectRaster(UK_7.0_2080s_CMI, HII_gcs, method = 'bilinear', 
                                 filename = "CMI_UK_7.0_2080.tif")
UK_7.0_2080_DD1040 <- projectRaster(UK_7.0_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                    filename = "DD1040_UK_7.0_2080.tif")
UK_7.0_2080_Tave_wt <- projectRaster(UK_7.0_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_wt_UK_7.0_2080.tif")
UK_7.0_2080_Tave_sp <- projectRaster(UK_7.0_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sp_UK_7.0_2080.tif")
UK_7.0_2080_Tave_sm <- projectRaster(UK_7.0_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sm_UK_7.0_2080.tif")
UK_7.0_2080_Tave_at <- projectRaster(UK_7.0_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_at_UK_7.0_2080.tif")
UK_7.0_2080_PPT_sp <- projectRaster(UK_7.0_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sp_UK_7.0_2080.tif")
UK_7.0_2080_PPT_at <- projectRaster(UK_7.0_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_at_UK_7.0_2080.tif")

############ UK 8.5 2050s ###################
setwd("D:/MastersProject/ClimateNA/UK_8.5_2050s") 

UK_8.5_2050s_TD <- raster("UKESM1-0-LL_ssp585_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
UK_8.5_2050s_SHM <- raster("UKESM1-0-LL_ssp585_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
UK_8.5_2050s_DD_0 <- raster("UKESM1-0-LL_ssp585_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
UK_8.5_2050s_DD18 <- raster("UKESM1-0-LL_ssp585_2041_DD18.tif") # degree-days above 18 C
UK_8.5_2050s_eFFP <- raster("UKESM1-0-LL_ssp585_2041_eFFP.tif") # the julian date on which the frost-free period ends
UK_8.5_2050s_MAR <- raster("UKESM1-0-LL_ssp585_2041_MAR.tif") # mean annual solar radiation
UK_8.5_2050s_RH <- raster("UKESM1-0-LL_ssp585_2041_RH.tif") # mean annual relative humidity (%)
UK_8.5_2050s_PPT_wt <- raster("UKESM1-0-LL_ssp585_2041_PPT_wt.tif") # winter precipitation
UK_8.5_2050s_PPT_sm <- raster("UKESM1-0-LL_ssp585_2041_PPT_sm.tif") # summer precipitation
UK_8.5_2050s_MAT <- raster("UKESM1-0-LL_ssp585_2041_MAT.tif") # mean annual temperature (C)
UK_8.5_2050s_MWMT <- raster("UKESM1-0-LL_ssp585_2041_MWMT.tif") # mean temperature of the warmest month
UK_8.5_2050s_MCMT <- raster("UKESM1-0-LL_ssp585_2041_MCMT.tif") # mean temperature of the coldest month
UK_8.5_2050s_MAP <- raster("UKESM1-0-LL_ssp585_2041_MAP.tif") # mean annual precipitation (mm)
UK_8.5_2050s_MSP <- raster("UKESM1-0-LL_ssp585_2041_MSP.tif") # mean summer (may to sept) precipitation
UK_8.5_2050s_AHM <- raster("UKESM1-0-LL_ssp585_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
UK_8.5_2050s_DD5 <- raster("UKESM1-0-LL_ssp585_2041_DD5.tif") # degree-days above 5 C (growing degree days)
UK_8.5_2050s_DD_18 <- raster("UKESM1-0-LL_ssp585_2041_DD_18.tif") # degree-days below 18 C
UK_8.5_2050s_NFFD <- raster("UKESM1-0-LL_ssp585_2041_NFFD.tif") # the number of frost-free days
UK_8.5_2050s_FFP <- raster("UKESM1-0-LL_ssp585_2041_FFP.tif") # frost-free period
UK_8.5_2050s_bFFP <- raster("UKESM1-0-LL_ssp585_2041_bFFP.tif") # the julian date on which the frost-free period begins
UK_8.5_2050s_PAS <- raster("UKESM1-0-LL_ssp585_2041_PAS.tif") # precipitation as snow (mm)
UK_8.5_2050s_EMT <- raster("UKESM1-0-LL_ssp585_2041_EMT.tif") # extreme minimum temperature over 30 years
UK_8.5_2050s_EXT <- raster("UKESM1-0-LL_ssp585_2041_EXT.tif") # extreme maximum temperature over 30 years
UK_8.5_2050s_Eref <- raster("UKESM1-0-LL_ssp585_2041_Eref.tif") # Hargreave's reference evaporation
UK_8.5_2050s_CMD <- raster("UKESM1-0-LL_ssp585_2041_CMD.tif") # Hargreave's climatic moisture index
UK_8.5_2050s_CMI <- raster("UKESM1-0-LL_ssp585_2041_CMI.tif") # Hogg's climate moisture index (mm)
UK_8.5_2050s_DD1040 <- raster("UKESM1-0-LL_ssp585_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
UK_8.5_2050s_Tave_wt <- raster("UKESM1-0-LL_ssp585_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
UK_8.5_2050s_Tave_sp <- raster("UKESM1-0-LL_ssp585_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
UK_8.5_2050s_Tave_sm <- raster("UKESM1-0-LL_ssp585_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
UK_8.5_2050s_Tave_at <- raster("UKESM1-0-LL_ssp585_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
UK_8.5_2050s_PPT_sp <- raster("UKESM1-0-LL_ssp585_2041_PPT_sp.tif") # spring precipitation
UK_8.5_2050s_PPT_at <- raster("UKESM1-0-LL_ssp585_2041_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
UK_8.5_2050_TD <- projectRaster(UK_8.5_2050s_TD, HII_gcs, method = 'bilinear', 
                                filename = "TD_UK_8.5_2050.tif")
UK_8.5_2050_SHM <- projectRaster(UK_8.5_2050s_SHM, HII_gcs, method = 'bilinear', 
                                 filename = "SHM_UK_8.5_2050.tif")
UK_8.5_2050_DD_0 <- projectRaster(UK_8.5_2050s_DD_0, HII_gcs, method = 'bilinear', 
                                  filename = "DD_0_UK_8.5_2050.tif")
UK_8.5_2050_DD18 <- projectRaster(UK_8.5_2050s_DD18, HII_gcs, method = 'bilinear', 
                                  filename = "DD18_UK_8.5_2050.tif")
UK_8.5_2050_eFFP <- projectRaster(UK_8.5_2050s_eFFP, HII_gcs, method = 'bilinear', 
                                  filename = "eFFP_UK_8.5_2050.tif")
UK_8.5_2050_MAR <- projectRaster(UK_8.5_2050s_MAR, HII_gcs, method = 'bilinear', 
                                 filename = "MAR_UK_8.5_2050.tif")
UK_8.5_2050_RH <- projectRaster(UK_8.5_2050s_RH, HII_gcs, method = 'bilinear', 
                                filename = "RH_UK_8.5_2050.tif")
UK_8.5_2050_PPT_wt <- projectRaster(UK_8.5_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_wt_UK_8.5_2050.tif")
UK_8.5_2050_PPT_sm <- projectRaster(UK_8.5_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sm_UK_8.5_2050.tif")
UK_8.5_2050_EXT <- projectRaster(UK_8.5_2050s_EXT, HII_gcs, method = 'bilinear', 
                                 filename = "EXT_UK_8.5_2050.tif")
UK_8.5_2050_MAT <- projectRaster(UK_8.5_2050s_MAT, HII_gcs, method = 'bilinear', 
                                 filename = "MAT_UK_8.5_2050.tif")
UK_8.5_2050_MWMT <- projectRaster(UK_8.5_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                  filename = "MWMT_UK_8.5_2050.tif")
UK_8.5_2050_MCMT <- projectRaster(UK_8.5_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                  filename = "MCMT_UK_8.5_2050.tif")
UK_8.5_2050_MAP <- projectRaster(UK_8.5_2050s_MAP, HII_gcs, method = 'bilinear', 
                                 filename = "MAP_UK_8.5_2050.tif")
UK_8.5_2050_MSP <- projectRaster(UK_8.5_2050s_MSP, HII_gcs, method = 'bilinear', 
                                 filename = "MSP_UK_8.5_2050.tif")
UK_8.5_2050_AHM <- projectRaster(UK_8.5_2050s_AHM, HII_gcs, method = 'bilinear', 
                                 filename = "AHM_UK_8.5_2050.tif")
UK_8.5_2050_DD5 <- projectRaster(UK_8.5_2050s_DD5, HII_gcs, method = 'bilinear', 
                                 filename = "DD5_UK_8.5_2050.tif")
UK_8.5_2050_DD_18 <- projectRaster(UK_8.5_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                   filename = "DD_18_UK_8.5_2050.tif")
UK_8.5_2050_NFFD <- projectRaster(UK_8.5_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                  filename = "NFFD_UK_8.5_2050.tif")
UK_8.5_2050_FFP <- projectRaster(UK_8.5_2050s_FFP, HII_gcs, method = 'bilinear', 
                                 filename = "FFP_UK_8.5_2050.tif")
UK_8.5_2050_bFFP <- projectRaster(UK_8.5_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                  filename = "bFFP_UK_8.5_2050.tif")
UK_8.5_2050_PAS <- projectRaster(UK_8.5_2050s_PAS, HII_gcs, method = 'bilinear', 
                                 filename = "PAS_UK_8.5_2050.tif")
UK_8.5_2050_EMT <- projectRaster(UK_8.5_2050s_EMT, HII_gcs, method = 'bilinear', 
                                 filename = "EMT_UK_8.5_2050.tif")
UK_8.5_2050_Eref <- projectRaster(UK_8.5_2050s_Eref, HII_gcs, method = 'bilinear', 
                                  filename = "Eref_UK_8.5_2050.tif")
UK_8.5_2050_CMD <- projectRaster(UK_8.5_2050s_CMD, HII_gcs, method = 'bilinear', 
                                 filename = "CMD_UK_8.5_2050.tif")
UK_8.5_2050_CMI <- projectRaster(UK_8.5_2050s_CMI, HII_gcs, method = 'bilinear', 
                                 filename = "CMI_UK_8.5_2050.tif")
UK_8.5_2050_DD1040 <- projectRaster(UK_8.5_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                    filename = "DD1040_UK_8.5_2050.tif")
UK_8.5_2050_Tave_wt <- projectRaster(UK_8.5_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                   filename = "Tave_wt_UK_8.5_2050.tif")
UK_8.5_2050_Tave_sp <- projectRaster(UK_8.5_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sp_UK_8.5_2050.tif")
UK_8.5_2050_Tave_sm <- projectRaster(UK_8.5_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sm_UK_8.5_2050.tif")
UK_8.5_2050_Tave_at <- projectRaster(UK_8.5_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_at_UK_8.5_2050.tif")
UK_8.5_2050_PPT_sp <- projectRaster(UK_8.5_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sp_UK_8.5_2050.tif")
UK_8.5_2050_PPT_at <- projectRaster(UK_8.5_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_at_UK_8.5_2050.tif")


################ UK 8.5 2080s ################
setwd("D:/MastersProject/ClimateNA/UK_8.5_2080s") 
UK_8.5_2080s_TD <- raster("UKESM1-0-LL_ssp585_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
UK_8.5_2080s_SHM <- raster("UKESM1-0-LL_ssp585_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
UK_8.5_2080s_DD_0 <- raster("UKESM1-0-LL_ssp585_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
UK_8.5_2080s_DD18 <- raster("UKESM1-0-LL_ssp585_2071_DD18.tif") # degree-days above 18 C
UK_8.5_2080s_eFFP <- raster("UKESM1-0-LL_ssp585_2071_eFFP.tif") # the julian date on which the frost-free period ends
UK_8.5_2080s_MAR <- raster("UKESM1-0-LL_ssp585_2071_MAR.tif") # mean annual solar radiation
UK_8.5_2080s_RH <- raster("UKESM1-0-LL_ssp585_2071_RH.tif") # mean annual relative humidity (%)
UK_8.5_2080s_PPT_wt <- raster("UKESM1-0-LL_ssp585_2071_PPT_wt.tif") # winter precipitation
UK_8.5_2080s_PPT_sm <- raster("UKESM1-0-LL_ssp585_2071_PPT_sm.tif") # summer precipitation
UK_8.5_2080s_MAT <- raster("UKESM1-0-LL_ssp585_2071_MAT.tif") # mean annual temperature (C)
UK_8.5_2080s_MWMT <- raster("UKESM1-0-LL_ssp585_2071_MWMT.tif") # mean temperature of the warmest month
UK_8.5_2080s_MCMT <- raster("UKESM1-0-LL_ssp585_2071_MCMT.tif") # mean temperature of the coldest month
UK_8.5_2080s_MAP <- raster("UKESM1-0-LL_ssp585_2071_MAP.tif") # mean annual precipitation (mm)
UK_8.5_2080s_MSP <- raster("UKESM1-0-LL_ssp585_2071_MSP.tif") # mean summer (may to sept) precipitation
UK_8.5_2080s_AHM <- raster("UKESM1-0-LL_ssp585_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
UK_8.5_2080s_DD5 <- raster("UKESM1-0-LL_ssp585_2071_DD5.tif") # degree-days above 5 C (growing degree days)
UK_8.5_2080s_DD_18 <- raster("UKESM1-0-LL_ssp585_2071_DD_18.tif") # degree-days below 18 C
UK_8.5_2080s_NFFD <- raster("UKESM1-0-LL_ssp585_2071_NFFD.tif") # the number of frost-free days
UK_8.5_2080s_FFP <- raster("UKESM1-0-LL_ssp585_2071_FFP.tif") # frost-free period
UK_8.5_2080s_bFFP <- raster("UKESM1-0-LL_ssp585_2071_bFFP.tif") # the julian date on which the frost-free period begins
UK_8.5_2080s_PAS <- raster("UKESM1-0-LL_ssp585_2071_PAS.tif") # precipitation as snow (mm)
UK_8.5_2080s_EMT <- raster("UKESM1-0-LL_ssp585_2071_EMT.tif") # extreme minimum temperature over 30 years
UK_8.5_2080s_EXT <- raster("UKESM1-0-LL_ssp585_2071_EXT.tif") # extreme maximum temperature over 30 years
UK_8.5_2080s_Eref <- raster("UKESM1-0-LL_ssp585_2071_Eref.tif") # Hargreave's reference evaporation
UK_8.5_2080s_CMD <- raster("UKESM1-0-LL_ssp585_2071_CMD.tif") # Hargreave's climatic moisture index
UK_8.5_2080s_CMI <- raster("UKESM1-0-LL_ssp585_2071_CMI.tif") # Hogg's climate moisture index (mm)
UK_8.5_2080s_DD1040 <- raster("UKESM1-0-LL_ssp585_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
UK_8.5_2080s_Tave_wt <- raster("UKESM1-0-LL_ssp585_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
UK_8.5_2080s_Tave_sp <- raster("UKESM1-0-LL_ssp585_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
UK_8.5_2080s_Tave_sm <- raster("UKESM1-0-LL_ssp585_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
UK_8.5_2080s_Tave_at <- raster("UKESM1-0-LL_ssp585_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
UK_8.5_2080s_PPT_sp <- raster("UKESM1-0-LL_ssp585_2071_PPT_sp.tif") # spring precipitation
UK_8.5_2080s_PPT_at <- raster("UKESM1-0-LL_ssp585_2071_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
UK_8.5_2080_TD <- projectRaster(UK_8.5_2080s_TD, HII_gcs, method = 'bilinear', 
                                filename = "TD_UK_8.5_2080.tif")
UK_8.5_2080_SHM <- projectRaster(UK_8.5_2080s_SHM, HII_gcs, method = 'bilinear', 
                                 filename = "SHM_UK_8.5_2080.tif")
UK_8.5_2080_DD_0 <- projectRaster(UK_8.5_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                  filename = "DD_0_UK_8.5_2080.tif")
UK_8.5_2080_DD18 <- projectRaster(UK_8.5_2080s_DD18, HII_gcs, method = 'bilinear', 
                                  filename = "DD18_UK_8.5_2080.tif")
UK_8.5_2080_eFFP <- projectRaster(UK_8.5_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                  filename = "eFFP_UK_8.5_2080.tif")
UK_8.5_2080_MAR <- projectRaster(UK_8.5_2080s_MAR, HII_gcs, method = 'bilinear', 
                                 filename = "MAR_UK_8.5_2080.tif")
UK_8.5_2080_RH <- projectRaster(UK_8.5_2080s_RH, HII_gcs, method = 'bilinear', 
                                filename = "RH_UK_8.5_2080.tif")
UK_8.5_2080_PPT_wt <- projectRaster(UK_8.5_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_wt_UK_8.5_2080.tif")
UK_8.5_2080_PPT_sm <- projectRaster(UK_8.5_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sm_UK_8.5_2080.tif")
UK_8.5_2080_EXT <- projectRaster(UK_8.5_2080s_EXT, HII_gcs, method = 'bilinear', 
                                 filename = "EXT_UK_8.5_2080.tif")
UK_8.5_2080_MAT <- projectRaster(UK_8.5_2080s_MAT, HII_gcs, method = 'bilinear', 
                                 filename = "MAT_UK_8.5_2080.tif")
UK_8.5_2080_MWMT <- projectRaster(UK_8.5_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                  filename = "MWMT_UK_8.5_2080.tif")
UK_8.5_2080_MCMT <- projectRaster(UK_8.5_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                  filename = "MCMT_UK_8.5_2080.tif")
UK_8.5_2080_MAP <- projectRaster(UK_8.5_2080s_MAP, HII_gcs, method = 'bilinear', 
                                 filename = "MAP_UK_8.5_2080.tif")
UK_8.5_2080_MSP <- projectRaster(UK_8.5_2080s_MSP, HII_gcs, method = 'bilinear', 
                                 filename = "MSP_UK_8.5_2080.tif")
UK_8.5_2080_AHM <- projectRaster(UK_8.5_2080s_AHM, HII_gcs, method = 'bilinear', 
                                 filename = "AHM_UK_8.5_2080.tif")
UK_8.5_2080_DD5 <- projectRaster(UK_8.5_2080s_DD5, HII_gcs, method = 'bilinear', 
                                 filename = "DD5_UK_8.5_2080.tif")
UK_8.5_2080_DD_18 <- projectRaster(UK_8.5_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                   filename = "DD_18_UK_8.5_2080.tif")
UK_8.5_2080_NFFD <- projectRaster(UK_8.5_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                  filename = "NFFD_UK_8.5_2080.tif")
UK_8.5_2080_FFP <- projectRaster(UK_8.5_2080s_FFP, HII_gcs, method = 'bilinear', 
                                 filename = "FFP_UK_8.5_2080.tif")
UK_8.5_2080_bFFP <- projectRaster(UK_8.5_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                  filename = "bFFP_UK_8.5_2080.tif")
UK_8.5_2080_PAS <- projectRaster(UK_8.5_2080s_PAS, HII_gcs, method = 'bilinear', 
                                 filename = "PAS_UK_8.5_2080.tif")
UK_8.5_2080_EMT <- projectRaster(UK_8.5_2080s_EMT, HII_gcs, method = 'bilinear', 
                                 filename = "EMT_UK_8.5_2080.tif")
UK_8.5_2080_Eref <- projectRaster(UK_8.5_2080s_Eref, HII_gcs, method = 'bilinear', 
                                  filename = "Eref_UK_8.5_2080.tif")
UK_8.5_2080_CMD <- projectRaster(UK_8.5_2080s_CMD, HII_gcs, method = 'bilinear', 
                                 filename = "CMD_UK_8.5_2080.tif")
UK_8.5_2080_CMI <- projectRaster(UK_8.5_2080s_CMI, HII_gcs, method = 'bilinear', 
                                 filename = "CMI_UK_8.5_2080.tif")
UK_8.5_2080_DD1040 <- projectRaster(UK_8.5_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                    filename = "DD1040_UK_8.5_2080.tif")
UK_8.5_2080_Tave_wt <- projectRaster(UK_8.5_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_wt_UK_8.5_2080.tif")
UK_8.5_2080_Tave_sp <- projectRaster(UK_8.5_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sp_UK_8.5_2080.tif")
UK_8.5_2080_Tave_sm <- projectRaster(UK_8.5_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_sm_UK_8.5_2080.tif")
UK_8.5_2080_Tave_at <- projectRaster(UK_8.5_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                     filename = "Tave_at_UK_8.5_2080.tif")
UK_8.5_2080_PPT_sp <- projectRaster(UK_8.5_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sp_UK_8.5_2080.tif")
UK_8.5_2080_PPT_at <- projectRaster(UK_8.5_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_at_UK_8.5_2080.tif")

######## MRI ###############

######## MRI 4.5 2050s ############
setwd("D:/MastersProject/ClimateNA/MRI_4.5_2050s")
MRI_4.5_2050s_TD <- raster("MRI-ESM2-0_ssp245_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MRI_4.5_2050s_SHM <- raster("MRI-ESM2-0_ssp245_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MRI_4.5_2050s_DD_0 <- raster("MRI-ESM2-0_ssp245_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
MRI_4.5_2050s_DD18 <- raster("MRI-ESM2-0_ssp245_2041_DD18.tif") # degree-days above 18 C
MRI_4.5_2050s_eFFP <- raster("MRI-ESM2-0_ssp245_2041_eFFP.tif") # the julian date on which the frost-free period ends
MRI_4.5_2050s_MAR <- raster("MRI-ESM2-0_ssp245_2041_MAR.tif") # mean annual solar radiation
MRI_4.5_2050s_RH <- raster("MRI-ESM2-0_ssp245_2041_RH.tif") # mean annual relative humidity (%)
MRI_4.5_2050s_PPT_wt <- raster("MRI-ESM2-0_ssp245_2041_PPT_wt.tif") # winter precipitation
MRI_4.5_2050s_PPT_sm <- raster("MRI-ESM2-0_ssp245_2041_PPT_sm.tif") # summer precipitation
MRI_4.5_2050s_MAT <- raster("MRI-ESM2-0_ssp245_2041_MAT.tif") # mean annual temperature (C)
MRI_4.5_2050s_MWMT <- raster("MRI-ESM2-0_ssp245_2041_MWMT.tif") # mean temperature of the warmest month
MRI_4.5_2050s_MCMT <- raster("MRI-ESM2-0_ssp245_2041_MCMT.tif") # mean temperature of the coldest month
MRI_4.5_2050s_MAP <- raster("MRI-ESM2-0_ssp245_2041_MAP.tif") # mean annual precipitation (mm)
MRI_4.5_2050s_MSP <- raster("MRI-ESM2-0_ssp245_2041_MSP.tif") # mean summer (may to sept) precipitation
MRI_4.5_2050s_AHM <- raster("MRI-ESM2-0_ssp245_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MRI_4.5_2050s_DD5 <- raster("MRI-ESM2-0_ssp245_2041_DD5.tif") # degree-days above 5 C (growing degree days)
MRI_4.5_2050s_DD_18 <- raster("MRI-ESM2-0_ssp245_2041_DD_18.tif") # degree-days below 18 C
MRI_4.5_2050s_NFFD <- raster("MRI-ESM2-0_ssp245_2041_NFFD.tif") # the number of frost-free days
MRI_4.5_2050s_FFP <- raster("MRI-ESM2-0_ssp245_2041_FFP.tif") # frost-free period
MRI_4.5_2050s_bFFP <- raster("MRI-ESM2-0_ssp245_2041_bFFP.tif") # the julian date on which the frost-free period begins
MRI_4.5_2050s_PAS <- raster("MRI-ESM2-0_ssp245_2041_PAS.tif") # precipitation as snow (mm)
MRI_4.5_2050s_EMT <- raster("MRI-ESM2-0_ssp245_2041_EMT.tif") # extreme minimum temperature over 30 years
MRI_4.5_2050s_EXT <- raster("MRI-ESM2-0_ssp245_2041_EXT.tif") # extreme maximum temperature over 30 years
MRI_4.5_2050s_Eref <- raster("MRI-ESM2-0_ssp245_2041_Eref.tif") # Hargreave's reference evaporation
MRI_4.5_2050s_CMD <- raster("MRI-ESM2-0_ssp245_2041_CMD.tif") # Hargreave's climatic moisture index
MRI_4.5_2050s_CMI <- raster("MRI-ESM2-0_ssp245_2041_CMI.tif") # Hogg's climate moisture index (mm)
MRI_4.5_2050s_DD1040 <- raster("MRI-ESM2-0_ssp245_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MRI_4.5_2050s_Tave_wt <- raster("MRI-ESM2-0_ssp245_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MRI_4.5_2050s_Tave_sp <- raster("MRI-ESM2-0_ssp245_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
MRI_4.5_2050s_Tave_sm <- raster("MRI-ESM2-0_ssp245_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MRI_4.5_2050s_Tave_at <- raster("MRI-ESM2-0_ssp245_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MRI_4.5_2050s_PPT_sp <- raster("MRI-ESM2-0_ssp245_2041_PPT_sp.tif") # spring precipitation
MRI_4.5_2050s_PPT_at <- raster("MRI-ESM2-0_ssp245_2041_PPT_at.tif") # autumn precipitation

# MRI 4.5 2050s
setwd("D:/MastersProject/Formatted variables")
MRI_4.5_2050_TD <- projectRaster(MRI_4.5_2050s_TD, HII_gcs, method = 'bilinear', 
                                filename = "TD_MRI_4.5_2050.tif")
MRI_4.5_2050_SHM <- projectRaster(MRI_4.5_2050s_SHM, HII_gcs, method = 'bilinear', 
                                 filename = "SHM_MRI_4.5_2050.tif")
MRI_4.5_2050_DD_0 <- projectRaster(MRI_4.5_2050s_DD_0, HII_gcs, method = 'bilinear', 
                                  filename = "DD_0_MRI_4.5_2050.tif")
MRI_4.5_2050_DD18 <- projectRaster(MRI_4.5_2050s_DD18, HII_gcs, method = 'bilinear', 
                                  filename = "DD18_MRI_4.5_2050.tif")
MRI_4.5_2050_eFFP <- projectRaster(MRI_4.5_2050s_eFFP, HII_gcs, method = 'bilinear', 
                                  filename = "eFFP_MRI_4.5_2050.tif")
MRI_4.5_2050_MAR <- projectRaster(MRI_4.5_2050s_MAR, HII_gcs, method = 'bilinear', 
                                 filename = "MAR_MRI_4.5_2050.tif")
MRI_4.5_2050_RH <- projectRaster(MRI_4.5_2050s_RH, HII_gcs, method = 'bilinear', 
                                filename = "RH_MRI_4.5_2050.tif")
MRI_4.5_2050_PPT_wt <- projectRaster(MRI_4.5_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_wt_MRI_4.5_2050.tif")
MRI_4.5_2050_PPT_sm <- projectRaster(MRI_4.5_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sm_MRI_4.5_2050.tif")
MRI_4.5_2050_EXT <- projectRaster(MRI_4.5_2050s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MRI_4.5_2050.tif")
MRI_4.5_2050_MAT <- projectRaster(MRI_4.5_2050s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MRI_4.5_2050.tif")
MRI_4.5_2050_MWMT <- projectRaster(MRI_4.5_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MRI_4.5_2050.tif")
MRI_4.5_2050_MCMT <- projectRaster(MRI_4.5_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MRI_4.5_2050.tif")
MRI_4.5_2050_MAP <- projectRaster(MRI_4.5_2050s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MRI_4.5_2050.tif")
MRI_4.5_2050_MSP <- projectRaster(MRI_4.5_2050s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MRI_4.5_2050.tif")
MRI_4.5_2050_AHM <- projectRaster(MRI_4.5_2050s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MRI_4.5_2050.tif")
MRI_4.5_2050_DD5 <- projectRaster(MRI_4.5_2050s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MRI_4.5_2050.tif")
MRI_4.5_2050_DD_18 <- projectRaster(MRI_4.5_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MRI_4.5_2050.tif")
MRI_4.5_2050_NFFD <- projectRaster(MRI_4.5_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MRI_4.5_2050.tif")
MRI_4.5_2050_FFP <- projectRaster(MRI_4.5_2050s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MRI_4.5_2050.tif")
MRI_4.5_2050_bFFP <- projectRaster(MRI_4.5_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MRI_4.5_2050.tif")
MRI_4.5_2050_PAS <- projectRaster(MRI_4.5_2050s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MRI_4.5_2050.tif")
MRI_4.5_2050_EMT <- projectRaster(MRI_4.5_2050s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MRI_4.5_2050.tif")
MRI_4.5_2050_Eref <- projectRaster(MRI_4.5_2050s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MRI_4.5_2050.tif")
MRI_4.5_2050_CMD <- projectRaster(MRI_4.5_2050s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MRI_4.5_2050.tif")
MRI_4.5_2050_CMI <- projectRaster(MRI_4.5_2050s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MRI_4.5_2050.tif")
MRI_4.5_2050_DD1040 <- projectRaster(MRI_4.5_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MRI_4.5_2050.tif")
MRI_4.5_2050_Tave_wt <- projectRaster(MRI_4.5_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MRI_4.5_2050.tif")
MRI_4.5_2050_Tave_sp <- projectRaster(MRI_4.5_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_4.5_2050.tif")
MRI_4.5_2050_Tave_sm <- projectRaster(MRI_4.5_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MRI_4.5_2050.tif")
MRI_4.5_2050_Tave_at <- projectRaster(MRI_4.5_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MRI_4.5_2050.tif")
MRI_4.5_2050_PPT_sp <- projectRaster(MRI_4.5_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MRI_4.5_2050.tif")
MRI_4.5_2050_PPT_at <- projectRaster(MRI_4.5_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MRI_4.5_2050.tif")

######### MRI 4.5 2080s ############
setwd("D:/MastersProject/ClimateNA/MRI_4.5_2080s")
MRI_4.5_2080s_TD <- raster("MRI-ESM2-0_ssp245_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MRI_4.5_2080s_SHM <- raster("MRI-ESM2-0_ssp245_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MRI_4.5_2080s_DD_0 <- raster("MRI-ESM2-0_ssp245_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
MRI_4.5_2080s_DD18 <- raster("MRI-ESM2-0_ssp245_2071_DD18.tif") # degree-days above 18 C
MRI_4.5_2080s_eFFP <- raster("MRI-ESM2-0_ssp245_2071_eFFP.tif") # the julian date on which the frost-free period ends
MRI_4.5_2080s_MAR <- raster("MRI-ESM2-0_ssp245_2071_MAR.tif") # mean annual solar radiation
MRI_4.5_2080s_RH <- raster("MRI-ESM2-0_ssp245_2071_RH.tif") # mean annual relative humidity (%)
MRI_4.5_2080s_PPT_wt <- raster("MRI-ESM2-0_ssp245_2071_PPT_wt.tif") # winter precipitation
MRI_4.5_2080s_PPT_sm <- raster("MRI-ESM2-0_ssp245_2071_PPT_sm.tif") # summer precipitation
MRI_4.5_2080s_MAT <- raster("MRI-ESM2-0_ssp245_2071_MAT.tif") # mean annual temperature (C)
MRI_4.5_2080s_MWMT <- raster("MRI-ESM2-0_ssp245_2071_MWMT.tif") # mean temperature of the warmest month
MRI_4.5_2080s_MCMT <- raster("MRI-ESM2-0_ssp245_2071_MCMT.tif") # mean temperature of the coldest month
MRI_4.5_2080s_MAP <- raster("MRI-ESM2-0_ssp245_2071_MAP.tif") # mean annual precipitation (mm)
MRI_4.5_2080s_MSP <- raster("MRI-ESM2-0_ssp245_2071_MSP.tif") # mean summer (may to sept) precipitation
MRI_4.5_2080s_AHM <- raster("MRI-ESM2-0_ssp245_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MRI_4.5_2080s_DD5 <- raster("MRI-ESM2-0_ssp245_2071_DD5.tif") # degree-days above 5 C (growing degree days)
MRI_4.5_2080s_DD_18 <- raster("MRI-ESM2-0_ssp245_2071_DD_18.tif") # degree-days below 18 C
MRI_4.5_2080s_NFFD <- raster("MRI-ESM2-0_ssp245_2071_NFFD.tif") # the number of frost-free days
MRI_4.5_2080s_FFP <- raster("MRI-ESM2-0_ssp245_2071_FFP.tif") # frost-free period
MRI_4.5_2080s_bFFP <- raster("MRI-ESM2-0_ssp245_2071_bFFP.tif") # the julian date on which the frost-free period begins
MRI_4.5_2080s_PAS <- raster("MRI-ESM2-0_ssp245_2071_PAS.tif") # precipitation as snow (mm)
MRI_4.5_2080s_EMT <- raster("MRI-ESM2-0_ssp245_2071_EMT.tif") # extreme minimum temperature over 30 years
MRI_4.5_2080s_EXT <- raster("MRI-ESM2-0_ssp245_2071_EXT.tif") # extreme maximum temperature over 30 years
MRI_4.5_2080s_Eref <- raster("MRI-ESM2-0_ssp245_2071_Eref.tif") # Hargreave's reference evaporation
MRI_4.5_2080s_CMD <- raster("MRI-ESM2-0_ssp245_2071_CMD.tif") # Hargreave's climatic moisture index
MRI_4.5_2080s_CMI <- raster("MRI-ESM2-0_ssp245_2071_CMI.tif") # Hogg's climate moisture index (mm)
MRI_4.5_2080s_DD1040 <- raster("MRI-ESM2-0_ssp245_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MRI_4.5_2080s_Tave_wt <- raster("MRI-ESM2-0_ssp245_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MRI_4.5_2080s_Tave_sp <- raster("MRI-ESM2-0_ssp245_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
MRI_4.5_2080s_Tave_sm <- raster("MRI-ESM2-0_ssp245_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MRI_4.5_2080s_Tave_at <- raster("MRI-ESM2-0_ssp245_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MRI_4.5_2080s_PPT_sp <- raster("MRI-ESM2-0_ssp245_2071_PPT_sp.tif") # spring precipitation
MRI_4.5_2080s_PPT_at <- raster("MRI-ESM2-0_ssp245_2071_PPT_at.tif") # autumn precipitation

# MRI 4.5 2080s
setwd("D:/MastersProject/Formatted variables")
MRI_4.5_2080_TD <- projectRaster(MRI_4.5_2080s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MRI_4.5_2080.tif")
MRI_4.5_2080_SHM <- projectRaster(MRI_4.5_2080s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MRI_4.5_2080.tif")
MRI_4.5_2080_DD_0 <- projectRaster(MRI_4.5_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MRI_4.5_2080.tif")
MRI_4.5_2080_DD18 <- projectRaster(MRI_4.5_2080s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MRI_4.5_2080.tif")
MRI_4.5_2080_eFFP <- projectRaster(MRI_4.5_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MRI_4.5_2080.tif")
MRI_4.5_2080_MAR <- projectRaster(MRI_4.5_2080s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MRI_4.5_2080.tif")
MRI_4.5_2080_RH <- projectRaster(MRI_4.5_2080s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MRI_4.5_2080.tif")
MRI_4.5_2080_PPT_wt <- projectRaster(MRI_4.5_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MRI_4.5_2080.tif")
MRI_4.5_2080_PPT_sm <- projectRaster(MRI_4.5_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MRI_4.5_2080.tif")
MRI_4.5_2080_EXT <- projectRaster(MRI_4.5_2080s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MRI_4.5_2080.tif")
MRI_4.5_2080_MAT <- projectRaster(MRI_4.5_2080s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MRI_4.5_2080.tif")
MRI_4.5_2080_MWMT <- projectRaster(MRI_4.5_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MRI_4.5_2080.tif")
MRI_4.5_2080_MCMT <- projectRaster(MRI_4.5_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MRI_4.5_2080.tif")
MRI_4.5_2080_MAP <- projectRaster(MRI_4.5_2080s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MRI_4.5_2080.tif")
MRI_4.5_2080_MSP <- projectRaster(MRI_4.5_2080s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MRI_4.5_2080.tif")
MRI_4.5_2080_AHM <- projectRaster(MRI_4.5_2080s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MRI_4.5_2080.tif")
MRI_4.5_2080_DD5 <- projectRaster(MRI_4.5_2080s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MRI_4.5_2080.tif")
MRI_4.5_2080_DD_18 <- projectRaster(MRI_4.5_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MRI_4.5_2080.tif")
MRI_4.5_2080_NFFD <- projectRaster(MRI_4.5_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MRI_4.5_2080.tif")
MRI_4.5_2080_FFP <- projectRaster(MRI_4.5_2080s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MRI_4.5_2080.tif")
MRI_4.5_2080_bFFP <- projectRaster(MRI_4.5_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MRI_4.5_2080.tif")
MRI_4.5_2080_PAS <- projectRaster(MRI_4.5_2080s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MRI_4.5_2080.tif")
MRI_4.5_2080_EMT <- projectRaster(MRI_4.5_2080s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MRI_4.5_2080.tif")
MRI_4.5_2080_Eref <- projectRaster(MRI_4.5_2080s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MRI_4.5_2080.tif")
MRI_4.5_2080_CMD <- projectRaster(MRI_4.5_2080s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MRI_4.5_2080.tif")
MRI_4.5_2080_CMI <- projectRaster(MRI_4.5_2080s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MRI_4.5_2080.tif")
MRI_4.5_2080_DD1040 <- projectRaster(MRI_4.5_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MRI_4.5_2080.tif")
MRI_4.5_2080_Tave_wt <- projectRaster(MRI_4.5_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MRI_4.5_2080.tif")
MRI_4.5_2080_Tave_sp <- projectRaster(MRI_4.5_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_4.5_2080.tif")
MRI_4.5_2080_Tave_sm <- projectRaster(MRI_4.5_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MRI_4.5_2080.tif")
MRI_4.5_2080_Tave_at <- projectRaster(MRI_4.5_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MRI_4.5_2080.tif")
MRI_4.5_2080_PPT_sp <- projectRaster(MRI_4.5_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MRI_4.5_2080.tif")
MRI_4.5_2080_PPT_at <- projectRaster(MRI_4.5_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MRI_4.5_2080.tif")

########### MRI 7.0 2050s #################
setwd("D:/MastersProject/ClimateNA/MRI_7.0_2050s") 
MRI_7.0_2050s_TD <- raster("MRI-ESM2-0_ssp370_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MRI_7.0_2050s_SHM <- raster("MRI-ESM2-0_ssp370_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MRI_7.0_2050s_DD_0 <- raster("MRI-ESM2-0_ssp370_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
MRI_7.0_2050s_DD18 <- raster("MRI-ESM2-0_ssp370_2041_DD18.tif") # degree-days above 18 C
MRI_7.0_2050s_eFFP <- raster("MRI-ESM2-0_ssp370_2041_eFFP.tif") # the julian date on which the frost-free period ends
MRI_7.0_2050s_MAR <- raster("MRI-ESM2-0_ssp370_2041_MAR.tif") # mean annual solar radiation
MRI_7.0_2050s_RH <- raster("MRI-ESM2-0_ssp370_2041_RH.tif") # mean annual relative humidity (%)
MRI_7.0_2050s_PPT_wt <- raster("MRI-ESM2-0_ssp370_2041_PPT_wt.tif") # winter precipitation
MRI_7.0_2050s_PPT_sm <- raster("MRI-ESM2-0_ssp370_2041_PPT_sm.tif") # summer precipitation
MRI_7.0_2050s_MAT <- raster("MRI-ESM2-0_ssp370_2041_MAT.tif") # mean annual temperature (C)
MRI_7.0_2050s_MWMT <- raster("MRI-ESM2-0_ssp370_2041_MWMT.tif") # mean temperature of the warmest month
MRI_7.0_2050s_MCMT <- raster("MRI-ESM2-0_ssp370_2041_MCMT.tif") # mean temperature of the coldest month
MRI_7.0_2050s_MAP <- raster("MRI-ESM2-0_ssp370_2041_MAP.tif") # mean annual precipitation (mm)
MRI_7.0_2050s_MSP <- raster("MRI-ESM2-0_ssp370_2041_MSP.tif") # mean summer (may to sept) precipitation
MRI_7.0_2050s_AHM <- raster("MRI-ESM2-0_ssp370_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MRI_7.0_2050s_DD5 <- raster("MRI-ESM2-0_ssp370_2041_DD5.tif") # degree-days above 5 C (growing degree days)
MRI_7.0_2050s_DD_18 <- raster("MRI-ESM2-0_ssp370_2041_DD_18.tif") # degree-days below 18 C
MRI_7.0_2050s_NFFD <- raster("MRI-ESM2-0_ssp370_2041_NFFD.tif") # the number of frost-free days
MRI_7.0_2050s_FFP <- raster("MRI-ESM2-0_ssp370_2041_FFP.tif") # frost-free period
MRI_7.0_2050s_bFFP <- raster("MRI-ESM2-0_ssp370_2041_bFFP.tif") # the julian date on which the frost-free period begins
MRI_7.0_2050s_PAS <- raster("MRI-ESM2-0_ssp370_2041_PAS.tif") # precipitation as snow (mm)
MRI_7.0_2050s_EMT <- raster("MRI-ESM2-0_ssp370_2041_EMT.tif") # extreme minimum temperature over 30 years
MRI_7.0_2050s_EXT <- raster("MRI-ESM2-0_ssp370_2041_EXT.tif") # extreme maximum temperature over 30 years
MRI_7.0_2050s_Eref <- raster("MRI-ESM2-0_ssp370_2041_Eref.tif") # Hargreave's reference evaporation
MRI_7.0_2050s_CMD <- raster("MRI-ESM2-0_ssp370_2041_CMD.tif") # Hargreave's climatic moisture index
MRI_7.0_2050s_CMI <- raster("MRI-ESM2-0_ssp370_2041_CMI.tif") # Hogg's climate moisture index (mm)
MRI_7.0_2050s_DD1040 <- raster("MRI-ESM2-0_ssp370_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MRI_7.0_2050s_Tave_wt <- raster("MRI-ESM2-0_ssp370_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MRI_7.0_2050s_Tave_sp <- raster("MRI-ESM2-0_ssp370_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
MRI_7.0_2050s_Tave_sm <- raster("MRI-ESM2-0_ssp370_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MRI_7.0_2050s_Tave_at <- raster("MRI-ESM2-0_ssp370_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MRI_7.0_2050s_PPT_sp <- raster("MRI-ESM2-0_ssp370_2041_PPT_sp.tif") # spring precipitation
MRI_7.0_2050s_PPT_at <- raster("MRI-ESM2-0_ssp370_2041_PPT_at.tif") # autumn precipitation

# MRI 7.0 2050s
setwd("D:/MastersProject/Formatted variables")
MRI_7.0_2050_TD <- projectRaster(MRI_7.0_2050s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MRI_7.0_2050.tif")
MRI_7.0_2050_SHM <- projectRaster(MRI_7.0_2050s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MRI_7.0_2050.tif")
MRI_7.0_2050_DD_0 <- projectRaster(MRI_7.0_2050s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MRI_7.0_2050.tif")
MRI_7.0_2050_DD18 <- projectRaster(MRI_7.0_2050s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MRI_7.0_2050.tif")
MRI_7.0_2050_eFFP <- projectRaster(MRI_7.0_2050s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MRI_7.0_2050.tif")
MRI_7.0_2050_MAR <- projectRaster(MRI_7.0_2050s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MRI_7.0_2050.tif")
MRI_7.0_2050_RH <- projectRaster(MRI_7.0_2050s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MRI_7.0_2050.tif")
MRI_7.0_2050_PPT_wt <- projectRaster(MRI_7.0_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MRI_7.0_2050.tif")
MRI_7.0_2050_PPT_sm <- projectRaster(MRI_7.0_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MRI_7.0_2050.tif")
MRI_7.0_2050_EXT <- projectRaster(MRI_7.0_2050s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MRI_7.0_2050.tif")
MRI_7.0_2050_MAT <- projectRaster(MRI_7.0_2050s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MRI_7.0_2050.tif")
MRI_7.0_2050_MWMT <- projectRaster(MRI_7.0_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MRI_7.0_2050.tif")
MRI_7.0_2050_MCMT <- projectRaster(MRI_7.0_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MRI_7.0_2050.tif")
MRI_7.0_2050_MAP <- projectRaster(MRI_7.0_2050s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MRI_7.0_2050.tif")
MRI_7.0_2050_MSP <- projectRaster(MRI_7.0_2050s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MRI_7.0_2050.tif")
MRI_7.0_2050_AHM <- projectRaster(MRI_7.0_2050s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MRI_7.0_2050.tif")
MRI_7.0_2050_DD5 <- projectRaster(MRI_7.0_2050s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MRI_7.0_2050.tif")
MRI_7.0_2050_DD_18 <- projectRaster(MRI_7.0_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MRI_7.0_2050.tif")
MRI_7.0_2050_NFFD <- projectRaster(MRI_7.0_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MRI_7.0_2050.tif")
MRI_7.0_2050_FFP <- projectRaster(MRI_7.0_2050s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MRI_7.0_2050.tif")
MRI_7.0_2050_bFFP <- projectRaster(MRI_7.0_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MRI_7.0_2050.tif")
MRI_7.0_2050_PAS <- projectRaster(MRI_7.0_2050s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MRI_7.0_2050.tif")
MRI_7.0_2050_EMT <- projectRaster(MRI_7.0_2050s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MRI_7.0_2050.tif")
MRI_7.0_2050_Eref <- projectRaster(MRI_7.0_2050s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MRI_7.0_2050.tif")
MRI_7.0_2050_CMD <- projectRaster(MRI_7.0_2050s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MRI_7.0_2050.tif")
MRI_7.0_2050_CMI <- projectRaster(MRI_7.0_2050s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MRI_7.0_2050.tif")
MRI_7.0_2050_DD1040 <- projectRaster(MRI_7.0_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MRI_7.0_2050.tif")
MRI_7.0_2050_Tave_wt <- projectRaster(MRI_7.0_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MRI_7.0_2050.tif")
MRI_7.0_2050_Tave_sp <- projectRaster(MRI_7.0_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_7.0_2050.tif")
MRI_7.0_2050_Tave_sm <- projectRaster(MRI_7.0_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MRI_7.0_2050.tif")
MRI_7.0_2050_Tave_at <- projectRaster(MRI_7.0_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MRI_7.0_2050.tif")
MRI_7.0_2050_PPT_sp <- projectRaster(MRI_7.0_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MRI_7.0_2050.tif")
MRI_7.0_2050_PPT_at <- projectRaster(MRI_7.0_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MRI_7.0_2050.tif")

############ MRI 7.0 2080s #############
setwd("D:/MastersProject/ClimateNA/MRI_7.0_2080s") 
MRI_7.0_2080s_TD <- raster("MRI-ESM2-0_ssp370_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MRI_7.0_2080s_SHM <- raster("MRI-ESM2-0_ssp370_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MRI_7.0_2080s_DD_0 <- raster("MRI-ESM2-0_ssp370_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
MRI_7.0_2080s_DD18 <- raster("MRI-ESM2-0_ssp370_2071_DD18.tif") # degree-days above 18 C
MRI_7.0_2080s_eFFP <- raster("MRI-ESM2-0_ssp370_2071_eFFP.tif") # the julian date on which the frost-free period ends
MRI_7.0_2080s_MAR <- raster("MRI-ESM2-0_ssp370_2071_MAR.tif") # mean annual solar radiation
MRI_7.0_2080s_RH <- raster("MRI-ESM2-0_ssp370_2071_RH.tif") # mean annual relative humidity (%)
MRI_7.0_2080s_PPT_wt <- raster("MRI-ESM2-0_ssp370_2071_PPT_wt.tif") # winter precipitation
MRI_7.0_2080s_PPT_sm <- raster("MRI-ESM2-0_ssp370_2071_PPT_sm.tif") # summer precipitation
MRI_7.0_2080s_MAT <- raster("MRI-ESM2-0_ssp370_2071_MAT.tif") # mean annual temperature (C)
MRI_7.0_2080s_MWMT <- raster("MRI-ESM2-0_ssp370_2071_MWMT.tif") # mean temperature of the warmest month
MRI_7.0_2080s_MCMT <- raster("MRI-ESM2-0_ssp370_2071_MCMT.tif") # mean temperature of the coldest month
MRI_7.0_2080s_MAP <- raster("MRI-ESM2-0_ssp370_2071_MAP.tif") # mean annual precipitation (mm)
MRI_7.0_2080s_MSP <- raster("MRI-ESM2-0_ssp370_2071_MSP.tif") # mean summer (may to sept) precipitation
MRI_7.0_2080s_AHM <- raster("MRI-ESM2-0_ssp370_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MRI_7.0_2080s_DD5 <- raster("MRI-ESM2-0_ssp370_2071_DD5.tif") # degree-days above 5 C (growing degree days)
MRI_7.0_2080s_DD_18 <- raster("MRI-ESM2-0_ssp370_2071_DD_18.tif") # degree-days below 18 C
MRI_7.0_2080s_NFFD <- raster("MRI-ESM2-0_ssp370_2071_NFFD.tif") # the number of frost-free days
MRI_7.0_2080s_FFP <- raster("MRI-ESM2-0_ssp370_2071_FFP.tif") # frost-free period
MRI_7.0_2080s_bFFP <- raster("MRI-ESM2-0_ssp370_2071_bFFP.tif") # the julian date on which the frost-free period begins
MRI_7.0_2080s_PAS <- raster("MRI-ESM2-0_ssp370_2071_PAS.tif") # precipitation as snow (mm)
MRI_7.0_2080s_EMT <- raster("MRI-ESM2-0_ssp370_2071_EMT.tif") # extreme minimum temperature over 30 years
MRI_7.0_2080s_EXT <- raster("MRI-ESM2-0_ssp370_2071_EXT.tif") # extreme maximum temperature over 30 years
MRI_7.0_2080s_Eref <- raster("MRI-ESM2-0_ssp370_2071_Eref.tif") # Hargreave's reference evaporation
MRI_7.0_2080s_CMD <- raster("MRI-ESM2-0_ssp370_2071_CMD.tif") # Hargreave's climatic moisture index
MRI_7.0_2080s_CMI <- raster("MRI-ESM2-0_ssp370_2071_CMI.tif") # Hogg's climate moisture index (mm)
MRI_7.0_2080s_DD1040 <- raster("MRI-ESM2-0_ssp370_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MRI_7.0_2080s_Tave_wt <- raster("MRI-ESM2-0_ssp370_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MRI_7.0_2080s_Tave_sp <- raster("MRI-ESM2-0_ssp370_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
MRI_7.0_2080s_Tave_sm <- raster("MRI-ESM2-0_ssp370_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MRI_7.0_2080s_Tave_at <- raster("MRI-ESM2-0_ssp370_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MRI_7.0_2080s_PPT_sp <- raster("MRI-ESM2-0_ssp370_2071_PPT_sp.tif") # spring precipitation
MRI_7.0_2080s_PPT_at <- raster("MRI-ESM2-0_ssp370_2071_PPT_at.tif") # autumn precipitation

# MRI 7.0 2080s
setwd("D:/MastersProject/Formatted variables")
MRI_7.0_2080_TD <- projectRaster(MRI_7.0_2080s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MRI_7.0_2080.tif")
MRI_7.0_2080_SHM <- projectRaster(MRI_7.0_2080s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MRI_7.0_2080.tif")
MRI_7.0_2080_DD_0 <- projectRaster(MRI_7.0_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MRI_7.0_2080.tif")
MRI_7.0_2080_DD18 <- projectRaster(MRI_7.0_2080s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MRI_7.0_2080.tif")
MRI_7.0_2080_eFFP <- projectRaster(MRI_7.0_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MRI_7.0_2080.tif")
MRI_7.0_2080_MAR <- projectRaster(MRI_7.0_2080s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MRI_7.0_2080.tif")
MRI_7.0_2080_RH <- projectRaster(MRI_7.0_2080s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MRI_7.0_2080.tif")
MRI_7.0_2080_PPT_wt <- projectRaster(MRI_7.0_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MRI_7.0_2080.tif")
MRI_7.0_2080_PPT_sm <- projectRaster(MRI_7.0_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MRI_7.0_2080.tif")
MRI_7.0_2080_EXT <- projectRaster(MRI_7.0_2080s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MRI_7.0_2080.tif")
MRI_7.0_2080_MAT <- projectRaster(MRI_7.0_2080s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MRI_7.0_2080.tif")
MRI_7.0_2080_MWMT <- projectRaster(MRI_7.0_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MRI_7.0_2080.tif")
MRI_7.0_2080_MCMT <- projectRaster(MRI_7.0_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MRI_7.0_2080.tif")
MRI_7.0_2080_MAP <- projectRaster(MRI_7.0_2080s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MRI_7.0_2080.tif")
MRI_7.0_2080_MSP <- projectRaster(MRI_7.0_2080s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MRI_7.0_2080.tif")
MRI_7.0_2080_AHM <- projectRaster(MRI_7.0_2080s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MRI_7.0_2080.tif")
MRI_7.0_2080_DD5 <- projectRaster(MRI_7.0_2080s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MRI_7.0_2080.tif")
MRI_7.0_2080_DD_18 <- projectRaster(MRI_7.0_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MRI_7.0_2080.tif")
MRI_7.0_2080_NFFD <- projectRaster(MRI_7.0_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MRI_7.0_2080.tif")
MRI_7.0_2080_FFP <- projectRaster(MRI_7.0_2080s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MRI_7.0_2080.tif")
MRI_7.0_2080_bFFP <- projectRaster(MRI_7.0_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MRI_7.0_2080.tif")
MRI_7.0_2080_PAS <- projectRaster(MRI_7.0_2080s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MRI_7.0_2080.tif")
MRI_7.0_2080_EMT <- projectRaster(MRI_7.0_2080s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MRI_7.0_2080.tif")
MRI_7.0_2080_Eref <- projectRaster(MRI_7.0_2080s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MRI_7.0_2080.tif")
MRI_7.0_2080_CMD <- projectRaster(MRI_7.0_2080s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MRI_7.0_2080.tif")
MRI_7.0_2080_CMI <- projectRaster(MRI_7.0_2080s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MRI_7.0_2080.tif")
MRI_7.0_2080_DD1040 <- projectRaster(MRI_7.0_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MRI_7.0_2080.tif")
MRI_7.0_2080_Tave_wt <- projectRaster(MRI_7.0_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MRI_7.0_2080.tif")
MRI_7.0_2080_Tave_sp <- projectRaster(MRI_7.0_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_7.0_2080.tif")
MRI_7.0_2080_Tave_sm <- projectRaster(MRI_7.0_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MRI_7.0_2080.tif")
MRI_7.0_2080_Tave_at <- projectRaster(MRI_7.0_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MRI_7.0_2080.tif")
MRI_7.0_2080_PPT_sp <- projectRaster(MRI_7.0_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MRI_7.0_2080.tif")
MRI_7.0_2080_PPT_at <- projectRaster(MRI_7.0_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MRI_7.0_2080.tif")

######### MRI 8.5 2050s ##################
setwd("D:/MastersProject/ClimateNA/MRI_8.5_2050s") 
MRI_8.5_2050s_TD <- raster("MRI-ESM2-0_ssp585_2041_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MRI_8.5_2050s_SHM <- raster("MRI-ESM2-0_ssp585_2041_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MRI_8.5_2050s_DD_0 <- raster("MRI-ESM2-0_ssp585_2041_DD_0.tif") # degree-days below 0 C (chilling degree days)
MRI_8.5_2050s_DD18 <- raster("MRI-ESM2-0_ssp585_2041_DD18.tif") # degree-days above 18 C
MRI_8.5_2050s_eFFP <- raster("MRI-ESM2-0_ssp585_2041_eFFP.tif") # the julian date on which the frost-free period ends
MRI_8.5_2050s_MAR <- raster("MRI-ESM2-0_ssp585_2041_MAR.tif") # mean annual solar radiation
MRI_8.5_2050s_RH <- raster("MRI-ESM2-0_ssp585_2041_RH.tif") # mean annual relative humidity (%)
MRI_8.5_2050s_PPT_wt <- raster("MRI-ESM2-0_ssp585_2041_PPT_wt.tif") # winter precipitation
MRI_8.5_2050s_PPT_sm <- raster("MRI-ESM2-0_ssp585_2041_PPT_sm.tif") # summer precipitation
MRI_8.5_2050s_MAT <- raster("MRI-ESM2-0_ssp585_2041_MAT.tif") # mean annual temperature (C)
MRI_8.5_2050s_MWMT <- raster("MRI-ESM2-0_ssp585_2041_MWMT.tif") # mean temperature of the warmest month
MRI_8.5_2050s_MCMT <- raster("MRI-ESM2-0_ssp585_2041_MCMT.tif") # mean temperature of the coldest month
MRI_8.5_2050s_MAP <- raster("MRI-ESM2-0_ssp585_2041_MAP.tif") # mean annual precipitation (mm)
MRI_8.5_2050s_MSP <- raster("MRI-ESM2-0_ssp585_2041_MSP.tif") # mean summer (may to sept) precipitation
MRI_8.5_2050s_AHM <- raster("MRI-ESM2-0_ssp585_2041_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MRI_8.5_2050s_DD5 <- raster("MRI-ESM2-0_ssp585_2041_DD5.tif") # degree-days above 5 C (growing degree days)
MRI_8.5_2050s_DD_18 <- raster("MRI-ESM2-0_ssp585_2041_DD_18.tif") # degree-days below 18 C
MRI_8.5_2050s_NFFD <- raster("MRI-ESM2-0_ssp585_2041_NFFD.tif") # the number of frost-free days
MRI_8.5_2050s_FFP <- raster("MRI-ESM2-0_ssp585_2041_FFP.tif") # frost-free period
MRI_8.5_2050s_bFFP <- raster("MRI-ESM2-0_ssp585_2041_bFFP.tif") # the julian date on which the frost-free period begins
MRI_8.5_2050s_PAS <- raster("MRI-ESM2-0_ssp585_2041_PAS.tif") # precipitation as snow (mm)
MRI_8.5_2050s_EMT <- raster("MRI-ESM2-0_ssp585_2041_EMT.tif") # extreme minimum temperature over 30 years
MRI_8.5_2050s_EXT <- raster("MRI-ESM2-0_ssp585_2041_EXT.tif") # extreme maximum temperature over 30 years
MRI_8.5_2050s_Eref <- raster("MRI-ESM2-0_ssp585_2041_Eref.tif") # Hargreave's reference evaporation
MRI_8.5_2050s_CMD <- raster("MRI-ESM2-0_ssp585_2041_CMD.tif") # Hargreave's climatic moisture index
MRI_8.5_2050s_CMI <- raster("MRI-ESM2-0_ssp585_2041_CMI.tif") # Hogg's climate moisture index (mm)
MRI_8.5_2050s_DD1040 <- raster("MRI-ESM2-0_ssp585_2041_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MRI_8.5_2050s_Tave_wt <- raster("MRI-ESM2-0_ssp585_2041_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MRI_8.5_2050s_Tave_sp <- raster("MRI-ESM2-0_ssp585_2041_Tave_sp.tif") # spring (Mar to May) mean temperature
MRI_8.5_2050s_Tave_sm <- raster("MRI-ESM2-0_ssp585_2041_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MRI_8.5_2050s_Tave_at <- raster("MRI-ESM2-0_ssp585_2041_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MRI_8.5_2050s_PPT_sp <- raster("MRI-ESM2-0_ssp585_2041_PPT_sp.tif") # spring precipitation
MRI_8.5_2050s_PPT_at <- raster("MRI-ESM2-0_ssp585_2041_PPT_at.tif") # autumn precipitation

# MRI 8.5 2050s
setwd("D:/MastersProject/Formatted variables")
MRI_8.5_2050_TD <- projectRaster(MRI_8.5_2050s_TD, HII_gcs, method = 'bilinear', 
                                 filename = "TD_MRI_8.5_2050.tif")
MRI_8.5_2050_SHM <- projectRaster(MRI_8.5_2050s_SHM, HII_gcs, method = 'bilinear', 
                                  filename = "SHM_MRI_8.5_2050.tif")
MRI_8.5_2050_DD_0 <- projectRaster(MRI_8.5_2050s_DD_0, HII_gcs, method = 'bilinear', 
                                   filename = "DD_0_MRI_8.5_2050.tif")
MRI_8.5_2050_DD18 <- projectRaster(MRI_8.5_2050s_DD18, HII_gcs, method = 'bilinear', 
                                   filename = "DD18_MRI_8.5_2050.tif")
MRI_8.5_2050_eFFP <- projectRaster(MRI_8.5_2050s_eFFP, HII_gcs, method = 'bilinear', 
                                   filename = "eFFP_MRI_8.5_2050.tif")
MRI_8.5_2050_MAR <- projectRaster(MRI_8.5_2050s_MAR, HII_gcs, method = 'bilinear', 
                                  filename = "MAR_MRI_8.5_2050.tif")
MRI_8.5_2050_RH <- projectRaster(MRI_8.5_2050s_RH, HII_gcs, method = 'bilinear', 
                                 filename = "RH_MRI_8.5_2050.tif")
MRI_8.5_2050_PPT_wt <- projectRaster(MRI_8.5_2050s_PPT_wt, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_wt_MRI_8.5_2050.tif")
MRI_8.5_2050_PPT_sm <- projectRaster(MRI_8.5_2050s_PPT_sm, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sm_MRI_8.5_2050.tif")
MRI_8.5_2050_EXT <- projectRaster(MRI_8.5_2050s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MRI_8.5_2050.tif")
MRI_8.5_2050_MAT <- projectRaster(MRI_8.5_2050s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MRI_8.5_2050.tif")
MRI_8.5_2050_MWMT <- projectRaster(MRI_8.5_2050s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MRI_8.5_2050.tif")
MRI_8.5_2050_MCMT <- projectRaster(MRI_8.5_2050s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MRI_8.5_2050.tif")
MRI_8.5_2050_MAP <- projectRaster(MRI_8.5_2050s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MRI_8.5_2050.tif")
MRI_8.5_2050_MSP <- projectRaster(MRI_8.5_2050s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MRI_8.5_2050.tif")
MRI_8.5_2050_AHM <- projectRaster(MRI_8.5_2050s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MRI_8.5_2050.tif")
MRI_8.5_2050_DD5 <- projectRaster(MRI_8.5_2050s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MRI_8.5_2050.tif")
MRI_8.5_2050_DD_18 <- projectRaster(MRI_8.5_2050s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MRI_8.5_2050.tif")
MRI_8.5_2050_NFFD <- projectRaster(MRI_8.5_2050s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MRI_8.5_2050.tif")
MRI_8.5_2050_FFP <- projectRaster(MRI_8.5_2050s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MRI_8.5_2050.tif")
MRI_8.5_2050_bFFP <- projectRaster(MRI_8.5_2050s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MRI_8.5_2050.tif")
MRI_8.5_2050_PAS <- projectRaster(MRI_8.5_2050s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MRI_8.5_2050.tif")
MRI_8.5_2050_EMT <- projectRaster(MRI_8.5_2050s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MRI_8.5_2050.tif")
MRI_8.5_2050_Eref <- projectRaster(MRI_8.5_2050s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MRI_8.5_2050.tif")
MRI_8.5_2050_CMD <- projectRaster(MRI_8.5_2050s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MRI_8.5_2050.tif")
MRI_8.5_2050_CMI <- projectRaster(MRI_8.5_2050s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MRI_8.5_2050.tif")
MRI_8.5_2050_DD1040 <- projectRaster(MRI_8.5_2050s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MRI_8.5_2050.tif")
MRI_8.5_2050_Tave_wt <- projectRaster(MRI_8.5_2050s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MRI_8.5_2050.tif")
MRI_8.5_2050_Tave_sp <- projectRaster(MRI_8.5_2050s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_8.5_2050.tif")
MRI_8.5_2050_Tave_sm <- projectRaster(MRI_8.5_2050s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MRI_8.5_2050.tif")
MRI_8.5_2050_Tave_at <- projectRaster(MRI_8.5_2050s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MRI_8.5_2050.tif")
MRI_8.5_2050_PPT_sp <- projectRaster(MRI_8.5_2050s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MRI_8.5_2050.tif")
MRI_8.5_2050_PPT_at <- projectRaster(MRI_8.5_2050s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MRI_8.5_2050.tif")

######### MRI 8.5 2080s ##############
setwd("D:/MastersProject/ClimateNA/MRI_8.5_2080s")
MRI_8.5_2080s_TD <- raster("MRI-ESM2-0_ssp585_2071_TD.tif") # difference between MCMT and MWMT, as a measure of continentality
MRI_8.5_2080s_SHM <- raster("MRI-ESM2-0_ssp585_2071_SHM.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
MRI_8.5_2080s_DD_0 <- raster("MRI-ESM2-0_ssp585_2071_DD_0.tif") # degree-days below 0 C (chilling degree days)
MRI_8.5_2080s_DD18 <- raster("MRI-ESM2-0_ssp585_2071_DD18.tif") # degree-days above 18 C
MRI_8.5_2080s_eFFP <- raster("MRI-ESM2-0_ssp585_2071_eFFP.tif") # the julian date on which the frost-free period ends
MRI_8.5_2080s_MAR <- raster("MRI-ESM2-0_ssp585_2071_MAR.tif") # mean annual solar radiation
MRI_8.5_2080s_RH <- raster("MRI-ESM2-0_ssp585_2071_RH.tif") # mean annual relative humidity (%)
MRI_8.5_2080s_PPT_wt <- raster("MRI-ESM2-0_ssp585_2071_PPT_wt.tif") # winter precipitation
MRI_8.5_2080s_PPT_sm <- raster("MRI-ESM2-0_ssp585_2071_PPT_sm.tif") # summer precipitation
MRI_8.5_2080s_MAT <- raster("MRI-ESM2-0_ssp585_2071_MAT.tif") # mean annual temperature (C)
MRI_8.5_2080s_MWMT <- raster("MRI-ESM2-0_ssp585_2071_MWMT.tif") # mean temperature of the warmest month
MRI_8.5_2080s_MCMT <- raster("MRI-ESM2-0_ssp585_2071_MCMT.tif") # mean temperature of the coldest month
MRI_8.5_2080s_MAP <- raster("MRI-ESM2-0_ssp585_2071_MAP.tif") # mean annual precipitation (mm)
MRI_8.5_2080s_MSP <- raster("MRI-ESM2-0_ssp585_2071_MSP.tif") # mean summer (may to sept) precipitation
MRI_8.5_2080s_AHM <- raster("MRI-ESM2-0_ssp585_2071_AHM.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
MRI_8.5_2080s_DD5 <- raster("MRI-ESM2-0_ssp585_2071_DD5.tif") # degree-days above 5 C (growing degree days)
MRI_8.5_2080s_DD_18 <- raster("MRI-ESM2-0_ssp585_2071_DD_18.tif") # degree-days below 18 C
MRI_8.5_2080s_NFFD <- raster("MRI-ESM2-0_ssp585_2071_NFFD.tif") # the number of frost-free days
MRI_8.5_2080s_FFP <- raster("MRI-ESM2-0_ssp585_2071_FFP.tif") # frost-free period
MRI_8.5_2080s_bFFP <- raster("MRI-ESM2-0_ssp585_2071_bFFP.tif") # the julian date on which the frost-free period begins
MRI_8.5_2080s_PAS <- raster("MRI-ESM2-0_ssp585_2071_PAS.tif") # precipitation as snow (mm)
MRI_8.5_2080s_EMT <- raster("MRI-ESM2-0_ssp585_2071_EMT.tif") # extreme minimum temperature over 30 years
MRI_8.5_2080s_EXT <- raster("MRI-ESM2-0_ssp585_2071_EXT.tif") # extreme maximum temperature over 30 years
MRI_8.5_2080s_Eref <- raster("MRI-ESM2-0_ssp585_2071_Eref.tif") # Hargreave's reference evaporation
MRI_8.5_2080s_CMD <- raster("MRI-ESM2-0_ssp585_2071_CMD.tif") # Hargreave's climatic moisture index
MRI_8.5_2080s_CMI <- raster("MRI-ESM2-0_ssp585_2071_CMI.tif") # Hogg's climate moisture index (mm)
MRI_8.5_2080s_DD1040 <- raster("MRI-ESM2-0_ssp585_2071_DD1040.tif") # (10<DD<40) degree-days above 10 and below 40 C
MRI_8.5_2080s_Tave_wt <- raster("MRI-ESM2-0_ssp585_2071_Tave_wt.tif") # winter (Dec to Feb) mean temperature
MRI_8.5_2080s_Tave_sp <- raster("MRI-ESM2-0_ssp585_2071_Tave_sp.tif") # spring (Mar to May) mean temperature
MRI_8.5_2080s_Tave_sm <- raster("MRI-ESM2-0_ssp585_2071_Tave_sm.tif") # summer (Jun to Aug) mean temperature
MRI_8.5_2080s_Tave_at <- raster("MRI-ESM2-0_ssp585_2071_Tave_at.tif") # autumn (Sep to Nov) mean temperature
MRI_8.5_2080s_PPT_sp <- raster("MRI-ESM2-0_ssp585_2071_PPT_sp.tif") # spring precipitation
MRI_8.5_2080s_PPT_at <- raster("MRI-ESM2-0_ssp585_2071_PPT_at.tif") # autumn precipitation


setwd("D:/MastersProject/Formatted variables")
MRI_8.5_2080_TD <- projectRaster(MRI_8.5_2080s_TD, HII_gcs, method = 'bilinear', 
                                filename = "TD_MRI_8.5_2080.tif")
MRI_8.5_2080_SHM <- projectRaster(MRI_8.5_2080s_SHM, HII_gcs, method = 'bilinear', 
                                 filename = "SHM_MRI_8.5_2080.tif")
MRI_8.5_2080_DD_0 <- projectRaster(MRI_8.5_2080s_DD_0, HII_gcs, method = 'bilinear', 
                                  filename = "DD_0_MRI_8.5_2080.tif")
MRI_8.5_2080_DD18 <- projectRaster(MRI_8.5_2080s_DD18, HII_gcs, method = 'bilinear', 
                                  filename = "DD18_MRI_8.5_2080.tif")
MRI_8.5_2080_eFFP <- projectRaster(MRI_8.5_2080s_eFFP, HII_gcs, method = 'bilinear', 
                                  filename = "eFFP_MRI_8.5_2080.tif")
MRI_8.5_2080_MAR <- projectRaster(MRI_8.5_2080s_MAR, HII_gcs, method = 'bilinear', 
                                 filename = "MAR_MRI_8.5_2080.tif")
MRI_8.5_2080_RH <- projectRaster(MRI_8.5_2080s_RH, HII_gcs, method = 'bilinear', 
                                filename = "RH_MRI_8.5_2080.tif")
MRI_8.5_2080_PPT_wt <- projectRaster(MRI_8.5_2080s_PPT_wt, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_wt_MRI_8.5_2080.tif")
MRI_8.5_2080_PPT_sm <- projectRaster(MRI_8.5_2080s_PPT_sm, HII_gcs, method = 'bilinear', 
                                    filename = "PPT_sm_MRI_8.5_2080.tif")
MRI_8.5_2080_EXT <- projectRaster(MRI_8.5_2080s_EXT, HII_gcs, method = 'bilinear', 
                                  filename = "EXT_MRI_8.5_2080.tif")
MRI_8.5_2080_MAT <- projectRaster(MRI_8.5_2080s_MAT, HII_gcs, method = 'bilinear', 
                                  filename = "MAT_MRI_8.5_2080.tif")
MRI_8.5_2080_MWMT <- projectRaster(MRI_8.5_2080s_MWMT, HII_gcs, method = 'bilinear', 
                                   filename = "MWMT_MRI_8.5_2080.tif")
MRI_8.5_2080_MCMT <- projectRaster(MRI_8.5_2080s_MCMT, HII_gcs, method = 'bilinear', 
                                   filename = "MCMT_MRI_8.5_2080.tif")
MRI_8.5_2080_MAP <- projectRaster(MRI_8.5_2080s_MAP, HII_gcs, method = 'bilinear', 
                                  filename = "MAP_MRI_8.5_2080.tif")
MRI_8.5_2080_MSP <- projectRaster(MRI_8.5_2080s_MSP, HII_gcs, method = 'bilinear', 
                                  filename = "MSP_MRI_8.5_2080.tif")
MRI_8.5_2080_AHM <- projectRaster(MRI_8.5_2080s_AHM, HII_gcs, method = 'bilinear', 
                                  filename = "AHM_MRI_8.5_2080.tif")
MRI_8.5_2080_DD5 <- projectRaster(MRI_8.5_2080s_DD5, HII_gcs, method = 'bilinear', 
                                  filename = "DD5_MRI_8.5_2080.tif")
MRI_8.5_2080_DD_18 <- projectRaster(MRI_8.5_2080s_DD_18, HII_gcs, method = 'bilinear', 
                                    filename = "DD_18_MRI_8.5_2080.tif")
MRI_8.5_2080_NFFD <- projectRaster(MRI_8.5_2080s_NFFD, HII_gcs, method = 'bilinear', 
                                   filename = "NFFD_MRI_8.5_2080.tif")
MRI_8.5_2080_FFP <- projectRaster(MRI_8.5_2080s_FFP, HII_gcs, method = 'bilinear', 
                                  filename = "FFP_MRI_8.5_2080.tif")
MRI_8.5_2080_bFFP <- projectRaster(MRI_8.5_2080s_bFFP, HII_gcs, method = 'bilinear', 
                                   filename = "bFFP_MRI_8.5_2080.tif")
MRI_8.5_2080_PAS <- projectRaster(MRI_8.5_2080s_PAS, HII_gcs, method = 'bilinear', 
                                  filename = "PAS_MRI_8.5_2080.tif")
MRI_8.5_2080_EMT <- projectRaster(MRI_8.5_2080s_EMT, HII_gcs, method = 'bilinear', 
                                  filename = "EMT_MRI_8.5_2080.tif")
MRI_8.5_2080_Eref <- projectRaster(MRI_8.5_2080s_Eref, HII_gcs, method = 'bilinear', 
                                   filename = "Eref_MRI_8.5_2080.tif")
MRI_8.5_2080_CMD <- projectRaster(MRI_8.5_2080s_CMD, HII_gcs, method = 'bilinear', 
                                  filename = "CMD_MRI_8.5_2080.tif")
MRI_8.5_2080_CMI <- projectRaster(MRI_8.5_2080s_CMI, HII_gcs, method = 'bilinear', 
                                  filename = "CMI_MRI_8.5_2080.tif")
MRI_8.5_2080_DD1040 <- projectRaster(MRI_8.5_2080s_DD1040, HII_gcs, method = 'bilinear', 
                                     filename = "DD1040_MRI_8.5_2080.tif")
MRI_8.5_2080_Tave_wt <- projectRaster(MRI_8.5_2080s_Tave_wt, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_wt_MRI_8.5_2080.tif")
MRI_8.5_2080_Tave_sp <- projectRaster(MRI_8.5_2080s_Tave_sp, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sp_MPI_8.5_2080.tif")
MRI_8.5_2080_Tave_sm <- projectRaster(MRI_8.5_2080s_Tave_sm, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_sm_MRI_8.5_2080.tif")
MRI_8.5_2080_Tave_at <- projectRaster(MRI_8.5_2080s_Tave_at, HII_gcs, method = 'bilinear', 
                                      filename = "Tave_at_MRI_8.5_2080.tif")
MRI_8.5_2080_PPT_sp <- projectRaster(MRI_8.5_2080s_PPT_sp, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_sp_MRI_8.5_2080.tif")
MRI_8.5_2080_PPT_at <- projectRaster(MRI_8.5_2080s_PPT_at, HII_gcs, method = 'bilinear', 
                                     filename = "PPT_at_MRI_8.5_2080.tif")
