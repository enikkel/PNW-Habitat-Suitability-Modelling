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

geranium_tv_train <- geranium_train_variables%>%
  filter(between(year, 1970, 2000)) 

geranium_tv_test <- geranium_test_variables%>%
  filter(between(year, 2001, 2020))


## For training data ##
geranium_tv_train <- subset(geranium_tv_train, select = -c(field_1, fid, SciName, issues, countryCod, 
                                                                  occurrence, coordinate, institutio, references, 
                                                                  basisOfRec, year, month, day, eventDate, geodeticDa))
geranium_train_var <- subset(geranium_tv_train, select = -c(decimallon, decimallat))

SG.cor.train <- cor(geranium_train_var, method = "pearson", use = "pairwise.complete.obs")
corrplot(SG.cor.train, is.corr = FALSE, method = "square", add = FALSE)

pearson.dist <- as.dist(1 - SG.cor.train)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree, main = "Geranium Variable Correlation (Train)")
abline(h = 0.7, col = "red", lty = 5)
plot(pearson.tree, main = "Geranium Variable Correlation (Train)")
abline(h = 0.3, col = "red", lty = 5)



## For testing data ##
geranium_tv_test <- subset(geranium_tv_test, select = -c(field_1, fid, SciName, issues, countryCod, 
                                                         occurrence, coordinate, institutio, references, 
                                                         basisOfRec, year, month, day, eventDate, geodeticDa))
geranium_test_var <- subset(geranium_tv_test, select = -c(decimallon, decimallat))

SG.cor.test <- cor(geranium_tv_test, method = "pearson", use = "pairwise.complete.obs")
corrplot(SG.cor.test, is.corr = FALSE, method = "square", add = FALSE)

pearson.dist <- as.dist(1 - SG.cor.test)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree, main = "Geranium Variable Correlation (Test)")
abline(h = 0.7, col = "red", lty = 5)
plot(pearson.tree, main = "Geranium Variable Correlation (Test)")
abline(h = 0.3, col = "red", lty = 5)
