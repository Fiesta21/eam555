#******************************************************INFO*********************************************************************

#***********************************************************************SQL*****************************************************
#sqlplus apps/$APPSID @XX_SN876_INSTALL.sql
#*******************************************************************************************************************************

#***********************************************************************OAF*****************************************************

#oafCopyXML копирование  XML файлов
#1 Module
#2 Path
#3 File Name
#oafCopyVoXML  'PO' 'po/reqsummary/server' 'xxReqLinesVO.xml'

#oafJava компиляция java классов
#1 Module
#2 Path
#3 File Name
#oafJava  'PO' 'po/reqsummary/webui' 'XxphaReqSummaryCO.java'

# oafPersXMLImport копирование оаф персонализации
#1 Module
#2 Path
#3 File Name
#oafPersXMLImport  'PO' 'po/reqsummary/server/customizations/site/0' 'ReqLinesVO.xml'

# oafPageXMLImport копирование оаф страниц
#1 Module
#2 Path
#3 File Name
#oafPageXMLImport 'XXPHA'   'xxpha/custom/nsi125/request/webui'  'RequestInsertPG.xml'

# oafXMLImport копирование оаф регионов
#1 Module
#2 Path
#3 File Name
#oafXMLImport 'xxpha' 'xxpha/icx/icatalog/shopping/webui' 'HeaderRN.xml'

#*******************************************************************************************************************************

#********************************************************************************OTHERS*****************************************

# compile_pll  Копирование и компиляция .pll
#  $1 - имя pll
# compile_pll XXPHA_FN121_CUSTOM.pll

# download_extrafile загрузка дополнительный файлов необходимых для установки
#1 Project
#2 Module
#3 Path
#4 File Name
# download_extrafile 'OEBS_OAF' 'PO' 'po/reqsummary/server/customizations/site/0' 'ReqLinesVO.xml'  -- скачает файл в PO/po/reqsummary/server/customizations/site/0/

# Для загрузки шаблонов через XDOLoader - возможно использовать -JDBC_CONNECTION $AD_APPS_JDBC_URL
#if java oracle.apps.xdo.oa.util.XDOLoader UPLOAD \
#  -DB_USERNAME  apps \
#  -DB_PASSWORD  $APPSID \
#  -JDBC_CONNECTION $AD_APPS_JDBC_URL \
#  -LOB_TYPE TEMPLATE \
#  -APPS_SHORT_NAME XXPHA \
#  -LOB_CODE XXPHA_EAM541 \
#  -LANGUAGE  ru \
#  -TERRITORY RU \
#  -XDO_FILE_TYPE XSL-XML \
#  -FILE_CONTENT_TYPE 'xsl/xml' \
#  -FILE_NAME XX_EAM541_TEMPL.xsl \
#  -NLS_LANG Russian_CIS.CL8MSWIN1251 \
#  -CUSTOM_MODE FORCE
#then
#  echo "Upload of XML Publisher RU Template OK"
#else
#   echo "Failed Upload of XML Publisher RU Template"
#fi

# Для загрузки XDO DATA-TEMPLATE  через XDOLoader
#echo "..load XDO DATE_TEMPLATE"
#java oracle.apps.xdo.oa.util.XDOLoader UPLOAD \
#-DB_USERNAME apps \
#-DB_PASSWORD $APPSID \
#-JDBC_CONNECTION $AD_APPS_JDBC_URL \
#-LOB_TYPE DATA_TEMPLATE \
#-APPS_SHORT_NAME XXPHA \
#-LOB_CODE XXPHA_FN575 \
#-LANGUAGE ru \
#-TERRITORY RU \
#-TRANSLATE N \
#-XDO_FILE_TYPE XML-DATA-TEMPLATE \
#-FILE_CONTENT_TYPE 'text/xml' \
#-FILE_NAME XX_FN575_DT.xml \
#-NLS_LANG Russian_CIS.AL32UTF8 \
#-CUSTOM_MODE FORCE


# copy_rdf Копирование файлов с расширением "rdf"
#  $1 - имя rdf файла без расширения
#  copy_rdf XXPHA_PR214

# compile_form Копирование и компиляция формы
#  $1 - имя формы  без расширения
# compile_form XXPHA_PR214

#fnd_load обертка FNDLOAD
# $0 - TOP
# $1 - Конфигурационный файл .lct
# $2 - Файл данных .ldt
# $3 - доп. информация UPLOAD_MODE=REPLACE CUSTOM_MODE=FORCE
#  fnd_load $FND_TOP afffload.lct XXPHA_PR214_MES_SOURCE.ldt

# wf_load  обертка WFLOAD
#  $1 - имя файла
#  wf_load XX_NSI125





#*******************************************************************************************************************************

#==================================================================
#                           MAIN CODE
#==================================================================
echo "Enter APPS Password (Enter q to quit) : "
      read APPSID
echo "Start install..."
echo "Start installing sql... "
sqlplus apps/$APPSID @XX_eam555_REG.sql
sqlplus apps/$APPSID @XX_eam555_PKG.sql
sqlplus apps/$APPSID @XX_eam555_T.sql
sqlplus apps/$APPSID @XX_eam555_V.sql
 # Для загрузки шаблонов через XDOLoader
if java oracle.apps.xdo.oa.util.XDOLoader UPLOAD \
  -DB_USERNAME apps \
  -DB_PASSWORD $APPSID \
  -JDBC_CONNECTION $AD_APPS_JDBC_URL \
  -LOB_TYPE TEMPLATE \
  -APPS_SHORT_NAME XXPHA \
  -LOB_CODE XX_eam555 \
  -LANGUAGE ru \
  -TERRITORY RU \
  -TRANSLATE N \
  -XDO_FILE_TYPE XSL-XML \
  -FILE_CONTENT_TYPE 'xsl/xml' \
  -FILE_NAME XXPHA_eam555_TEMPL.xsl \
  -NLS_LANG Russian_CIS.CL8MSWIN1251 \
  -CUSTOM_MODE FORCE
then  
 echo "Upload of XML Publisher RU Template OK"
else  
 echo "Failed Upload of XML Publisher RU Template"
fi

echo "Installed  successfully..."