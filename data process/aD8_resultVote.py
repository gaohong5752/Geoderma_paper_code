# -*- coding: utf-8 -*-
"""
Created on 2018.1.29

@author: gaohong
"""

import numpy as np
import pandas as pd
from gwp_image import IMAGE
from scipy.stats import mode

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

reTif_folder="E:\\otherWork\\02_1\\数据\\aD4_8\\result_MapTif\\因子并集综合结果"
reTif_fn=getFileName(reTif_folder,"tif")

out_folder="E:\\otherWork\\02_1\\数据\\aD4_8\\result_MapTif\\voteResult\\"

#factorName=np.unique([i.split("_")[0] for i in reTif_fn])
factorName=["HPM"]
print (factorName)

methodName="HPM"
reTif_mn=[re for re in reTif_fn if methodName in re and "_top4" in re]
reTif_mn_fn=[reTif_folder+"//"+fn for fn in reTif_mn]
print(reTif_mn)

image=IMAGE()
for fa in factorName:
    isFirst=True
    for fn in reTif_mn_fn:
        if fa in fn:
            im_proj,im_geotrans,im_data = image.read_img(fn)
            if isFirst==True:
                re_all_data=im_data.reshape(im_data.shape[0]*im_data.shape[1],1)
                isFirst=False
            else:
                re_all_data=np.concatenate((re_all_data,im_data.reshape(im_data.shape[0]*im_data.shape[1],1)),1)
    
    re=np.zeros((re_all_data.shape[0],1), dtype=np.int)
    re_prob=np.zeros((re_all_data.shape[0],1))
    for i in range(re_all_data.shape[0]):
        row_data=re_all_data[i,]
        row_re=mode(row_data)
        re[i]=row_re[0][0]
        re_prob[i]=round(row_re[1][0]/5.0,2)
        #print np.sort(row_data),re[i],re_prob[i]
    
    re_data=re.reshape(im_data.shape[0],im_data.shape[1])
    outFn1=out_folder+fa+"_"+methodName+"_top4.tif"
    image.write_img(outFn1,im_proj,im_geotrans,re_data)

    re_prob_data=re_prob.reshape(im_data.shape[0],im_data.shape[1])
    outFn2=out_folder+fa+"_prob_"+methodName+"_top4.tif"
    image.write_img(outFn2,im_proj,im_geotrans,re_prob_data)
