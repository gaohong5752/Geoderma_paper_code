library(rgdal)
library(raster)

setwd("E:/otherWork/02_1/soil2019-rewrite/modling")

#设置最终结果tif的保存路径
result_tif_folder="E:/otherWork/02_1/soil2019-rewrite/modling/result_mapTif/"

result_map_name<-c("All_pSNA_TWI_NS5_pen15",               #SNA单因子精度最高的
                   "All_pSNA_PCA3_NS3_pen15",              #SNA多因子精度最高的
                   "All_pRAN_TWI_NS3_pen45",               #图斑随机精度最高的
                   "All_pRANst_Slope_NS3_pen45"          #土壤类型精度最高的
                   )

resultCovStack<-raster(paste(result_tif_folder,result_map_name[1],".tif",sep = ""))
for (i in 2:length(result_map_name)) {
  resultCovStack <- stack(resultCovStack, raster(paste(result_tif_folder,result_map_name[i],".tif",sep = "")))
}

method_name<-c("SNA_single","SNA_integrated","RAN_polygon","RAN_soiltype")

names(resultCovStack)<-method_name

validationPoint<-readOGR(paste(result_tif_folder,"validationPoint.shp",sep = "")) ###


vp_data <- extract(resultCovStack, validationPoint, sp = TRUE,method = "simple") 
vp_data<-na.omit(vp_data@data)

soil_type<-c(1,3,7,20,21,23,30,31,501,502,503)  # 41样本数量太少，删掉。
vp_data<-vp_data[vp_data$trueType %in% soil_type,]

print(nrow(vp_data))

st_precision_df<-data.frame("method"=rep(method_name,length(soil_type)),
                            "soilType"=rep(soil_type,length(method_name)),
                            "vp_num"=rep(NA,length(soil_type)*length(method_name)),
                            "precisionValue"=rep(NA,length(soil_type)*length(method_name)))

for (mn in method_name) {
  mn_point<-vp_data[,c(mn,"trueType")]
  for (st in soil_type) {
    
    mn_st_point<-mn_point[mn_point$trueType==st,]
    
    st_precision_df[st_precision_df$method==mn & st_precision_df$soilType==st,]$vp_num<-nrow(mn_st_point)
    
    st_precision_df[st_precision_df$method==mn & st_precision_df$soilType==st,]$precisionValue<- round(sum(mn_st_point[,mn]==mn_st_point$trueType)/ nrow(mn_st_point),2)
    
  
  }
}

re_table<-data.frame(matrix(NA,length(method_name)+1,length(soil_type)))
names(re_table)<-soil_type
row.names(re_table) <-c( method_name,"sample_num")


for (i in 1:nrow(st_precision_df)) {
  
  mn<-as.vector(st_precision_df[i,]$method)
  st<-st_precision_df[i,]$soilType
  
  re_table[mn,paste(st)]<-st_precision_df[i,]$precisionValue
  re_table["sample_num",paste(st)]<-st_precision_df[i,]$vp_num
  
}


write.csv(re_table,"土壤类型4种方法精度.csv",row.names = T,fileEncoding="utf-8")