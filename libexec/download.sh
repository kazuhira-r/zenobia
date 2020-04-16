#!/bin/bash

source ${ZENOBIA_LIBEXEC_DIR}/functions.sh

OUTPUT_DIR=$1
GROUP_DIR=$2
ARTIFACT_NAME=$3
VERSION=$4
CLASSIFIER=$5

cd ${OUTPUT_DIR}

if [ ! -z "${CLASSIFIER}" ];then
    if [ -e ${ARTIFACT_NAME}-${VERSION}-${CLASSIFIER}.jar ]; then
        logging INFO "already downloaded, ${ARTIFACT_NAME}-${VERSION}-${CLASSIFIER}.jar"
        exit 0
    fi
    
    DOWNLOAD_URL=https://search.maven.org/remotecontent?filepath=${GROUP_DIR}/${ARTIFACT_NAME}/${VERSION}/${ARTIFACT_NAME}-${VERSION}-${CLASSIFIER}.jar
    logging INFO "downloading... ${ARTIFACT_NAME}-${VERSION}-${CLASSIFIER}.jar"
    
    curl -L ${DOWNLOAD_URL} -o ${ARTIFACT_NAME}-${VERSION}-${CLASSIFIER}.jar

    grep 'Not Found' ${ARTIFACT_NAME}-${VERSION}-${CLASSIFIER}.jar 2>&1 > /dev/null
    if [ $? -eq 0 ]; then
        logging ERROR "invalid version ${VERSION}"
        rm ${ARTIFACT_NAME}-${VERSION}-${CLASSIFIER}.jar
        exit 1
    fi
else
    if [ -e ${ARTIFACT_NAME}-${VERSION}.jar ]; then
        logging INFO "already downloaded, ${ARTIFACT_NAME}-${VERSION}.jar"
        exit 0
    fi
    
    DOWNLOAD_URL=https://search.maven.org/remotecontent?filepath=${GROUP_DIR}/${ARTIFACT_NAME}/${VERSION}/${ARTIFACT_NAME}-${VERSION}.jar
    logging INFO "downloading... ${ARTIFACT_NAME}-${VERSION}.jar"
    
    curl -L ${DOWNLOAD_URL} -o ${ARTIFACT_NAME}-${VERSION}.jar

    grep 'Not Found' ${ARTIFACT_NAME}-${VERSION}.jar 2>&1 > /dev/null
    if [ $? -eq 0 ]; then
        logging ERROR "invalid version ${VERSION}"
        rm ${ARTIFACT_NAME}-${VERSION}.jar
        exit 1
    fi
fi
