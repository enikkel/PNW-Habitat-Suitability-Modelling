# NA model script using world soils database for landcover

# install packages
install.packages("dismo")
install.packages("maptools")
install.packages("rgdal")
install.packages("Rtools")
install.packages("raster")
install.packages("sp")
install.packages("usdm")
install.packages("biomod2")
install.packages("corrplot")
install.packages("tidyverse")
install.packages("JGR")
install.packages("rJava")

# load packages
library(sp)
library(rgdal)
library(raster)
library(dismo)
library(biomod2)
library(usdm)
library(maptools)
library(corrplot)
library(ggplot2)
library(readr)
library(tidyverse)
library(ecospat)
library(colorRamps)
library(rJava)
library(JGR)

############### download species records ##################
# download .csv files of species records *already cleaned*
shiny.geranium.records <- read.csv("NA_geranium_records.csv")
geranium.coords <- shiny.geranium.records[ , c("decimallon", "decimallat")]


############# download environmental variables ############## 
# download ClimateNA vclimate normals variables
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

# create rasters of world soils variables
NVG <- raster("NVG_2000")
URB <- raster("URB_2000")
FOR <- raster("FOR_2000")
GRS <- raster("GRS_2000")
CULTIR <- raster("CULTIR_2000")
CULTRF <- raster("CULT_2000")
CULT <- raster("CULTRF_2000")
WATER <- raster("WAT_2000")

# download and unzip Human Influence Index v2: Last of the Wild (World)
# create raster of Human Influence Index using local file path
HII <- raster("w001001.adf")

ext <- extent(-180, -40, 10, 90)

NVG.NA <- crop(NVG, ext)
URB.NA <- crop(URB, ext)
FOR.NA <- crop(FOR, ext)
GRS.NA <- crop(GRS, ext)
CULTIR.NA <- crop(CULTIR, ext)
CULTRF.NA <- crop(CULTRF, ext)
CULT.NA <- crop(CULT, ext)
WATER.NA <- crop(WATER, ext)

# method = 'ngb' for categorical variables, 'bilinear' for continuous
# reproject variables to 30s resolution
# using worldclim bio1 as the input projection
bio1 <- raster("wc2.1_30s_bio_1.tif")
bio1 <- crop(bio1, ext)
HII_gcs <- projectRaster(HII, bio1, method = 'ngb')

crs(NVG.NA) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(URB.NA) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(FOR.NA) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(GRS.NA) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(CULTIR.NA) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(CULTRF.NA) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(CULT.NA) <- "+proj=longlat +datum=WGS84 +no_defs"

NVG.NA <- projectRaster(NVG.NA, HII_gcs, method = 'ngb')
URB.NA <- projectRaster(URB.NA, HII_gcs, method = 'ngb')
FOR.NA <- projectRaster(FOR.NA, HII_gcs, method = 'ngb')
GRS.NA <- projectRaster(GRS.NA, HII_gcs, method = 'ngb')
CULTIR.NA <- projectRaster(CULTIR.NA, HII_gcs, method = 'ngb')
CULTRF.NA <- projectRaster(CULTRF.NA, HII_gcs, method = 'ngb')
CULT.NA <- projectRaster(CULT.NA, HII_gcs, method = 'ngb')

MAT.NA <- projectRaster(MAT, HII_gcs, method = 'bilinear')
MWMT.NA <- projectRaster(MWMT, HII_gcs, method = 'bilinear')
MCMT.NA <- projectRaster(MCMT, HII_gcs, method = 'bilinear')
TD.NA <- projectRaster(TD, HII_gcs, method = 'bilinear')
MAP.NA <- projectRaster(MAP, HII_gcs, method = 'bilinear')
MSP.NA <- projectRaster(MSP, HII_gcs, method = 'bilinear')
AHM.NA <- projectRaster(AHM, HII_gcs, method = 'bilinear')
SHM.NA <- projectRaster(SHM, HII_gcs, method = 'bilinear')
DD_0.NA <- projectRaster(DD_0, HII_gcs, method = 'bilinear')
DD5.NA <- projectRaster(DD5, HII_gcs, method = 'bilinear')
DD_18.NA <- projectRaster(DD_18, HII_gcs, method = 'bilinear')
DD18.NA <- projectRaster(DD18, HII_gcs, method = 'bilinear')
NFFD.NA <- projectRaster(NFFD, HII_gcs, method = 'bilinear')
FFP.NA <- projectRaster(FFP, HII_gcs, method = 'bilinear')
bFFP.NA <- projectRaster(bFFP, HII_gcs, method = 'bilinear')
eFFP.NA <- projectRaster(eFFP, HII_gcs, method = 'bilinear')
PAS.NA <- projectRaster(PAS, HII_gcs, method = 'bilinear')
EMT.NA <- projectRaster(EMT, HII_gcs, method = 'bilinear')
EXT.NA <- projectRaster(EXT, HII_gcs, method = 'bilinear')
Eref.NA <- projectRaster(Eref, HII_gcs, method = 'bilinear')
CMD.NA <- projectRaster(CMD, HII_gcs, method = 'bilinear')
MAR.NA <- projectRaster(MAR, HII_gcs, method = 'bilinear')
RH.NA <- projectRaster(RH, HII_gcs, method = 'bilinear')
CMI.NA <- projectRaster(CMI, HII_gcs, method = 'bilinear')
DD1040.NA <- projectRaster(DD1040, HII_gcs, method = 'bilinear')
Tave_wt.NA <- projectRaster(Tave_wt, HII_gcs, method = 'bilinear')
Tave_sp.NA <- projectRaster(Tave_sp, HII_gcs, method = 'bilinear')
Tave_sm.NA <- projectRaster(Tave_sm, HII_gcs, method = 'bilinear')
Tave_at.NA <- projectRaster(Tave_at, HII_gcs, method = 'bilinear')
PPT_wt.NA <- projectRaster(PPT_wt, HII_gcs, method = 'bilinear')
PPT_sp.NA <- projectRaster(PPT_sp, HII_gcs, method = 'bilinear')
PPT_sm.NA <- projectRaster(PPT_sm, HII_gcs, method = 'bilinear')
PPT_at.NA <- projectRaster(PPT_at, HII_gcs, method = 'bilinear')

# needs same projection, ext, resolution, crs, etc
all.variables <- stack(MAT.NA, MWMT.NA, MCMT.NA, TD.NA, MAP.NA, MSP.NA, AHM.NA, 
                       SHM.NA, DD_0.NA, DD5.NA, DD_18.NA, DD18.NA, NFFD.NA, 
                       FFP.NA, bFFP.NA, eFFP.NA, PAS.NA, EMT.NA, EXT.NA, Eref.NA, 
                       CMD.NA, MAR.NA, RH.NA, CMI.NA, DD1040.NA, Tave_wt.NA, 
                       Tave_sp.NA, Tave_sm.NA, Tave_at.NA, PPT_wt.NA, 
                       PPT_sp.NA, PPT_sm.NA, PPT_at.NA, 
                       NVG.NA, URB.NA, FOR.NA, GRS.NA, CULTRF.NA, 
                       CULTIR.NA, CULT.NA, HII_gcs)

############## extract variable values for each species record ###############

geranium.values <- raster::extract(all.variables, geranium.coords, method = 'simple')
# check for any Na values
summary(geranium.values)

# remove any NA values, but add coordinates first
geranium.values.coords <- cbind(geranium.coords, geranium.values)
geranium.values.coords <- na.omit(geranium.values.coords)

geranium.variable.values <- subset(geranium.values.coords, select = -c(decimallon, decimallat))
geranium.records <- subset(geranium.values.coords, select = c(decimallon, decimallat))

#################### Run Pearson's Correlation and VIF #######################

geranium.cor <- cor(geranium.variable.values, method = "pearson", use = "pairwise.complete.obs")


# creating a tree graph visual
pearson.dist <- as.dist(1 - geranium.cor)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree)
abline(h = 0.3, col = "red", lty = 5)

# VIF
vif <- vifstep(geranium.variable.values, th = 10) # threshold value of 10 
vif

####################### Future Climate Data #######################
# upload future climate, we'll start with the GCM: MRI 4.5 2050s
# TD_MRI_4.5_50s <- raster("MRI-ESM2-0_ssp245_2041_TD.tif")


#################### BIOMOD2 #####################################
# with world soils dataset

### formatting the data
geranium.records$Geranium.lucidum <- 1 # if wanting to use all data, to split

myRespName <- 'Geranium.lucidum'
myResp <- as.numeric(geranium.records[,myRespName])
myRespXY <- geranium.records[,c("decimallon", "decimallat")]
myExpl <- stack(TD.NA, SHM.NA, DD_0.NA, DD18.NA, eFFP.NA, MAR.NA, 
                RH.NA, PPT_wt.NA, PPT_sm.NA, NVG.NA, GRS.NA, 
                URB.NA, CULT.NA, CULTIR.NA, HII_gcs)

geranium_format_ws <- 
  BIOMOD_FormatingData(
    resp.var = myResp,
    expl.var = myExpl,
    resp.xy = myRespXY,
    resp.name = myRespName,
    PA.nb.rep = 3
  )

plot(geranium_format_ws) # might show up as all 'undifined', this is because of 
# the high resolution

### now moving on to defining model options *at default for now*
default_mod_opt_ws <- BIOMOD_ModelingOptions()

### now choosing which models and eval methods
geranium_model_out_ws <-
  BIOMOD_Modeling(
    geranium_format_ws,
    models = c('GLM','GBM', 'MARS', 'RF', 'MAXENT.Phillips'),
    models.options = default_mod_opt_ws,
    NbRunEval = 1,
    DataSplit = 70,
    VarImport = 3,
    models.eval.meth = c('KAPPA', 'TSS','ROC'),
    SaveObj = TRUE,
    do.full.models = FALSE,
    modeling.id = "worldsoils"
  )


geranium_model_out_ws # to view

# get all model evaluations
geranium_model_eval_ws <- get_evaluations(geranium_model_out_ws)
dimnames(geranium_model_eval_ws)

# print out KAPPA scores for models
geranium_model_eval_ws["KAPPA", "Testing.data",,,]
geranium_model_eval_ws["TSS", "Testing.data",,,]
geranium_model_eval_ws["ROC", "Testing.data",,,]

# relative importance of variables
get_variables_importance(geranium_model_out_ws)

geranium_em_ws <- BIOMOD_EnsembleModeling(
  modeling.output = geranium_model_out_ws,
  chosen.models = 'all',
  em.by='all',
  eval.metric = c('TSS'),
  eval.metric.quality.threshold = c(0.7),
  prob.mean = T,
  prob.cv = F,
  prob.ci = F,
  prob.ci.alpha = 0.05,
  prob.median = F,
  committee.averaging = F,
  prob.mean.weight = T,
  prob.mean.weight.decay = 'proportional',
  VarImport = 3)

geranium_em_ws
get_evaluations(geranium_em_ws)
# presence-only evaluation methods? Boyce using BIOMOD_presenceonly
### Ger.4.pres.only.eval <- BIOMOD_presenceonly(Ger.4.ModelOut, Ger.4.EM) #need to set ensemble modeling to
# 'PA_dataset+repet' for this to work

# projection over the globe under current conditions
geranium_current_proj_ws <- BIOMOD_Projection(
  modeling.output = geranium_model_out_ws,
  new.env = myExpl,
  proj.name = 'current',
  selected.models = 'all',
  binary.meth = 'TSS',
  compress = F,
  clamping.mask = F,
  output.format = '.grd')

# files created
list.files("Geranium.lucidum/proj_current/")

plot(geranium_current_proj_ws, str.grep = 'MARS')
plot(geranium_current_proj_ws, str.grep = 'GLM')
plot(geranium_current_proj_ws, str.grep = 'GBM')
plot(geranium_current_proj_ws, str.grep = 'RF')

geranium_all_current_proj_ws <- get_predictions(geranium_current_proj_ws)
geranium_all_current_proj_ws

# make ensemble forecasting
geranium_ef_ws <- BIOMOD_EnsembleForecasting(EM.output = geranium_em_ws,
                                          projection.output = geranium_current_proj_ws)
plot(geranium_ef_ws)

ext_pnw <- extent(-129, -120, 43, 51)
ext_mv <- extent(-123, -122, 49, 49.5)

proj1_ensemble_ws <- raster::stack("Geranium.lucidum_EMmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(proj1_ensemble_ws)
proj_ensemble_pnw_ws <- crop(proj1_ensemble_ws, ext_pnw)
proj_ensemble_mv_ws <- crop(proj1_ensemble_ws, ext_mv)
plot(proj_ensemble_pnw_ws)
plot(proj_ensemble_mv_ws)
