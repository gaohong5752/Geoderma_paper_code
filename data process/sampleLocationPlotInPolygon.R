setwd("E:/otherWork/02_1/soil2019-rewrite/图斑样点分布示意图/polygonPlot2")

library(sp)
library(rgdal)
library(raster)
library(ggplot2)
library(grid)

pointSize<-6
pointSize_small<-3

SNAPloygon_folder<-"E:/otherWork/02_1/soil2019-rewrite/SNAresult_ClipBySingleShp/"
SNAPoint_tif_folder<-"E:/otherWork/02_1/soil2019-rewrite/SNA_tifSamplePolygonAll/"
SNAPoint_tifPercent_folder<-"E:/otherWork/02_1/soil2019-rewrite/SNApoint_tifSelectByPercent/"

#####
SNA_result<-raster(paste(SNAPloygon_folder,"DEM_NS3_S7_6_25500.tif",sep = ""))
SNA_result <- as(SNA_result, "SpatialPixelsDataFrame")
coordnames(SNA_result) <- c("cor_X", "cor_Y")
names(SNA_result)<-"factorName"
SNA_result<-as.data.frame(SNA_result)
SNA_DEM_result_n3<-SNA_result[SNA_result$factorName>-10,]


SNA_n3<-raster(paste(SNAPoint_tif_folder,"pSNA_DEM_NS3_S7_6_25500.tif",sep = ""))
SNA_n3 <- as(SNA_n3, "SpatialPixelsDataFrame")
coordnames(SNA_n3) <- c("cor_X", "cor_Y")
names(SNA_n3)<-"samplingOrder"
SNA_n3<-as.data.frame(SNA_n3)
SNA_DEM_n3<-SNA_n3[SNA_n3$samplingOrder>-10,]

p_DEM_n3<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n3,pch=15,size=pointSize) + 
  geom_point(data =SNA_DEM_n3,aes(x=cor_X, y=cor_Y),col="peru" )+
  geom_text(data=SNA_DEM_n3,aes(x=cor_X,y=cor_Y+7,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Value", 
                         limits=c(min(SNA_DEM_result_n3$factorName),
                                  max(SNA_DEM_result_n3$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("All candidate samples with orders, Elevation, 3×3")+
  theme(plot.title = element_text(hjust = 0.5,size=13,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))
print(p_DEM_n3)


SNA_n3_pen<-raster(paste(SNAPoint_tifPercent_folder,"pSNA_DEM_NS3_S7_6_25500_pen15.tif",sep = ""))
SNA_n3_pen <- as(SNA_n3_pen, "SpatialPixelsDataFrame")
coordnames(SNA_n3_pen) <- c("cor_X", "cor_Y")
names(SNA_n3_pen)<-"samplingOrder"
SNA_n3_pen<-as.data.frame(SNA_n3_pen)
SNA_DEM_n3_pen15<-SNA_n3_pen[SNA_n3_pen$samplingOrder>-10,]

p_dem_ns3_p15<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n3,pch=15,size=pointSize_small) +
  geom_point(data =SNA_DEM_n3_pen15,aes(x=cor_X, y=cor_Y),col="darkred" )+
  #geom_text(data=SNA_DEM_n3_pen15,aes(x=cor_X,y=cor_Y+9,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(SNA_DEM_result_n3$factorName),max(SNA_DEM_result_n3$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("3 × 3,  15 %")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=12,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())
print(p_dem_ns3_p15)

SNA_n3_pen<-raster(paste(SNAPoint_tifPercent_folder,"pSNA_DEM_NS3_S7_6_25500_pen45.tif",sep = ""))
SNA_n3_pen <- as(SNA_n3_pen, "SpatialPixelsDataFrame")
coordnames(SNA_n3_pen) <- c("cor_X", "cor_Y")
names(SNA_n3_pen)<-"samplingOrder"
SNA_n3_pen<-as.data.frame(SNA_n3_pen)
SNA_DEM_n3_pen45<-SNA_n3_pen[SNA_n3_pen$samplingOrder>-10,]

p_dem_ns3_p45<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n3,pch=15,size=pointSize_small) +
  geom_point(data =SNA_DEM_n3_pen45,aes(x=cor_X, y=cor_Y),col="darkred" )+
  #geom_text(data=SNA_DEM_n3_pen45,aes(x=cor_X,y=cor_Y+9,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(SNA_DEM_result_n3$factorName),max(SNA_DEM_result_n3$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle(" 3 × 3, 45 % ")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=12,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())
print(p_dem_ns3_p45)

#####
SNA_result<-raster(paste(SNAPloygon_folder,"DEM_ns5_S7_6_25500.tif",sep = ""))
SNA_result <- as(SNA_result, "SpatialPixelsDataFrame")
coordnames(SNA_result) <- c("cor_X", "cor_Y")
names(SNA_result)<-"factorName"
SNA_result<-as.data.frame(SNA_result)
SNA_DEM_result_n5<-SNA_result[SNA_result$factorName>-10,]


SNA_n5<-raster(paste(SNAPoint_tif_folder,"pSNA_DEM_ns5_S7_6_25500.tif",sep = ""))
SNA_n5 <- as(SNA_n5, "SpatialPixelsDataFrame")
coordnames(SNA_n5) <- c("cor_X", "cor_Y")
names(SNA_n5)<-"samplingOrder"
SNA_n5<-as.data.frame(SNA_n5)
SNA_DEM_n5<-SNA_n5[SNA_n5$samplingOrder>-10,]

p_DEM_n5<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n5,pch=15,size=pointSize) + 
  geom_point(data =SNA_DEM_n5,aes(x=cor_X, y=cor_Y),col="peru" )+
  geom_text(data=SNA_DEM_n5,aes(x=cor_X,y=cor_Y+7,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(SNA_DEM_result_n5$factorName),
                                  max(SNA_DEM_result_n5$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("All candidate samples with orders, Elevation, 5×5")+
  theme(plot.title = element_text(hjust = 0.5,size=13,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))
print(p_DEM_n5)


SNA_n5_pen<-raster(paste(SNAPoint_tifPercent_folder,"pSNA_DEM_ns5_S7_6_25500_pen15.tif",sep = ""))
SNA_n5_pen <- as(SNA_n5_pen, "SpatialPixelsDataFrame")
coordnames(SNA_n5_pen) <- c("cor_X", "cor_Y")
names(SNA_n5_pen)<-"samplingOrder"
SNA_n5_pen<-as.data.frame(SNA_n5_pen)
SNA_DEM_n5_pen15<-SNA_n5_pen[SNA_n5_pen$samplingOrder>-10,]

p_dem_ns5_p15<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n5,pch=15,size=pointSize_small) +
  geom_point(data =SNA_DEM_n5_pen15,aes(x=cor_X, y=cor_Y),col="darkred" )+
  #geom_text(data=SNA_DEM_n5_pen15,aes(x=cor_X,y=cor_Y+9,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(SNA_DEM_result_n5$factorName),max(SNA_DEM_result_n5$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("5 × 5, 15 %")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=12,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())
print(p_dem_ns5_p15)

SNA_n5_pen<-raster(paste(SNAPoint_tifPercent_folder,"pSNA_DEM_ns5_S7_6_25500_pen45.tif",sep = ""))
SNA_n5_pen <- as(SNA_n5_pen, "SpatialPixelsDataFrame")
coordnames(SNA_n5_pen) <- c("cor_X", "cor_Y")
names(SNA_n5_pen)<-"samplingOrder"
SNA_n5_pen<-as.data.frame(SNA_n5_pen)
SNA_DEM_n5_pen45<-SNA_n5_pen[SNA_n5_pen$samplingOrder>-10,]

p_dem_ns5_p45<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n5,pch=15,size=pointSize_small) +
  geom_point(data =SNA_DEM_n5_pen45,aes(x=cor_X, y=cor_Y),col="darkred" )+
  #geom_text(data=SNA_DEM_n5_pen45,aes(x=cor_X,y=cor_Y+9,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(SNA_DEM_result_n5$factorName),max(SNA_DEM_result_n5$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("5 × 5, 45 %")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=12,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())
print(p_dem_ns5_p45)

######
SNA_result<-raster(paste(SNAPloygon_folder,"DEM_ns7_S7_6_25500.tif",sep = ""))
SNA_result <- as(SNA_result, "SpatialPixelsDataFrame")
coordnames(SNA_result) <- c("cor_X", "cor_Y")
names(SNA_result)<-"factorName"
SNA_result<-as.data.frame(SNA_result)
SNA_DEM_result_n7<-SNA_result[SNA_result$factorName>-10,]


SNA_n7<-raster(paste(SNAPoint_tif_folder,"pSNA_DEM_ns7_S7_6_25500.tif",sep = ""))
SNA_n7 <- as(SNA_n7, "SpatialPixelsDataFrame")
coordnames(SNA_n7) <- c("cor_X", "cor_Y")
names(SNA_n7)<-"samplingOrder"
SNA_n7<-as.data.frame(SNA_n7)
SNA_DEM_n7<-SNA_n7[SNA_n7$samplingOrder>-10,]

p_DEM_n7<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n7,pch=15,size=pointSize) + 
  geom_point(data =SNA_DEM_n7,aes(x=cor_X, y=cor_Y),col="peru" )+
  geom_text(data=SNA_DEM_n7,aes(x=cor_X,y=cor_Y+7,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(SNA_DEM_result_n7$factorName),
                                  max(SNA_DEM_result_n7$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("All candidate samples with orders, Elevation, 7×7")+
  theme(plot.title = element_text(hjust = 0.5,size=13,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))
print(p_DEM_n7)


SNA_n7_pen<-raster(paste(SNAPoint_tifPercent_folder,"pSNA_DEM_ns7_S7_6_25500_pen15.tif",sep = ""))
SNA_n7_pen <- as(SNA_n7_pen, "SpatialPixelsDataFrame")
coordnames(SNA_n7_pen) <- c("cor_X", "cor_Y")
names(SNA_n7_pen)<-"samplingOrder"
SNA_n7_pen<-as.data.frame(SNA_n7_pen)
SNA_DEM_n7_pen15<-SNA_n7_pen[SNA_n7_pen$samplingOrder>-10,]

p_dem_ns7_p15<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n7,pch=15,size=pointSize_small) +
  geom_point(data =SNA_DEM_n7_pen15,aes(x=cor_X, y=cor_Y),col="darkred" )+
  #geom_text(data=SNA_DEM_n7_pen15,aes(x=cor_X,y=cor_Y+9,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(SNA_DEM_result_n7$factorName),max(SNA_DEM_result_n7$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("7 × 7, 15 %")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=12,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())
print(p_dem_ns7_p15)

SNA_n7_pen<-raster(paste(SNAPoint_tifPercent_folder,"pSNA_DEM_ns7_S7_6_25500_pen45.tif",sep = ""))
SNA_n7_pen <- as(SNA_n7_pen, "SpatialPixelsDataFrame")
coordnames(SNA_n7_pen) <- c("cor_X", "cor_Y")
names(SNA_n7_pen)<-"samplingOrder"
SNA_n7_pen<-as.data.frame(SNA_n7_pen)
SNA_DEM_n7_pen45<-SNA_n7_pen[SNA_n7_pen$samplingOrder>-10,]

p_dem_ns7_p45<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=factorName), 
             data=SNA_DEM_result_n7,pch=15,size=pointSize_small) +
  geom_point(data =SNA_DEM_n7_pen45,aes(x=cor_X, y=cor_Y),col="darkred" )+
  #geom_text(data=SNA_DEM_n7_pen45,aes(x=cor_X,y=cor_Y+9,label=samplingOrder),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(SNA_DEM_result_n7$factorName),max(SNA_DEM_result_n7$factorName)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("7 × 7, 45 %")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=12,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())
print(p_dem_ns7_p45)

grid.newpage()
pushViewport(viewport(layout = grid.layout(6,3)))
plotout<-function(x,y) viewport(layout.pos.row = x,layout.pos.col = y)

print(p_DEM_n3,vp=plotout(1:2,1:2))
print(p_dem_ns3_p15,vp=plotout(1,3))
print(p_dem_ns3_p45,vp=plotout(2,3))

print(p_DEM_n5,vp=plotout(3:4,1:2))
print(p_dem_ns5_p15,vp=plotout(3,3))
print(p_dem_ns5_p45,vp=plotout(4,3))

print(p_DEM_n7,vp=plotout(5:6,1:2))
print(p_dem_ns7_p15,vp=plotout(5,3))
print(p_dem_ns7_p45,vp=plotout(6,3))