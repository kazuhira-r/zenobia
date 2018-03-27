#!/bin/bash

source ${ZENOBIA_LIBEXEC_DIR}/functions.sh

TARGET_ARTIFACT_NAME=$1
EXECUTABLE_FILE_NAME=$2

if [ ${RUN_CYGWIN} -ne 1 ]; then
JAVA_COMMAND=$(cat << 'EOS'
java -jar "$0" "$@"
exit $?
EOS
)

echo "${JAVA_COMMAND}" > ${ZENOBIA_BIN_DIR}/${EXECUTABLE_FILE_NAME}
cat ${ZENOBIA_BIN_DIR}/${TARGET_ARTIFACT_NAME} >> ${ZENOBIA_BIN_DIR}/${EXECUTABLE_FILE_NAME}

chmod a+x ${ZENOBIA_BIN_DIR}/${EXECUTABLE_FILE_NAME}
else
JAVA_COMMAND=$(cat << 'EOS'
@echo off
java -jar %~f0 %*
exit /b
EOS
)

echo "${JAVA_COMMAND}" | perl -wp -e 's!\n!\r\n!' > ${ZENOBIA_BIN_DIR}/${EXECUTABLE_FILE_NAME}.bat
cat ${ZENOBIA_BIN_DIR}/${TARGET_ARTIFACT_NAME} >> ${ZENOBIA_BIN_DIR}/${EXECUTABLE_FILE_NAME}.bat
chmod a+x ${ZENOBIA_BIN_DIR}/${EXECUTABLE_FILE_NAME}.bat
fi
