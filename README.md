GitHub repository associated with the masters thesis work entitled:

EFFECTS OF CLIMATE CHANGE ON THE HABITAT SUITABILITY OF 4 RELATIVELY NEW INVASIVE PLANT SPECIES IN THE PACIFIC NORTHWEST

by Emma K. Nikkel

University of British Columbia, 2022

***
Abstract:

Invasive species are a substantial threat to biodiversity and ecosystem structure. This threat is exacerbated by the increasingly concerning and urgent outlook of predicted climate change, land cover change, and other human influences. Specifically, an increasing number of invasive plant species are spreading in the Pacific Northwest (PNW), an area of unique natural areas, economic value, and increasing human population. Predicting the potential habitat suitability for invasive plant species that are not yet established in the region is crucial for developing preventative management strategies. To this end, I developed habitat suitability models for four invasive plant species, two terrestrial species: Geranium lucidum and Pilosella officinarum; and two aquatic species: Butomus umbellatus and Pontederia crassipes. I initially considered 33 bioclimatic variables, 10 land cover types, and a human influence index as current model predictor variables with location records for each species drawn from the introduced range (North America). I projected each species’ current habitat suitability in the PNW region using ensemble modelling of six algorithms to 2050 and 2080, under 3 potential future climate scenarios. The majority of the coastal PNW is predicted to remain potential habitat for Geranium lucidum under all future climate scenarios, with some loss of habitat suitability in Oregon. In contrast, Pilosella officinarum, while currently suited to most inland regions of the PNW, is predicted to lose suitable habitat by 2050 under all climate scenarios, retaining high elevations as potential habitat. The suitable habitat for Butomus umbellatus in the PNW, which is currently moderately suitable, is not predicted to increase substantially in the future. Likewise, potential future habitat suitability remains relatively unchanged for Pontederia crasipes, which is currently highly suitable for inland waterways that do not experience freezing temperatures. Overall, the bioclimatic variables and human influence index were more important than land cover variables, suggesting that climate change and human activity are the determining factors for changes in future suitable habitat. My research provides a template to model other concerning species, assisting local land managers and practitioners to inform current and future management strategies and increasing the efficiency of allocating limited resources toward species with expanding ranges.

***


This repo contains all R code to run the habitat suitability modelling for all species studied and can be used for additional species.

Methodolgy and R code for

  - species record cleaning 
  
  (Scripts > 'Species record cleaning example script.R')
  - formatting/reprojecting environmental variables

  (Scripts > 'Formatting_Rasters.R')
  - current climate model (including variable correlation analyses)

  (Scripts > 'GL_final_model_script.R')
  - future climate models (RCP 4.5, 7.0, and 8.5 for 2050 and 2080)

  (Scripts > 'GL_future_climates.R')

**
Additional files include

  - .csv files of cleaned species records used for modelling 
  
  (_Geranium lucidum_ = 'lucidum_fullclean.csv'; _Pilosella officinarum_ = 'hawkweed_fullclean.csv'; _Butomus umbellatus_ = 'umbellatus_fullclean.csv'; _Pontederia crassipes_ = 'hyacinth_fullclean.csv')
  - .xlsx file of common GBIF issue codes and descriptions
  - R script for downloading GBIF occurrences

  (Other helpful files > 'GBIF template using occ_search.R' and 'GBIF_cleaning_template.R'
  - R script for example species map making

  (Other helpful files > 'species_maps_script.R')
  - text file with detailed cleaning and map visualization methods
