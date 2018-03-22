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

curl https://raw.githubusercontent.com/kazuhira-r/zenobia/master/bin/zenobia -o ${ZENOBIA_BIN_DIR}/zenobia
chmod a+x ${ZENOBIA_BIN_DIR}/zenobia

LIBEXEC_SCRIPTS=(
    download.sh
    executable.sh
    link.sh
    payara-micro.sh
    wildfly-swarm.sh
)

if [ -e "${ZENOBIA_LIBEXEC_DIR}/*" ]; then
    rm ${ZENOBIA_LIBEXEC_DIR}/*
fi

for LIBEXEC_SCRIPT in ${LIBEXEC_SCRIPTS[@]}
do
    curl https://raw.githubusercontent.com/kazuhira-r/zenobia/master/libexec/${LIBEXEC_SCRIPT} -o ${ZENOBIA_LIBEXEC_DIR}/${LIBEXEC_SCRIPT}
    chmod a+x ${ZENOBIA_LIBEXEC_DIR}/${LIBEXEC_SCRIPT}
done
