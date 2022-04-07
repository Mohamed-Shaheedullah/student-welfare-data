#Clear the memory
rm(list=ls())
#Load some important packages
library(maps)
library(mapdata)
library(maptools)
library(rgdal)
library(ggmap)
library(ggplot2)
library(rgeos)
library(broom)
library(plyr)
#Load the shape file - make sure you change the file path to where you saved the shape files
# version
# install.packages("broom", type="binary")
shapefile <- readOGR(dsn="C:/Users/conif/OneDrive/Documents/R/Maps_Shape/NUTS_Level_2_(January_2018)_Boundaries", layer="NUTS_Level_2_(January_2018)_Boundaries")
#Reshape for ggplot2 using the Broom package
mapdata <- tidy(shapefile, region="nuts218nm") #This might take a few minutes
# mapdata <- tidy(shapefile, region = "nuts218nm")
#Check the shape file has loaded correctly by plotting an outline map of the UK
#gg <- ggplot() + geom_polygon(data = mapdata, aes(x = long, y = lat, group = group), color = "#FFFFFF", size = 0.25)
#gg <- gg + coord_fixed(1) #This gives the map a 1:1 aspect ratio to prevent the map from appearing squashed
#print(gg)
#Create some data to use in the heatmap - here we are creating a random "value" for each county (by id)

# mydata <- read.csv("C:/Users/conif/OneDrive/Documents/R/Maps_Shape/resid_grouped.csv", header = TRUE)
mydata <- read.csv("C:/Users/conif/OneDrive/Documents/R/Maps_Shape/student_mapping_completed.csv", header = TRUE)

# mydata <- data.frame(id=unique(mapdata$id), value=sample(c(0:100), length(unique(mapdata$id)), replace = TRUE))
#Join mydata with mapdata
df <- join(mapdata, mydata, by="id")
#
#
#Create the heatmap using the ggplot2 package
#
#png("pgrad.png")
gg <- ggplot() + geom_polygon(data = df, aes(x = long, y = lat, group = group, fill = value), color = "#FFFFFF", size = .3)
gg <- gg + scale_fill_gradient2(low = "blue", mid = "red", high = "yellow", na.value = "white")
gg <- gg + coord_fixed(1)
gg <- gg + guides(fill=guide_legend(title="Legend"))
gg <- gg + ggtitle("Residual Income Estimate") # added line --------
gg <- gg + theme_minimal()
gg <- gg + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), legend.position = 'right')
gg <- gg + theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank())
gg <- gg + theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())
gg<- gg + theme(panel.background = element_rect(fill = 'white', colour='white', color='white'))
gg<- gg + theme(plot.background = element_rect(fill = 'white', colour='white', color='white'))
ggsave("pgrad_cleaned_by_python.png", plot = gg, dpi = 300)
print(gg)
dev.off()
