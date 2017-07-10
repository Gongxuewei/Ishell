#!/bin/bash
BINDIR=$(cd "$(dirname "$0")"; pwd)
LOCAL_WORKDIR=${BINDIR%/*}
LIST_CONF="${BINDIR%/*}/conf/yt.list"
LOCALE_TMP_DIR="/opt/ftpuser"
LINE="--------------------------------------------------------"
clear
echo  "+${LINE}"
echo  "|餐饮项目:"
echo  "|CY-BACK   ==>   snailf-foods-merchant-manager-web.war"
echo  "|CY-BACK   ==>   snailf-foods-system-manager-web.war"
echo  "|CY-BACK   ==>   snailf-manage-foods-boot-service.jar"
echo  "|CY-BOSS   ==>   snailf-foods-boss-api.war"
echo  "|CY-BOSS   ==>   snailf-foods-boss-boot-service.jar"
echo  "|CY-FRONT  ==>   snailf-foods-api.war"
echo  "|CY-FRONT  ==>   snailf-foods-boot-service.jar"
echo  "|CY-WXDC   ==>   snailf-foods-wechat-api.war"
echo  "|YM-WXDC   ==>   snailf-foods-wechat-ym-api.war"
echo  "|"
echo  "|欢洗项目:"
echo  "|HX-BACK   ==>   snailf-manage-pubservice.jar"
echo  "|HX-BACK   ==>   snailf-manage-retail-goods.jar"
echo  "|HX-BACK   ==>   snailf-manage-retail-order.jar"
echo  "|HX-FRONT  ==>   snailf-mobile-pos-api.war"
echo  "|HX-FRONT  ==>   snailf-pubservice-boot-service.jar"
echo  "|HX-FRONT  ==>   snailf-retail-goods.jar"
echo  "|CASHER    ==>   snailf-cashier-api.war"
echo  "|"
echo  "|平台项目:"
echo  "|PT-BACK   ==>   snailf-merchant-manager-web.war"
echo  "|PT-BACK   ==>   snailf-platform-manage-boot-service.jar"
echo  "|PT-BACK   ==>   snailf-system-manager-web.war"
echo  "|PT-FRONT  ==>   snailf-huanxin-push-service.jar"
echo  "|PT-FRONT  ==>   snailf-mqconsumers-service.jar"
echo  "|PT-FRONT  ==>   snailf-platform-boot-service.jar"
echo  "|PT-FRONT  ==>   snailf-shopping-cart.jar"
echo  "|"
echo  "|其他项目:"
echo  "|REPORT    ==>   snailf-report-data-cache.jar"
echo  "|third_api ==>   cloud-fintech-third-api.war"
echo  "|third_api ==>   cloud-fintech-platform-boot-service.jar"
echo  "|p_test    ==>   cloud-fintech-platform-boot-service.jar"
echo  "|p_test    ==>   cloud-fintech-platform-pay-api.war"
echo  "|p_test    ==>   cloud-fintech-platform-pay-notify-api.war"
echo  "+${LINE}"

if [ $# -ne 1 ] ; then
           echo ""
           echo "useAge:sh `basename $0` ftp_dir"
           echo ""
           exit 11
fi

if [[ -d ${LOCALE_TMP_DIR}/${1#/*} ]]; then
           FTP_DIR="/${1#/*}"
      else
           echo ""
           echo "Dir:\"${LOCALE_TMP_DIR}/${1#/*}\" is not exist !"
           echo ""
           exit 11
fi

cut_config_file () { 
          ftp_dir=$1
          local_app_name=$2
          list_tmp=$3
          TARGET_IP=`echo ${list_tmp}|awk -F ":" '{print $2}'`
          TARGET_USER=`echo ${list_tmp}|awk -F ":" '{print $3}'`
          TARGET_APP_DIR_APPNAME=`echo ${list_tmp}|awk -F ":" '{print $4}'`
          TARGET_KEYWORD_MTOBE=`echo ${list_tmp}|awk -F ":" '{print $5}'`
          FFFLG=`echo ${list_tmp}|awk -F ":" '{print $6}'`
          TARGET_SCRIPT_DIR=`echo "${TARGET_APP_DIR_APPNAME}"|awk -F "/" '{print "/"$2"/"$3}'`
          TARGET_DIR_SCRIPT="${TARGET_SCRIPT_DIR}/up_cl_dir/bin/test.sh"
          LOCAL_TARGET_DIR_APPNAME=`find    ${LOCALE_TMP_DIR}${ftp_dir} -type f -name "${local_app_name}"`
}

echo ""
read -p "Please enter the application name(LOCAL_APP_NAME):" LOCAL_APP_NAME
if [[ x${LOCAL_APP_NAME} != x ]]; then
           LIST_TMP=`cat ${LIST_CONF} |grep -v "#"|grep -v "^$"|grep -w "${LOCAL_APP_NAME}"`
           if [[ x${LIST_TMP} != x ]] ; then
                             for  i  in  ${LIST_TMP}  
                             do            
                                           cut_config_file ${FTP_DIR} ${LOCAL_APP_NAME} ${i}
                                           if [ ${LOCAL_APP_NAME##*\.} == "jar" ] ; then
                                                            TARGET_KEYWORD=${LOCAL_APP_NAME}
                                                        else
                                                            TARGET_KEYWORD=${TARGET_KEYWORD_MTOBE}
                                           fi

                                           if [ ! -d "${LOCAL_WORKDIR}/${LOCAL_APP_NAME}" ] ; then
                                                            mkdir -p   ${LOCAL_WORKDIR}/${LOCAL_APP_NAME}
                                           fi

                                           if [ x"${LOCAL_TARGET_DIR_APPNAME}" != x ] && [ -f "${LOCAL_TARGET_DIR_APPNAME}" ] ; then
                                                            echo ""
                                                            echo "Copy the target file to the local working directory:"
                                                            rm   -fr  ${LOCAL_WORKDIR}/${LOCAL_APP_NAME}/*
                                                            cp   -v   ${LOCAL_TARGET_DIR_APPNAME}   ${LOCAL_WORKDIR}/${LOCAL_APP_NAME}/
                                                        else
                                                            echo ""
                                                            echo "\"${LOCALE_TMP_DIR}${FTP_DIR%*/}/${LOCAL_APP_NAME}\"  is not exist, exit !"
                                                            echo ""
                                                            exit 13
                                           fi

                                           echo ""
                                           
                                           read -p "Do you want to update the package \"${TARGET_IP} ${LOCAL_APP_NAME}\"? (Y/N):" YN
                                           case ${YN} in
                                                 Y|y)
                                                  sh  ${BINDIR}/jenshell.sh  ${TARGET_IP}  ${TARGET_USER} ${TARGET_DIR_SCRIPT}   ${LOCAL_APP_NAME} ${TARGET_APP_DIR_APPNAME} ${TARGET_KEYWORD}  ${FFFLG}  
                                               ;;
                                                 N|n)
                                                  echo ""
                                                  echo "The package \"${LOCAL_APP_NAME}\" not updated, exit"
                                                  echo ""
                                                  #exit  21
                                               ;;
                                                 *)
                                                  echo ""
                                                  echo "Please enter \"Y\" or \"N\""
                                                  echo ""
                                                  #exit  22
                                           esac
                             done                            
                        else
                            echo "\"${LOCAL_APP_NAME}\" is not in ${BINDIR%/*}/conf/t.list"
                            echo ""
                            exit 12
            fi
        else
               echo "error: The parameter \"${LOCAL_APP_NAME}\" invalid,exit"
            echo "example : \"LOCAL_APP_NAME\" is \"xxx.jar\" or \"xxx.war\""
            echo ""
            exit 11
fi
exit 0
