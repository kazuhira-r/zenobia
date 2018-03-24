#!/bin/bash

PROJECT=$1
ARCHIVE_NAME=$2

if [ -z "${PROJECT}" ]; then
    echo "require [project] [archive-name]"
    exit 1
fi

if [ -z "${ARCHIVE_NAME}" ]; then
    echo "require [project] [archive-name]"
    exit 1
fi

cd ${PROJECT}
tar -czf ${ARCHIVE_NAME}.tar.gz pom.xml src
mv ${ARCHIVE_NAME}.tar.gz ../../executable-container
