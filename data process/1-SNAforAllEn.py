# -*- coding: utf-8 -*-
"""
Created on Mon Jun 10 21:01:52 2019

@author: gh
"""

from gwp_image import IMAGE
import numpy as np

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

def NeiStat(raster,K):
    row=raster.shape[0]
    col=raster.shape[1]
    nodata=-3.40282346639e+038
    re=np.repeat(nodata,row*col).reshape(row,col)
    k=np.floor(K/2)
    
    for ri in range(row):
        for ci in range(col):
            middle_value=raster[ri,ci]
            edge_value=[]
            
            for nrj in range(int(ri-k),int(ri+k+1),1):
                for ncj in range(int(ci-k),int(ci+k+1),1):
                    if nrj >=0 and ncj >=0 and nrj < row and ncj < col:
                        edge_value.append(raster[nrj,ncj])
            
            re[ri,ci]=np.sum([(middle_value - ev)**2 for ev in edge_value])/(len(edge_value)-1)
            
    return re

image=IMAGE()

nei=[3,5,7]

factors_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\EnFactor\\"

#factors_files=getFileName(factors_folder,"tif")
factors_files=["PCA8.tif"]

fn_out_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\EnFactor_NSresult\\"

for f in factors_files:
    im_proj,im_geotrans,im_data = image.read_img(factors_folder+f)
    for n in nei:
        re_temp=NeiStat(im_data,n)
        image.write_img(fn_out_folder+"%s_NS%s.tif"%(f[:-4],n),im_proj,im_geotrans,re_temp)


