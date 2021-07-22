# -*- coding: utf-8 -*-
"""
Created on 2018.1.15

@author: gaohong

随机法进行训练样本的筛选，在这里比较考虑采用在图斑内筛选还是在土壤类型内筛选,最后决定在图斑内筛选。
"""

import numpy as np
import pandas as pd
from gwp_image import IMAGE
import random

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
    for sc in shp_count.keys():
        sc_count=shp_count[sc]
        if sc_count<100:
            n1=int(round((10.0-5.0)/(max(d1)-min(d1))*(sc_count-min(d1))+5,0))
            shp_num[sc]=n1
            del n1
        elif sc_count>=100 and sc_count<500:
            n2=int(round((15.0-10.0)/(max(d2)-min(d2))*(sc_count-min(d2))+10,0))
            shp_num[sc]=n2
            del n2
        elif sc_count>=500 and sc_count<1000:
            n3=int(round((20.0-15.0)/(max(d3)-min(d3))*(sc_count-min(d3))+15,0))
            shp_num[sc]=n3
            del n3
        elif sc_count>=1000:
            n4=int(round((25.0-20.0)/(max(d4)-min(d4))*(sc_count-min(d4))+20,0))
            shp_num[sc]=n4
            del n4
    return shp_num

singleShp_folder="E:\\officeFile\\aD4_8\\singleShp"

Sn=calculateShpNum(singleShp_folder)  #####  aD8的目标数量为851

soil=np.unique([s.split("_")[0] for s in Sn.keys()])
localVar = locals()
for s in soil:
     localVar["num_%s"%s]=0

for sk in Sn.keys():
    ss=sk.split("_")[0]
    for  si in soil:
        if ss==si:
            localVar["num_%s"%si]=localVar["num_%s"%si]+Sn[sk]

for si in soil:
    print "%s num = %s"%(si,localVar["num_%s"%si])


FS_Clip_folder="E:\\officeFile\\aD4_8\\FS_Clip"

FS_Clip_Fn=getFileName(FS_Clip_folder,"tif")

sShp_represent_fn=getFileName(singleShp_folder,"shp")

image=IMAGE() 

###
nei=3    
nei_inFn="fs_%s"%nei

###————————
target_factor="DEM"     ###这里变化不同的环境因子值： DEM，LSF，PlanC，RSP，Slope，TWI，VD

print "randomSamp in polygon method: factor= %s" %target_factor


FS_clip=[]
for FCf in FS_Clip_Fn:
    for ssr in sShp_represent_fn:
        if target_factor in FCf and nei_inFn in FCf and ssr[0:-4] in FCf:
            FS_clip.append(FCf)


image=IMAGE()    
   
for fsi in range(len(FS_clip)):
    fs=FS_clip[fsi]
    fn=FS_Clip_folder+"\\"+fs
    im_proj,im_geotrans,im_data = image.read_img(fn)
    row=im_data.shape[0]
    col=im_data.shape[1]
    nodata=np.min(im_data[0,])
    #print nodata
    
    shp_fn=fs.split("_")[3]+"_"+fs.split("_")[4]
    sampNum=Sn[shp_fn]    
    
    x=[];y=[];v=[]    
    k=3
    for i in range(k/2,row-k/2-1):
        for j in range(k/2,col-k/2-1):
            nei_data=im_data[(i-k/2):(i+k/2+1),(j-k/2):(j+k/2+1)]
            if len(np.where(nei_data.reshape(k*k)==nodata)[0]) <6:
                x.append(i)
                y.append(j)
                v.append(im_data[i,j])
    XYraster=np.transpose(np.array([x,y,v]))
    samp_xyraster=random.sample(XYraster,sampNum)
        
    randomSamp_re=np.repeat(nodata,row*col).reshape(row,col)
    for sxy in samp_xyraster:
        randomSamp_re[int(sxy[0]),int(sxy[1])]=3
        
    hps_ranSamp_folder="E:\\officeFile\\aD4_8\\sampleCell_tif_666\\"
    hps_ranSamp_outfn=hps_ranSamp_folder+"%s_randomSamp5.tif"%shp_fn
    image.write_img(hps_ranSamp_outfn,im_proj,im_geotrans,randomSamp_re)

    print " %s sampleNum is %s   !!!" %(shp_fn,sampNum)
    

print "random sample function Finish !!!!!"        
    