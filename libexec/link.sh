#!/bin/bash

source ${ZENOBIA_LIBEXEC_DIR}/functions.sh

ACTUAL_ARTIFACT_DIR=$1
ACTUAL_ARTIFACT_NAME=$2
LINK_ARTIFACT_NAME=$3

if [ -e ${ZENOBIA_BIN_DIR}/${LINK_ARTIFACT_NAME} ]; then
    rm ${ZENOBIA_BIN_DIR}/${LINK_ARTIFACT_NAME}
fi

ln -s ${ACTUAL_ARTIFACT_DIR}/${ACTUAL_ARTIFACT_NAME} ${ZENOBIA_BIN_DIR}/${LINK_ARTIFACT_NAME}

logging INFO "current active version ${ACTUAL_ARTIFACT_NAME}"