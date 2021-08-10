install.packages("devtools")
install.packages("CoordinateCleaner")
install.packages("countrycode")
install.packages("rnaturalearthdata")

library(rgbif)
library(scrubr)
library(maps)
library(dplyr)
library(sp)
library(maptools)
library(rgdal)
library(countrycode)
library(CoordinateCleaner)
library(corrplot)
library(ggplot2)
library(devtools)
library(FactoMineR)
library(factoextra)
library(readr)
library(gridExtra)
library(tidyverse)

hyacinth_tv_train <- hyacinth_test_variables%>%
  filter(between(year, 1970, 2000)) 

hyacinth_tv_test <- hyacinth_test_variables%>%
  filter(between(year, 2001, 2020))


## For training data ##
hyacinth_tv_train <- subset(hyacinth_tv_train, select = -c(field_1, field_1_1, species, issues, countryCod, 
                                                           occurrence, coordinate, institutio, gbifID, references, 
                                                           basisOfRec, year, month, day, eventDate, geodeticDa))
hyacinth_train_var <- subset(hyacinth_tv_train, select = -c(decimallon, decimallat))

WH.cor.train <- cor(hyacinth_train_var, method = "pearson", use = "pairwise.complete.obs")
corrplot(WH.cor.train, is.corr = FALSE, method = "square", add = FALSE)

pearson.dist <- as.dist(1 - WH.cor.train)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree, main = "Hyacinth Variable Correlation (Train)")
abline(h = 0.7, col = "red", lty = 5)
plot(pearson.tree, main = "Hyacinth Variable Correlation (Train)")
abline(h = 0.3, col = "red", lty = 5)



## For testing data ##
hyacinth_tv_test <- subset(hyacinth_tv_test, select = -c(field_1, fid, SciName, issues, countryCod, 
                                                         occurrence, coordinate, institutio, references, 
                                                         basisOfRec, year, month, day, eventDate, geodeticDa))
hyacinth_test_var <- subset(hyacinth_tv_test, select = -c(decimallon, decimallat))

WH.cor.test <- cor(hyacinth_tv_test, method = "pearson", use = "pairwise.complete.obs")
corrplot(WH.cor.test, is.corr = FALSE, method = "square", add = FALSE)

pearson.dist <- as.dist(1 - WH.cor.test)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree, main = "Hyacinth Variable Correlation (Test)")
abline(h = 0.7, col = "red", lty = 5)
plot(pearson.tree, main = "Hyacinth Variable Correlation (Test)")
abline(h = 0.3, col = "red", lty = 5)
