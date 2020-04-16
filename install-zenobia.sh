#!/bin/bash

ZENOBIA_HOME=${HOME}/.zenobia
ZENOBIA_BIN_DIR=${ZENOBIA_HOME}/bin
ZENOBIA_LIBEXEC_DIR=${ZENOBIA_HOME}/libexec

if [  ! -e ${ZENOBIA_HOME} ]; then
    mkdir ${ZENOBIA_HOME}
fi

if [ ! -e ${ZENOBIA_BIN_DIR} ]; then
    mkdir ${ZENOBIA_BIN_DIR}
fi

if [ ! -e ${ZENOBIA_LIBEXEC_DIR} ]; then
    mkdir ${ZENOBIA_LIBEXEC_DIR}
fi

BIN_SCRIPTS=(
    zenobia
    init-zenobia.sh
)

for BIN_SCRIPT in ${BIN_SCRIPTS[@]}
do
    curl -L -s https://raw.githubusercontent.com/kazuhira-r/zenobia/master/bin/${BIN_SCRIPT} -o ${ZENOBIA_BIN_DIR}/${BIN_SCRIPT}
    chmod a+x ${ZENOBIA_BIN_DIR}/${BIN_SCRIPT}
done

LIBEXEC_SCRIPTS=(
    build.sh
    download.sh
    executable.sh
    functions.sh
    link.sh
    tomcat.sh
    payara-micro.sh
)

if [ -e "${ZENOBIA_LIBEXEC_DIR}/*" ]; then
    rm ${ZENOBIA_LIBEXEC_DIR}/*
fi

for LIBEXEC_SCRIPT in ${LIBEXEC_SCRIPTS[@]}
do
    curl -L -s https://raw.githubusercontent.com/kazuhira-r/zenobia/master/libexec/${LIBEXEC_SCRIPT} -o ${ZENOBIA_LIBEXEC_DIR}/${LIBEXEC_SCRIPT}
    chmod a+x ${ZENOBIA_LIBEXEC_DIR}/${LIBEXEC_SCRIPT}
done

ZENOBIA_VERSION=`grep 'ZENOBIA_VERSION=' ${ZENOBIA_HOME}/bin/zenobia | perl -wp -e 's!.*ZENOBIA_VERSION="([^"]+)".*!$1!'`

echo "Installed Zenobia ${ZENOBIA_VERSION}!!"
echo
echo "editing and removing the initialisation snippet from your .bashrc, .bash_profile and/or .profile files."
echo '[[ -s "${HOME}/.zenobia/bin/init-zenobia.sh" ]] && source "${HOME}/.zenobia/bin/init-zenobia.sh"'
echo
echo "Enjoy Zenobia!!"

