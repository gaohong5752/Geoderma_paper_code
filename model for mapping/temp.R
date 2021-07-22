#RSP -ok
##ns3
SNA  RSP ns3 15
```{r}
mn="All_pSNA_RSP_NS3_pen15" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

SNA  RSP ns3 30
```{r}
mn="All_pSNA_RSP_NS3_pen30" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

SNA  RSP ns3 45
```{r}
mn="All_pSNA_RSP_NS3_pen45" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns3 15
```{r}
mn="All_pRAN_RSP_NS3_pen15" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns3 30
```{r}
mn="All_pRAN_RSP_NS3_pen30" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns3 45
```{r}
mn="All_pRAN_RSP_NS3_pen45" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

##ns5
SNA  RSP ns5 15
```{r}
mn="All_pSNA_RSP_NS5_pen15" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

SNA  RSP ns5 30
```{r}
mn="All_pSNA_RSP_NS5_pen30" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

SNA  RSP ns5 45
```{r}
mn="All_pSNA_RSP_NS5_pen45" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns5 15
```{r}
mn="All_pRAN_RSP_NS5_pen15" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns5 30
```{r}
mn="All_pRAN_RSP_NS5_pen30" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns5 45
```{r}
mn="All_pRAN_RSP_NS5_pen45" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

##ns7
SNA  RSP ns7 15
```{r}
mn="All_pSNA_RSP_NS7_pen15" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

SNA  RSP ns7 30
```{r}
mn="All_pSNA_RSP_NS7_pen30" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

SNA  RSP ns7 45
```{r}
mn="All_pSNA_RSP_NS7_pen45" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns7 15
```{r}
mn="All_pRAN_RSP_NS7_pen15" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns7 30
```{r}
mn="All_pRAN_RSP_NS7_pen30" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```

RAN  RSP ns7 45
```{r}
mn="All_pRAN_RSP_NS7_pen45" 

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

sampData<-sampData@data

sampData<-sampData[sampData$soilID %in% soil_type,]

sampData<-na.omit(sampData)

print(dim(sampData))

sampleNum_dict[mn]<-nrow(sampData)

sampData$Bedrock<- droplevels(as.factor(sampData$Bedrock))
sampData$soilID<- droplevels(as.factor(sampData$soilID))

RF_model<-randomForest(soilID ~.,data = sampData, 
                       importance = TRUE, proximity = FALSE,
                       ntree=1000,type="classification")

varImpPlot(RF_model)
print(RF_model)

map_RF <- predict(covStack, RF_model, paste(result_tif_folder,mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)

rm("mn","shpPoint","sampData","RF_model","map_RF")

```
