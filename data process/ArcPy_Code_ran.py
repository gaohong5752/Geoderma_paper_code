####2.样本点的栅格形式转矢量形式  point.tif ——> point.shp

import arcpy
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampTifFolder="E:\\officeFile\\aD4_9\\sampleCell_tif_777"
sampTifFile=getFileName(sampTifFolder,"tif")

sampShpFolder="E:\\officeFile\\aD4_9\\sampleCell_Shp_777"

#methodName=["fsMinSamp","hpRanSamp","randomSamp"]
methodName=["randomSamp11","randomSamp22","randomSamp33","randomSamp44","randomSamp55"]

files_num=1
for i in sampTifFile:
    for mn in methodName:
        if mn in i:
            #print "%s in %s"%(mn,i)
            try:
                arcpy.RasterToPoint_conversion(sampTifFolder+"\\"+i,sampShpFolder+"\\"+i[:-3]+"shp","VALUE")
                files_num +=1
            except:
                print "Sth's wrong:::%s" %i[:-4]
                continue
        
        if files_num>=10:
            mxd=arcpy.mapping.MapDocument('CURRENT')
            layers=arcpy.mapping.ListLayers(mxd)
            dfs=arcpy.mapping.ListDataFrames(mxd)
            for lay in layers:
                arcpy.mapping.RemoveLayer(dfs[0],lay)
            files_num=1

####3.1样本矢量数据按照不用方法、不同因子进行合并

import arcpy
import numpy as np
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampShpFolder="E:\\officeFile\\aD4_92\\sampleCell_Shp_666"
arcpy.env.workspace=sampShpFolder
sampShpFile=getFileName(sampShpFolder,"shp")

methodName=["randomsamp1","randomsamp2","randomsamp3","randomsamp4","randomsamp5"]

soil=np.unique([i.split("_")[0] for i in sampShpFile if not("merge" in i) and not("points" in i)])

shpfile_n3=sampShpFile

files_num=1
for si in soil:
    for mn in methodName:
        soilCode=si.lower()
        soilCodeName=[]   
        ranNum=mn[len(mn)-1]
        for j in shpfile_n3:
            if soilCode+"_" in j and mn in j:
                soilCodeName.append(j)
        if len(soilCodeName)>0:
            print soilCodeName
            arcpy.Merge_management(soilCodeName,soilCode+"_merge_ran%s.shp"%ranNum)
            files_num += 1
        
        if files_num>=8:
            mxd=arcpy.mapping.MapDocument('CURRENT')
            layers=arcpy.mapping.ListLayers(mxd)
            dfs=arcpy.mapping.ListDataFrames(mxd)
            for lay in layers:
                arcpy.mapping.RemoveLayer(dfs[0],lay)
            files_num=1


######3.2  将3.1得出的合并后的样点添加对应的土壤类型字段属性,最后整体合并

import arcpy
import numpy as np
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampShpFolder="E:\\officeFile\\aD4_92\\sampleCell_Shp_666"

arcpy.env.workspace=sampShpFolder
sampShpFile=getFileName(sampShpFolder,"shp")
soil=np.unique([i.split("_")[0] for i in sampShpFile if not("merge" in i) and not("points" in i)])

methodName=["ran1","ran2","ran3","ran4","ran5"]  

merge_fn=[i for i in sampShpFile if "merge" in i ]

files_num=1


for t in merge_fn:
    for si in soil:
        for mn in methodName:
            soilCode=si.lower()         
            if soilCode+"_" in t and mn in t:
                print t
                arcpy.AddField_management(t,"soil_code","SHORT")
                arcpy.CalculateField_management(t,"soil_code",'"%s"'%int(soilCode[1:]))
                files_num += 1
            
            
            if files_num>=8:
                mxd=arcpy.mapping.MapDocument('CURRENT')
                layers=arcpy.mapping.ListLayers(mxd)
                dfs=arcpy.mapping.ListDataFrames(mxd)
                for lay in layers:
                    arcpy.mapping.RemoveLayer(dfs[0],lay)
                files_num=1

for mn in methodName:
    mn_file=[i for i in merge_fn if mn in i]
    print mn_file
    arcpy.Merge_management(mn_file,mn+"_points.shp")

shpFile=getFileName(sampShpFolder,"shp")
point_file=[i for i in shpFile if "_points" in i]
for pf in point_file:
    arcpy.DeleteField_management(pf,["GRID_CODE","POINTID"])


###对土壤类型随机的处理
import arcpy
import numpy as np
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampShpFolder="E:\\officeFile\\aD4_9\\sampleCell_Shp_777"

arcpy.env.workspace=sampShpFolder
sampShpFile=getFileName(sampShpFolder,"shp")
soil=np.unique([i.split("_")[0] for i in sampShpFile])

#methodName=["dem","planc","rsp","slope","lsf","twi","vd"]    ##pca
methodName=["randomsamp11","randomsamp22","randomsamp33","randomsamp44","randomsamp55"]

files_num=1
merge_fn_hp=[i for i in sampShpFile if "randomsamp" in i]
for t in merge_fn_hp:
    for si in soil:
        for mn in methodName:
            soilCode=si.lower()         
            if soilCode+"_" in t and mn in t:
                #print t
                arcpy.AddField_management(t,"soil_code","SHORT")
                arcpy.CalculateField_management(t,"soil_code",'"%s"'%int(soilCode[1:]))
                files_num += 1
            
            if files_num>=10:
                mxd=arcpy.mapping.MapDocument('CURRENT')
                layers=arcpy.mapping.ListLayers(mxd)
                dfs=arcpy.mapping.ListDataFrames(mxd)
                for lay in layers:
                    arcpy.mapping.RemoveLayer(dfs[0],lay)
                files_num=1

for mn in methodName:
    mn_file=[i for i in merge_fn_hp if mn in i]
    print mn_file
    arcpy.Merge_management(mn_file,mn+"_points.shp")
    
shpFile=getFileName(sampShpFolder,"shp")
point_file=[i for i in shpFile if "_points" in i]
for pf in point_file:
    arcpy.DeleteField_management(pf,["GRID_CODE","POINTID"]) 






import arcpy
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampTifFolder="E:\\officeFile\\aD4_8\\sampleCell_tif_PCAmerge_5"
sampTifFile=getFileName(sampTifFolder,"tif")

sampShpFolder="E:\\officeFile\\aD4_8\\sampleCell_Shp_PCAmerge_5"

#methodName=["fsMinSamp","hpRanSamp","randomSamp"]
#methodName=["randomSamp1","randomSamp2","randomSamp3","randomSamp4","randomSamp5"]
methodName=["hpRanSamp"]

files_num=1
for i in sampTifFile:
    for mn in methodName:
        if mn in i:
            #print "%s in %s"%(mn,i)
            try:
                arcpy.RasterToPoint_conversion(sampTifFolder+"\\"+i,sampShpFolder+"\\"+i[:-3]+"shp","VALUE")
                files_num +=1
            except:
                print "Sth's wrong:::%s" %i[:-4]
                continue
        
        if files_num>=8:
            mxd=arcpy.mapping.MapDocument('CURRENT')
            layers=arcpy.mapping.ListLayers(mxd)
            dfs=arcpy.mapping.ListDataFrames(mxd)
            for lay in layers:
                arcpy.mapping.RemoveLayer(dfs[0],lay)
            files_num=1