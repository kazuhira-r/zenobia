#!/bin/bash

COMMAND=$1
TYPE=$3
VERSION=$4

VALID_TYPES=(
    "microprofile hollowswarm"
    "web  hollowswarm"
    "full hollowswarm"
    "keycloak swarm"
    "swagger-ui swarm"
    "management-console swarm"
)

IS_VALID_TYPE=0
for VALID_TYPE in "${VALID_TYPES[@]}"
do
   VT=(${VALID_TYPE[@]})
    if [ "${TYPE}" == "${VT[0]}" ]; then
        IS_VALID_TYPE=1
    fi
done

if [ ${IS_VALID_TYPE} == 0 ]; then
    echo "invalid WIldFly Swarm type ${TYPE}"
    exit 1
fi

if [ "${COMMAND}" == "install" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/download.sh ${WILDFLY_SWARM_DIR}/${TYPE} org/wildfly/swarm/servers/ ${TYPE} ${VERSION} hollowswarm

    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${WILDFLY_SWARM_DIR}/${TYPE} "${TYPE}-${VERSION}-hollowswarm.jar" "${TYPE}-hollowswarm.jar"

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh "${TYPE}-hollowswarm.jar" "${TYPE}-hollowswarm"

elif [ "${COMMAND}" == "set" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${WILDFLY_SWARM_DIR}/${TYPE} "${TYPE}-${VERSION}-hollowswarm.jar" "${TYPE}-hollowswarm.jar"

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh "${TYPE}-hollowswarm.jar" "${TYPE}-hollowswarm"

elif [ "${COMMAND}" == "list" ]; then
    ls -l ${WILDFLY_SWARM_DIR}/${TYPE}

elif [ "${COMMAND}" == "uninstall" ]; then
    if [ "${VERSION}" == "" ]; then
        echo "require version"
        exit 1
    fi

    if [ -e ${WILDFLY_SWARM_DIR}/${TYPE}/"${TYPE}-${VERSION}-hollowswarm.jar" ]; then
        rm ${WILDFLY_SWARM_DIR}/${TYPE}/"${TYPE}-${VERSION}-hollowswarm.jar"
    fi
fi
