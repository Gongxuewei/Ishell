###############################################################
#Script name：test.sh
#parameter:4
#mail:gxw_pad@163.com
###############################################################
#!/bin/bash
#set -x
export JAVA_HOME="/usr/local/jdk1.7"
export PATH=$JAVA_HOME/bin:$PATH:$HOME/bin
APP_NAME=$1
APP_DIR_APPNAME_LOCAL=$2
APP_KEYWORD=$3
FFFLG=$4
LINE="========================================================"
DATE=`date '+%Y-%m%d-%H%M'`
FLAG=${APP_NAME##*\.}
RSYNC_MODULE=${APP_NAME}
APP_DIR=${APP_DIR_APPNAME_LOCAL%/*}
APPID=`ps -ef|grep "java"|grep "${APP_KEYWORD}"|grep -v grep |awk '{print$2}'`
##############################################################
backup_war_jar () {
                   if [[ $# -ne 3 ]]; then
                              echo "Usage: backup_war_jar parameter1 parameter2 parameter3"
                              return 1
                   fi
                   app_name=$1
                   app_dir_appname_local=$2
                   date_1=$3
                   if [[ -f ${app_dir_appname_local} ]]; then
                                       cp   -v ${app_dir_appname_local}  $HOME/backup/${app_name}_${date_1}
                                       flist=`find    $HOME/backup/   -type f  -mtime +1`
                                       if [ x != "${flist}"x ] ; then
                                                          echo    "Delete the backup before the one  day ago!"
                                                          while read line
                                                          do
                                                                      echo "\"delete : ${line}\""
                                                                      rm -f  ${line}
                                                          done  <<EOF
${flist}
EOF
                                        fi
                                    else
                                        echo "${app_dir_appname_local}  is not exist !"
                                        return 1
                    fi
}

kil_app () {
            if [[ $# -ne 1 ]]; then
                      echo "Usage: kil_app parameter1"
                      return 1
            fi
            appid=$1
            echo ""
            ps -fe |grep "${appid}"|grep -v "grep"
            echo ""
            echo "\"kill -9 ${appid}\""
            kill -9  ${appid}
            if [[ $? -ne 0 ]]; then
                      return 1
            fi
}

kil_app_y () {
          app_keyword=$1
          appid=`ps -ef|grep "java"|grep "${app_keyword}"|grep -v grep |awk '{print$2}'`
          ps -ef|grep "java"|grep "${app_keyword}"|grep -v grep 
          if [[ x"${appid}" != x ]]; then
                        for i in ${appid}  
                        do
                                 echo "\"kill -9 ${i}\""
                                 kill -9 ${i}
                        done       
          fi
}

rs_war() {
          if [[ $# -ne 3 ]]; then
                     echo "Usage: rs_war parameter1 parameter2 parameter3"
                     return 1
          fi
          rsync_module=$1
          app_dir=$2
          app_dir_appname_local=$3
          if [[ -f ${app_dir_appname_local} ]]; then
                        rm -rf ${app_dir}/*
                        /usr/bin/rsync   -avH  --progress  --password-file=$HOME/up_cl_dir/passfile       tusr@10.16.31.36::${rsync_module}    ${app_dir}
                        if [ -f ${app_dir}/${rsync_module} ] ; then
                                              ls -rtl  ${app_dir}/${rsync_module}
                                          else
                                              echo    "${app_dir}/${rsync_module} is not exist !"
                        fi
                        if [[ "${app_dir_appname_local##*/}" == "ROOT.war" ]]; then
                                              mv  ${app_dir}/${rsync_module}   ${app_dir_appname_local}
                                              ls  -rtl  ${app_dir_appname_local}
                        fi
                    else
                        echo "${app_dir_appname_local} is not exist !" 
                        return 1
          fi
                 
}

rs_war_y() {
          if [[ $# -ne 3 ]]; then
                     echo "Usage: rs_war parameter1 parameter2 parameter3"
                     return 1
          fi
          rsync_module=$1
          app_dir=$2
          app_dir_appname_local=$3
                        rm -rf ${app_dir}/*
                        /usr/bin/rsync   -avH  --progress  --password-file=$HOME/up_cl_dir/passfile       tusr@10.16.31.36::${rsync_module}    ${app_dir}
                        if [ -f ${app_dir}/${rsync_module} ] ; then
                                              ls -rtl  ${app_dir}/${rsync_module}
                                          else
                                              echo    "${app_dir}/${rsync_module} is not exist !"
                        fi
                        if [[ "${app_dir_appname_local##*/}" == "ROOT.war" ]]; then
                                              mv  ${app_dir}/${rsync_module}   ${app_dir_appname_local}
                                              ls  -rtl  ${app_dir_appname_local}
                        fi

}

rs_jar() {
          if [[ $# -ne 3 ]]; then
                     echo "Usage: rs_war parameter1 parameter2 parameter3"
                     return 1
          fi
          rsync_module=$1
          app_dir=$2
          app_dir_appname_local=$3
          if [[ -f ${app_dir_appname_local} ]]; then
                      rm -f  ${app_dir_appname_local}
                      /usr/bin/rsync   -avH  --progress  --password-file=$HOME/up_cl_dir/passfile       tusr@10.16.31.36::${rsync_module}    ${app_dir}
                      ls -rtl   ${app_dir_appname_local}
                  else
                      echo "${app_dir_appname_local} is not exist !" 
                      return 1
          fi
}

rs_jar_y() {
          if [[ $# -ne 3 ]]; then
                     echo "Usage: rs_war parameter1 parameter2 parameter3"
                     return 1
          fi
          rsync_module=$1
          app_dir=$2
          app_dir_appname_local=$3
                      rm -f  ${app_dir_appname_local}
                      /usr/bin/rsync   -avH  --progress  --password-file=$HOME/up_cl_dir/passfile       tusr@10.16.31.36::${rsync_module}    ${app_dir}
                      ls -rtl   ${app_dir_appname_local}
}

sta_jar() {
            if [[ $# -ne 2 ]]; then
                       echo "Usage: sta_jar parameter1 parameter2 "
                       return 1
            fi
            app_dir_appname_local=$1
            app_dir=$2
            echo  "java -jar ${app_dir_appname_local}"
            cat /dev/null  >${app_dir}/tmp.log
            echo ""
            /usr/local/jdk1.7/bin/java   -jar    ${app_dir_appname_local} >>${app_dir}/tmp.log &
            echo "${app_dir_appname_local}  P_I_D   is $!"
            echo ""
            sleep 3
            tail -f  ${app_dir}/tmp.log &
            sleep  60
            kill  -9  $!

}

sta_war() {
           if [[ $# -ne 2 ]]; then
                      echo "Usage: sta_war parameter1 parameter2 "
                      return 1
           fi
           app_dir_appname_local=$1
           app_dir=$2
           echo "sh ${app_dir%/*}/bin/startup.sh"
           sh  ${app_dir%/*}/bin/startup.sh
           echo ""
           sleep 3
           tail -f ${app_dir%/*}/logs/catalina.out &
           sleep  60 
           kill  -9  $!         
}

if [[ $# -ne 4 ]]; then
        echo "Usage: $0 parameter1 parameter2 parameter3 parameter4"
        exit  1
fi

if [ ! -d $HOME/backup ] ; then
          mkdir  -p   $HOME/backup
fi

case ${FFFLG} in
        n)
            if [ x"${APPID}" !=  "x" ] ; then
                                echo ""
                                echo $LINE
                                echo "Start backing up files!"
                                echo $LINE
                                          backup_war_jar  ${APP_NAME}  ${APP_DIR_APPNAME_LOCAL} ${DATE}
                                          return_val=$?
                                echo $LINE
                                echo "The backup file is complete!"
                                echo $LINE
                                echo ""
                      
                                echo ""
                                echo $LINE
                                echo "Stop the application:\"${APP_NAME}\""
                                echo $LINE
                                          echo "return_val value of \"${return_val}\""
                                          if [[ ${return_val} -eq  0 ]]; then
                                                      kil_app $APPID
                                                      return_val=$?
                                                  else
                                                      echo "return_val value of \"${return_val}\",Exit the script"          
                                                      exit 11
                                          fi
                                echo $LINE
                                echo "application:\"${APP_NAME}\" Has stopped!"
                                echo $LINE
                                echo "" 
                      
                                echo ""
                                echo $LINE
                                echo "Start synchronizing files!"
                                echo $LINE
                                          echo "return_val value of \"${return_val}\""
                                          if [[ ${return_val} -eq 0 ]]; then
                                                          if [[ ${FLAG} == "war" ]]; then
                                                                            rs_war  ${RSYNC_MODULE}  ${APP_DIR}  ${APP_DIR_APPNAME_LOCAL}
                                                                            return_val=$?
                                                          fi
                                                          if [[ ${FLAG} == "jar" ]]; then
                                                                            rs_jar  ${RSYNC_MODULE}  ${APP_DIR}  ${APP_DIR_APPNAME_LOCAL}
                                                                            return_val=$?
                                                          fi
                                                      else
                                                          echo "return_val value of \"${return_val}\",Exit the script"          
                                                          exit 11
                                          fi
                                echo $LINE
                                echo "File synchronization is complete!"
                                echo $LINE
                                echo ""
                      
                                echo ""
                                echo $LINE
                                echo "Start the application: \"${APP_NAME}\" "
                                echo $LINE 
                                          echo "return_val value of \"${return_val}\""
                                          echo "$JAVA_HOME"
                                          echo "$PATH"
                                          if [[ ${return_val} -eq 0 ]]; then
                                                         if [ ${FLAG} == "war" ] ; then
                                                                        sta_war   ${APP_DIR_APPNAME_LOCAL}  ${APP_DIR}
                                                         fi 
                                                         if [ ${FLAG} == "jar" ] ; then
                                                                        sta_jar  ${APP_DIR_APPNAME_LOCAL}  ${APP_DIR}
                                                         fi
                                                     else
                                                         echo "return_val value of \"${return_val}\",Exit the script"          
                                                         exit 11
                                          fi
                                #echo $LINE
                                #echo "Application startup is complete"
                                #echo $LINE
                                #echo ""
            else
                                echo   "The process : \"${APP_NAME}\" is not alive，please check! "
                                echo   "Exit the deployment process"
                                exit  1
                      
            fi
      ;;
      y)
          echo ""
          echo $LINE
          echo "Start backing up files!"
          echo $LINE
                    backup_war_jar  ${APP_NAME}  ${APP_DIR_APPNAME_LOCAL} ${DATE}
          echo $LINE
          echo "The backup file is complete!"
          echo $LINE
          echo ""
          
          echo ""
          echo $LINE
          echo "Stop the application:\"${APP_NAME}\""
          echo $LINE
                    kil_app_y ${APP_KEYWORD}
          echo $LINE
          echo "application:\"${APP_NAME}\" Has stopped!"
          echo $LINE
          echo "" 
          
          echo ""
          echo $LINE
          echo "Start synchronizing files!"
          echo $LINE
                    if [[ ${FLAG} == "war" ]]; then
                                    rs_war_y  ${RSYNC_MODULE}  ${APP_DIR}  ${APP_DIR_APPNAME_LOCAL}
                    fi
                    if [[ ${FLAG} == "jar" ]]; then
                                    rs_jar_y  ${RSYNC_MODULE}  ${APP_DIR}  ${APP_DIR_APPNAME_LOCAL}
                    fi
          echo $LINE
          echo "File synchronization is complete!"
          echo $LINE
          echo ""

          echo ""
          echo $LINE
          echo "Start the application: \"${APP_NAME}\" "
          echo $LINE 
                    echo "$JAVA_HOME"
                    echo "$PATH"
                    if [ ${FLAG} == "war" ] ; then
                                   sta_war   ${APP_DIR_APPNAME_LOCAL}  ${APP_DIR}
                    fi 
                    if [ ${FLAG} == "jar" ] ; then
                                   sta_jar  ${APP_DIR_APPNAME_LOCAL}  ${APP_DIR}
                    fi 
          #echo $LINE
          #echo "Application startup is complete"
          #echo $LINE
          #echo ""
      ;;
esac
exit 0
