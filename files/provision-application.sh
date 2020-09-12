#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

BASENAME=$(basename "${0}")

function log {
  local MESSAGE=${1}
  echo "${BASENAME}: ${MESSAGE}"
  logger --id "${BASENAME}: ${MESSAGE}"
}

log 'Started ...'


export APP_URL=https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war
export APP_SRC=/usr/local/src/application
export APP_DST=/opt/wildfly/standalone/deployments

mkdir -p ${APP_SRC}
curl --silent --location -o ${APP_SRC}/sample.war

# TODO: validate\checksum archive

cp ${APP_SRC}/sample.war ${APP_DST}/service1.war
cp ${APP_SRC}/sample.war ${APP_DST}/service2.war
cp ${APP_SRC}/sample.war ${APP_DST}/service3.war

# TODO: validate packages with wildfly

log 'Finished ...'
