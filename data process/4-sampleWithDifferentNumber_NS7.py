# -*- coding: utf-8 -*-
"""
Created on Mon Jul  8 21:42:13 2019

@author: gh
"""

import numpy as np
from gwp_image import IMAGE
import random

random.seed(2019)

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

# DEM  Slope  PlanC  ProfileC TWI LSF  VD  RSP
factor="RSP"

# 15  30  45              #60  75
num_pencent=45

print("%s  %s"%(factor,num_pencent))

image=IMAGE() 
sna_outFile_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\SNApoint_tifSelectByPercent"


pSNA_tif_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\SNA_tifSamplePolygonAll"
pSNA_tif_Fn=getFileName(pSNA_tif_folder,"tif")



pSNA_tif_n7=[i for i in pSNA_tif_Fn if factor in i and "NS7" in i ]
#pSNA_tif_n7=pSNA_tif_n3[0:1]

polygon_num_ns7={}

for pti in pSNA_tif_n7:
    
    polygon_ID=pti.split("_")[3]+"_"+pti.split("_")[4]
    
    im_proj,im_geotrans,im_data = image.read_img(pSNA_tif_folder+"\\"+pti)
    
    da=im_data[im_data>=0]
    
    if len(da) >= 1:
        polygon_num_ns7[polygon_ID] = len(da[da<=np.percentile(da,num_pencent)])

        
    if len(da)==0:
        continue
    
    im_data[im_data>polygon_num_ns7[polygon_ID]]=np.min(im_data[0:2,])
    
    fn_out= sna_outFile_folder + "\\" + pti[0:-4]+"_pen%s"%num_pencent+".tif"
    
    image.write_img(fn_out,im_proj,im_geotrans,im_data)

del pSNA_tif_n7



ran_outFile_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\RANpoint_tifSelectByPercent"

pRAN_tif_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\RAN_tifSamplePolygonAll"
pRAN_tif_Fn=getFileName(pRAN_tif_folder,"tif")

pRAN_tif_n7=[i for i in pRAN_tif_Fn if factor in i and "NS7" in i ]
#pRAN_tif_n7=pRAN_tif_n3[0:1]

for prti in pRAN_tif_n7:
    
    polygon_ID=prti.split("_")[3]+"_"+prti.split("_")[4]
    
    if polygon_ID in polygon_num_ns7.keys():
    
        im_proj,im_geotrans,im_data = image.read_img(pRAN_tif_folder+"\\"+prti)
        row=im_data.shape[0]
        col=im_data.shape[1]
        nodata=np.min(im_data[0:2,])
    
        pranXY_all=[[i,j] for i in range(im_data.shape[0]) for j in range(im_data.shape[1]) if im_data[i,j]>=0]
    
        pranXY_select=random.sample(pranXY_all,polygon_num_ns7[polygon_ID])
    
        pran_select = np.repeat(nodata,row*col).reshape(row,col)
    
        for xyi in pranXY_select:
            pran_select[xyi[0],xyi[1]]=0
        
        fn_out= ran_outFile_folder + "\\" + prti[0:-4]+"_pen%s"%num_pencent+".tif"
    
        image.write_img(fn_out,im_proj,im_geotrans,pran_select)