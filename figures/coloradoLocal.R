
#----------------------------
# Install necessary packages
#----------------------------
if("devtools" %in% rownames(installed.packages()) == F){install.packages("devtools")}
library(devtools)
if("rgcam" %in% rownames(installed.packages()) == F){install_github(repo="JGCRI/rgcam")}
library(rgcam)
if("tibble" %in% rownames(installed.packages()) == F){install.packages("tibble")}
library(tibble)
if("dplyr" %in% rownames(installed.packages()) == F){install.packages("dlpyr")}
library(dplyr)
if("rgdal" %in% rownames(installed.packages()) == F){install.packages("rgdal")}
library(rgdal)
if("tmap" %in% rownames(installed.packages()) == F){install.packages("tmap")}
library(tmap)
if("rgeos" %in% rownames(installed.packages()) == F){install.packages("rgeos")}
library(rgeos)
if("tools" %in% rownames(installed.packages()) == F){install.packages("tools")}
library(tools)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("..")
dir_metis <- paste(getwd(), "metis_input", sep = '/')
countryName="Argentina"


# Plot 10 subregions in Colorado
localBasinShapeFileFolder = paste(dir_metis,"/dataFiles/gis/shapefiles_Argentina",sep="")
localBasinShapeFile = "ArgentinaLocalBasin_Corrected"
countryLocalBasin <-readOGR(dsn=localBasinShapeFileFolder,
                            layer=localBasinShapeFile,use_iconv=T,encoding='UTF-8')
localBasinsShapeFileColName = "cuenca" # Will need to load the file to see which name this would be
countryLocalBasin<-countryLocalBasin[(!countryLocalBasin$cuenca %in%
                                        c("media","baja","RioGrande","Barrancas")) & !is.na(countryLocalBasin$cuenca),]
countryLocalBasin@data <- droplevels(countryLocalBasin@data)
head(countryLocalBasin@data)
plot(countryLocalBasin)
writeOGR(obj=countryLocalBasin, dsn=paste(dir_metis,"/dataFiles/gis/shapefiles_",countryName,sep=""), layer=paste(countryName,"LocalBasin",sep=""), driver="ESRI Shapefile", overwrite_layer=TRUE)
metis.map(dataPolygon=countryLocalBasin,fillColumn = localBasinsShapeFileColName,printFig=F, facetsOn = F, labels=F)

colnames(countryLocalBasin@data)[colnames(countryLocalBasin@data) == localBasinsShapeFileColName] <- 'subRegion'


# subRegShpFolder_i = paste(dir_metis,"/dataFiles/gis/shapefiles_",countryName,sep = "")
# subRegShpFile_i = paste("colorado_10_subregions",sep= "") # localBasinShapeFile # paste("colombiaLocalBasin",sep= "")
subRegShape_i = countryLocalBasin
subRegCol_i = "subRegion" #localBasinsShapeFileColName  #
subRegType_i = "localBasin"
nameAppend_i = "_local"

scenario_name <- 'Reference'
polygonDataTables_i=paste(getwd(),"/outputs/Maps/Tables/griddedScarcity", '_', scenario_name, ".csv",sep="")
a1<-read.csv(polygonDataTables_i); head(a1); unique(a1$scenario); unique(a1$param); unique(a1$x)


xRange_i= seq(from=2000,to=2050,by=5)
legendPosition_i=c("LEFT","bottom")
legendOutsideSingle_i=T
animateOn_i=T
delay_i=100
scenRef_i="gfdl-esm2m_rcp2p6_NA_NA"
paramsSelect_i = c("All")
indvScenarios_i = "All"
GCMRCPSSPPol_i=F

scaleRange_i=data.frame(param=c("griddedScarcity"),
                        maxScale=c(1),
                        minScale=c(0))
numeric2Cat_param <- list("griddedScarcity","param2")
numeric2Cat_breaks <- list(c(-Inf, 0.1, 0.2, 0.4,Inf),c(0,1,2,3,4))
numeric2Cat_labels <- list(c("None (0<WSI<0.1)","Low (0.1<WSI<0.2)","Moderate (0.2<WSI<0.4)","Severe (WSI>0.4)"),
                           c("a","b","c","d"))
numeric2Cat_palette <- list(c("pal_ScarcityCat"),
                            #c("c('None (0<WSI<0.1)'='black','Low (0.1<WSI<0.2)'='blue','Moderate (0.2<WSI<0.4)'='purple','Severe (WSI>0.4)'='yellow')"),
                            c("Spectral")) # Can be a custom scale or an R brewer paletter or a metis.pal
numeric2Cat_legendTextSize <- list(c(0.7),c(NULL))
numeric2Cat_list <-list(numeric2Cat_param=numeric2Cat_param,
                        numeric2Cat_breaks=numeric2Cat_breaks,
                        numeric2Cat_labels=numeric2Cat_labels,
                        numeric2Cat_palette=numeric2Cat_palette,
                        numeric2Cat_legendTextSize=numeric2Cat_legendTextSize)

list_index <- which(numeric2Cat_list$numeric2Cat_param=="griddedScarcity")
catBreaks <- numeric2Cat_list$numeric2Cat_breaks[[list_index]]; catBreaks
catLabels <- numeric2Cat_list$numeric2Cat_labels[[list_index]]; catLabels
catPalette <- numeric2Cat_list$numeric2Cat_palette[[list_index]]; catPalette
catLegendTextSize <- numeric2Cat_list$numeric2Cat_legendTextSize[[list_index]];catLegendTextSize

boundaryRegShape_i = NULL
# boundaryRegShpFolder_i=paste(dir_metis,"/dataFiles/gis/naturalEarth",sep="")
# boundaryRegShpFile_i=paste("ne_10m_admin_0_countries",sep="")
boundaryRegCol_i="NAME"
boundaryRegionsSelect_i=countryName

# xRange=xRange_i,

metis.mapsProcess(polygonTable=polygonDataTables_i,
                 #gridDataTables=gridDataTables_i,
                 # boundaryRegShape=boundaryRegShape_i,
                 # boundaryRegShpFolder=boundaryRegShpFolder_i,
                 # boundaryRegShpFile=boundaryRegShpFile_i,
                 # boundaryRegCol=boundaryRegCol_i,
                 boundaryRegionsSelect=boundaryRegionsSelect_i,
                 subRegShape=subRegShape_i,
                 # subRegShpFolder=subRegShpFolder_i,
                 # subRegShpFile=subRegShpFile_i,
                 subRegCol=subRegCol_i,
                 subRegType=subRegType_i,
                 nameAppend=nameAppend_i,
                 legendOutsideSingle=legendOutsideSingle_i,
                 legendPosition=legendPosition_i,
                 animateOn=animateOn_i,
                 # delay=delay_i,
                 scenRef=scenRef_i,
                 extension=T,
                 expandPercent = 3,
                 figWidth=6,
                 figHeight=7,
                 paramsSelect = paramsSelect_i,
                 scaleRange = scaleRange_i,
                 # indvScenarios=indvScenarios_i,
                 # GCMRCPSSPPol=GCMRCPSSPPol_i,
                 multiFacetCols="scenarioRCP",
                 multiFacetRows="scenarioGCM",
                 legendOutsideMulti=T,
                 legendPositionMulti=NULL,
                 legendTitleSizeMulti=NULL,
                 legendTextSizeAnim=NULL,
                 legendTextSizeMulti=NULL,
                 # refGCM="gfdl-esm2m",
                 # refRCP="rcp2p6",
                 chosenRefMeanYears=c(2000:2050),
                 numeric2Cat_list=numeric2Cat_list)

