#!/bin/bash

set -e

source ${ZENOBIA_LIBEXEC_DIR}/functions.sh

COMMAND=$1
VERSION=$3

if [ "${COMMAND}" == "install" ]; then
    if [ -z "${VERSION}" ]; then
        VERSION=`curl -s 'http://search.maven.org/solrsearch/select?q=g:fish.payara.extras+AND+a:payara-micro' | perl -wn -e 'print $1 if /"latestVersion":"([^"]+)"/'`
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/download.sh ${PAYARA_MICRO_DIR} fish/payara/extras payara-micro ${VERSION}

    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${PAYARA_MICRO_DIR} "payara-micro-${VERSION}.jar" payara-micro.jar

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh payara-micro.jar payara-micro

elif [ "${COMMAND}" == "set" ]; then
    if [ -z "${VERSION}" ]; then
        logging ERROR "require version"
        exit 1
    fi

    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${PAYARA_MICRO_DIR} "payara-micro-${VERSION}.jar" payara-micro.jar

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh payara-micro.jar payara-micro

elif [ "${COMMAND}" == "list" ]; then
    logging INFO "local installed payara-micro jars"

    CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/payara-micro.jar | perl -wp -e 's!.+payara-micro-([^-]+).jar!$1!'`
    
    for PAYARA_MICRO_JAR in `ls -1 ${PAYARA_MICRO_DIR} | sort -r`
    do
        VERSION=`echo ${PAYARA_MICRO_JAR} | perl -wp -e 's!.+-([^-]+)\.jar!$1!'`

        if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
            echo "  ${CURRENT_VERSION} [current]"
        else
            echo "  ${VERSION}"
        fi
    done

elif [ "${COMMAND}" == "current" ];then
    VERSION=`ls -l ${ZENOBIA_BIN_DIR}/payara-micro.jar | perl -wp -e 's!.+payara-micro-([^-]+).jar!$1!'`

    logging INFO "current version ${VERSION}"

elif [ "${COMMAND}" == "uninstall" ]; then
    if [ -z "${VERSION}" ]; then
        logging ERROR "require version"
        exit 1
    fi

    if [ -e ${PAYARA_MICRO_DIR}/"payara-micro-${VERSION}.jar" ]; then
        rm ${PAYARA_MICRO_DIR}/"payara-micro-${VERSION}.jar"
        logging INFO "uninstall payara-micro-${VERSION}.jar"

        CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/payara-micro.jar | perl -wp -e 's!.+payara-micro-([^-]+).jar!$1!'`

        if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
            rm ${ZENOBIA_BIN_DIR}/"payara-micro.jar"
            rm ${ZENOBIA_BIN_DIR}/"payara-micro"
            logging INFO "remove payara-micro.jar"
            logging INFO "remove payara-micro"
        fi
    else
        logging INFO "already uninstalled payara-micro-${VERSION}.jar"
    fi
fi
