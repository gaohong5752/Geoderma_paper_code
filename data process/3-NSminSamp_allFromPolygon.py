# -*- coding: utf-8 -*-
"""
Created on Mon Jun 10 21:01:52 2019

@author: gh
"""


import numpy as np
import pandas as pd
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


FS_Clip_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\SNAresult_ClipBySingleShp"

FS_Clip_Fn=getFileName(FS_Clip_folder,"tif")

# DEM  Slope  PlanC  ProfileC TWI LSF VD RSP
factor="PCA8"
nei=7

FS_clip=[i for i in FS_Clip_Fn if factor in i and "NS%s"%nei in i ]
#FS_clip=FS_clip[0:1]

image=IMAGE() 

dn=[]     
for fsi in range(len(FS_clip)):
    fs=FS_clip[fsi]
    fn=FS_Clip_folder+"\\"+fs
    im_proj,im_geotrans,im_data = image.read_img(fn)
    row=im_data.shape[0]
    col=im_data.shape[1]
    nodata=np.min(im_data[0:2,])
    #print nodata
           
    x=[];y=[];v=[]    
    k=np.floor(nei/2)
    
    for ri in range(row):
        for ci in range(col):
            middle_value=im_data[ri,ci]
            edge_value=[]
            
            for nrj in range(int(ri-k),int(ri+k+1),1):
                for ncj in range(int(ci-k),int(ci+k+1),1):
                    if nrj >=0 and ncj >=0 and nrj < row and ncj < col:
                        edge_value.append(im_data[nrj,ncj])
            
            if len([ev for ev in edge_value if ev >-10]) > nei*nei-nei :
                x.append(ri)
                y.append(ci)
                v.append(middle_value)
    
    XYraster=np.transpose(np.array([x,y,v]))
    del x,y
    v=np.sort(v)  ###

    distance=k*1.42
    sampleOrder=1
    while True:
        row_id=[]
        col_id=[]
        rc_value=[]
        for i in range(XYraster.shape[0]):
            value=v[i]
            loc=np.where(XYraster[:,2]==value)[0]
            for lc in loc:
                if len(row_id)==0:
                    row_id.append(XYraster[lc,0])
                    col_id.append(XYraster[lc,1])
                    rc_value.append(sampleOrder)
                    sampleOrder=sampleOrder+1
                else:
                    isout=True
                    for s in range(len(row_id)):
                        dis=np.sqrt((XYraster[lc,0] - row_id[s])**2+(XYraster[lc,1] - col_id[s])**2)
                        if dis < distance:
                            isout=False
                            break
                    if isout==True:
                        row_id.append(XYraster[lc,0])
                        col_id.append(XYraster[lc,1])
                        rc_value.append(sampleOrder)  
                        sampleOrder=sampleOrder+1
        break  
    
    sample_tif_sna=np.repeat(nodata,row*col).reshape(row,col)
    for t in range(len(row_id)):
        sample_tif_sna[int(row_id[t]),int(col_id[t])]=rc_value[t]

    sample_tif_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\SNA_tifSamplePolygonAll\\"
    #sample_tif_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\temp\\"
    sample_tif_outfn=sample_tif_folder+"pSNA_%s"%fs
    image.write_img(sample_tif_outfn,im_proj,im_geotrans,sample_tif_sna)
    
    ran_row = random.sample(range(XYraster.shape[0]),len(row_id))
    ran_data= XYraster[ran_row,]
    
    sample_tif_ran = np.repeat(nodata,row*col).reshape(row,col)
    for tr in range(len(ran_data)):
        sample_tif_ran[int(ran_data[tr,0]),int(ran_data[tr,1])] = ran_data[tr,2]
        
    sample_tif_folder_ran="E:\\otherWork\\02_1\\soil2019-rewrite\\RAN_tifSamplePolygonAll\\"
    sample_tif_outfn=sample_tif_folder_ran+"pRAN_%s"%fs
    image.write_img(sample_tif_outfn,im_proj,im_geotrans,sample_tif_ran)
    

