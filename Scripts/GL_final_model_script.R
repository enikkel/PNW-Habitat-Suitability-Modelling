# Habitat suitability modelling script using Geranium lucidum as an example species

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

############### download species records ##################
setwd("~/R_projects/MastersProject/Geranium.lucidum")
# download .csv files of species records *already cleaned*
# see species record cleaning example script for cleaning protocol 
shiny.geranium.records <- read.csv("lucidum_fullclean.csv") 
geranium.coords <- shiny.geranium.records[ , c("decimallon", "decimallat")]


############# download environmental variables ############## 
# read in formatting variables as created in 'Formatting_Rasters.R'
setwd("D:/MastersProject/Formatted variables")

MAT <- raster("MAT_current.tif") # mean annual temperature (C)
MWMT <- raster("MWMT_current.tif") # mean temperature of the warmest month
MCMT <- raster("MCMT_current.tif") # mean temperature of the coldest month
TD <- raster("TD_current.tif") # difference between MCMT and MWMT, as a measure of continentality
MAP <- raster("MAP_current.tif") # mean annual precipitation (mm)
MSP <- raster("MSP_current.tif") # mean summer (may to sept) precipitation
AHM <- raster("AHM_current.tif") # annual heat moisture index, calculated as (MAT+10)/(MAP/1000)
SHM <- raster("SHM_current.tif") # summer heat moisture index, calculated as MWMT/(MSP/1000)
DD_0 <- raster("DD_0_current.tif") # degree-days below 0 C (chilling degree days)
DD5 <- raster("DD5_current.tif") # degree-days above 5 C (growing degree days)
DD_18 <- raster("DD_18_current.tif") # degree-days below 18 C
DD18 <- raster("DD18_current.tif") # degree-days above 18 C
NFFD <- raster("NFFD_current.tif") # the number of frost-free days
FFP <- raster("FFP_current.tif") # frost-free period
bFFP <- raster("bFFP_current.tif") # the julian date on which the frost-free period begins
eFFP <- raster("eFFP_current.tif") # the julian date on which the frost-free period ends
PAS <- raster("PAS_current.tif") # precipitation as snow (mm)
EMT <- raster("EMT_current.tif") # extreme minimum temperature over 30 years
EXT <- raster("EXT_current.tif") # extreme maximum temperature over 30 years
Eref <- raster("Eref_current.tif") # Hargreave's reference evaporation
CMD <- raster("CMD_current.tif") # Hargreave's climatic moisture index
# MAR
RH <- raster("RH_current.tif") # mean annual relative humidity (%)
CMI <- raster("CMI_current.tif") # Hogg's climate moisture index (mm)
DD1040 <- raster("DD1040_current.tif") # (10<DD<40) degree-days above 10 and below 40 C
Tave_wt <- raster("Tave_wt_current.tif") # winter (Dec to Feb) mean temperature
Tave_sp <- raster("Tave_sp_current.tif") # spring (Mar to May) mean temperature
Tave_sm <- raster("Tave_sm_current.tif") # summer (Jun to Aug) mean temperature
Tave_at <- raster("Tave_at_current.tif") # autumn (Sep to Nov) mean temperature
PPT_wt <- raster("PPT_wt_current.tif") # winter precipitation
PPT_sp <- raster("PPT_sp_current.tif") # spring precipitation
PPT_sm <- raster("PPT_sm_current.tif") # summer precipitation
PPT_at <- raster("PPT_at_current.tif") # autumn precipitation

HII <- raster("HII_NA.tif")

artificial <- raster("artificial_surfaces_landcover.tif") # barren
cropland <- raster("cropland_landcover.tif") # urban
grassland <- raster("grassland_landcover.tif") # forest
forest <- raster("tree_covered_areas_landcover.tif") # grassland
shrub <- raster("shrub_covered_areas_landcover.tif") # cultivated irrigated
herb_veg <- raster("herbaceous_veg_landcover.tif") # cultivated rain-red
mangroves <- raster("mangroves_landcover.tif") #all cultivated
sparse <- raster("sparse_veg_landcover.tif") # water
bare <- raster("bare_soil_landcover.tif")
snow_glaciers <- raster("snow_glaciers_landcover.tif")
water_bodies <- raster("water_bodies_landcover.tif")

# create rasterstack of all variables
setwd("~/R_projects/MastersProject/Geranium.lucidum")

all.variables <- stack(MAT, MWMT, MCMT, TD, MAP, MSP, AHM, 
                       SHM, DD_0, DD5, DD_18, DD18, NFFD, 
                       FFP, bFFP, eFFP, PAS, EMT, EXT, Eref, 
                       CMD, RH, CMI, DD1040, Tave_wt, 
                       Tave_sp, Tave_sm, Tave_at, PPT_wt, 
                       PPT_sp, PPT_sm, PPT_at, 
                       artificial, cropland, grassland, forest,
                       shrub, herb_veg, water_bodies, HII)

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
vif <- vifstep(geranium.variable.values, th = 5) # threshold value of 5
vif

# use these results to choose which variables to use in the model
# vif scores used to determine between 2 correlated variables if necessary 
# (as shown by Pearson's correlation coefficient)

#################### BIOMOD2 #####################################

# crop variables
ext_limited <- extent(-130, -55, 25, 52)
SHM <- crop(SHM, ext_limited)
DD_0 <- crop(DD_0, ext_limited)
DD18 <- crop(DD18, ext_limited)
RH <- crop(RH, ext_limited)
PPT_wt <- crop(PPT_wt, ext_limited)
PPT_sm <- crop(PPT_sm, ext_limited)
cropland <- crop(cropland, ext_limited)
grassland <- crop(grassland, ext_limited)
shrub <- crop(shrub, ext_limited)
herb_veg <- crop(herb_veg, ext_limited)
water_bodies <- crop(water_bodies, ext_limited)
HII <- crop(HII, ext_limited)

### formatting the data
geranium.records$Geranium.lucidum <- 1 # if wanting to use all data, to split

myRespName <- 'Geranium.lucidum'
myResp <- as.numeric(geranium.records[,myRespName])
myRespXY <- geranium.records[,c("decimallon", "decimallat")]
myExpl <- stack(SHM, DD_0, DD18, RH, PPT_wt, PPT_sm, cropland, 
                grassland, shrub, herb_veg, water_bodies, HII)


geranium_format <- 
  BIOMOD_FormatingData(
    resp.var = myResp,
    expl.var = myExpl,
    resp.xy = myRespXY,
    resp.name = myRespName,
    PA.nb.rep = 10, 
    PA.nb.absences = 576, 
    PA.strategy = 'disk', 
    PA.dist.min = 1000, 
    PA.dist.max = 200000,
    na.rm = TRUE
  )

# max distance determined by examining the variable contributions and model evaluation 
# scores after running test models in increments of 100km distances (i.e. 100 kms, 200 kms, etc)
# the distance is too great with 1 or 2 variables are contributing the most to the model, compared
# to the rest of the variables
# See: VanDerWal, J., L. P. Shoo, C. Graham, and S. E. Williams. 2009. 
# Selecting pseudo-absence data for presence-only distribution modeling: how far should you stray from what you know? 
# Ecological Modelling 220:589-594. doi:10.1016/j.ecolmodel.2008.11.010 for full methodology


plot(geranium_format) # might show up as all 'undifined', this is because of the high resolution
# to see the loactions of pseudo-absences, use following function:

## function to get PA dataset - creates a new function
get_PAtab <- function(bfd){dplyr::bind_cols(x = bfd@coord[, 1],
                                            y = bfd@coord[, 2],
                                            status = bfd@data.species,
                                            bfd@PA)}

## function to get background mask
get_mask <- function(bfd){bfd@data.mask}

## get the coordiantes of presences
pres.xy <- get_PAtab(geranium_format)
# filter(status == 1) 
# select(x, y)

## plot the first PA selection and add the presences on top
plot(get_mask(geranium_format)[['PA1']])
points(pres.xy, pch = 1)

### now moving on to defining model options *default settings used for all algorithms*
default_mod_opt <- BIOMOD_ModelingOptions()

geranium_model_out <-
  BIOMOD_Modeling(
    geranium_format,
    models = c('GLM', 'ANN','GBM', 'MARS', 'RF', 'GAM'),
    models.options = default_mod_opt,
    NbRunEval = 5,
    DataSplit = 70,
    VarImport = 3,
    models.eval.meth = c('KAPPA', 'TSS','ROC'),
    SaveObj = TRUE,
    do.full.models = FALSE,
    modeling.id = "final_model200"
  )

geranium_model_out # to view

####### get all model evaluations ###########
geranium_model_eval <- get_evaluations(geranium_model_out)
dimnames(geranium_model_eval)

#inspect scores in plots window
models_scores_graph(geranium_model_out, by = "models" , metrics = c("ROC","TSS"), 
                    xlim = c(0.5,1), ylim = c(0.5,1)) # save .png

#inspect scores in plots window
models_scores_graph(geranium_model_out, by = "cv_run" , metrics = c("ROC","TSS"), 
                    xlim = c(0.5,1), ylim = c(0.5,1))

#inspect scores in plots window
models_scores_graph(geranium_model_out, by = "data_set" , metrics = c("ROC","TSS"), 
                    xlim = c(0.5,1), ylim = c(0.5,1))

# print out KAPPA scores for models
geranium_model_eval["KAPPA", "Testing.data",,,]
geranium_model_eval["TSS", "Testing.data",,,]
geranium_model_eval["ROC", "Testing.data",,,]

library(reshape2)

## rearrange data
ModEval <- melt(geranium_model_eval)
write.csv(ModEval, file = paste("geranium_modeleval.csv",sep=""))
ModEval <- ModEval[which(ModEval$Var2 == "Testing.data"), ]
head(ModEval)

col_vec <- c('#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c'
            ,'#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99','#b15928', 
            '#ffcce5', '#660000', '#000066', '#99004c', '#193300', '#006666')
col_fun <- colorRampPalette(col_vec)

ggplot(ModEval, aes(x = Var1, y = value, color = interaction(Var5,Var3))) +
  scale_color_manual("", values = rep(col_fun(6), each = 10)) +
  geom_boxplot(size = 0.8) +
  labs(x = "", y = "") +
  theme(
    axis.text.x = element_text(angle = 90),
    panel.border = element_rect(size = 1, fill = NA),
    panel.grid.major = element_line(linetype = 2, color = "grey", size = 0.8)
  )


# relative importance of variables
variable_importance <- get_variables_importance(geranium_model_out)

## rearrange data
VarImport = melt(variable_importance)
head(VarImport)

ggplot(VarImport, aes(x = Var1, y = value, color = interaction(Var4,Var2))) +
  scale_color_manual("", values = rep(col_fun(6), each = 10)) +
  geom_boxplot(size = 0.8) +
  labs(x = "", y = "") +
  theme(
    axis.text.x = element_text(angle = 90),
    panel.border = element_rect(size = 1, fill = NA),
    panel.grid.major = element_line(linetype = 2, color = "grey", size = 0.8)
  )


## make the mean of variable importance by algorithm
varimp <- apply(variable_importance, c(1,2), mean)
varimp
write.csv(varimp,file = paste("geranium_varimp.csv",sep="")) # write csv variable importance doc


# to create the variable response curves
meanVarImport_gbm <- BIOMOD_LoadModels(geranium_model_out, models='GBM')
meanVarImport_rf <- BIOMOD_LoadModels(geranium_model_out, models='RF')
meanVarImport_gam <- BIOMOD_LoadModels(geranium_model_out, models='GAM')
meanVarImport_glm <- BIOMOD_LoadModels(geranium_model_out, models='GLM')
meanVarImport_ann <- BIOMOD_LoadModels(geranium_model_out, models='ANN')
meanVarImport_mars <- BIOMOD_LoadModels(geranium_model_out, models='MARS')

gbm_eval_strip <- biomod2::response.plot2(
  models  = meanVarImport_gbm,
  Data = get_formal_data(geranium_model_out,'expl.var'), 
  show.variables= get_formal_data(geranium_model_out,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean', 
  col = c("red", "blue", "yellow", "green", "orange", "purple", "pink"), 
  legend = FALSE,
  display_title = TRUE,
  data_species = get_formal_data(geranium_model_out,'resp.var'))

rf_eval_strip <- biomod2::response.plot2(
  models  = meanVarImport_rf,
  Data = get_formal_data(geranium_model_out,'expl.var'), 
  show.variables= get_formal_data(geranium_model_out,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean', 
  col = c("red", "blue", "yellow", "green", "orange", "purple", "pink"), 
  legend = FALSE,
  display_title = TRUE,
  data_species = get_formal_data(geranium_model_out,'resp.var'))

gam_eval_strip <- biomod2::response.plot2(
  models  = meanVarImport_gam,
  Data = get_formal_data(geranium_model_out,'expl.var'), 
  show.variables= get_formal_data(geranium_model_out,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean', 
  col = c("red", "blue", "yellow", "green", "orange", "purple", "pink"), 
  legend = FALSE,
  display_title = TRUE,
  data_species = get_formal_data(geranium_model_out,'resp.var'))

glm_eval_strip <- biomod2::response.plot2(
  models  = meanVarImport_glm,
  Data = get_formal_data(geranium_model_out,'expl.var'), 
  show.variables= get_formal_data(geranium_model_out,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean', 
  col = c("red", "blue", "yellow", "green", "orange", "purple", "pink"), 
  legend = FALSE,
  display_title = TRUE,
  data_species = get_formal_data(geranium_model_out,'resp.var'))

ann_eval_strip <- biomod2::response.plot2(
  models  = meanVarImport_ann,
  Data = get_formal_data(geranium_model_out,'expl.var'), 
  show.variables= get_formal_data(geranium_model_out,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean', 
  col = c("red", "blue", "yellow", "green", "orange", "purple", "pink"), 
  legend = FALSE,
  display_title = TRUE,
  data_species = get_formal_data(geranium_model_out,'resp.var'))

mars_eval_strip <- biomod2::response.plot2(
  models  = meanVarImport_mars,
  Data = get_formal_data(geranium_model_out,'expl.var'), 
  show.variables= get_formal_data(geranium_model_out,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean', 
  col = c("red", "blue", "yellow", "green", "orange", "purple", "pink"), 
  legend = FALSE,
  display_title = TRUE,
  data_species = get_formal_data(geranium_model_out,'resp.var'))

######## continue ensemble ##############
geranium_em <- BIOMOD_EnsembleModeling(
  modeling.output = geranium_model_out,
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

geranium_em
get_evaluations(geranium_em)

## get ensemble model variable importance
ensemble_models_var_import <- get_variables_importance(geranium_em)

## rearrange data
EnsVarImport = melt(ensemble_models_var_import)
EnsVarImport$Var3 = sub(".*EM", "", EnsVarImport$Var3)
EnsVarImport$Var3 = sub("_merged.*", "", EnsVarImport$Var3)
head(EnsVarImport)

ggplot(EnsVarImport, aes(x = Var1, y = value, color = Var3)) +
  scale_color_manual("", values = col_fun(3)) +
  geom_boxplot(size = 0.8) +
  labs(x = "", y = "") +
  theme(
    axis.text.x = element_text(angle = 90),
    panel.border = element_rect(size = 1, fill = NA),
    panel.grid.major = element_line(linetype = 2, color = "grey", size = 0.8)
  )

# limit extent if you want to save processing time
ext_limited <- extent(-130, -115, 32, 52)
SHM <- crop(SHM, ext_limited)
DD_0 <- crop(DD_0, ext_limited)
DD18 <- crop(DD18, ext_limited)
RH <- crop(RH, ext_limited)
PPT_wt <- crop(PPT_wt, ext_limited)
PPT_sm <- crop(PPT_sm, ext_limited)
cropland <- crop(cropland, ext_limited)
grassland <- crop(grassland, ext_limited)
shrub <- crop(shrub, ext_limited)
herb_veg <- crop(herb_veg, ext_limited)
water_bodies <- crop(water_bodies, ext_limited)
HII <- crop(HII, ext_limited)

myExpl <- stack(SHM, DD_0, DD18, RH, PPT_wt, PPT_sm, cropland, 
                grassland, shrub, herb_veg, water_bodies, HII)

# projection
geranium_current_proj <- BIOMOD_Projection(
  modeling.output = geranium_model_out,
  new.env = myExpl,
  proj.name = 'final_model200',
  selected.models = 'all',
  binary.meth = 'TSS',
  compress = 'xz',
  clamping.mask = F,
  output.format = '.grd')


plot(geranium_current_proj, str.grep = 'MARS')
plot(geranium_current_proj, str.grep = 'GLM')
plot(geranium_current_proj, str.grep = 'GBM')
plot(geranium_current_proj, str.grep = 'RF')
plot(geranium_current_proj, str.grep = 'GAM')
plot(geranium_current_proj, str.grep = 'ANN')

geranium_all_current_proj <- get_predictions(geranium_current_proj)
geranium_all_current_proj

# make ensemble forecasting
geranium_ef <- BIOMOD_EnsembleForecasting(EM.output = geranium_em,
                                             projection.output = geranium_current_proj)
plot(geranium_ef)

################ Plotting the model outputs and cropping to PNW and MV ###################

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_final_model200/individual_projections")
geranium_current_ensemble <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(geranium_current_ensemble)
geranium_current_ensemble_pnw <- crop(geranium_current_ensemble, ext_pnw)
geranium_current_ensemble_mv <- crop(geranium_current_ensemble, ext_mv)
plot(geranium_current_ensemble_pnw)
plot(geranium_current_ensemble_mv)
setwd("~/R_projects/MastersProject/Geranium.lucidum/")
writeRaster(geranium_current_ensemble, filename = "geranium_current_ensemble.tif", overwrite = TRUE)
writeRaster(geranium_current_ensemble_pnw, filename = "geranium_current_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(geranium_current_ensemble_mv, filename = "geranium_current_ensemble_mv.tif", overwrite = TRUE)


# to see the ensemble response curve
ensemble_model_response_curve <- BIOMOD_LoadModels(geranium_em)

ensemble_eval_strip <- biomod2::response.plot2(
  models  = ensemble_model_response_curve,
  Data = get_formal_data(geranium_model_out,'expl.var'), 
  show.variables= get_formal_data(geranium_model_out,'expl.var.names'),
  do.bivariate = FALSE,
  fixed.var.metric = 'mean', 
  col = c("blue", "purple"), 
  legend = FALSE,
  display_title = TRUE,
  data_species = get_formal_data(geranium_model_out,'resp.var'))
