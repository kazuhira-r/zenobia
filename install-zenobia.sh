#!/bin/bash

ZENOBIA_HOME=${HOME}/.zenobia
ZENOBIA_BIN_DIR=${ZENOBIA_HOME}/bin

if [  ! -e ${ZENOBIA_HOME} ]; then
    mkdir ${ZENOBIA_HOME}
fi

if [ ! -e ${ZENOBIA_BIN_DIR} ]; then
    mkdir ${ZENOBIA_BIN_DIR}
fi

curl https://raw.githubusercontent.com/kazuhira-r/zenobia/master/bin/zenobia -o ${ZENOBIA_BIN_DIR}/zenobia
chmod a+x ${ZENOBIA_BIN_DIR}/zenobia
