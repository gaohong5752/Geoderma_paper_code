setwd("E:/otherWork/02_1/soil2019-rewrite/EnFactor")

library(rgdal)
library(raster)
library(sp)

files<-c("DEM.tif","Slope.tif","PlanC.tif","ProfileC.tif","TWI.tif","LSF.tif","VD.tif","RSP.tif")

covStack <- raster(files[1])
for (i in 2:length(files)) {
  covStack <- stack(covStack, files[i])
}

cov_data <- as(covStack, "SpatialPixelsDataFrame")
cov_df<-as.data.frame(cov_data)
cov_df<-na.omit(cov_df)
print(names(cov_df))

en_data<-subset(cov_df,select=c("DEM","Slope","PlanC","ProfileC","TWI","LSF","VD","RSP"))

en_data$DEM<-scale(en_data$DEM)
en_data$Slope<-scale(en_data$Slope)
en_data$PlanC<-scale(en_data$PlanC)
en_data$ProfileC<-scale(en_data$ProfileC)
en_data$TWI<-scale(en_data$TWI)
en_data$LSF<-scale(en_data$LSF)
en_data$VD<-scale(en_data$VD)
en_data$RSP<-scale(en_data$RSP)

PCA_model<-princomp(en_data)
summary(PCA_model,loading=T)

pc1<-data.frame(PC1=PCA_model$scores[,1])
pc1_shp<-cbind(pc1,subset(cov_df,select=c("x","y")))
coordinates(pc1_shp)<-c("x","y")
pc1_spdf <- as(pc1_shp, "SpatialPixelsDataFrame")
pc1_raster <- as(pc1_spdf, "RasterLayer")
image(pc1_raster)

#writeRaster(pc1_raster, filename="PCA8.tif", format="GTiff", overwrite=TRUE)

rm(list = ls())

files<-c("DEM.tif","Slope.tif","PlanC.tif","ProfileC.tif","TWI.tif","LSF.tif")

covStack <- raster(files[1])
for (i in 2:length(files)) {
  covStack <- stack(covStack, files[i])
}

cov_data <- as(covStack, "SpatialPixelsDataFrame")
cov_df<-as.data.frame(cov_data)
cov_df<-na.omit(cov_df)
print(names(cov_df))

en_data<-subset(cov_df,select=c("DEM","Slope","PlanC","ProfileC","TWI","LSF"))

en_data$DEM<-scale(en_data$DEM)
en_data$Slope<-scale(en_data$Slope)
en_data$PlanC<-scale(en_data$PlanC)
en_data$ProfileC<-scale(en_data$ProfileC)
en_data$TWI<-scale(en_data$TWI)
en_data$LSF<-scale(en_data$LSF)

PCA_model<-princomp(en_data)
summary(PCA_model,loading=T)

pc1<-data.frame(PC1=PCA_model$scores[,1])
pc1_shp<-cbind(pc1,subset(cov_df,select=c("x","y")))
coordinates(pc1_shp)<-c("x","y")
pc1_spdf <- as(pc1_shp, "SpatialPixelsDataFrame")
pc1_raster <- as(pc1_spdf, "RasterLayer")
image(pc1_raster)

#writeRaster(pc1_raster, filename="PCA6.tif", format="GTiff", overwrite=TRUE)

rm(list=ls())

files<-c("TWI.tif","Slope.tif","LSF.tif")

covStack <- raster(files[1])
for (i in 2:length(files)) {
  covStack <- stack(covStack, files[i])
}

cov_data <- as(covStack, "SpatialPixelsDataFrame")
cov_df<-as.data.frame(cov_data)
cov_df<-na.omit(cov_df)
print(names(cov_df))

en_data<-subset(cov_df,select=c("TWI","Slope","LSF"))

en_data$TWI<-scale(en_data$TWI)
en_data$Slope<-scale(en_data$Slope)
en_data$LSF<-scale(en_data$LSF)

PCA_model<-princomp(en_data)
summary(PCA_model,loading=T)

pc1<-data.frame(PC1=PCA_model$scores[,1])
pc1_shp<-cbind(pc1,subset(cov_df,select=c("x","y")))
coordinates(pc1_shp)<-c("x","y")
pc1_spdf <- as(pc1_shp, "SpatialPixelsDataFrame")
pc1_raster <- as(pc1_spdf, "RasterLayer")
image(pc1_raster)

#writeRaster(pc1_raster, filename="PCA3.tif", format="GTiff", overwrite=TRUE)
