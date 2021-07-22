# -*- coding: utf-8 -*-
"""
Created on Sun Jul 14 12:54:33 2019

@author: gh
"""

import numpy as np
import pandas as pd
from gwp_image import IMAGE
from sklearn.metrics import confusion_matrix

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

result_tif_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\modling\\result_mapTif\\"

result_tif_fn = getFileName(result_tif_folder,"tif")

result_tif_fn = [rtf for rtf in result_tif_fn if not "historical" in rtf]

image=IMAGE() 

im_proj,im_geotrans,im_data = image.read_img("E:\\otherWork\\02_1\\soil2019-rewrite\\modling\\result_mapTif\\historical_soil_map.tif")
row=im_data.shape[0]
col=im_data.shape[1]

hsm_data=np.copy(im_data)
hsm_data=hsm_data.reshape(row*col)

changeRatio={}
changeRatio_st={}

for rtf in result_tif_fn:
    im_proj,im_geotrans,usm_data = image.read_img(result_tif_folder + rtf)
    usm_data=usm_data.reshape(row*col)
    changeRatio[rtf[0:-4]] = np.round(np.sum(hsm_data!=usm_data) / len(hsm_data),2)
    
    soil_type = np.unique(usm_data)[np.unique(usm_data)>0]
    changeCell= hsm_data[hsm_data!=usm_data]
    
    for st in soil_type:
        changeCell_st = sum(changeCell==st)
        name = rtf[0:-4] + "+%s"%int(st)
        changeRatio_st[name] = np.round(changeCell_st / len(hsm_data),4)
    
changeRatio_df = pd.DataFrame({"resultName":list(changeRatio.keys()),
                               "changeRatio":list(changeRatio.values())})


method = [i.split("_")[1] for i in list(changeRatio.keys())]
factor = [i.split("_")[2] for i in list(changeRatio.keys())]
NS = [i.split("_")[3] for i in list(changeRatio.keys())]
pen = [i.split("_")[4] for i in list(changeRatio.keys())]

changeRatio_df["factor"] = factor
changeRatio_df["method"] = method
changeRatio_df["NS"] = NS
changeRatio_df["pen"] = pen

#changeRatio_df.to_csv("E:\\otherWork\\02_1\\soil2019-rewrite\\modling\\变化面积比率.csv",index=False)

changeRatio_st_df =   pd.DataFrame({"resultName":list(changeRatio_st.keys()),
                               "changeRatio":list(changeRatio_st.values())})   
    
method_st = [i.split("_")[1] for i in list(changeRatio_st.keys())]
factor_st = [i.split("_")[2] for i in list(changeRatio_st.keys())]
NS_st = [i.split("_")[3] for i in list(changeRatio_st.keys())]
pen_st = [i.split("_")[4].split("+")[0] for i in list(changeRatio_st.keys())] 
soiltype= [i.split("+")[1] for i in list(changeRatio_st.keys())]  


changeRatio_st_df["factor"] = factor_st
changeRatio_st_df["method"] = method_st
changeRatio_st_df["NS"] = NS_st
changeRatio_st_df["pen"] = pen_st
changeRatio_st_df["soiltype"]=soiltype

changeRatio_st_df.to_csv("E:\\otherWork\\02_1\\soil2019-rewrite\\modling\\变化面积比率_土壤类型.csv",index=False)