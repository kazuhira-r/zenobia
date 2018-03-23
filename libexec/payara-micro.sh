#!/bin/bash

COMMAND=$1
VERSION=$3

if [ "${COMMAND}" == "install" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/download.sh ${PAYARA_MICRO_DIR} fish/payara/extras payara-micro ${VERSION}

    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${PAYARA_MICRO_DIR} "payara-micro-${VERSION}.jar" payara-micro.jar

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh payara-micro.jar payara-micro

elif [ "${COMMAND}" == "set" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${PAYARA_MICRO_DIR} fish/payara/extras payara-micro ${VERSION} payara-micro.jar

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh payara-micro.jar payara-micro

elif [ "${COMMAND}" == "list" ]; then
    ls -l ${PAYARA_MICRO_DIR}

elif [ "${COMMAND}" == "uninstall" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi

    if [ -e ${PAYARA_MICRO_DIR}/"payara-micro-${VERSION}.jar" ]; then
        rm ${PAYARA_MICRO_DIR}/"payara-micro-${VERSION}.jar"
    fi
fi
