#
#  用单个图斑提取SNA的结果
from arcpy import env
from arcpy.sa import *

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

tif_fileFolder="E:\\otherWork\\02_1\\soil2019-rewrite\\EnFactor_NSresult"
tif_file_all=getFileName(tif_fileFolder,"tif")

#myfactor=["DEM","Slope","PlanC","ProfileC","TWI"]
#myfactor=["RSP","LSF","VD"]
myfactor=["PCA3","PCA6","PCA8"]

factorName=[]
for tfa in tif_file_all:
	for mf in myfactor:
		if mf in tfa:
			factorName.append(tfa)

targetFolder="E:\\otherWork\\02_1\\soil2019-rewrite\\SNAresult_ClipBySingleShp\\"

shp_fileFolder="E:\\otherWork\\02_1\\soil2019-rewrite\\SingleShp_BT100m2"
shpName=getFileName(shp_fileFolder,"shp")

files_num=1
for i in factorName:
    for j in shpName:       
        try:
            ExtractByMask(tif_fileFolder+"\\"+i, shp_fileFolder+"\\"+j).save(targetFolder+i[0:-4]+"_"+j[0:-4]+".tif")
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

###  栅格样点转矢量，并添加土壤类型字段，并进行合并。

###SNA的方法
import arcpy

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

pTif_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\SNApoint_tifSelectByPercent"
pTif_fn = getFileName(pTif_folder,"tif")



#factor_set=["DEM","Slope","PlanC","ProfileC","TWI"]
#neiSize_set=["NS3","NS5"]
#percentNum_set=["pen15","pen30","pen45","pen60","pen75"]

pShp_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\SNApoint_ShpSelectByPercent"

factor="PCA"
neiSize="NS3"
#percentNum="pen15"


percentNum_set=["pen15","pen30","pen45"]
#percentNum_set=["pen60","pen75"]

for percentNum in percentNum_set:

	pTif_fn_target=[i for i in pTif_fn if "pSNA" in i and factor in i and neiSize in i and percentNum in i]

	files_num=1
	for ptf in pTif_fn_target:
		arcpy.RasterToPoint_conversion(pTif_folder+"\\"+ptf,pShp_folder+"\\"+ptf[:-3]+"shp","VALUE")

		#soilName=ptf.split("_")[3]

		arcpy.AddField_management(pShp_folder+"\\"+ptf[:-3]+"shp", "soilID", "TEXT")
		arcpy.CalculateField_management(ptf[:-3]+"shp","soilID",int(ptf.split("_")[3][1:]))

		files_num = files_num + 1

		if files_num>=5:
	                mxd=arcpy.mapping.MapDocument('CURRENT')
	                layers=arcpy.mapping.ListLayers(mxd)
	                dfs=arcpy.mapping.ListDataFrames(mxd)
	                for lay in layers:
	                    arcpy.mapping.RemoveLayer(dfs[0],lay)
	                files_num=1

	pShp_fn=getFileName(pShp_folder,"shp")

	pShp_fn_target=[i for i in pShp_fn if "pSNA".lower() in i and factor.lower() in i and neiSize.lower() in i and percentNum.lower() in i]

	if len(pShp_fn_target)>0:
		arcpy.Merge_management([pShp_folder+"\\"+psft for psft in pShp_fn_target],pShp_folder+"\\"+"All_pSNA_%s_%s_%s.shp"%(factor,neiSize,percentNum))

	arcpy.DeleteField_management(pShp_folder+"\\"+"All_pSNA_%s_%s_%s.shp"%(factor,neiSize,percentNum),["GRID_CODE","POINTID"])

	del pTif_fn_target

################################

###RAN的方法
import arcpy

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

pTif_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\RANpoint_tifSelectByPercent"
pTif_fn = getFileName(pTif_folder,"tif")



#factor_set=["DEM","Slope","PlanC","ProfileC","TWI"]
#neiSize_set=["NS3","NS5"]
#percentNum_set=["pen15","pen30","pen45","pen60","pen75"]

pShp_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\RANpoint_ShpSelectByPercent"

factor="PCA"
neiSize="NS3"
#percentNum="pen15"


#percentNum_set=["pen15","pen30","pen45"]
percentNum_set=["pen60","pen75"]

for percentNum in percentNum_set:

	pTif_fn_target=[i for i in pTif_fn if "pRAN" in i and factor in i and neiSize in i and percentNum in i]

	files_num=1
	for ptf in pTif_fn_target:
		arcpy.RasterToPoint_conversion(pTif_folder+"\\"+ptf,pShp_folder+"\\"+ptf[:-3]+"shp","VALUE")

		#soilName=ptf.split("_")[3]

		arcpy.AddField_management(pShp_folder+"\\"+ptf[:-3]+"shp", "soilID", "TEXT")
		arcpy.CalculateField_management(ptf[:-3]+"shp","soilID",int(ptf.split("_")[3][1:]))

		files_num = files_num + 1

		if files_num>=5:
	                mxd=arcpy.mapping.MapDocument('CURRENT')
	                layers=arcpy.mapping.ListLayers(mxd)
	                dfs=arcpy.mapping.ListDataFrames(mxd)
	                for lay in layers:
	                    arcpy.mapping.RemoveLayer(dfs[0],lay)
	                files_num=1

	pShp_fn=getFileName(pShp_folder,"shp")

	pShp_fn_target=[i for i in pShp_fn if "pRAN".lower() in i and factor.lower() in i and neiSize.lower() in i and percentNum.lower() in i]

	if len(pShp_fn_target)>0:
		arcpy.Merge_management([pShp_folder+"\\"+psft for psft in pShp_fn_target],pShp_folder+"\\"+"All_pRAN_%s_%s_%s.shp"%(factor,neiSize,percentNum))

	arcpy.DeleteField_management(pShp_folder+"\\"+"All_pRAN_%s_%s_%s.shp"%(factor,neiSize,percentNum),["GRID_CODE","POINTID"])

	del pTif_fn_target


###RANst的方法
import arcpy

def getFileName(foldername,filter):
    import os
    filename_re=[]
    for fn in os.listdir(foldername):
        if fn[-3:]==filter:
            filename_re.append(fn)
    return filename_re

pTif_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\RAN_soiltype_tifPoint"
pTif_fn = getFileName(pTif_folder,"tif")
#pTif_fn=pTif_fn[0:1]

pShp_folder="E:\\otherWork\\02_1\\soil2019-rewrite\\RAN_soiltype_shpPoint"

files_num=1
for ptf in pTif_fn:

	arcpy.RasterToPoint_conversion(pTif_folder+"\\"+ptf,pShp_folder+"\\All_"+ptf[:-3]+"shp","VALUE")
	
	arcpy.AddField_management(pShp_folder+"\\All_"+ptf[:-3]+"shp", "soilID", "TEXT")
	arcpy.CalculateField_management(pShp_folder+"\\All_"+ptf[:-3]+"shp","soilID","[GRID_CODE]")

	arcpy.DeleteField_management(pShp_folder+"\\All_"+ptf[:-3]+"shp",["GRID_CODE","POINTID"])

	files_num = files_num + 1

	if files_num>=5:
        mxd=arcpy.mapping.MapDocument('CURRENT')
        layers=arcpy.mapping.ListLayers(mxd)
        dfs=arcpy.mapping.ListDataFrames(mxd)
        for lay in layers:
            arcpy.mapping.RemoveLayer(dfs[0],lay)
        files_num=1









