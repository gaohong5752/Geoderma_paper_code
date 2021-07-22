setwd("E:/otherWork/02_1/soil2019-rewrite/modling")

library(ggplot2)

mydata<-read.csv("结果精度_8单因子_origin.csv")
mydata_single<-mydata[mydata$factor %in% c("DEM","Slope","PlanC","ProfileC","TWI"),]

hsm_precision<-0.6333


##单因子样本数量敏感性比较
mydata_sna<-mydata_single[mydata_single$method=="pSNA",]
mydata_sna$method<-as.vector(mydata_sna$method)
mydata_sna$factor<-as.vector(mydata_sna$factor)
mydata_sna$NS<-as.vector(mydata_sna$NS)
mydata_sna$percent<-as.vector(mydata_sna$percent)

ggplot(mydata_sna)+ylim(0.2,0.85)+
  geom_point(aes(x=percent,y=precisionValue,shape=as.factor(NS),col=as.factor(factor)),size=2)+
  geom_hline(aes(yintercept=hsm_precision),col="black",linetype=2,lwd=0.8)+
  scale_shape_manual(breaks=c("NS3","NS5"),values=c(15,16),labels=c("3 × 3","5 × 5"))+
  scale_x_discrete(limits=c("pen15","pen30","pen45","pen60","pen75"),
                   labels = c("15 %","30 %","45 %","60 %","75 %"))+
  scale_color_manual(breaks=c("DEM","Slope","PlanC","ProfileC","TWI"),
                    values=c("limegreen","blue1","peru","red1","black"),
                    labels=c("Elevation","Slope","Plan Curvature","Profile Curvature","TWI"))+
  guides(colour=guide_legend(title="Environmental Covariates"),shape=guide_legend(title="Neighborhood Size"))+
  labs(x="Relative Sample Number",y="Updated Accuracy")+
  theme(legend.position="right",
        legend.text = element_text(colour="black", size = 12,face="bold"),
        legend.title = element_text(colour="black", size = 12,face="bold"),
        axis.title.x = element_text(size = 12,face = "bold"),
        axis.title.y = element_text(size = 12,face = "bold"),
        axis.text.x = element_text(size = 11,face = "bold"),
        axis.text.y  = element_text(size = 11,face = "bold"),
        legend.key = element_blank())

##绝对样本数量

mydata_sampNum<-mydata_sna
mydata_sampNum$factor<-as.vector(mydata_sampNum$factor)
mydata_sampNum[mydata_sampNum$factor=="DEM",]$factor<-"a-DEM"
mydata_sampNum[mydata_sampNum$factor=="Slope",]$factor<-"b-Slope"
mydata_sampNum[mydata_sampNum$factor=="PlanC",]$factor<-"c-PlanC"
mydata_sampNum[mydata_sampNum$factor=="ProfileC",]$factor<-"d-ProfileC"
mydata_sampNum[mydata_sampNum$factor=="TWI",]$factor<-"e-TWI"
mydata_sampNum$NS<-as.vector(mydata_sampNum$NS)
mydata_sampNum[mydata_sampNum$NS=="NS3",]$NS<-"Neighbor Size: 3 × 3"
mydata_sampNum[mydata_sampNum$NS=="NS5",]$NS<-"Neighbor Size: 5 × 5"

ggplot(mydata_sampNum)+
  geom_bar(aes(x=percent,y=sampleNum,fill=factor),
           position = position_dodge(width=0.7), stat="identity",width = 0.7)+
  facet_wrap(~NS,nrow = 1)+
  scale_fill_manual(breaks=c("a-DEM","b-Slope","c-PlanC","d-ProfileC","e-TWI"),
                    values=c("limegreen","blue1","peru","red1","black"),
                    labels=c("Elevation","Slope","Plan Curvature","Profile Curvature","TWI"))+
  scale_x_discrete(limits=c("pen15","pen30","pen45","pen60","pen75"),
                   labels = c("15 %","30 %","45 %","60 %","75 %"))+
  guides(fill=guide_legend(title="Environmental covariates:"))+
  labs(x="Relative Sample Number",y="Actual Sample Number")+
  theme(legend.position="top",
        legend.text = element_text(colour="black", size = 12,face="bold"),
        legend.title = element_text(colour="black", size = 12,face="bold"),
        axis.title.x = element_text(size = 12,face = "bold"),
        axis.title.y = element_text(size = 12,face = "bold"),
        axis.text.x = element_text(size = 11,face = "bold"),
        axis.text.y  = element_text(size = 11,face = "bold"),
        strip.text.x = element_text(size = 11,face = "bold"),
        legend.key = element_blank())


##邻域大小的比较

mydata_NS3<-subset(mydata_sna,NS=="NS3" & percent=="pen15")
mydata_NS5<-subset(mydata_sna,NS=="NS5" & percent=="pen45")
mydata_NS35_1<-rbind(mydata_NS3,mydata_NS5)
mydata_NS35_1$group<-"3 × 3 (15%) vs 5 × 5 (45%)"
mydata_NS3<-subset(mydata_sna,NS=="NS3" & percent=="pen30")
mydata_NS5<-subset(mydata_sna,NS=="NS5" & percent=="pen75")
mydata_NS35_2<-rbind(mydata_NS3,mydata_NS5)
mydata_NS35_2$group<-"3 × 3 (30%) vs 5 × 5 (75%)"

mydata_NS35<-rbind(mydata_NS35_1,mydata_NS35_2)

ggplot(mydata_NS35,aes(x=factor,y=precisionValue,fill=NS))+
  geom_bar(position = position_dodge(width=0.7), stat="identity",width = 0.7)+
  geom_text(aes(x=factor,y=precisionValue+0.03,label=round(precisionValue,3)),
            position = position_dodge(width=0.7),size = 3)+
  #ylim(0,0.85)+
  #geom_hline(aes(yintercept=hsm_precision),col="black",linetype=2,lwd=0.8)+
  facet_wrap(~group,nrow = 2)+
  scale_fill_manual(breaks=c("NS3","NS5"),
                    values = c("tan1","springgreen3"),
                    labels=c("3 × 3   ","5 × 5"))+
  guides(fill=guide_legend(title="Neighborhood Size :"))+
  labs(x="Environmental Covariates",y="Updated Accuracy")+
  theme(legend.position="top",
        legend.text = element_text(colour="black", size = 12,face="bold"),
        legend.title = element_text(colour="black", size = 12,face="bold"),
        axis.title.x = element_text(size = 12,face = "bold"),
        axis.title.y = element_text(size = 12,face = "bold"),
        axis.text.x = element_text(size = 11,face = "bold"),
        axis.text.y  = element_text(size = 11,face = "bold"),
        strip.text.x = element_text(size = 11,face = "bold"),
        legend.key = element_blank())

##方法间的比较——针对DEM和TWI变量
mydata_method<-mydata[mydata$factor %in% c("DEM","TWI"),]

mydata_method_plot<-mydata_method

mydata_method_plot$factor<-as.vector(mydata_method_plot$factor)
mydata_method_plot$NS<-as.vector(mydata_method_plot$NS)

mydata_method_plot_sna<-subset(mydata_method_plot,method=="pSNA")
mydata_method_plot_ran<-subset(mydata_method_plot,method=="pRAN")

mydata_method_plot_ran2<-aggregate(mydata_method_plot_ran[c("precisionValue","sampleNum")],
                                   by=list(mydata_method_plot_ran$NS,mydata_method_plot_ran$percent),
                                   FUN=mean)

names(mydata_method_plot_ran2)<-c("NS","percent","precisionValue","sampleNum")

mydata_method_plot_ran2$factor<-"RAN"
mydata_method_plot_ran2$method<-"RAN"

mydata_method_plot<-rbind(mydata_method_plot_sna,mydata_method_plot_ran2)
mydata_method_plot[mydata_method_plot$NS=="NS3",]$NS<-"Neighbor Size: 3 × 3"
mydata_method_plot[mydata_method_plot$NS=="NS5",]$NS<-"Neighbor Size: 5 × 5"
mydata_method_plot[mydata_method_plot$factor=="DEM",]$factor<-"1DEM"
mydata_method_plot[mydata_method_plot$factor=="TWI",]$factor<-"2TWI"
mydata_method_plot[mydata_method_plot$factor=="RAN",]$factor<-"3RAN"

ggplot(mydata_method_plot,aes(x=percent,y=precisionValue,fill=factor))+
  geom_bar(position = position_dodge(width=0.7), stat="identity",width = 0.7)+
  ylim(0,0.85)+
  geom_text(aes(x=percent,y=precisionValue+0.03,label=round(precisionValue,3)),
            position = position_dodge(width=0.7),size = 3)+
  geom_hline(aes(yintercept=hsm_precision),col="black",linetype=2,lwd=0.8)+
  facet_wrap(~NS,nrow = 2)+
  scale_fill_manual(breaks=c("1DEM","2TWI","3RAN"),
                    values = c("salmon","skyblue","limegreen"),
                    labels=c("SNA: Elevation","SNA: TWI","Random Samplng"))+
  scale_x_discrete(limits=c("pen15","pen30","pen45","pen60","pen75"),
                   labels = c("15 %","30 %","45 %","60 %","75 %"))+
  guides(fill=guide_legend(title="Sampling Method :"))+
  labs(x="Relative Sample Number",y="Updated Accuracy")+
  theme(legend.position="top",
        legend.text = element_text(colour="black", size = 12,face="bold"),
        legend.title = element_text(colour="black", size = 12,face="bold"),
        axis.title.x = element_text(size = 12,face = "bold"),
        axis.title.y = element_text(size = 12,face = "bold"),
        axis.text.x = element_text(size = 11,face = "bold"),
        axis.text.y  = element_text(size = 11,face = "bold"),
        strip.text.x = element_text(size = 11,face = "bold"),
        strip.text.y = element_text(size = 11,face = "bold"),
        legend.key = element_blank())

##单因子与综合因子的比较

mydata_multi<-subset(mydata,factor=="5factor")
mydata_multi<-subset(mydata_multi,select = c("factor","NS","precisionValue","sampleNum"))
mydata_multi$factor<-as.vector(mydata_multi$factor)
mydata_multi$factor<-"All factors"

mydata_ran75<-subset(mydata,method=="pRAN" & percent=="pen75")

mydata_ran75<-aggregate(mydata_ran75[c("precisionValue","sampleNum")],by=list(mydata_ran75$NS),FUN = mean)
names(mydata_ran75)<-c("NS","precisionValue", "sampleNum")
mydata_ran75$factor<-"RAN"

mydata_dem75<-subset(mydata,method=="pSNA" & factor=="DEM" & percent=="pen75")
mydata_dem75<-subset(mydata_dem75,select = c("factor","NS","precisionValue","sampleNum"))

mydata_twi75<-subset(mydata,method=="pSNA" & factor=="TWI" & percent=="pen75")
mydata_twi75<-subset(mydata_twi75,select = c("factor","NS","precisionValue","sampleNum"))

mydata_multi_plot<-rbind(mydata_dem75,mydata_twi75,mydata_ran75,mydata_multi)

ggplot(mydata_multi_plot,aes(x=NS,y=precisionValue,fill=factor))+
  geom_bar(position = position_dodge(width=0.7), stat="identity",width = 0.7)+
  geom_text(aes(x=NS,y=precisionValue+0.02,label=round(precisionValue,3)),
            position = position_dodge(width=0.7),size = 4)+
  scale_x_discrete(limits=c("NS3","NS5"),
                   labels = c("3 × 3","5 × 5"))+
  scale_fill_manual(breaks=c("DEM","TWI","RAN","All factors"),
                    values = c("salmon","skyblue","limegreen","gray40"),
                    labels=c("SNA: Elevation","SNA: TWI","Random Samplng","SNA: All factors"))+
  labs(x="neighbor Size",y="Updated Accuracy")+
  guides(fill=guide_legend(title="Sampling Method :"))+
  theme(legend.position="top",
        legend.text = element_text(colour="black", size = 12,face="bold"),
        legend.title = element_text(colour="black", size = 12,face="bold"),
        axis.title.x = element_text(size = 12,face = "bold"),
        axis.title.y = element_text(size = 12,face = "bold"),
        axis.text.x = element_text(size = 13,face = "bold"),
        axis.text.y  = element_text(size = 11,face = "bold"),
        legend.key = element_blank())
