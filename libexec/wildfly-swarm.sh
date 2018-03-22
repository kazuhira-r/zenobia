#!/bin/bash

PROFILE=$2
COMMAND=$3
VERSION=$4

if [ "${COMMAND}" == "install" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/download.sh ${WILDFLY_SWARM_DIR}/${PROFILE} org/wildfly/swarm/servers/ ${PROFILE} ${VERSION} hollowswarm

    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${WILDFLY_SWARM_DIR}/${PROFILE} "${PROFILE}-${VERSION}-hollowswarm.jar" "${PROFILE}-hollowswarm.jar"

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh "${PROFILE}-hollowswarm.jar" "${PROFILE}-hollowswarm"

elif [ "${COMMAND}" == "set" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${WILDFLY_SWARM_DIR}/${PROFILE} "${PROFILE}-${VERSION}-hollowswarm.jar" "${PROFILE}-hollowswarm.jar"

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh "${PROFILE}-hollowswarm.jar" "${PROFILE}-hollowswarm"

elif [ "${COMMAND}" == "list" ]; then
    ls -l ${WILDFLY_SWARM_DIR}/${PROFILE}

elif [ "${COMMAND}" == "uninstall" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi

    if [ -e ${WILDFLY_SWARM_DIR}/${PROFILE}/"${PROFILE}-${VERSION}-hollowswarm.jar" ]; then
        rm ${WILDFLY_SWARM_DIR}/${PROFILE}/"${PROFILE}-${VERSION}-hollowswarm.jar"
    fi
fi
