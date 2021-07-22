
setwd("E:/otherWork/02_1/soil2019-rewrite/EnFactor")

library(rgdal)
library(raster)
library(randomForest)

files<-c("DEM.tif","Slope.tif","PlanC.tif","ProfileC.tif","TWI.tif","RSP.tif","LSF.tif","VD.tif","Bedrock.tif")

covStack <- raster(files[1])
for (i in 2:length(files)) {
  covStack <- stack(covStack, files[i])
}

#point_shp_folder="E:/officeFile/aD4_8/points_final/merge_5/"
point_shp_folder="E:/otherWork/02_1/soil2019-rewrite/shpPoint_allTrainingSamples/"
  
mn="All_pRAN_DEM_pen25"   ###  dem  planc rsp slope lsf twi vd 
mn_infile=paste(unlist(strsplit(mn,"_"))[1],"_",unlist(strsplit(mn,"_"))[3],sep = "")
#mn_infile=unlist(strsplit(mn,"_"))[1]

shpPoint<-readOGR(paste(point_shp_folder,mn,".shp",sep = "")) ###
sampData <- extract(covStack, shpPoint, sp = TRUE,method = "simple") 

#sampData<-as.data.frame(sampData)
sampData<-sampData@data
sampData<-na.omit(sampData)
dim(sampData)

sampData$soilID<-substring(as.vector(sampData$soilID),2,nchar(as.vector(sampData$soilID)))

sampData$Bedrock<-as.factor(sampData$Bedrock)  ##母岩数据设置成因子型变量
sampData$soilID<-as.factor(sampData$soilID)

#选取训练数据
set.seed(233)
training <- sample(nrow(sampData), 1 * nrow(sampData))

RF_model<-randomForest(soilID ~.,data = sampData[training, ], 
                       importance = TRUE, proximity = FALSE,ntree=1000,type="classification")
varImpPlot(RF_model)  ###在这里停一下，依据重要性进行变量筛选

RF_pred_preData <- predict(RF_model, sampData[-training, ],type="class")
#sum(sampData$soil_code[-training]==RF_pred_preData)/(dim(sampData)[1]-length(training))  ##测试集预测精度
#table(observed =sampData$soil_code[-training],predicted=RF_pred_preData)
map_RF <- predict(covStack, RF_model, paste("E:/otherWork/02_1/soil2019-rewrite/result_mapTif/",mn,".tif",sep=""),
                  format = "GTiff", datatype = "FLT4S", overwrite = TRUE)
RF_model
mn
