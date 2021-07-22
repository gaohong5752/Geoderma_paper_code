# -*- coding: utf-8 -*-
"""
Created on Wed Apr  3 15:21:55 2019

@author: gh
"""

import numpy as np
import pandas as pd
from gwp_image import IMAGE

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

def calculateShpNum(folder_name):
    singleShp_fn=getFileName(singleShp_folder,"shp")
    shp_count={}
    for shp in singleShp_fn:
        s=shp.split("_")
        shp_count[s[0]+"_"+s[1]]=int(s[2][0:-4])

    count=shp_count.values()
    d1=[i for i in count if i <100]
    d2=[i for i in count if i >=100 and i<500]
    d3=[i for i in count if i >=500 and i<1000]
    d4=[i for i in count if i >=1000]

    shp_num={}
    polygon=[]
    sampNum=[]
    area=[]
    for sc in shp_count.keys():
        sc_count=shp_count[sc]
        if sc_count<100:
            n1=int(round((10.0-5.0)/(max(d1)-min(d1))*(sc_count-min(d1))+5,0))
            shp_num[sc]=n1
            polygon.append(sc)
            sampNum.append(n1)
            area.append(sc_count)
            del n1
        elif sc_count>=100 and sc_count<500:
            n2=int(round((15.0-10.0)/(max(d2)-min(d2))*(sc_count-min(d2))+10,0))
            shp_num[sc]=n2
            polygon.append(sc)
            sampNum.append(n2)
            area.append(sc_count)
            del n2
        elif sc_count>=500 and sc_count<1000:
            n3=int(round((20.0-15.0)/(max(d3)-min(d3))*(sc_count-min(d3))+15,0))
            shp_num[sc]=n3
            polygon.append(sc)
            sampNum.append(n3)
            area.append(sc_count)
            del n3
        elif sc_count>=1000:
            n4=int(round((25.0-20.0)/(max(d4)-min(d4))*(sc_count-min(d4))+20,0))
            shp_num[sc]=n4
            polygon.append(sc)
            sampNum.append(n4)
            area.append(sc_count)
            del n4
    return shp_num,polygon,sampNum,area

singleShp_folder="E:\\otherWork\\02_1\\数据\\aD4_8\\singleShp"

Sn,polygonName,sampleNum,area=calculateShpNum(singleShp_folder)  #####  aD8的目标数量为851
totalNum=np.sum(sampleNum)
totalArea=np.sum(area)
areaRate=area/totalArea
weightNum=totalNum*areaRate
weightNum=[int(round(i,0)) for i in weightNum]

print("分区区间映射法样本数量标准差：%s"%np.std(sampleNum))
print("面积加权法样本数量标准差：%s"%np.std(weightNum))

da=pd.DataFrame({"polygonName":polygonName,"polygonArea":area,"sampleNum":sampleNum,"weightNum":weightNum})
#da.to_csv("E:\\otherWork\\02_1\\soil manuscript\\revise-20190223\\polygonSampleNum.csv")

Area=area*0.01


soiltypeNum_new=[138,192,40,150,96,92,21,20,56,35,11]

soiltype_area=[79.06,56.61,53.88,48.11,34.26,19.36,17.41,14.39,11.51,6.92,2.02]

soiltypeNum_weight=[int(round(i,0)) for i in  soiltype_area/np.sum(soiltype_area) * np.sum(soiltypeNum_new)]
