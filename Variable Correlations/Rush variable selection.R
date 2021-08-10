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

umbellatus_tv_train <- umbellatus_test_variables%>%
  filter(between(year, 1970, 2000)) 

umbellatus_tv_test <- umbellatus_test_variables%>%
  filter(between(year, 2001, 2020))


## For training data ##
umbellatus_tv_train <- subset(umbellatus_tv_train, select = -c(field_1, field_1_1, species, issues, countryCod, individual,
                                                                 occurrence, coordinate, institutio, gbifID, references, 
                                                                 basisOfRec, year, month, day, eventDate, geodeticDa))
umbellatus_train_var <- subset(umbellatus_tv_train, select = -c(decimallon, decimallat))

FR.cor.train <- cor(umbellatus_train_var, method = "pearson", use = "pairwise.complete.obs")
corrplot(FR.cor.train, is.corr = FALSE, method = "square", add = FALSE)

pearson.dist <- as.dist(1 - FR.cor.train)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree, main = "Flowering Rush Variable Correlation (Train)")
abline(h = 0.7, col = "red", lty = 5)
plot(pearson.tree, main = "Flowering Rush Variable Correlation (Train)")
abline(h = 0.3, col = "red", lty = 5)



## For testing data ##
umbellatus_tv_test <- subset(umbellatus_tv_test, select = -c(field_1, field_1_1, species, issues, countryCod, individual,
                                                               occurrence, coordinate, institutio, gbifID, references, 
                                                               basisOfRec, year, month, day, eventDate, geodeticDa))
umbellatus_test_var <- subset(umbellatus_tv_test, select = -c(decimallon, decimallat))

FR.cor.test <- cor(umbellatus_tv_test, method = "pearson", use = "pairwise.complete.obs")
corrplot(FR.cor.test, is.corr = FALSE, method = "square", add = FALSE)

pearson.dist <- as.dist(1 - FR.cor.test)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree, main = "Flowering Rush Variable Correlation (Test)")
abline(h = 0.7, col = "red", lty = 5)
plot(pearson.tree, main = "Flowering Rush Variable Correlation (Test)")
abline(h = 0.3, col = "red", lty = 5)
