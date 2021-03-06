#!C:/Python27/ArcGIS10.1/python.exe -u
#coding=UTF-8

"""
Users who redistribute the program, with or without changes, must pass along the freedom to further copy and change it. 
In addition, the orignal authors should be refered.
This is a program for reading or writing an arcgis shape file, programmed by Dr. Song, Xianfeng, Contact: ucas@ucas.ac.cn.
"""

from osgeo import ogr, osr
import os

class SHAPE:

    #读ArcGIS Shape文件
    def read_shp(self, filename):
        ds = ogr.Open(filename, False)  #代开Shape文件（False - read only, True - read/write）
        layer = ds.GetLayer(0)   #获取图层
        # layer = ds.GetLayerByName(filename[-4:])

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


    #写ArcGIS Shape文件
    def write_shp(self,filename,spatialref,geomtype,geomlist,fieldlist,reclist):

        driver = ogr.GetDriverByName("ESRI Shapefile")
        if os.access(filename, os.F_OK ): #如文件已存在，则删除
            driver.DeleteDataSource(filename)

        ds = driver.CreateDataSource(filename) #创建Shape文件

        #spatialref = osr.SpatialReference( 'LOCAL_CS["arbitrary"]' )
        layer = ds.CreateLayer(filename [:-4], srs=spatialref, geom_type=geomtype) #创建图层

        for fd in fieldlist:  #将字段列表写入图层
            field = ogr.FieldDefn(fd['name'],fd['type'])
            if fd.has_key('width'):
                field.SetWidth(fd['width'])
            if fd.has_key('decimal'):
                field.SetPrecision(fd['decimal'])
            layer.CreateField(field)

        for i in range(len(reclist)):  #将SF数据记录（几何对象及其属性写入图层）
            geom = ogr.CreateGeometryFromWkt(geomlist[i])
            feat = ogr.Feature(layer.GetLayerDefn())  #创建SF
            feat.SetGeometry(geom)
            for fd in fieldlist:
                feat.SetField(fd['name'], reclist[i][fd['name']])
            layer.CreateFeature(feat)  #将SF写入图层

        ds.Destroy() #关闭文件


#Test
if __name__ == "__main__":
    test = SHAPE()

    # #读出点SHAPE文件的坐标和属性，存为CSV文本文件。
    # fh = open("stations.csv",'w')
    # fh.write("x,y,elev,prec\n")
    # spatialref,geomtype,geomlist,fieldlist,reclist = test.read_shp("stations.shp")
    # for i in range(len(geomlist)):
    #     pnt = ogr.CreateGeometryFromWkt(geomlist[i])
    #     x,y = pnt.GetX(),pnt.GetY()
    #     e,p = reclist[i]["ELEV"],reclist[i]["ANN_PREC"]
    #     s = "%f,%f,%d,%.2f\n" % (x,y,e,p)
    #     fh.write(s)
    # fh.close()

    #拷贝Shape文件
    #filename_input = "E:\\python temp\\spital data\\cntry98.shp"
    #spatialref,geomtype,geomlist,fieldlist,reclist = test.read_shp(filename_input)
    #filename_output = "E:\\python temp\\spital data\\cntry98_new.shp"
    #test.write_shp(filename_output,spatialref,geomtype,geomlist,fieldlist,reclist)

    #显示字段列表, 几何对象及属性值
    #len(fieldlist)
    #len(geomlist)
    #print spatialref.ExportToPrettyWkt()
    #print geomtype
    #print fieldlist[0]
    #print geomlist[0], reclist[0][fieldlist[0][ 'name']]
