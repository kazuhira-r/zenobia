#!/bin/bash

logging() {
    LEVEL=$1
    MESSAGE=$2

    TIME=`date +"%Y-%m-%d %H:%M:%S"`

    if [ -z "${SERVER_TYPE}" ]; then
        echo "[${TIME}] [${LEVEL}] ${MESSAGE}"
    else
        echo "[${TIME}] [${LEVEL}] [${SERVER_TYPE}] ${MESSAGE}"
    fi
}
