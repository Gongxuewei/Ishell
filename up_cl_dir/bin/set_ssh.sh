#!/bin/bash
BINDIR=$(cd "$(dirname "$0")"; pwd)
KEYDIR=${BINDIR%/*}/key

if [ x${HOME} = x ] ; then
           read -p "Please enter the user's home directory:" home_dir_enter
           home_dir=${home_dir_enter}
else
           home_dir=${HOME}
fi

rm -rf     ${home_dir}/.ssh
mkdir      ${home_dir}/.ssh
chmod 700  ${home_dir}/.ssh

for i in ${KEYDIR}/*
do
         cat    ${i} >> ${home_dir}/.ssh/authorized_keys
done
chmod 600 ${home_dir}/.ssh/authorized_keys
exit 0
