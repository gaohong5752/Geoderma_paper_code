# -*- coding: utf-8 -*-
"""
Created on Mon Jun 10 21:01:52 2019

@author: gh
"""

from osgeo import ogr
import os
import numpy as np

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

#写单图斑shape文件
def write_shp(filename,spatialref,geomtype,geom,fieldlist,rec):
        driver = ogr.GetDriverByName("ESRI Shapefile")
        if os.access(filename, os.F_OK ): #如文件已存在，则删除
            driver.DeleteDataSource(filename)
        ds = driver.CreateDataSource(filename) #创建Shape文件
        layer = ds.CreateLayer(filename[:-4], srs=spatialref, geom_type=geomtype) #创建图层
        for fd in fieldlist:  #将字段列表写入图层
            field = ogr.FieldDefn(fd['name'],fd['type'])
            #if fd.has_key('width'):
            field.SetWidth(fd['width'])
            #if fd.has_key('decimal'):
            field.SetPrecision(fd['decimal'])
            layer.CreateField(field)
        #将SF数据记录（几何对象及其属性写入图层）
        geo = ogr.CreateGeometryFromWkt(geom)
        feat = ogr.Feature(layer.GetLayerDefn())  #创建SF
        feat.SetGeometry(geo)
        for fd in fieldlist:
            feat.SetField(fd['name'], rec[fd['name']])
        layer.CreateFeature(feat)  #将SF写入图层
        ds.Destroy() #关闭文件


shpfilename="E:\\otherWork\\02_1\\soil2019-rewrite\\historySoilMap\\historicalsoilmap_BT100m2.shp" 
fn_out="E:\\otherWork\\02_1\\soil2019-rewrite\\SingleShp_BT100m2"
spatialref,geomtype,geomlist,fieldlist,reclist = read_shp(shpfilename)

soil_type=np.unique([reclist[i]['SOILcode'] for i in range(len(reclist))])
localVar = locals()   ###动态生成变量
for st in soil_type:
    localVar["num%s"%st]=1


for i in range(len(geomlist)):
    geom=geomlist[i]
    rec=reclist[i]    
    fn=fn_out+"\\S%s_%s_%s.shp" %(rec['SOILcode'],localVar["num%s"%rec['SOILcode']],rec['Area'])
    localVar["num%s"%rec['SOILcode']]+=1
    write_shp(fn,spatialref,geomtype,geom,fieldlist,rec)


print ("Finish !!!")
