#!/bin/bash

set -e

source ${ZENOBIA_LIBEXEC_DIR}/functions.sh

OUTPUT_DIR=$1
ARTIFACT_NAME=$2
SERVER_NAME=$3
VERSION=$4

GITHUB_RAW_USERCONTENT_BASE_URL=https://raw.githubusercontent.com/kazuhira-r/zenobia/master

if [ ! -e ${ZENOBIA_SRC_BUILD_DIR} ]; then
    mkdir -p ${ZENOBIA_SRC_BUILD_DIR}
else
    rm -rf ${ZENOBIA_SRC_BUILD_DIR}
    mkdir -p ${ZENOBIA_SRC_BUILD_DIR}
fi

cd ${ZENOBIA_SRC_BUILD_DIR}

set +e
which mvn 2>&1 > /dev/null
FOUND_MAVEN=$?
set -e

if [ ${FOUND_MAVEN} -ne 0 ]; then
    logging INFO "use Maven Wrapper..."

    curl -s ${GITHUB_RAW_USERCONTENT_BASE_URL}/executable-container/mvnw.tar.gz  -o mvnw.tar.gz
    tar -xf mvnw.tar.gz

    MVN=./mvnw
else
    logging INFO "use local installed Maven..."

    MVN=mvn
fi

curl -s ${GITHUB_RAW_USERCONTENT_BASE_URL}/executable-container/${ARTIFACT_NAME}.tar.gz -o ${ARTIFACT_NAME}.tar.gz
tar -xf ${ARTIFACT_NAME}.tar.gz

perl -wpi -e "s!<server.name>.+</server.name>!<server.name>${SERVER_NAME}</server.name>!" pom.xml
perl -wpi -e "s!<${ARTIFACT_NAME}.version>.+</${ARTIFACT_NAME}.version>!<${ARTIFACT_NAME}.version>${VERSION}</${ARTIFACT_NAME}.version>!" pom.xml
${MVN} package

cp target/${SERVER_NAME}-${VERSION}.jar ${OUTPUT_DIR}/${SERVER_NAME}-${VERSION}.jar

cd ..
rm -rf ${ZENOBIA_SRC_BUILD_DIR}
