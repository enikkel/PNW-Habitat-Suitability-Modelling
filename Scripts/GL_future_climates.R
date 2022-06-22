# Future climate for Geranium lucidum
# continued from current climate model in final_model_script.R

# if loading in new R session (need saved temp files)
geranium_model_out <- load("Geranium.lucidum.final_model200.models.out")
geranium_em <- load("Geranium.lucidum.final_model200ensemble.models.out")

geranium_model_out <- Geranium.lucidum.final_model200.models.out
geranium_em <- Geranium.lucidum.final_model200ensemble.models.out

################## 4.5 2050s #####################

# UK 4.5 2050s - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_UK_4.5_2050.tif")
DD_0 <- raster("DD_0_UK_4.5_2050.tif")
DD18 <- raster("DD18_UK_4.5_2050.tif")
RH <- raster("RH_UK_4.5_2050.tif")
PPT_wt <- raster("PPT_wt_UK_4.5_2050.tif")
PPT_sm <- raster("PPT_sm_UK_4.5_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_4.5_2050_variables <- stack(SHM, DD_0, DD18, 
                               RH, PPT_wt, 
                               PPT_sm, cropland, grassland, 
                               shrub, herb_veg, water_bodies, HII)

names(UK_4.5_2050_variables) <- names(myExpl) # new, try this

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_4.5_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                            new.env = UK_4.5_2050_variables,
                                            proj.name = "UK_4.5_2050",
                                            selected.models = 'all',
                                            binary.meth = 'TSS',
                                            compress = 'xz',
                                            clamping.mask = F,
                                            output.format = '.grd')

UK_4.5_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                   projection.output = UK_4.5_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_UK_4.5_2050/individual_projections")
UK_4.5_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(UK_4.5_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(UK_4.5_2050_ensemble_climate, filename = "UK_4.5_2050_ensemble.tif", overwrite = TRUE)

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_4.5_2050_ensemble_pnw <- crop(UK_4.5_2050_ensemble_climate, ext_pnw)
UK_4.5_2050_ensemble_mv <- crop(UK_4.5_2050_ensemble_climate, ext_mv)
plot(UK_4.5_2050_ensemble_pnw)
plot(UK_4.5_2050_ensemble_mv)
writeRaster(UK_4.5_2050_ensemble_pnw, filename = "UK_4.5_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(UK_4.5_2050_ensemble_mv, filename = "UK_4.5_2050_ensemble_mv.tif", overwrite = TRUE)


### MRI 4.5 2050s ### DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MRI_4.5_2050.tif")
DD_0 <- raster("DD_0_MRI_4.5_2050.tif")
DD18 <- raster("DD18_MRI_4.5_2050.tif")
RH <- raster("RH_MRI_4.5_2050.tif")
PPT_wt <- raster("PPT_wt_MRI_4.5_2050.tif")
PPT_sm <- raster("PPT_sm_MRI_4.5_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MRI_4.5_2050_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MRI_4.5_2050_variables) <- names(myExpl) # names need to match

MRI_4.5_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MRI_4.5_2050_variables,
                                             proj.name = "MRI_4.5_2050",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MRI_4.5_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MRI_4.5_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MRI_4.5_2050/individual_projections")
MRI_4.5_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MRI_4.5_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MRI_4.5_2050_ensemble_climate, filename = "MRI_4.5_2050_ensemble.tif", overwrite = TRUE)

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MRI_4.5_2050_ensemble_pnw <- crop(MRI_4.5_2050_ensemble_climate, ext_pnw)
MRI_4.5_2050_ensemble_mv <- crop(MRI_4.5_2050_ensemble_climate, ext_mv)
plot(MRI_4.5_2050_ensemble_pnw)
plot(MRI_4.5_2050_ensemble_mv)
writeRaster(MRI_4.5_2050_ensemble_pnw, filename = "MRI_4.5_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MRI_4.5_2050_ensemble_mv, filename = "MRI_4.5_2050_ensemble_mv.tif", overwrite = TRUE)


### MPI 4.5 2050s ### DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MPI_4.5_2050.tif")
DD_0 <- raster("DD_0_MPI_4.5_2050.tif")
DD18 <- raster("DD18_MPI_4.5_2050.tif")
RH <- raster("RH_MPI_4.5_2050.tif")
PPT_wt <- raster("PPT_wt_MPI_4.5_2050.tif")
PPT_sm <- raster("PPT_sm_MPI_4.5_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MPI_4.5_2050_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MPI_4.5_2050_variables) <- names(myExpl) # names need to match

MPI_4.5_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MPI_4.5_2050_variables,
                                             proj.name = "MPI_4.5_2050",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MPI_4.5_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MPI_4.5_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MPI_4.5_2050/individual_projections")
MPI_4.5_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MPI_4.5_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MPI_4.5_2050_ensemble_climate, filename = "MPI_4.5_2050_ensemble.tif", overwrite = TRUE)

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MPI_4.5_2050_ensemble_pnw <- crop(MPI_4.5_2050_ensemble_climate, ext_pnw)
MPI_4.5_2050_ensemble_mv <- crop(MPI_4.5_2050_ensemble_climate, ext_mv)
plot(MPI_4.5_2050_ensemble_pnw)
plot(MPI_4.5_2050_ensemble_mv)
writeRaster(MPI_4.5_2050_ensemble_pnw, filename = "MPI_4.5_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MPI_4.5_2050_ensemble_mv, filename = "MPI_4.5_2050_ensemble_mv.tif", overwrite = TRUE)

# ensemble of GCMs 
setwd("~/R_projects/MastersProject/Geranium.lucidum")
# scenario 4.5 2050s
MPI_4.5_2050 <- raster("MPI_4.5_2050_ensemble_pnw.tif")
MRI_4.5_2050 <- raster("MRI_4.5_2050_ensemble_pnw.tif")
UK_4.5_2050 <- raster("UK_4.5_2050_ensemble_pnw.tif")

all_4.5_2050 <- raster::stack(MPI_4.5_2050, MRI_4.5_2050, UK_4.5_2050)

ensemble_4.5_2050 <- calc(all_4.5_2050, fun = mean, 
                          filename = 'ensemble_4.5_2050.tif', 
                          overwrite = TRUE)

plot(ensemble_4.5_2050)

################# 4.5 2080s ##################

# UK 4.5 2080s - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_UK_4.5_2080.tif")
DD_0 <- raster("DD_0_UK_4.5_2080.tif")
DD18 <- raster("DD18_UK_4.5_2080.tif")
RH <- raster("RH_UK_4.5_2080.tif")
PPT_wt <- raster("PPT_wt_UK_4.5_2080.tif")
PPT_sm <- raster("PPT_sm_UK_4.5_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_4.5_2080_variables <- stack(SHM, DD_0, DD18, 
                               RH, PPT_wt, 
                               PPT_sm, cropland, grassland, 
                               shrub, herb_veg, water_bodies, HII)

names(UK_4.5_2080_variables) <- names(myExpl) # new, try this

UK_4.5_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                            new.env = UK_4.5_2080_variables,
                                            proj.name = "UK_4.5_2080",
                                            selected.models = 'all',
                                            binary.meth = 'TSS',
                                            compress = 'xz',
                                            clamping.mask = F,
                                            output.format = '.grd')

UK_4.5_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                   projection.output = UK_4.5_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_UK_4.5_2080/individual_projections")
UK_4.5_2080s_ensemble <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(UK_4.5_2080s_ensemble)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(UK_4.5_2080s_ensemble, filename = "UK_4.5_2080_ensemble.tif", overwrite = TRUE)

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_4.5_2080_ensemble_pnw <- crop(UK_4.5_2080s_ensemble, ext_pnw)
UK_4.5_2080_ensemble_mv <- crop(UK_4.5_2080s_ensemble, ext_mv)
plot(UK_4.5_2080_ensemble_pnw)
plot(UK_4.5_2080_ensemble_mv)
writeRaster(UK_4.5_2080_ensemble_pnw, filename = "UK_4.5_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(UK_4.5_2080_ensemble_mv, filename = "UK_4.5_2080_ensemble_mv.tif", overwrite = TRUE)


### MRI 4.5 2080s ### - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MRI_4.5_2080.tif")
DD_0 <- raster("DD_0_MRI_4.5_2080.tif")
DD18 <- raster("DD18_MRI_4.5_2080.tif")
RH <- raster("RH_MRI_4.5_2080.tif")
PPT_wt <- raster("PPT_wt_MRI_4.5_2080.tif")
PPT_sm <- raster("PPT_sm_MRI_4.5_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MRI_4.5_2080_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MRI_4.5_2080_variables) <- names(myExpl) # names need to match

MRI_4.5_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MRI_4.5_2080_variables,
                                             proj.name = "MRI_4.5_2080",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MRI_4.5_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MRI_4.5_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MRI_4.5_2080/individual_projections")
MRI_4.5_2080s_ensemble <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MRI_4.5_2080s_ensemble)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MRI_4.5_2080s_ensemble, filename = "MRI_4.5_2080_ensemble.tif", overwrite = TRUE)

MRI_4.5_2080_ensemble_pnw <- crop(MRI_4.5_2080s_ensemble, ext_pnw)
MRI_4.5_2080_ensemble_mv <- crop(MRI_4.5_2080s_ensemble, ext_mv)
plot(MRI_4.5_2080_ensemble_pnw)
plot(MRI_4.5_2080_ensemble_mv)
writeRaster(MRI_4.5_2080_ensemble_pnw, filename = "MRI_4.5_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MRI_4.5_2080_ensemble_mv, filename = "MRI_4.5_2080_ensemble_mv.tif", overwrite = TRUE)


### MPI 4.5 2080s ### DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MPI_4.5_2080.tif")
DD_0 <- raster("DD_0_MPI_4.5_2080.tif")
DD18 <- raster("DD18_MPI_4.5_2080.tif")
RH <- raster("RH_MPI_4.5_2080.tif")
PPT_wt <- raster("PPT_wt_MPI_4.5_2080.tif")
PPT_sm <- raster("PPT_sm_MPI_4.5_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MPI_4.5_2080_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MPI_4.5_2080_variables) <- names(myExpl) # names need to match

MPI_4.5_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MPI_4.5_2080_variables,
                                             proj.name = "MPI_4.5_2080",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MPI_4.5_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MPI_4.5_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MPI_4.5_2080/individual_projections")
MPI_4.5_2080s_ensemble <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MPI_4.5_2080s_ensemble)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MPI_4.5_2080s_ensemble, filename = "MPI_4.5_2080_ensemble.tif", overwrite = TRUE)

MPI_4.5_2080_ensemble_pnw <- crop(MPI_4.5_2080s_ensemble, ext_pnw)
MPI_4.5_2080_ensemble_mv <- crop(MPI_4.5_2080s_ensemble, ext_mv)
plot(MPI_4.5_2080_ensemble_pnw)
plot(MPI_4.5_2080_ensemble_mv)
writeRaster(MPI_4.5_2080_ensemble_pnw, filename = "MPI_4.5_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MPI_4.5_2080_ensemble_mv, filename = "MPI_4.5_2080_ensemble_mv.tif", overwrite = TRUE)

# ensemble of GCMs
setwd("~/R_projects/MastersProject/Geranium.lucidum")
# scenario 4.5 2080s
MPI_4.5_2080 <- raster("MPI_4.5_2080_ensemble_pnw.tif")
MRI_4.5_2080 <- raster("MRI_4.5_2080_ensemble_pnw.tif")
UK_4.5_2080 <- raster("UK_4.5_2080_ensemble_pnw.tif")

all_4.5_2080 <- raster::stack(MPI_4.5_2080, MRI_4.5_2080, UK_4.5_2080)

ensemble_4.5_2080 <- calc(all_4.5_2080, fun = mean, 
                          filename = 'ensemble_4.5_2080.tif', 
                          overwrite = TRUE)

plot(ensemble_4.5_2080)

################ 7.0 2050s #################

# UK 7.0 2050s - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_UK_7.0_2050.tif")
DD_0 <- raster("DD_0_UK_7.0_2050.tif")
DD18 <- raster("DD18_UK_7.0_2050.tif")
RH <- raster("RH_UK_7.0_2050.tif")
PPT_wt <- raster("PPT_wt_UK_7.0_2050.tif")
PPT_sm <- raster("PPT_sm_UK_7.0_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_7.0_2050_variables <- stack(SHM, DD_0, DD18, 
                               RH, PPT_wt, 
                               PPT_sm, cropland, grassland, 
                               shrub, herb_veg, water_bodies, HII)

names(UK_7.0_2050_variables) <- names(myExpl) # new, try this

UK_7.0_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                            new.env = UK_7.0_2050_variables,
                                            proj.name = "UK_7.0_2050",
                                            selected.models = 'all',
                                            binary.meth = 'TSS',
                                            compress = 'xz',
                                            clamping.mask = F,
                                            output.format = '.grd')

UK_7.0_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                   projection.output = UK_7.0_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_UK_7.0_2050/individual_projections")
UK_7.0_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(UK_7.0_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(UK_7.0_2050_ensemble_climate, filename = "UK_7.0_2050_ensemble.tif", overwrite = TRUE)

UK_7.0_2050_ensemble_pnw <- crop(UK_7.0_2050_ensemble_climate, ext_pnw)
UK_7.0_2050_ensemble_mv <- crop(UK_7.0_2050_ensemble_climate, ext_mv)
plot(UK_7.0_2050_ensemble_pnw)
plot(UK_7.0_2050_ensemble_mv)
writeRaster(UK_7.0_2050_ensemble_pnw, filename = "UK_7.0_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(UK_7.0_2050_ensemble_mv, filename = "UK_7.0_2050_ensemble_mv.tif", overwrite = TRUE)


### MRI 7.0 2050s ### - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MRI_7.0_2050.tif")
DD_0 <- raster("DD_0_MRI_7.0_2050.tif")
DD18 <- raster("DD18_MRI_7.0_2050.tif")
RH <- raster("RH_MRI_7.0_2050.tif")
PPT_wt <- raster("PPT_wt_MRI_7.0_2050.tif")
PPT_sm <- raster("PPT_sm_MRI_7.0_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MRI_7.0_2050_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MRI_7.0_2050_variables) <- names(myExpl) # names need to match

MRI_7.0_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MRI_7.0_2050_variables,
                                             proj.name = "MRI_7.0_2050",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MRI_7.0_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MRI_7.0_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MRI_7.0_2050/individual_projections")
MRI_7.0_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MRI_7.0_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MRI_7.0_2050_ensemble_climate, filename = "MRI_7.0_2050_ensemble.tif", overwrite = TRUE)

MRI_7.0_2050_ensemble_pnw <- crop(MRI_7.0_2050_ensemble_climate, ext_pnw)
MRI_7.0_2050_ensemble_mv <- crop(MRI_7.0_2050_ensemble_climate, ext_mv)
plot(MRI_7.0_2050_ensemble_pnw)
plot(MRI_7.0_2050_ensemble_mv)
writeRaster(MRI_7.0_2050_ensemble_pnw, filename = "MRI_7.0_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MRI_7.0_2050_ensemble_mv, filename = "MRI_7.0_2050_ensemble_mv.tif", overwrite = TRUE)


### MPI 7.0 2050s ### - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MPI_7.0_2050.tif")
DD_0 <- raster("DD_0_MPI_7.0_2050.tif")
DD18 <- raster("DD18_MPI_7.0_2050.tif")
RH <- raster("RH_MPI_7.0_2050.tif")
PPT_wt <- raster("PPT_wt_MPI_7.0_2050.tif")
PPT_sm <- raster("PPT_sm_MPI_7.0_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MPI_7.0_2050_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MPI_7.0_2050_variables) <- names(myExpl) # names need to match

MPI_7.0_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MPI_7.0_2050_variables,
                                             proj.name = "MPI_7.0_2050",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MPI_7.0_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MPI_7.0_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MPI_7.0_2050/individual_projections")
MPI_7.0_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MPI_7.0_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MPI_7.0_2050_ensemble_climate, filename = "MPI_7.0_2050_ensemble.tif", overwrite = TRUE)

MPI_7.0_2050_ensemble_pnw <- crop(MPI_7.0_2050_ensemble_climate, ext_pnw)
MPI_7.0_2050_ensemble_mv <- crop(MPI_7.0_2050_ensemble_climate, ext_mv)
plot(MPI_7.0_2050_ensemble_pnw)
plot(MPI_7.0_2050_ensemble_mv)
writeRaster(MPI_7.0_2050_ensemble_pnw, filename = "MPI_7.0_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MPI_7.0_2050_ensemble_mv, filename = "MPI_7.0_2050_ensemble_mv.tif", overwrite = TRUE)

# ensemble of GCMs 
setwd("~/R_projects/MastersProject/Geranium.lucidum")
# scenario 7.0 2050s
MPI_7.0_2050 <- raster("MPI_7.0_2050_ensemble_pnw.tif")
MRI_7.0_2050 <- raster("MRI_7.0_2050_ensemble_pnw.tif")
UK_7.0_2050 <- raster("UK_7.0_2050_ensemble_pnw.tif")

all_7.0_2050 <- raster::stack(MPI_7.0_2050, MRI_7.0_2050, UK_7.0_2050)

ensemble_7.0_2050 <- calc(all_7.0_2050, fun = mean, 
                          filename = 'ensemble_7.0_2050.tif', 
                          overwrite = TRUE)

plot(ensemble_7.0_2050)


################ 7.0 2080s #####################

# UK 7.0 2080s - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_UK_7.0_2080.tif")
DD_0 <- raster("DD_0_UK_7.0_2080.tif")
DD18 <- raster("DD18_UK_7.0_2080.tif")
RH <- raster("RH_UK_7.0_2080.tif")
PPT_wt <- raster("PPT_wt_UK_7.0_2080.tif")
PPT_sm <- raster("PPT_sm_UK_7.0_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_7.0_2080_variables <- stack(SHM, DD_0, DD18, 
                               RH, PPT_wt, 
                               PPT_sm, cropland, grassland, 
                               shrub, herb_veg, water_bodies, HII)

names(UK_7.0_2080_variables) <- names(myExpl) # new, try this

UK_7.0_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                            new.env = UK_7.0_2080_variables,
                                            proj.name = "UK_7.0_2080",
                                            selected.models = 'all',
                                            binary.meth = 'TSS',
                                            compress = 'xz',
                                            clamping.mask = F,
                                            output.format = '.grd')

UK_7.0_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                   projection.output = UK_7.0_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_UK_7.0_2080/individual_projections")
UK_7.0_2080_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(UK_7.0_2080_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(UK_7.0_2080_ensemble_climate, filename = "UK_7.0_2080_ensemble.tif", overwrite = TRUE)

UK_7.0_2080_ensemble_pnw <- crop(UK_7.0_2080_ensemble_climate, ext_pnw)
UK_7.0_2080_ensemble_mv <- crop(UK_7.0_2080_ensemble_climate, ext_mv)
plot(UK_7.0_2080_ensemble_pnw)
plot(UK_7.0_2080_ensemble_mv)
writeRaster(UK_7.0_2080_ensemble_pnw, filename = "UK_7.0_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(UK_7.0_2080_ensemble_mv, filename = "UK_7.0_2080_ensemble_mv.tif", overwrite = TRUE)


### MRI 7.0 2080s ### - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MRI_7.0_2080.tif")
DD_0 <- raster("DD_0_MRI_7.0_2080.tif")
DD18 <- raster("DD18_MRI_7.0_2080.tif")
RH <- raster("RH_MRI_7.0_2080.tif")
PPT_wt <- raster("PPT_wt_MRI_7.0_2080.tif")
PPT_sm <- raster("PPT_sm_MRI_7.0_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MRI_7.0_2080_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MRI_7.0_2080_variables) <- names(myExpl) # names need to match

MRI_7.0_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MRI_7.0_2080_variables,
                                             proj.name = "MRI_7.0_2080",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MRI_7.0_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MRI_7.0_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MRI_7.0_2080/individual_projections")
MRI_7.0_2080_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MRI_7.0_2080_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MRI_7.0_2080_ensemble_climate, filename = "MRI_7.0_2080_ensemble.tif", overwrite = TRUE)

MRI_7.0_2080_ensemble_pnw <- crop(MRI_7.0_2080_ensemble_climate, ext_pnw)
MRI_7.0_2080_ensemble_mv <- crop(MRI_7.0_2080_ensemble_climate, ext_mv)
plot(MRI_7.0_2080_ensemble_pnw)
plot(MRI_7.0_2080_ensemble_mv)
writeRaster(MRI_7.0_2080_ensemble_pnw, filename = "MRI_7.0_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MRI_7.0_2080_ensemble_mv, filename = "MRI_7.0_2080_ensemble_mv.tif", overwrite = TRUE)


### MPI 7.0 2080s ### - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MPI_7.0_2080.tif")
DD_0 <- raster("DD_0_MPI_7.0_2080.tif")
DD18 <- raster("DD18_MPI_7.0_2080.tif")
RH <- raster("RH_MPI_7.0_2080.tif")
PPT_wt <- raster("PPT_wt_MPI_7.0_2080.tif")
PPT_sm <- raster("PPT_sm_MPI_7.0_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MPI_7.0_2080_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MPI_7.0_2080_variables) <- names(myExpl) # names need to match

MPI_7.0_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MPI_7.0_2080_variables,
                                             proj.name = "MPI_7.0_2080",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MPI_7.0_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MPI_7.0_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MPI_7.0_2080/individual_projections")
MPI_7.0_2080_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MPI_7.0_2080_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MPI_7.0_2080_ensemble_climate, filename = "MPI_7.0_2080_ensemble.tif", overwrite = TRUE)

MPI_7.0_2080_ensemble_pnw <- crop(MPI_7.0_2080_ensemble_climate, ext_pnw)
MPI_7.0_2080_ensemble_mv <- crop(MPI_7.0_2080_ensemble_climate, ext_mv)
plot(MPI_7.0_2080_ensemble_pnw)
plot(MPI_7.0_2080_ensemble_mv)
writeRaster(MPI_7.0_2080_ensemble_pnw, filename = "MPI_7.0_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MPI_7.0_2080_ensemble_mv, filename = "MPI_7.0_2080_ensemble_mv.tif", overwrite = TRUE)

# ensemble of GCMs 
setwd("~/R_projects/MastersProject/Geranium.lucidum")
# scenario 7.0 2080s
MPI_7.0_2080 <- raster("MPI_7.0_2080_ensemble_pnw.tif")
MRI_7.0_2080 <- raster("MRI_7.0_2080_ensemble_pnw.tif")
UK_7.0_2080 <- raster("UK_7.0_2080_ensemble_pnw.tif")

all_7.0_2080 <- raster::stack(MPI_7.0_2080, MRI_7.0_2080, UK_7.0_2080)

ensemble_7.0_2080 <- calc(all_7.0_2080, fun = mean, 
                          filename = 'ensemble_7.0_2080.tif', 
                          overwrite = TRUE)

plot(ensemble_7.0_2080)


################ 8.5 2050s ####################

### MRI 8.5 2050s ### - 
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MRI_8.5_2050.tif")
DD_0 <- raster("DD_0_MRI_8.5_2050.tif")
DD18 <- raster("DD18_MRI_8.5_2050.tif")
RH <- raster("RH_MRI_8.5_2050.tif")
PPT_wt <- raster("PPT_wt_MRI_8.5_2050.tif")
PPT_sm <- raster("PPT_sm_MRI_8.5_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MRI_8.5_2050_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MRI_8.5_2050_variables) <- names(myExpl) # names need to match

MRI_8.5_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MRI_8.5_2050_variables,
                                             proj.name = "MRI_8.5_2050",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MRI_8.5_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MRI_8.5_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MRI_8.5_2050/individual_projections")
MRI_8.5_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MRI_8.5_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MRI_8.5_2050_ensemble_climate, filename = "MRI_8.5_2050_ensemble.tif", overwrite = TRUE)

MRI_8.5_2050_ensemble_pnw <- crop(MRI_8.5_2050_ensemble_climate, ext_pnw)
MRI_8.5_2050_ensemble_mv <- crop(MRI_8.5_2050_ensemble_climate, ext_mv)
plot(MRI_8.5_2050_ensemble_pnw)
plot(MRI_8.5_2050_ensemble_mv)
writeRaster(MRI_8.5_2050_ensemble_pnw, filename = "MRI_8.5_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MRI_8.5_2050_ensemble_mv, filename = "MRI_8.5_2050_ensemble_mv.tif", overwrite = TRUE)

### MPI 8.5 2050s ### - 
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MPI_8.5_2050.tif")
DD_0 <- raster("DD_0_MPI_8.5_2050.tif")
DD18 <- raster("DD18_MPI_8.5_2050.tif")
RH <- raster("RH_MPI_8.5_2050.tif")
PPT_wt <- raster("PPT_wt_MPI_8.5_2050.tif")
PPT_sm <- raster("PPT_sm_MPI_8.5_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MPI_8.5_2050_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MPI_8.5_2050_variables) <- names(myExpl) # new, try this

MPI_8.5_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MPI_8.5_2050_variables,
                                             proj.name = "MPI_8.5_2050",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MPI_8.5_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MPI_8.5_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MPI_8.5_2050/individual_projections")
MPI_8.5_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MPI_8.5_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MPI_8.5_2050_ensemble_climate, filename = "MPI_8.5_2050_ensemble.tif", overwrite = TRUE)

MPI_8.5_2050_ensemble_climate_pnw <- crop(MPI_8.5_2050_ensemble_climate, ext_pnw)
MPI_8.5_2050_ensemble_climate_mv <- crop(MPI_8.5_2050_ensemble_climate, ext_mv)
plot(MPI_8.5_2050_ensemble_climate_pnw)
plot(MPI_8.5_2050_ensemble_climate_mv)
writeRaster(MPI_8.5_2050_ensemble_climate_pnw, filename = "MPI_8.5_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MPI_8.5_2050_ensemble_climate_mv, filename = "MPI_8.5_2050_ensemble_mv.tif", overwrite = TRUE)

### UK 8.5 2050s ### - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_UK_8.5_2050.tif")
DD_0 <- raster("DD_0_UK_8.5_2050.tif")
DD18 <- raster("DD18_UK_8.5_2050.tif")
RH <- raster("RH_UK_8.5_2050.tif")
PPT_wt <- raster("PPT_wt_UK_8.5_2050.tif")
PPT_sm <- raster("PPT_sm_UK_8.5_2050.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_8.5_2050_variables <- stack(SHM, DD_0, DD18, 
                               RH, PPT_wt, 
                               PPT_sm, cropland, grassland, 
                               shrub, herb_veg, water_bodies, HII)

names(UK_8.5_2050_variables) <- names(myExpl) # new, try this

UK_8.5_2050_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                            new.env = UK_8.5_2050_variables,
                                            proj.name = "UK_8.5_2050",
                                            selected.models = 'all',
                                            binary.meth = 'TSS',
                                            compress = 'xz',
                                            clamping.mask = F,
                                            output.format = '.grd')

UK_8.5_2050_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                   projection.output = UK_8.5_2050_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_UK_8.5_2050/individual_projections")
UK_8.5_2050_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(UK_8.5_2050_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(UK_8.5_2050_ensemble_climate, filename = "UK_8.5_2050_ensemble.tif", overwrite = TRUE)

UK_8.5_2050_ensemble_pnw <- crop(UK_8.5_2050_ensemble_climate, ext_pnw)
UK_8.5_2050_ensemble_mv <- crop(UK_8.5_2050_ensemble_climate, ext_mv)
plot(UK_8.5_2050_ensemble_pnw)
plot(UK_8.5_2050_ensemble_mv)
writeRaster(UK_8.5_2050_ensemble_pnw, filename = "UK_8.5_2050_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(UK_8.5_2050_ensemble_mv, filename = "UK_8.5_2050_ensemble_mv.tif", overwrite = TRUE)

# ensemble of GCMs
MPI_8.5_2050 <- raster("MPI_8.5_2050_ensemble_pnw.tif")
MRI_8.5_2050 <- raster("MRI_8.5_2050_ensemble_pnw.tif")
UK_8.5_2050 <- raster("UK_8.5_2050_ensemble_pnw.tif")

all_8.5_2050 <- raster::stack(MPI_8.5_2050, MRI_8.5_2050, UK_8.5_2050)

ensemble_8.5_2050 <- calc(all_8.5_2050, fun = mean,  
                          filename = 'ensemble_8.5_2050.tif', 
                          overwrite = TRUE)

plot(ensemble_8.5_2050)

################# 8.5 2080s ################

### MPI 8.5 2080s ### - 
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MPI_8.5_2080.tif")
DD_0 <- raster("DD_0_MPI_8.5_2080.tif")
DD18 <- raster("DD18_MPI_8.5_2080.tif")
RH <- raster("RH_MPI_8.5_2080.tif")
PPT_wt <- raster("PPT_wt_MPI_8.5_2080.tif")
PPT_sm <- raster("PPT_sm_MPI_8.5_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MPI_8.5_2080_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MPI_8.5_2080_variables) <- names(myExpl) # new, try this

MPI_8.5_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MPI_8.5_2080_variables,
                                             proj.name = "MPI_8.5_2080",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MPI_8.5_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MPI_8.5_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MPI_8.5_2080/individual_projections")
MPI_8.5_2080_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MPI_8.5_2080_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MPI_8.5_2080_ensemble_climate, filename = "MPI_8.5_2080_ensemble_climate.tif", overwrite = TRUE)

MPI_8.5_2080_ensemble_climate_pnw <- crop(MPI_8.5_2080_ensemble_climate, ext_pnw)
MPI_8.5_2080_ensemble_climate_mv <- crop(MPI_8.5_2080_ensemble_climate, ext_mv)
plot(MPI_8.5_2080_ensemble_climate_pnw)
plot(MPI_8.5_2080_ensemble_climate_mv)
writeRaster(MPI_8.5_2080_ensemble_climate_pnw, filename = "MPI_8.5_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MPI_8.5_2080_ensemble_climate_mv, filename = "MPI_8.5_2080_ensemble_mv.tif", overwrite = TRUE)


### MRI 8.5 2080s ### - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_MRI_8.5_2080.tif")
DD_0 <- raster("DD_0_MRI_8.5_2080.tif")
DD18 <- raster("DD18_MRI_8.5_2080.tif")
RH <- raster("RH_MRI_8.5_2080.tif")
PPT_wt <- raster("PPT_wt_MRI_8.5_2080.tif")
PPT_sm <- raster("PPT_sm_MRI_8.5_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
MRI_8.5_2080_variables <- stack(SHM, DD_0, DD18, 
                                RH, PPT_wt, 
                                PPT_sm, cropland, grassland, 
                                shrub, herb_veg, water_bodies, HII)

names(MRI_8.5_2080_variables) <- names(myExpl) # new, try this

MRI_8.5_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                             new.env = MRI_8.5_2080_variables,
                                             proj.name = "MRI_8.5_2080",
                                             selected.models = 'all',
                                             binary.meth = 'TSS',
                                             compress = 'xz',
                                             clamping.mask = F,
                                             output.format = '.grd')

MRI_8.5_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                    projection.output = MRI_8.5_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_MRI_8.5_2080/individual_projections")
MRI_8.5_2080_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(MRI_8.5_2080_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(MRI_8.5_2080_ensemble_climate, filename = "MRI_8.5_2080_ensemble.tif", overwrite = TRUE)

MRI_8.5_2080_ensemble_pnw <- crop(MRI_8.5_2080_ensemble_climate, ext_pnw)
MRI_8.5_2080_ensemble_mv <- crop(MRI_8.5_2080_ensemble_climate, ext_mv)
plot(MRI_8.5_2080_ensemble_pnw)
plot(MRI_8.5_2080_ensemble_mv)
writeRaster(MRI_8.5_2080_ensemble_pnw, filename = "MRI_8.5_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(MRI_8.5_2080_ensemble_mv, filename = "MRI_8.5_2080_ensemble_mv.tif", overwrite = TRUE)


### UK 8.5 2080s ### - DONE
setwd("D:/MastersProject/Formatted variables")

SHM <- raster("SHM_UK_8.5_2080.tif")
DD_0 <- raster("DD_0_UK_8.5_2080.tif")
DD18 <- raster("DD18_UK_8.5_2080.tif")
RH <- raster("RH_UK_8.5_2080.tif")
PPT_wt <- raster("PPT_wt_UK_8.5_2080.tif")
PPT_sm <- raster("PPT_sm_UK_8.5_2080.tif")

# crop variables
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

setwd("~/R_projects/MastersProject/Geranium.lucidum")
UK_8.5_2080_variables <- stack(SHM, DD_0, DD18, 
                               RH, PPT_wt, 
                               PPT_sm, cropland, grassland, 
                               shrub, herb_veg, water_bodies, HII)

names(UK_8.5_2080_variables) <- names(myExpl) # new, try this

UK_8.5_2080_projection <- BIOMOD_Projection(modeling.output = geranium_model_out,
                                            new.env = UK_8.5_2080_variables,
                                            proj.name = "UK_8.5_2080",
                                            selected.models = 'all',
                                            binary.meth = 'TSS',
                                            compress = 'xz',
                                            clamping.mask = F,
                                            output.format = '.grd')

UK_8.5_2080_ensemble <- BIOMOD_EnsembleForecasting(EM.output = geranium_em, 
                                                   projection.output = UK_8.5_2080_projection)

ext_pnw <- extent(-129, -117, 42, 51) # pacific north west coordinates
ext_mv <- extent(-124, -121, 49, 50) # metro vancouver coordinates

setwd("~/R_projects/MastersProject/Geranium.lucidum/Geranium.lucidum/proj_UK_8.5_2080/individual_projections")
UK_8.5_2080_ensemble_climate <- raster::stack("Geranium.lucidum_EMwmeanByTSS_mergedAlgo_mergedRun_mergedData.grd")
plot(UK_8.5_2080_ensemble_climate)
setwd("~/R_projects/MastersProject/Geranium.lucidum")
writeRaster(UK_8.5_2080_ensemble_climate, filename = "UK_8.5_2080_ensemble.tif", overwrite = TRUE)

UK_8.5_2080_ensemble_pnw <- crop(UK_8.5_2080_ensemble_climate, ext_pnw)
UK_8.5_2080_ensemble_mv <- crop(UK_8.5_2080_ensemble_climate, ext_mv)
plot(UK_8.5_2080_ensemble_pnw)
plot(UK_8.5_2080_ensemble_mv)
writeRaster(UK_8.5_2080_ensemble_pnw, filename = "UK_8.5_2080_ensemble_pnw.tif", overwrite = TRUE)
writeRaster(UK_8.5_2080_ensemble_mv, filename = "UK_8.5_2080_ensemble_mv.tif", overwrite = TRUE)

# ensemble of GCMs
MPI_8.5_2080 <- raster("MPI_8.5_2080_ensemble_pnw.tif")
MRI_8.5_2080 <- raster("MRI_8.5_2080_ensemble_pnw.tif")
UK_8.5_2080 <- raster("UK_8.5_2080_ensemble_pnw.tif")

all_8.5_2080 <- raster::stack(MPI_8.5_2080, MRI_8.5_2080, UK_8.5_2080)

ensemble_8.5_2080 <- calc(all_8.5_2080, fun = mean,  
                          filename = 'ensemble_8.5_2080.tif', 
                          overwrite = TRUE)

plot(ensemble_8.5_2080)

########## Plotting all rasters ################

setwd("~/R_projects/MastersProject/Geranium.lucidum")

current_projection <- raster("geranium_current_ensemble.tif")
current_projection <- crop(current_projection, ext_mv)

ensemble_4.5_2050 <- raster("ensemble_4.5_2050.tif")
ensemble_7.0_2050 <- raster("ensemble_7.0_2050.tif")
ensemble_8.5_2050 <- raster("ensemble_8.5_2050.tif")

ensemble_4.5_2080 <- raster("ensemble_4.5_2080.tif")
ensemble_7.0_2080 <- raster("ensemble_7.0_2080.tif")
ensemble_8.5_2080 <- raster("ensemble_8.5_2080.tif")

all_GL_GCMS <- raster::stack(ensemble_4.5_2050, ensemble_7.0_2050, ensemble_8.5_2050, 
                             ensemble_4.5_2080, ensemble_7.0_2080, ensemble_8.5_2080)

plot(all_GL_GCMS)

library(PNWColors)
shuksan <- pnw_palette(name = "Shuksan2", n = 5, type = "discrete")

# range size 4.5 2050
range_current_4.5_2050 <- BIOMOD_RangeSize(current_projection, 
                                           ensemble_4.5_2050)
range_current_4.5_2050$Compt.By.Models

# 4.5 2080
range_current_4.5_2080 <- BIOMOD_RangeSize(current_projection, 
                                           ensemble_4.5_2080)
range_current_4.5_2080$Compt.By.Models

# range histogram
range_hist_4.5_2050 <- hist(range_current_4.5_2050$Diff.By.Pixel, 
                            breaks = 4)
plot(range_current_4.5_2050$Diff.By.Pixel, 
     breaks = c(-1500, -1000, -500, 0, 500), 
     col = shuksan)
# map
GL_range_change_map <- stack(range_current_4.5_2050$Diff.By.Pixel, 
                             range_current_4.5_2080$Diff.By.Pixel)
names(GL_range_change_map) <- c("current-2050", "current-2080")
my.at <- seq(-2.5, 1.5, 1)
myColourKey <- list(at = my.at, 
                    labels = list(labels = c("lost", "pres", "abs", "gain"), 
                                  at = my.at[-1] - 0.5)
                    )
rasterVis::levelplot(
  GL_range_change_map, 
  main = "Geranium lucidum range change", 
  colorkey = myColourKey, 
  col.regions = c('#f03b20', '#99d8c9', '#f0f0f0', '#2ca25f'), 
  layout = c(1, 1)
)