# -*- coding: utf-8 -*-
"""
Created on 2018.1.15

@author: gaohong
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from gwp_image import IMAGE
import random
import math

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

def calculateShpNum(fsClip_folder_name):
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

Sn=calculateShpNum(singleShp_folder)       ##采用851个样点

soil=np.unique([s.split("_")[0] for s in Sn.keys()])
localVar = locals()
for s in soil:
     localVar["num_%s"%s]=0

for sk in Sn.keys():
    ss=sk.split("_")[0]
    for  si in soil:
        if ss==si:
            localVar["num_%s"%si]=localVar["num_%s"%si]+Sn[sk]
si_num={}
for si in soil:
    si_num[si]=localVar["num_%s"%si]
    print "%s num = %s"%(si,localVar["num_%s"%si])

target_factor="pca33"     ###这里变化不同的环境因子值： DEM，LSF，PlanC，RSP，Slope，TWI，VD
print target_factor+" histogram Peak method: factor= %s" %target_factor

factors_Clip_folder="E:\\officeFile\\aD4_8\\Factors_Clip"
factors_Clip_fn=getFileName(factors_Clip_folder,"tif")
factors_Clip=[i for i in factors_Clip_fn if target_factor in i]

image=IMAGE()    
   
for factori in range(len(factors_Clip)):
    factor=factors_Clip[factori]
    fn=factors_Clip_folder+"\\"+factor
    im_proj,im_geotrans,im_data = image.read_img(fn)
    row=im_data.shape[0]
    col=im_data.shape[1]
    nodata=np.min(im_data[0,])
    #nodata=-3.40282346639e+038
    
    si_key=factor.split("_")[1].split(".")[0].upper()
    sampNum=si_num[si_key]
        
    x=[];y=[];v=[]    
    k=3
    for i in range(k/2,row-k/2-1):
        for j in range(k/2,col-k/2-1):
            nei_data=im_data[(i-k/2):(i+k/2+1),(j-k/2):(j+k/2+1)]
            if im_data[i,j]!=nodata  and not math.isnan(im_data[i,j]) and len(np.where(nei_data.reshape(nei_data.shape[0]*nei_data.shape[1])==nodata)[0]) <6:
                x.append(i)
                y.append(j)
                v.append(im_data[i,j])
    XYraster=np.transpose(np.array([x,y,v]))
    
    bins_num=int(round(len(v)*1.0/sampNum,0))
    
    h=np.histogram(v,bins_num)

    n=np.where(h[0]==np.max(h[0]))[0][0]
    interval_min=h[1][n]
    interval_max=h[1][n+1]
    
    histPeak_value=[vv for vv in v if vv>=interval_min and vv<=interval_max] 
    
    histPeak_value_unique=np.unique(histPeak_value)
        
    row_id=[]
    col_id=[]
    value_id=[]
    value=XYraster[:,2]
    for hpv in histPeak_value_unique:        
        loc=np.where(value==hpv)[0]
        if len(loc)>=2:
            for lc in loc:
                row_id.append(XYraster[lc,0])
                col_id.append(XYraster[lc,1])
                value_id.append(XYraster[lc,2])
        elif len(loc)==1:
            row_id.append(XYraster[loc[0],0])
            col_id.append(XYraster[loc[0],1])
            value_id.append(XYraster[loc[0],2])
    
    hp_section=np.transpose(np.array([row_id,col_id,value_id]))
    hpSection_ranSamp=random.sample(hp_section,sampNum)        
        
    hpSection_ranSamp_tif_re=np.repeat(nodata,row*col).reshape(row,col)
    for rs_id in range(len(hpSection_ranSamp)):
        hpSection_ranSamp_tif_re[int(hpSection_ranSamp[rs_id][0]),int(hpSection_ranSamp[rs_id][1])]=2       
        
    hps_ranSamp_folder="E:\\officeFile\\aD4_8\\sampleCell_tif_PCAmerge_5\\"
    hps_ranSamp_outfn=hps_ranSamp_folder+"%s_%s_hpRanSamp.tif"%(target_factor,si_key)
    image.write_img(hps_ranSamp_outfn,im_proj,im_geotrans,hpSection_ranSamp_tif_re)

print target_factor+" histogram Peak method: factor= %s" %target_factor  
print "hpRanSamp function Finish !!!!!"        
    
    
    
    
    
    
    
    