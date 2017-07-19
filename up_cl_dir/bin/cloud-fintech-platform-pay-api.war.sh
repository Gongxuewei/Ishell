#!/bin/bash
#set -x
LINE="========================================================"
export JAVA_HOME="/usr/local/jdk1.7"
export PATH=$JAVA_HOME/bin:$PATH:$HOME/bin
DATE=`date '+%Y-%m%d-%H%M'`
APPDIR=/opt/p_test/app
APP_DIR_APPNAME_LOCAL=/opt/p_test/app/cloud-fintech-platform-pay-api.war

if [ -f ${APP_DIR_APPNAME_LOCAL} ] ; then
                                echo ""
                                echo $LINE
                                echo "Start backing up files!"
                                echo $LINE
                                          cp -v ${APP_DIR_APPNAME_LOCAL}  $HOME/backup/${APP_DIR_APPNAME_LOCAL##*/}_${DATE}
                                echo $LINE
                                echo "The backup file is complete!"
                                echo $LINE
                                echo ""

                                echo ""
                                echo $LINE
                                echo "Stop the application:\"${APP_NAME}\""
                                echo $LINE
                                         ps -ef|grep java|grep cloud-fintech-platform-pay-api.war
                                         a=`ps -ef|grep java|grep cloud-fintech-platform-pay-api.war|awk '{print $2}'`
                                         echo "\"kill -9  ${a}\""
                                         kill -9  ${a}
                                echo $LINE
                                echo "application:\"${APP_NAME}\" Has stopped!"
                                echo $LINE
                                echo "" 

                                echo ""
                                echo $LINE
                                echo "Start synchronizing files!"
                                echo $LINE
                                          rm -f ${APP_DIR_APPNAME_LOCAL}
                                          /usr/bin/rsync   -avH  --progress  --password-file=$HOME/up_cl_dir/passfile       tusr@10.16.31.36::${APP_DIR_APPNAME_LOCAL##*/}    ${APPDIR}
                                echo $LINE
                                echo "File synchronization is complete!"
                                echo $LINE
                                echo ""

                                echo ""
                                echo $LINE
                                echo "Start the application: \"${APP_NAME}\" "
                                echo $LINE
                                         echo ""
                                         echo "$JAVA_HOME"
                                         echo "$PATH" 
                                         echo  "java -jar ${APP_DIR_APPNAME_LOCAL##*/}"
                                         cat /dev/null  >${APPDIR}/tmp.log
                                         echo ""
                                         /usr/local/jdk1.7/bin/java   -jar   ${APP_DIR_APPNAME_LOCAL} >>${APPDIR}/tmp.log &
                                         echo "${APP_DIR_APPNAME_LOCAL}  P_I_D   is $!"
                                         echo ""
                                         sleep 3
                                         tail -f  ${APPDIR}/tmp.log &
                                         sleep  60
                                         kill  -9  $! 
else
       echo  "${APP_DIR_APPNAME_LOCAL} is not exits ,exit"
       exit 11
fi
exit 0
