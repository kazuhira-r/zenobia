#!/bin/bash

set -e

source ${ZENOBIA_LIBEXEC_DIR}/functions.sh

show_swarm_version() {
    if [ -e "${ZENOBIA_BIN_DIR}/${TYPE}-${CLASSIFIER}.jar" ]; then
        CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/${TYPE}-${CLASSIFIER}.jar | perl -wp -e 's!.+-([^-]+)-(hollow)?swarm.jar!$1!'`

        echo "  type: ${TYPE}"

        for WILDFLY_SWARM_JAR in `ls -1 ${WILDFLY_SWARM_DIR}/${TYPE} | sort -r`
        do
            VERSION=`echo ${WILDFLY_SWARM_JAR} | perl -wp -e 's!.+-([^-]+)-(hollow)?swarm.jar!$1!'`

            if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
                echo "    ${CURRENT_VERSION} [current]"
            else
                echo "    ${VERSION}"
            fi
        done
    fi
}

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
       CLASSIFIER=${VT[1]}
        IS_VALID_TYPE=1
    fi
done

if [ ${IS_VALID_TYPE} == 0 ]; then
    if [ "${COMMAND}" != "list" -a ! -z "${TYPE}" ]; then
        logging ERROR "invalid WildFly Swarm type ${TYPE}"
        exit 1
    fi
fi

if [ "${COMMAND}" == "install" ]; then
    if [ -z "${VERSION}" ]; then
        VERSION=`curl -s "https://search.maven.org/solrsearch/select?q=g:org.wildfly.swarm.servers+AND+a:${TYPE}" | perl -wn -e 'print $1 if /"latestVersion":"([^"]+)"/'`
    fi

    ${ZENOBIA_LIBEXEC_DIR}/download.sh ${WILDFLY_SWARM_DIR}/${TYPE} org/wildfly/swarm/servers ${TYPE} ${VERSION} ${CLASSIFIER}

    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${WILDFLY_SWARM_DIR}/${TYPE} "${TYPE}-${VERSION}-${CLASSIFIER}.jar" "${TYPE}-${CLASSIFIER}.jar"

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh "${TYPE}-${CLASSIFIER}.jar" "${TYPE}-${CLASSIFIER}"

elif [ "${COMMAND}" == "set" ]; then
    if [ -z "${VERSION}" ]; then
        logging ERROR "require version"
        exit 1
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${WILDFLY_SWARM_DIR}/${TYPE} "${TYPE}-${VERSION}-${CLASSIFIER}.jar" "${TYPE}-${CLASSIFIER}.jar"

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh "${TYPE}-${CLASSIFIER}.jar" "${TYPE}-${CLASSIFIER}"

elif [ "${COMMAND}" == "list" ]; then
    if [ -z "${TYPE}" ]; then
        logging INFO "local installed wildfly-swarm uberjars"
        
        for TYPE in `ls ${WILDFLY_SWARM_DIR}`
        do
            for VALID_TYPE in "${VALID_TYPES[@]}"
            do
                VT=(${VALID_TYPE[@]})
                if [ "${TYPE}" == "${VT[0]}" ]; then
                    CLASSIFIER=${VT[1]}
                fi
            done

            show_swarm_version
        done
    else
        logging INFO "local installed wildfly-swarm ${TYPE} uberjars"
        show_swarm_version
    fi

elif [ "${COMMAND}" == "list-remote" ];then
    if [ -z "${TYPE}" ]; then
        logging INFO "Maven Central registerd wildfly-swarm uberjars"

        for VALID_TYPE in "${VALID_TYPES[@]}"
        do
            VT=(${VALID_TYPE[@]})
            TYPE="${VT[0]}"
            CLASSIFIER="${VT[1]}"

            echo "  type: ${TYPE}"

            if [ -e "${ZENOBIA_BIN_DIR}/${TYPE}-${CLASSIFIER}.jar" ]; then
                CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/${TYPE}-${CLASSIFIER}.jar | perl -wp -e 's!.+-([^-]+)-(hollow)?swarm.jar!$1!'`
            else
                CURRENT_VERSION=
            fi

            for VERSION in `curl -s "https://search.maven.org/solrsearch/select?q=g:org.wildfly.swarm.servers+AND+a:${TYPE}&core=gav" |  perl -wp -e 's!,!,\n!g' | perl -wnl -e 'print "$1 " if /"v":"([^"]+)"/' | sort`
            do
                if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
                    echo "    ${CURRENT_VERSION} [current]"
                else
                    echo "    ${VERSION}"
                fi
            done
        done
    else
        logging INFO "Maven Central registerd wildfly-swarm ${TYPE} uberjars"

        echo "  type: ${TYPE}"

        if [ -e "${ZENOBIA_BIN_DIR}/${TYPE}-${CLASSIFIER}.jar" ]; then
            CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/${TYPE}-${CLASSIFIER}.jar | perl -wp -e 's!.+-([^-]+)-(hollow)?swarm.jar!$1!'`
        else
            CURRENT_VERSION=
        fi

        for VERSION in `curl -s "https://search.maven.org/solrsearch/select?q=g:org.wildfly.swarm.servers+AND+a:${TYPE}&core=gav" |  perl -wp -e 's!,!,\n!g' | perl -wnl -e 'print "$1 " if /"v":"([^"]+)"/' | sort`
        do
            if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
                echo "    ${CURRENT_VERSION} [current]"
            else
                echo "    ${VERSION}"
            fi
        done
    fi

elif [ "${COMMAND}" == "current" ]; then
    VERSION=`ls -l ${ZENOBIA_BIN_DIR}/${TYPE}-${CLASSIFIER}.jar | perl -wp -e 's!.+-([^-]+)-(hollow)?swarm.jar!$1!'`

    logging INFO "current ${TYPE} version ${VERSION}"

elif [ "${COMMAND}" == "uninstall" ]; then
    if [ -z "${VERSION}" ]; then
        logging ERROR "require version"
        exit 1
    fi

    if [ -e ${WILDFLY_SWARM_DIR}/${TYPE}/"${TYPE}-${VERSION}-${CLASSIFIER}.jar" ]; then
        rm ${WILDFLY_SWARM_DIR}/${TYPE}/"${TYPE}-${VERSION}-${CLASSIFIER}.jar"
        logging INFO "uninstall ${TYPE}-${VERSION}-${CLASSIFIER}.jar"

        CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/${TYPE}-${CLASSIFIER}.jar | perl -wp -e 's!.+-([^-]+)-(hollow)?swarm.jar!$1!'`

        if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
            rm ${ZENOBIA_BIN_DIR}/${TYPE}/"${TYPE}-${CLASSIFIER}.jar"
            rm ${ZENOBIA_BIN_DIR}/${TYPE}/"${TYPE}-${CLASSIFIER}"
            logging INFO "remove ${TYPE}-${CLASSIFIER}.jar"
            logging INFO "remove ${TYPE}-${CLASSIFIER}"
        fi
    else
        logging INFO "already uninstalled ${TYPE}-${VERSION}-${CLASSIFIER}.jar"
    fi
fi
