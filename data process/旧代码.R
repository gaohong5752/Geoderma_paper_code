
######
setwd("E:/otherWork/02_1/soil2019-rewrite/图斑样点分布示意图/data")

library(sp)
library(rgdal)
library(raster)
library(ggplot2)
library(grid)
#######
#
dem_data<-raster("DEM_S7_6.tif")
dem_data <- as(dem_data, "SpatialPixelsDataFrame")
coordnames(dem_data) <- c("cor_X", "cor_Y")
names(dem_data)<-"Elevation"

dem_df<-as.data.frame(dem_data)

pointSize<-6

p_dem<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=Elevation), data=dem_df,pch=15,size=pointSize) + 
  coord_fixed() + 
  scale_colour_distiller(name="Elevation /m", 
                         limits=c(min(dem_df$Elevation),max(dem_df$Elevation)), 
                         space="Lab",palette="OrRd")+
  labs(x="",y="") + 
  ggtitle("Evelation in polygon")+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))

#
twi_data<-raster("TWI_S7_6.tif")
twi_data <- as(twi_data, "SpatialPixelsDataFrame")
coordnames(twi_data) <- c("cor_X", "cor_Y")
names(twi_data)<-"TWI"

twi_df<-as.data.frame(twi_data)

p_twi<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=TWI), data=twi_df,pch=15,size=pointSize) + 
  coord_fixed() + 
  scale_colour_distiller(name="TWI           ", 
                         limits=c(min(twi_df$TWI),max(twi_df$TWI)), 
                         space="Lab",palette="OrRd")+
  labs(x="",y="") + 
  ggtitle("TWI in polygon")+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))

grid.newpage()
pushViewport(viewport(layout = grid.layout(1,2)))
plotout<-function(x,y) viewport(layout.pos.row = x,layout.pos.col = y)

print(p_dem,vp=plotout(1,1))
print(p_twi,vp=plotout(1,2))


#####

#DEM
sna_ns3_data<-raster("SNA结果_DEM_NS3_S7_6.tif")
sna_ns3_data <- as(sna_ns3_data, "SpatialPixelsDataFrame")
coordnames(sna_ns3_data) <- c("cor_X", "cor_Y")
names(sna_ns3_data)<-"SNA_NS3"
sna_ns3_df<-as.data.frame(sna_ns3_data)


allShp_sna_ns3<-readOGR("all_psna_dem_ns3_s7_6.shp")
coordnames(allShp_sna_ns3) <- c("cor_X", "cor_Y")
allShp_ns3_df<-as.data.frame(allShp_sna_ns3)
allShp_ns3_df$cor_X<-allShp_ns3_df$cor_X-5
allShp_ns3_df$cor_Y<-allShp_ns3_df$cor_Y-5

p_sna_ns3<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =allShp_ns3_df,aes(x=cor_X, y=cor_Y),col="peru" )+
  geom_text(data=allShp_ns3_df,aes(x=cor_X,y=cor_Y+7,label=GRID_CODE),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("SNA result and Sorted candidate samples, 3×3")+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))

#print(p_sna_ns3)


pShp_sna_ns3_p15<-readOGR("psna_dem_ns3_s7_6_25500_pen15.shp")
coordnames(pShp_sna_ns3_p15) <- c("cor_X", "cor_Y")
pShp_ns3_p15_df<-as.data.frame(pShp_sna_ns3_p15)
pShp_ns3_p15_df$cor_X<-pShp_ns3_p15_df$cor_X-5
pShp_ns3_p15_df$cor_Y<-pShp_ns3_p15_df$cor_Y-5

p_ns3_p15<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p15_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p15_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 15%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p15)

pShp_sna_ns3_p30<-readOGR("psna_dem_ns3_s7_6_25500_pen30.shp")
coordnames(pShp_sna_ns3_p30) <- c("cor_X", "cor_Y")
pShp_ns3_p30_df<-as.data.frame(pShp_sna_ns3_p30)
pShp_ns3_p30_df$cor_X<-pShp_ns3_p30_df$cor_X-5
pShp_ns3_p30_df$cor_Y<-pShp_ns3_p30_df$cor_Y-5

p_ns3_p30<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p30_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p30_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 30%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p30)

pShp_sna_ns3_p45<-readOGR("psna_dem_ns3_s7_6_25500_pen45.shp")
coordnames(pShp_sna_ns3_p45) <- c("cor_X", "cor_Y")
pShp_ns3_p45_df<-as.data.frame(pShp_sna_ns3_p45)
pShp_ns3_p45_df$cor_X<-pShp_ns3_p45_df$cor_X-5
pShp_ns3_p45_df$cor_Y<-pShp_ns3_p45_df$cor_Y-5

p_ns3_p45<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p45_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p45_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 45%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p45)


pShp_sna_ns3_p60<-readOGR("psna_dem_ns3_s7_6_25500_pen60.shp")
coordnames(pShp_sna_ns3_p60) <- c("cor_X", "cor_Y")
pShp_ns3_p60_df<-as.data.frame(pShp_sna_ns3_p60)
pShp_ns3_p60_df$cor_X<-pShp_ns3_p60_df$cor_X-5
pShp_ns3_p60_df$cor_Y<-pShp_ns3_p60_df$cor_Y-5

p_ns3_p60<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p60_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p60_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 60%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p60)

pShp_sna_ns3_p75<-readOGR("psna_dem_ns3_s7_6_25500_pen75.shp")
coordnames(pShp_sna_ns3_p75) <- c("cor_X", "cor_Y")
pShp_ns3_p75_df<-as.data.frame(pShp_sna_ns3_p75)
pShp_ns3_p75_df$cor_X<-pShp_ns3_p75_df$cor_X-5
pShp_ns3_p75_df$cor_Y<-pShp_ns3_p75_df$cor_Y-5

p_ns3_p75<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p75_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p75_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 75%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p75)
#
#

sna_ns5_data<-raster("SNA结果_DEM_NS5_S7_6.tif")
sna_ns5_data <- as(sna_ns5_data, "SpatialPixelsDataFrame")
coordnames(sna_ns5_data) <- c("cor_X", "cor_Y")
names(sna_ns5_data)<-"SNA_NS5"
sna_ns5_df<-as.data.frame(sna_ns5_data)


allShp_sna_ns5<-readOGR("all_psna_dem_ns5_s7_6.shp")
coordnames(allShp_sna_ns5) <- c("cor_X", "cor_Y")
allShp_ns5_df<-as.data.frame(allShp_sna_ns5)
allShp_ns5_df$cor_X<-allShp_ns5_df$cor_X-5
allShp_ns5_df$cor_Y<-allShp_ns5_df$cor_Y-5

p_sna_ns5<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =allShp_ns5_df,aes(x=cor_X, y=cor_Y),col="peru" )+
  geom_text(data=allShp_ns5_df,aes(x=cor_X,y=cor_Y+7,label=GRID_CODE),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  scale_x_continuous(breaks=c(662900,663000,663100),
                     labels = c(662900,663000,663100))+
  scale_y_continuous(breaks=c(4872720,4872760,4872800),
                     labels = c(4872720,4872760,4872800))+
  labs(x="",y="") + 
  ggtitle("SNA result and Sorted candidate samples, 5×5")+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))

#print(p_sna_ns5)


pShp_sna_ns5_p15<-readOGR("psna_dem_ns5_s7_6_25500_pen15.shp")
coordnames(pShp_sna_ns5_p15) <- c("cor_X", "cor_Y")
pShp_ns5_p15_df<-as.data.frame(pShp_sna_ns5_p15)
pShp_ns5_p15_df$cor_X<-pShp_ns5_p15_df$cor_X-5
pShp_ns5_p15_df$cor_Y<-pShp_ns5_p15_df$cor_Y-5

p_ns5_p15<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) +
  geom_point(data =pShp_ns5_p15_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p15_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 15%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p15)

pShp_sna_ns5_p30<-readOGR("psna_dem_ns5_s7_6_25500_pen30.shp")
coordnames(pShp_sna_ns5_p30) <- c("cor_X", "cor_Y")
pShp_ns5_p30_df<-as.data.frame(pShp_sna_ns5_p30)
pShp_ns5_p30_df$cor_X<-pShp_ns5_p30_df$cor_X-5
pShp_ns5_p30_df$cor_Y<-pShp_ns5_p30_df$cor_Y-5

p_ns5_p30<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns5_p30_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p30_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 30%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p30)

pShp_sna_ns5_p45<-readOGR("psna_dem_ns5_s7_6_25500_pen45.shp")
coordnames(pShp_sna_ns5_p45) <- c("cor_X", "cor_Y")
pShp_ns5_p45_df<-as.data.frame(pShp_sna_ns5_p45)
pShp_ns5_p45_df$cor_X<-pShp_ns5_p45_df$cor_X-5
pShp_ns5_p45_df$cor_Y<-pShp_ns5_p45_df$cor_Y-5

p_ns5_p45<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns5_p45_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p45_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 45%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p45)


pShp_sna_ns5_p60<-readOGR("psna_dem_ns5_s7_6_25500_pen60.shp")
coordnames(pShp_sna_ns5_p60) <- c("cor_X", "cor_Y")
pShp_ns5_p60_df<-as.data.frame(pShp_sna_ns5_p60)
pShp_ns5_p60_df$cor_X<-pShp_ns5_p60_df$cor_X-5
pShp_ns5_p60_df$cor_Y<-pShp_ns5_p60_df$cor_Y-5

p_ns5_p60<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns5_p60_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p60_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 60%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p60)

pShp_sna_ns5_p75<-readOGR("psna_dem_ns5_s7_6_25500_pen75.shp")
coordnames(pShp_sna_ns5_p75) <- c("cor_X", "cor_Y")
pShp_ns5_p75_df<-as.data.frame(pShp_sna_ns5_p75)
pShp_ns5_p75_df$cor_X<-pShp_ns5_p75_df$cor_X-5
pShp_ns5_p75_df$cor_Y<-pShp_ns5_p75_df$cor_Y-5

p_ns5_p75<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns5_p75_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p75_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 75%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p75)

grid.newpage()
pushViewport(viewport(layout = grid.layout(4,4)))
plotout<-function(x,y) viewport(layout.pos.row = x,layout.pos.col = y)

print(p_sna_ns3,vp=plotout(1:2,1:2))
print(p_sna_ns5,vp=plotout(3:4,1:2))

print(p_ns3_p15,vp=plotout(1,3))
print(p_ns3_p30,vp=plotout(1,4))

print(p_ns3_p60,vp=plotout(2,3))
print(p_ns3_p75,vp=plotout(2,4))

print(p_ns5_p15,vp=plotout(3,3))
print(p_ns5_p30,vp=plotout(3,4))

print(p_ns5_p60,vp=plotout(4,3))
print(p_ns5_p75,vp=plotout(4,4))

#######
rm(list=ls())
######

twi_data<-raster("TWI_S7_6.tif")
twi_data <- as(twi_data, "SpatialPixelsDataFrame")
coordnames(twi_data) <- c("cor_X", "cor_Y")
names(twi_data)<-"TWI"

twi_df<-as.data.frame(twi_data)

pointSize<-6

p_twi<-ggplot() + 
  geom_point(aes(x=cor_X, y=cor_Y, colour=TWI), data=twi_df,pch=15,size=pointSize) + 
  coord_fixed() + 
  scale_colour_distiller(name="TWI", 
                         limits=c(min(twi_df$TWI),max(twi_df$TWI)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("TWI in polygon")+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))

#print(p_twi)

#
sna_ns3_data<-raster("SNA结果_TWI_NS3_S7_6.tif")
sna_ns3_data <- as(sna_ns3_data, "SpatialPixelsDataFrame")
coordnames(sna_ns3_data) <- c("cor_X", "cor_Y")
names(sna_ns3_data)<-"SNA_NS3"
sna_ns3_df<-as.data.frame(sna_ns3_data)


allShp_sna_ns3<-readOGR("all_psna_twi_ns3_s7_6.shp")
coordnames(allShp_sna_ns3) <- c("cor_X", "cor_Y")
allShp_ns3_df<-as.data.frame(allShp_sna_ns3)
allShp_ns3_df$cor_X<-allShp_ns3_df$cor_X-5
allShp_ns3_df$cor_Y<-allShp_ns3_df$cor_Y-5

p_sna_ns3<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =allShp_ns3_df,aes(x=cor_X, y=cor_Y),col="peru" )+
  geom_text(data=allShp_ns3_df,aes(x=cor_X,y=cor_Y+7,label=GRID_CODE),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("SNA result and Sorted candidate samples, 3×3")+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))

#print(p_sna_ns3)


pShp_sna_ns3_p15<-readOGR("psna_twi_ns3_s7_6_25500_pen15.shp")
coordnames(pShp_sna_ns3_p15) <- c("cor_X", "cor_Y")
pShp_ns3_p15_df<-as.data.frame(pShp_sna_ns3_p15)
pShp_ns3_p15_df$cor_X<-pShp_ns3_p15_df$cor_X-5
pShp_ns3_p15_df$cor_Y<-pShp_ns3_p15_df$cor_Y-5

p_ns3_p15<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p15_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p15_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 15%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p15)

pShp_sna_ns3_p30<-readOGR("psna_twi_ns3_s7_6_25500_pen30.shp")
coordnames(pShp_sna_ns3_p30) <- c("cor_X", "cor_Y")
pShp_ns3_p30_df<-as.data.frame(pShp_sna_ns3_p30)
pShp_ns3_p30_df$cor_X<-pShp_ns3_p30_df$cor_X-5
pShp_ns3_p30_df$cor_Y<-pShp_ns3_p30_df$cor_Y-5

p_ns3_p30<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p30_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p30_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 30%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p30)

pShp_sna_ns3_p45<-readOGR("psna_twi_ns3_s7_6_25500_pen45.shp")
coordnames(pShp_sna_ns3_p45) <- c("cor_X", "cor_Y")
pShp_ns3_p45_df<-as.data.frame(pShp_sna_ns3_p45)
pShp_ns3_p45_df$cor_X<-pShp_ns3_p45_df$cor_X-5
pShp_ns3_p45_df$cor_Y<-pShp_ns3_p45_df$cor_Y-5

p_ns3_p45<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p45_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p45_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 45%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p45)


pShp_sna_ns3_p60<-readOGR("psna_twi_ns3_s7_6_25500_pen60.shp")
coordnames(pShp_sna_ns3_p60) <- c("cor_X", "cor_Y")
pShp_ns3_p60_df<-as.data.frame(pShp_sna_ns3_p60)
pShp_ns3_p60_df$cor_X<-pShp_ns3_p60_df$cor_X-5
pShp_ns3_p60_df$cor_Y<-pShp_ns3_p60_df$cor_Y-5

p_ns3_p60<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p60_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p60_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 60%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p60)

pShp_sna_ns3_p75<-readOGR("psna_twi_ns3_s7_6_25500_pen75.shp")
coordnames(pShp_sna_ns3_p75) <- c("cor_X", "cor_Y")
pShp_ns3_p75_df<-as.data.frame(pShp_sna_ns3_p75)
pShp_ns3_p75_df$cor_X<-pShp_ns3_p75_df$cor_X-5
pShp_ns3_p75_df$cor_Y<-pShp_ns3_p75_df$cor_Y-5

p_ns3_p75<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS3), data=sna_ns3_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns3_p75_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns3_p75_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA", 
                         limits=c(min(sna_ns3_df$SNA_NS3),max(sna_ns3_df$SNA_NS3)), 
                         palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 3×3, 75%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns3_p75)
#

sna_ns5_data<-raster("SNA结果_twi_NS5_S7_6.tif")
sna_ns5_data <- as(sna_ns5_data, "SpatialPixelsDataFrame")
coordnames(sna_ns5_data) <- c("cor_X", "cor_Y")
names(sna_ns5_data)<-"SNA_NS5"
sna_ns5_df<-as.data.frame(sna_ns5_data)


allShp_sna_ns5<-readOGR("all_psna_slope_ns5_s7_6.shp")
coordnames(allShp_sna_ns5) <- c("cor_X", "cor_Y")
allShp_ns5_df<-as.data.frame(allShp_sna_ns5)
allShp_ns5_df$cor_X<-allShp_ns5_df$cor_X-5
allShp_ns5_df$cor_Y<-allShp_ns5_df$cor_Y-5

p_sna_ns5<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =allShp_ns5_df,aes(x=cor_X, y=cor_Y),col="peru" )+
  geom_text(data=allShp_ns5_df,aes(x=cor_X,y=cor_Y+7,label=GRID_CODE),size=4,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  scale_x_continuous(breaks=c(662900,663000,663100),
                     labels = c(662900,663000,663100))+
  scale_y_continuous(breaks=c(4872720,4872760,4872800),
                     labels = c(4872720,4872760,4872800))+
  labs(x="",y="") + 
  ggtitle("SNA result and Sorted candidate samples, 5×5")+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_text(size = 8,face = "bold"),
        axis.title.y = element_text(size = 8,face = "bold"),
        axis.text.x = element_text(size = 8,face = "bold"),
        axis.text.y  = element_text(size = 8,face = "bold"))

#print(p_sna_ns5)


pShp_sna_ns5_p15<-readOGR("psna_twi_ns5_s7_6_25500_pen15.shp")
coordnames(pShp_sna_ns5_p15) <- c("cor_X", "cor_Y")
pShp_ns5_p15_df<-as.data.frame(pShp_sna_ns5_p15)
pShp_ns5_p15_df$cor_X<-pShp_ns5_p15_df$cor_X-5
pShp_ns5_p15_df$cor_Y<-pShp_ns5_p15_df$cor_Y-5

p_ns5_p15<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) +
  geom_point(data =pShp_ns5_p15_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p15_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 15%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p15)

pShp_sna_ns5_p30<-readOGR("psna_twi_ns5_s7_6_25500_pen30.shp")
coordnames(pShp_sna_ns5_p30) <- c("cor_X", "cor_Y")
pShp_ns5_p30_df<-as.data.frame(pShp_sna_ns5_p30)
pShp_ns5_p30_df$cor_X<-pShp_ns5_p30_df$cor_X-5
pShp_ns5_p30_df$cor_Y<-pShp_ns5_p30_df$cor_Y-5

p_ns5_p30<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns5_p30_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p30_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 30%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p30)

pShp_sna_ns5_p45<-readOGR("psna_twi_ns5_s7_6_25500_pen45.shp")
coordnames(pShp_sna_ns5_p45) <- c("cor_X", "cor_Y")
pShp_ns5_p45_df<-as.data.frame(pShp_sna_ns5_p45)
pShp_ns5_p45_df$cor_X<-pShp_ns5_p45_df$cor_X-5
pShp_ns5_p45_df$cor_Y<-pShp_ns5_p45_df$cor_Y-5

p_ns5_p45<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns5_p45_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p45_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 45%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p45)


pShp_sna_ns5_p60<-readOGR("psna_twi_ns5_s7_6_25500_pen60.shp")
coordnames(pShp_sna_ns5_p60) <- c("cor_X", "cor_Y")
pShp_ns5_p60_df<-as.data.frame(pShp_sna_ns5_p60)
pShp_ns5_p60_df$cor_X<-pShp_ns5_p60_df$cor_X-5
pShp_ns5_p60_df$cor_Y<-pShp_ns5_p60_df$cor_Y-5

p_ns5_p60<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns5_p60_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p60_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 60%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p60)

pShp_sna_ns5_p75<-readOGR("psna_twi_ns5_s7_6_25500_pen75.shp")
coordnames(pShp_sna_ns5_p75) <- c("cor_X", "cor_Y")
pShp_ns5_p75_df<-as.data.frame(pShp_sna_ns5_p75)
pShp_ns5_p75_df$cor_X<-pShp_ns5_p75_df$cor_X-5
pShp_ns5_p75_df$cor_Y<-pShp_ns5_p75_df$cor_Y-5

p_ns5_p75<-ggplot() + 
  geom_point(aes(x=cor_X-5, y=cor_Y-5, colour=SNA_NS5), data=sna_ns5_df,pch=15,size=pointSize) + 
  geom_point(data =pShp_ns5_p75_df,aes(x=cor_X, y=cor_Y),col="darkred" )+
  geom_text(data=pShp_ns5_p75_df,aes(x=cor_X,y=cor_Y+9,label=GRID_CODE),size=2,col="black")+
  coord_fixed() + 
  scale_colour_distiller(name="SNA Legend", 
                         limits=c(min(sna_ns5_df$SNA_NS5),max(sna_ns5_df$SNA_NS5)), 
                         space="Lab",palette="GnBu")+
  labs(x="",y="") + 
  ggtitle("Final Samples, 5×5, 75%")+
  guides(col=F)+
  theme(plot.title = element_text(hjust = 0.5,size=10,face = "bold"),
        legend.position="right",
        legend.title = element_text(colour="black", size = 10,face="bold"),
        legend.text = element_text(colour="black",size=9,face = "bold"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y  = element_blank())

#print(p_ns5_p75)

grid.newpage()
pushViewport(viewport(layout = grid.layout(4,4)))
plotout<-function(x,y) viewport(layout.pos.row = x,layout.pos.col = y)

print(p_sna_ns3,vp=plotout(1:2,1:2))
print(p_sna_ns5,vp=plotout(3:4,1:2))

print(p_ns3_p15,vp=plotout(1,3))
print(p_ns3_p30,vp=plotout(1,4))

print(p_ns3_p60,vp=plotout(2,3))
print(p_ns3_p75,vp=plotout(2,4))

print(p_ns5_p15,vp=plotout(3,3))
print(p_ns5_p30,vp=plotout(3,4))

print(p_ns5_p60,vp=plotout(4,3))
print(p_ns5_p75,vp=plotout(4,4))
