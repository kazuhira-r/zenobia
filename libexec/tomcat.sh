#!/bin/bash

set -e

source ${ZENOBIA_LIBEXEC_DIR}/functions.sh

show_tomcat_version() {
    MV=$1

    set +e
    COUNT=`ls -1 ${TOMCAT_DIR}/tomcat${MV}-* 2> /dev/null | grep tomcat${MV}-* | wc -l`
    set -e

    if [ ${COUNT} -gt 0 ]; then
        CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/tomcat${MV}.jar | perl -wp -e "s!.+tomcat${MV}-([^-]+).jar"'!$1!'`

        for TOMCAT_JAR in `ls -1 ${TOMCAT_DIR}/tomcat${MV}-* | sort -r`
        do
            VERSION=`echo ${TOMCAT_JAR} | perl -wp -e "s!.+tomcat${MV}-([^-]+)\.jar"'!$1!'`

            if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
                echo "  ${CURRENT_VERSION} [current]"
            else
                echo "  ${VERSION}"
            fi
        done
    fi
}

COMMAND=$1
VERSION=$3

if [ -z "${VERSION}" ]; then
    LATEST_VERSION=`curl -s 'http://search.maven.org/solrsearch/select?q=g:org.apache.tomcat.embed+AND+a:tomcat-embed-core' | perl -wn -e 'print $1 if /"latestVersion":"([^"]+)"/'`
fi

set +e

echo ${VERSION} | grep '^9\.' 2>&1 > /dev/null
if [ $? -eq 0 ];then
    MAJOR_VERSION=9
fi

echo ${VERSION} | grep '^8\.5' 2>&1 > /dev/null
if [ $? -eq 0 ];then
    MAJOR_VERSION=85
fi

if [ -z "${VERSION}" ]; then
    echo ${LATEST_VERSION} | grep '^9\.' 2>&1 > /dev/null
    if [ $? -eq 0 ];then
        MAJOR_VERSION=9
    fi

    echo ${LATEST_VERSION} | grep '^8\.5' 2>&1 > /dev/null
    if [ $? -eq 0 ];then
        MAJOR_VERSION=85
    fi
fi

set -e

if [ "${COMMAND}" == "install" ]; then
    if [ -z "${VERSION}" ]; then
        VERSION=${LATEST_VERSION}
    fi
    
    ${ZENOBIA_LIBEXEC_DIR}/build.sh ${TOMCAT_DIR} tomcat tomcat${MAJOR_VERSION} ${VERSION}

    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${TOMCAT_DIR} "tomcat${MAJOR_VERSION}-${VERSION}.jar" tomcat${MAJOR_VERSION}.jar

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh tomcat${MAJOR_VERSION}.jar tomcat${MAJOR_VERSION}

elif [ "${COMMAND}" == "set" ]; then
    if [ -z "${VERSION}" ]; then
        logging ERROR "require version"
        exit 1
    fi

    ${ZENOBIA_LIBEXEC_DIR}/link.sh ${TOMCAT_DIR} "tomcat${MAJOR_VERSION}-${VERSION}.jar" tomcat${MAJOR_VERSION}.jar

    ${ZENOBIA_LIBEXEC_DIR}/executable.sh tomcat${MAJOR_VERSION}.jar tomcat${MAJOR_VERSION}
    
elif [ "${COMMAND}" == "list" ]; then
    logging INFO "local installed tomcat 9 jars"
    show_tomcat_version 9

    logging INFO "local installed tomcat 8.5 jars"
    show_tomcat_version 85

elif [ "${COMMAND}" == "list-remote" ];then
    logging INFO "Maven Central registered tomcat 9 jars"

    CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/tomcat9.jar | perl -wp -e 's!.+tomcat9-([^-]+).jar!$1!'`

    for VERSION in `curl -s 'http://search.maven.org/solrsearch/select?q=g:org.apache.tomcat.embed+AND+a:tomcat-embed-core+AND+v:9*&rows=100&core=gav' | perl -wp -e 's!,!,\n!g' | perl -wnl -e 'print "$1 " if /"v":"([^"]+)"/' | sort | grep -v M`
    do
        if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
            echo "  ${CURRENT_VERSION} [current]"
        else
            echo "  ${VERSION}"
        fi
    done

    logging INFO "Maven Central registered tomcat 8.5 jars"

    CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/tomcat85.jar | perl -wp -e 's!.+tomcat85-([^-]+).jar!$1!'`

    for VERSION in `curl -s 'http://search.maven.org/solrsearch/select?q=g:org.apache.tomcat.embed+AND+a:tomcat-embed-core+AND+v:8.5*&rows=100&core=gav' | perl -wp -e 's!,!,\n!g' | perl -wnl -e 'print "$1 " if /"v":"([^"]+)"/' | sort`
    do
        if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
            echo "  ${CURRENT_VERSION} [current]"
        else
            echo "  ${VERSION}"
        fi
    done

elif [ "${COMMAND}" == "current" ];then
    VERSION=`ls -l ${ZENOBIA_BIN_DIR}/tomcat9.jar | perl -wp -e 's!.+tomcat9-([^-]+).jar!$1!'`

    logging INFO "current tomcat 9 version ${VERSION}"

    VERSION=`ls -l ${ZENOBIA_BIN_DIR}/tomcat85.jar | perl -wp -e 's!.+tomcat85-([^-]+).jar!$1!'`

    logging INFO "current tomcat 8.5 version ${VERSION}"

elif [ "${COMMAND}" == "uninstall" ]; then
    if [ -z "${VERSION}" ]; then
        logging ERROR "require version"
        exit 1
    fi

    if [ -e ${TOMCAT_DIR}/"tomcat${MAJOR_VERSION}-${VERSION}.jar" ]; then
        rm ${TOMCAT_DIR}/"tomcat${MAJOR_VERSION}-${VERSION}.jar"
        logging INFO "uninstall tomcat${MAJOR_VERSION}-${VERSION}.jar"

        CURRENT_VERSION=`ls -l ${ZENOBIA_BIN_DIR}/tomcat${MAJOR_VERSION}.jar | perl -wp -e "s!.+tomcat${MAJOR_VERSION}-([^-]+).jar!$1!"`

        if [ "${CURRENT_VERSION}" == "${VERSION}" ]; then
            rm ${ZENOBIA_BIN_DIR}/"tomcat${MAJOR_VERSION}.jar"
            rm ${ZENOBIA_BIN_DIR}/"tomcat${MAJOR_VERSION}"
            logging INFO "remove tomcat${MAJOR_VERSION}.jar"
            logging INFO "remove tomcat${MAJOR_VERSION}"
        fi
    else
        logging INFO "already uninstalled payara-micro-${VERSION}.jar"
    fi
fi
