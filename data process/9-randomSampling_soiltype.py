# -*- coding: utf-8 -*-
"""
Created on Sat Jul 13 12:25:02 2019

@author: gh
"""

from osgeo import ogr
import os
import numpy as np
from gwp_image import IMAGE
import random

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

#读shape文件
def read_shp(filename):
    ds = ogr.Open(filename, False)  #打开Shape文件（False - read only, True - read/write）
    layer = ds.GetLayer(0)   #获取图层
    spatialref = layer.GetSpatialRef() #投影信息
    lydefn = layer.GetLayerDefn() #图层定义信息
    geomtype = lydefn.GetGeomType() #几何对象类型（ogr.wkbPoint, ogr.wkbLineString, ogr.wkbPolygon）
    fieldlist = [] #字段列表 （字段类型，ogr.OFTInteger, ogr.OFTReal, ogr.OFTString, ogr.OFTDateTime）
    for i in range(lydefn.GetFieldCount()):
        fddefn = lydefn.GetFieldDefn(i)
        fddict = {'name':fddefn.GetName(),'type':fddefn.GetType(),
                  'width':fddefn.GetWidth(),'decimal':fddefn.GetPrecision()}
        fieldlist += [fddict]
    geomlist, reclist = [], [] #SF数据记录 – 几何对象及其对应属性
    feature = layer.GetNextFeature() #获得第一个SF
    while feature is not None:
        geom = feature.GetGeometryRef()
        geomlist += [geom.ExportToWkt()]
        rec = {}
        for fd in fieldlist:
            rec[fd['name']] = feature.GetField(fd['name'])
        reclist += [rec]
        feature = layer.GetNextFeature()
    ds.Destroy() #关闭数据源
    return spatialref,geomtype,geomlist,fieldlist,reclist


image=IMAGE() 
im_proj,im_geotrans,im_data = image.read_img("E:\\otherWork\\02_1\\soil2019-rewrite\\result_mapTif\\historical_soil_map.tif")
row=im_data.shape[0]
col=im_data.shape[1]
nodata=-3.4028235e+38
#print nodata

all_sample_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\allTrainingSamples_shp"

all_sample_fn=getFileName(all_sample_folder,"shp")
all_sample_fn=[i for i in all_sample_fn if "All_pSNA" in i]
#all_sample_fn=all_sample_fn[0:1]

sample_folder_ranST="E:\\otherWork\\02_1\\soil2019-rewrite\\RAN_soiltype_tifPoint\\"

for fn in all_sample_fn:
    
    nei=int(fn.split("_")[3][-1])
    
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
    del x,y,v
    
    sample_tif_ran = np.repeat(nodata,row*col).reshape(row,col)

    spatialref,geomtype,geomlist,fieldlist,reclist = read_shp(all_sample_folder+"\\"+fn)
    
    pt_soiltype=[list(reclist[i].values())[0] for i in range(len(reclist))]
    
    soiltype=list(np.unique(pt_soiltype))
    
    for st in soiltype:
        soiltype_num=len([pts for pts in pt_soiltype if pts==st])
        
        
        XYraster_soiltype=XYraster[XYraster[:,2]==int(st),:]
    
        ran_row = random.sample(range(XYraster_soiltype.shape[0]),soiltype_num)
        ran_data= XYraster_soiltype[ran_row,]
    
        for tr in range(len(ran_data)):
            sample_tif_ran[int(ran_data[tr,0]),int(ran_data[tr,1])] = ran_data[tr,2]
        
    
    sample_tif_outfn=sample_folder_ranST+"pRANst%s.tif"%fn.split("pSNA")[1][0:-4]
    image.write_img(sample_tif_outfn,im_proj,im_geotrans,sample_tif_ran)

