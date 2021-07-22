
###1.1-利用土壤类型的图斑提取环境因子栅格图层
from arcpy import env
from arcpy.sa import *

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

tif_fileFolder="E:\\officeFile\\aD4_6\\Factors"

#factorName=["DEM.tif","PlanC.tif","RSP.tif","Slope.tif","LSF.tif","TWI.tif","VD.tif"]  #pca

factorName=["pca73.tif","pca33.tif"]

shp_fileFolder="E:\\soiltype_shp"
shpName=getFileName(shp_fileFolder,"shp")


targetFolder="E:\\officeFile\\aD4_6\\Factors_Clip_pca"

files_num=1
for i in factorName:
    for j in shpName:       
        try:
            ExtractByMask(tif_fileFolder+"\\"+i, shp_fileFolder+"\\"+j).save(targetFolder+"\\"+i[0:-4]+"_"+j[0:-4]+".tif")
            files_num+=1
        except:
            print "Sth's wrong!!",i[0:-4],j[0:-4]
            continue
        
        if files_num==10:
            mxd=arcpy.mapping.MapDocument('CURRENT')
            layers=arcpy.mapping.ListLayers(mxd)
            dfs=arcpy.mapping.ListDataFrames(mxd)
            for lay in layers:
                arcpy.mapping.RemoveLayer(dfs[0],lay)




####1.2-用土壤类型的单个图斑提取

from arcpy import env
from arcpy.sa import *

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

#tif_fileFolder="E:\\officeFile\\aD4_6\\Factors_FS_pca"
##factorName=getFileName(tif_fileFolder,"tif")
#factorName=["pca73_fs_3.tif","pca73_fs_5.tif","pca33_fs_3.tif","pca33_fs_5.tif"]
#targetFolder="E:\\officeFile\\aD4_6\\FS_Clip_multiPCA"

tif_fileFolder="E:\\officeFile\\aD4_6\\Factors"
factorName=["DEM.tif","PlanC.tif","RSP.tif","Slope.tif","LSF.tif","TWI.tif","VD.tif"]  #pca

targetFolder="E:\\officeFile\\aD4_7\\Factors_singleShp_Clip"

shp_fileFolder="E:\\officeFile\\aD4_6\\singleShp"
shpName=getFileName(shp_fileFolder,"shp")

files_num=1
for i in factorName:
    for j in shpName:       
        try:
            ExtractByMask(tif_fileFolder+"\\"+i, shp_fileFolder+"\\"+j).save(targetFolder+"\\"+i[0:-4]+"_"+j[0:-4]+".tif")
            files_num+=1
        except:
            print "Sth's wrong!!",i[0:-4],j[0:-4]
            continue
        
        if files_num==10:
            mxd=arcpy.mapping.MapDocument('CURRENT')
            layers=arcpy.mapping.ListLayers(mxd)
            dfs=arcpy.mapping.ListDataFrames(mxd)
            for lay in layers:
                arcpy.mapping.RemoveLayer(dfs[0],lay)
            files_num=1 


####2.样本点的栅格形式转矢量形式  point.tif ——> point.shp

import arcpy
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

nei=5
nei_inFn="_N%s"%nei

sampTifFolder="E:\\officeFile\\aD4_92\\sampleCell_tif_5"
sampTifFile=getFileName(sampTifFolder,"tif")

sampShpFolder="E:\\officeFile\\aD4_92\\sampleCell_Shp_5"

#sampTifFile=[i for i in sampTifFile if nei_inFn in i]
#sampTifFile.sort()

#methodName=["fsMinSamp","hpRanSamp","randomSamp"]
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
        
        if files_num>=10:
            mxd=arcpy.mapping.MapDocument('CURRENT')
            layers=arcpy.mapping.ListLayers(mxd)
            dfs=arcpy.mapping.ListDataFrames(mxd)
            for lay in layers:
                arcpy.mapping.RemoveLayer(dfs[0],lay)
            files_num=1

####3.1两种邻域确定的样本矢量数据按照不用方法、不同因子进行合并

import arcpy
import numpy as np
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampShpFolder="E:\\officeFile\\aD4_92\\sampleCell_Shp_0"
arcpy.env.workspace=sampShpFolder
sampShpFile=getFileName(sampShpFolder,"shp")

methodName=["dem","planc","rsp","slope","lsf","twi","vd","pca73","pca33"] 
#methodName=["fsminsamp_n3","fsminsamp_n5"]
#methodName=["pca73"]

soil=np.unique([i.split("_")[0] for i in sampShpFile if not("merge" in i)])


shpfile_n3=[i for i in sampShpFile if "_n5" in i]

files_num=1
for si in soil:
    for mn in methodName:
        soilCode=si.lower()
        soilCodeName=[]   
        for j in shpfile_n3:
            if soilCode+"_" in j and mn in j:
                soilCodeName.append(j)
        if len(soilCodeName)>0:
            print soilCodeName
            arcpy.Merge_management(soilCodeName,mn+"_"+soilCode+"_merge_n5.shp")
            files_num += 1
        
        if files_num>=10:
            mxd=arcpy.mapping.MapDocument('CURRENT')
            layers=arcpy.mapping.ListLayers(mxd)
            dfs=arcpy.mapping.ListDataFrames(mxd)
            for lay in layers:
                arcpy.mapping.RemoveLayer(dfs[0],lay)
            files_num=1




shpfile_n5=[i for i in sampShpFile if "_fs_5_" in i]

files_num=1
for si in soil:
    for mn in methodName:
        soilCode=si.lower()
        soilCodeName=[]   
        for j in shpfile_n5:
            if soilCode+"_" in j and mn in j:
                soilCodeName.append(j)
        if len(soilCodeName)>0:
            print soilCodeName
            arcpy.Merge_management(soilCodeName,mn+"_"+soilCode+"_merge_n5.shp")
            files_num += 1
        
        if files_num>=20:
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

sampShpFolder="E:\\officeFile\\aD4_92\\sampleCell_Shp_0"

arcpy.env.workspace=sampShpFolder
sampShpFile=getFileName(sampShpFolder,"shp")
soil=np.unique([i.split("_")[1] for i in sampShpFile if "merge" in i])

#methodName=["dem","planc","rsp","slope","lsf","twi","vd"]    ##pca
#methodName=["dem","vdtcn","lsf","slope","rsp","vd","fa"]      ##RF

methodName=["dem","planc","rsp","slope","lsf","twi","vd","pca73","pca33"]

files_num=1

merge_fn_n3=[i for i in sampShpFile if "merge" in i and "_n5" in i ]
for t in merge_fn_n3:
    for si in soil:
        for mn in methodName:
            soilCode=si.lower()         
            if soilCode+"_" in t and mn in t:
                #print t
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
    mn_file=[i for i in merge_fn_n3 if mn in i]
    print mn_file
    arcpy.Merge_management(mn_file,mn+"_points_n5.shp")

shpFile=getFileName(sampShpFolder,"shp")
point_file=[i for i in shpFile if "_points_n5" in i]
for pf in point_file:
    arcpy.DeleteField_management(pf,["GRID_CODE","POINTID"])







#####   n5

merge_fn_n5=[i for i in sampShpFile if "merge" in i and "_n5" in i ]
for t in merge_fn_n5:
    for si in soil:
        for mn in methodName:
            soilCode=si.lower()         
            if soilCode+"_" in t and mn in t:
                print t
                arcpy.AddField_management(t,"soil_code","SHORT")
                arcpy.CalculateField_management(t,"soil_code",'"%s"'%int(soilCode[1:]))
                files_num += 1
            
            
            if files_num>=20:
                mxd=arcpy.mapping.MapDocument('CURRENT')
                layers=arcpy.mapping.ListLayers(mxd)
                dfs=arcpy.mapping.ListDataFrames(mxd)
                for lay in layers:
                    arcpy.mapping.RemoveLayer(dfs[0],lay)
                files_num=1

for mn in methodName:
    mn_file=[i for i in merge_fn_n5 if mn in i]
    print mn_file
    arcpy.Merge_management(mn_file,mn+"_points_n5.shp")

shpFile=getFileName(sampShpFolder,"shp")
point_file=[i for i in shpFile if "_points_n5" in i]
for pf in point_file:
    arcpy.DeleteField_management(pf,["GRID_CODE","POINTID"])


### 4 HP 和 RA方法 的点矢量数据进添加土壤类型字段、并进行整体合并。

import arcpy
import numpy as np
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampShpFolder="E:\\officeFile\\aD4_92\\sampleCell_Shp_5"

arcpy.env.workspace=sampShpFolder
sampShpFile=getFileName(sampShpFolder,"shp")
soil=np.unique([i.split("_")[1] for i in sampShpFile])

#methodName=["dem","planc","rsp","slope","lsf","twi","vd"]    ##pca
methodName=["dem","planc","rsp","slope","lsf","twi","vd","pca73","pca33"]

files_num=1
merge_fn_hp=[i for i in sampShpFile if "hpransamp" in i]
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
    #print mn_file
    arcpy.Merge_management(mn_file,mn+"_points_hp.shp")
    
shpFile=getFileName(sampShpFolder,"shp")
point_file=[i for i in shpFile if "_points_hp" in i]
for pf in point_file:
    arcpy.DeleteField_management(pf,["GRID_CODE","POINTID"]) 
    




files_num=1
merge_fn_hp=[i for i in sampShpFile if "randomsamp" in i]
for t in merge_fn_hp:
    for si in soil:
        for mn in methodName:
            soilCode=si.lower()         
            if soilCode+"_" in t and mn in t:
                print t
                arcpy.AddField_management(t,"soil_code","SHORT")
                arcpy.CalculateField_management(t,"soil_code",'"%s"'%int(soilCode[1:]))
                files_num += 1
            
            if files_num>=20:
                mxd=arcpy.mapping.MapDocument('CURRENT')
                layers=arcpy.mapping.ListLayers(mxd)
                dfs=arcpy.mapping.ListDataFrames(mxd)
                for lay in layers:
                    arcpy.mapping.RemoveLayer(dfs[0],lay)
                files_num=1

for mn in methodName:
    mn_file=[i for i in merge_fn_hp if mn in i]
    print mn_file
    arcpy.Merge_management(mn_file,mn+"_points_ran.shp")
    
shpFile=getFileName(sampShpFolder,"shp")
point_file=[i for i in shpFile if "_points_ran" in i]
for pf in point_file:
    arcpy.DeleteField_management(pf,["GRID_CODE","POINTID"]) 

###### 5.1 将采用union方法综合的NA矢量样本添加环境因子属性，添加后按土壤类型合并，
######    合并后再添加对应的土壤类型属性，添加后整体合并。

import arcpy
import numpy as np
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampShpFolder="E:\\officeFile\\aD4_7\\samplePoint_shp_multiNA"
arcpy.env.workspace=sampShpFolder
sampShpFile=getFileName(sampShpFolder,"shp")

methodName=["twi","planc","slope"]  

soil=np.unique([i.split("_")[0] for i in sampShpFile])

nei="_n5"

shpfile=[i for i in sampShpFile if nei in i]

files_num=1
for si in soil:
    soilCode=si.lower()
    soilCodeName=[]
    for mn in methodName:
        for j in shpfile:
            if soilCode+"_" in j and mn in j :
                soilCodeName.append(j)
                arcpy.AddField_management(j,"factor","TEXT")
                arcpy.CalculateField_management(j,"factor",'"%s"'%mn)
                files_num += 1
        
            if files_num>=10:
                mxd=arcpy.mapping.MapDocument('CURRENT')
                layers=arcpy.mapping.ListLayers(mxd)
                dfs=arcpy.mapping.ListDataFrames(mxd)
                for lay in layers:
                    arcpy.mapping.RemoveLayer(dfs[0],lay)
                files_num=1
    
    if len(soilCodeName)>0:
        print soilCodeName
        arcpy.Merge_management(soilCodeName,soilCode+"_merge%s.shp"%nei)
        arcpy.AddField_management(soilCode+"_merge%s.shp"%nei,"soil_code","SHORT")
        arcpy.CalculateField_management(soilCode+"_merge%s.shp"%nei,"soil_code",'"%s"'%int(soilCode[1:]))
        arcpy.DeleteField_management(soilCode+"_merge%s.shp"%nei,["GRID_CODE","POINTID"]) 
        files_num += 1
        
        if files_num>=10:
                mxd=arcpy.mapping.MapDocument('CURRENT')
                layers=arcpy.mapping.ListLayers(mxd)
                dfs=arcpy.mapping.ListDataFrames(mxd)
                for lay in layers:
                    arcpy.mapping.RemoveLayer(dfs[0],lay)
                files_num=1

sampShpFile=getFileName(sampShpFolder,"shp")
soil_merge=[i for i in sampShpFile if "_merge" in i]
arcpy.Merge_management(soil_merge,"unionNA_%s.shp"%nei)


#####  5.2 将采用pca方法综合的NA矢量样本添加环境因子属性，添加后按土壤类型合并，
######    合并后再添加对应的土壤类型属性，添加后整体合并。

import arcpy
import numpy as np
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

sampShpFolder="E:\\officeFile\\aD4_7\\samplePoint_shp_multiPCA"

arcpy.env.workspace=sampShpFolder
sampShpFile=getFileName(sampShpFolder,"shp")

soil=['s1', 's20', 's21', 's23', 's3', 's30', 's31', 's501', 's502','s503', 's7']

methodName=["pca73","pca33"]

nei="_n5"

shpfile=[i for i in sampShpFile if nei in i]

files_num=1
for si in soil:
    soilCode=si.lower()
    for mn in methodName:
        soilCodeName=[]
        for j in shpfile:
            if soilCode+"_" in j and mn in j :
                soilCodeName.append(j)
    
        if len(soilCodeName)>0:
            print soilCodeName
            arcpy.Merge_management(soilCodeName,soilCode+"_merge_%s%s.shp"%(mn,nei))
            arcpy.AddField_management(soilCode+"_merge_%s%s.shp"%(mn,nei),"soil_code","SHORT")
            arcpy.CalculateField_management(soilCode+"_merge_%s%s.shp"%(mn,nei),"soil_code",'"%s"'%int(soilCode[1:]))
            arcpy.DeleteField_management(soilCode+"_merge_%s%s.shp"%(mn,nei),["GRID_CODE","POINTID"]) 
            files_num += 1
        
            if files_num>=10:
                    mxd=arcpy.mapping.MapDocument('CURRENT')
                    layers=arcpy.mapping.ListLayers(mxd)
                    dfs=arcpy.mapping.ListDataFrames(mxd)
                    for lay in layers:
                        arcpy.mapping.RemoveLayer(dfs[0],lay)
                    files_num=1

sampShpFile=getFileName(sampShpFolder,"shp")
soil_merge=[i for i in sampShpFile if "_merge_" in i and nei in i]
for mn in methodName:
    soil_m=[i for i in soil_merge if mn in i]
    print soil_m
    arcpy.Merge_management(soil_m,"multiNA_%s%s.shp"%(mn,nei))


#####  5.3 将采用union方法综合的hp矢量样本添加环境因子属性，添加后按土壤类型合并，
######    合并后再添加对应的土壤类型属性，添加后整体合并。

import arcpy
from arcpy.sa import *
def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

point_shp_folder="E:\\officeFile\\ad3\\articleData3_2\\process_tif\\sampleCell_shp"

arcpy.env.workspace=point_shp_folder

ps_file=getFileName(point_shp_folder,"shp")

mm="hpransamp"
factor=["dem","slope"]
factor_folder="E:\\officeFile\\ad3\\Factors\\"

ps_file=[i for i in ps_file if mm in i]


for psf in ps_file:
    if "dem" in psf:
        ExtractMultiValuesToPoints(psf, [[factor_folder+"DEM.tif", "DEM"]], "NONE")
    if "slope" in psf:
        ExtractMultiValuesToPoints(psf, [[factor_folder+"Slope.tif", "Slope"]], "NONE")
