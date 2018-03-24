#!/bin/bash

set -e

SCRIPT_DIR=$(cd $(dirname $0)  && pwd)

cd ${SCRIPT_DIR}

mvn -N io.takari:maven:wrapper
tar -czf mvnw.tar.gz mvnw* .mvn
mv mvnw.tar.gz ../executable-container
rm -rf  mvnw* .mvn
