#!/bin/bash

OUTPUT_DIR=$1
GROUP_DIR=$2
ARTIFACT_NAME=$3
VERSION=$4
CLASSFIER=$5

cd ${OUTPUT_DIR}

if [ "${CLASSFIER}" != "" ];then
    if [ -e ${ARTIFACT_NAME}-${VERSION}-${CLASSFIER}.jar ]; then
        exit 0
    fi
    
    DOWNLOAD_URL=https://search.maven.org/remotecontent?filepath=${GROUP_DIR}/${ARTIFACT_NAME}/${VERSION}/${ARTIFACT_NAME}-${VERSION}-${CLASSFIER}.jar
    curl ${DOWNLOAD_URL} -o ${ARTIFACT_NAME}-${VERSION}-${CLASSFIER}.jar
else
    if [ -e ${ARTIFACT_NAME}-${VERSION}.jar ]; then
        exit 0
    fi
    
    DOWNLOAD_URL=https://search.maven.org/remotecontent?filepath=${GROUP_DIR}/${ARTIFACT_NAME}/${VERSION}/${ARTIFACT_NAME}-${VERSION}.jar
    echo ${DOWNLOAD_URL}
    curl ${DOWNLOAD_URL} -o ${ARTIFACT_NAME}-${VERSION}.jar
fi
