setwd("E:/otherWork/02_1/soil2019-rewrite/modling")

library(ggplot2)

mydata<-read.csv("随机boxplot.csv")

mydata$Group<-as.vector(mydata$Group)
mydata$NS<-NA
mydata$pen<-NA

for (i in 1:nrow(mydata)){mydata[i,]$NS<-unlist(strsplit(mydata[i,]$Group,split = "_"))[1]}

mydata[mydata$NS=="NS3",]$NS<-"3 × 3"
mydata[mydata$NS=="NS5",]$NS<-"5 × 5"
mydata[mydata$NS=="NS7",]$NS<-"7 × 7"

for (i in 1:nrow(mydata)){mydata[i,]$pen<-unlist(strsplit(mydata[i,]$Group,split = "_"))[2]}

mydata[mydata$pen=="p15",]$pen<-"15 %"
mydata[mydata$pen=="p30",]$pen<-"30 %"
mydata[mydata$pen=="p45",]$pen<-"45 %"

mydata$random<-as.vector(mydata$random)
mydata[mydata$random=="polygon",]$random<-"Based on soil polygons"
mydata[mydata$random=="soil type",]$random<-"Based on soil types"

ggplot(mydata,aes(x=pen,y=value))+
  geom_boxplot()+
  geom_hline(aes(yintercept=0.6333,col="hsm"),linetype=2,lwd=0.8)+
  facet_grid(random~NS)+
  scale_colour_manual(breaks=c("hsm","twi"),values = c("red","blue"),label=c("Based on the conventional soil map","Max precision of SNA"))+
  scale_y_continuous(breaks=c(0.55,0.65,0.75),labels=c(0.55,0.65,0.75))+
  guides(col=guide_legend(title="",ncol  = 2))+
  labs(x="Sample number",y="Updated accuracy")+
  theme(legend.position="top",
        legend.text = element_text(colour="black",size=12,face="bold"),
        legend.title = element_text(colour="black", size = 12,face="bold"),
        axis.title.x = element_text(size = 11,face = "bold"),
        axis.title.y = element_text(size = 11,face = "bold"),
        axis.text.x = element_text(size = 11),
        axis.text.y  = element_text(size = 11),
        strip.text.x = element_text(size=14, face="bold"),
        strip.text.y = element_text(size=14, face="bold"),
        legend.background = element_rect(fill="transparent",colour = "transparent"),
        legend.key.width = unit(1.5,"cm"),legend.key.height = unit(0.5,"cm"),
        legend.key = element_blank())





data_changeRatio<-read.csv("随机变化率boxplot.csv")
data_changeRatio$method<-as.vector(data_changeRatio$method)
data_changeRatio$NS<-as.vector(data_changeRatio$NS)
data_changeRatio$pen<-as.vector(data_changeRatio$pen)

data_changeRatio[data_changeRatio$NS=="NS3",]$NS<-"3 × 3"
data_changeRatio[data_changeRatio$NS=="NS5",]$NS<-"5 × 5"
data_changeRatio[data_changeRatio$NS=="NS7",]$NS<-"7 × 7"

data_changeRatio[data_changeRatio$pen=="pen15",]$pen<-"15 %"
data_changeRatio[data_changeRatio$pen=="pen30",]$pen<-"30 %"
data_changeRatio[data_changeRatio$pen=="pen45",]$pen<-"45 %"

data_changeRatio[data_changeRatio$method=="pRAN",]$method<-"Based on Soil Polygons"
data_changeRatio[data_changeRatio$method=="pRANst",]$method<-"Based on Soil Types"

ggplot(data_changeRatio,aes(x=pen,y=changeRatio))+
  geom_boxplot()+
  #geom_hline(aes(yintercept=0.6333,col="hsm"),linetype=2,lwd=0.8)+
  facet_grid(method~NS)+
  scale_colour_manual(breaks=c("hsm","twi"),values = c("red","blue"),label=c("Accuracy of Conventional Soil Map","Max precision of SNA"))+
  scale_y_continuous(breaks=c(0.55,0.65,0.75),labels=c(0.55,0.65,0.75))+
  guides(col=guide_legend(title="",ncol  = 2))+
  labs(x="Sample Number",y="Updated Accuracy")+
  theme(legend.position="top",
        legend.text = element_text(colour="black",size=12,face="bold"),
        legend.title = element_text(colour="black", size = 12,face="bold"),
        axis.title.x = element_text(size = 11,face = "bold"),
        axis.title.y = element_text(size = 11,face = "bold"),
        axis.text.x = element_text(size = 11),
        axis.text.y  = element_text(size = 11),
        strip.text.x = element_text(size=14, face="bold"),
        strip.text.y = element_text(size=14, face="bold"),
        legend.background = element_rect(fill="transparent",colour = "transparent"),
        legend.key.width = unit(1.5,"cm"),legend.key.height = unit(0.5,"cm"),
        legend.key = element_blank())
