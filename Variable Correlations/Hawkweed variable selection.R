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

officinarum_tv_train <- officinarum_test_variables%>%
  filter(between(year, 1970, 2000)) 

officinarum_tv_test <- officinarum_test_variables%>%
  filter(between(year, 2001, 2020))


## For training data ##
officinarum_tv_train <- subset(officinarum_tv_train, select = -c(field_1, field_1_1, species, issues, countryCod, individual,
                                                           occurrence, coordinate, institutio, gbifID, references, 
                                                           basisOfRec, year, month, day, eventDate, geodeticDa))
officinarum_train_var <- subset(officinarum_tv_train, select = -c(decimallon, decimallat))

MEH.cor.train <- cor(officinarum_train_var, method = "pearson", use = "pairwise.complete.obs")
corrplot(MEH.cor.train, is.corr = FALSE, method = "square", add = FALSE)

pearson.dist <- as.dist(1 - MEH.cor.train)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree, main = "Mouse-Ear Hawkweed Variable Correlation (Train)")
abline(h = 0.7, col = "red", lty = 5)
plot(pearson.tree, main = "Mouse-ear Hawkweed Variable Correlation (Train)")
abline(h = 0.3, col = "red", lty = 5)



## For testing data ##
officinarum_tv_test <- subset(officinarum_tv_test, select = -c(field_1, field_1_1, species, issues, countryCod, individual,
                                                         occurrence, coordinate, institutio, gbifID, references, 
                                                         basisOfRec, year, month, day, eventDate, geodeticDa))
officinarum_test_var <- subset(officinarum_tv_test, select = -c(decimallon, decimallat))

MEH.cor.test <- cor(officinarum_tv_test, method = "pearson", use = "pairwise.complete.obs")
corrplot(MEH.cor.test, is.corr = FALSE, method = "square", add = FALSE)

pearson.dist <- as.dist(1 - MEH.cor.test)
pearson.tree <- hclust(pearson.dist, method="complete")
plot(pearson.tree, main = "Mouse-Ear Hawkweed Variable Correlation (Test)")
abline(h = 0.7, col = "red", lty = 5)
plot(pearson.tree, main = "Mouse-Ear Hawkweed Variable Correlation (Test)")
abline(h = 0.3, col = "red", lty = 5)
