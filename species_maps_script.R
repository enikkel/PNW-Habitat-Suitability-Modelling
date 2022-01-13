############### create species record maps ###################
install.packages(c("ggplot2", "devtools", "dplyr", "stringr"))
install.packages(c("maps", "mapdata", "ggmap"))

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

ext <- extent(-180, -40, 10, 90)

geranium <- read.csv("Geranium_NA_records.csv") # 564 records

wm <- borders("world", xlim = c(-180, -40), ylim = c(10, 90), colour="gray50", fill="gray50")
ggplot()+ coord_fixed()+ wm +
  geom_point(data = geranium, aes(x = decimallon, y = decimallat),
             colour = "darkred", size = 0.5)+
  theme_bw()

