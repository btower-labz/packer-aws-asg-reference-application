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

log 'Variables configured ...'

mkdir -p ${APP_SRC}
curl --silent --location -o ${APP_SRC}/sample.war ${APP_URL}
ls -la ${APP_SRC}/sample.war

log 'Application downloaded ...'

# TODO: validate\checksum archive

cp ${APP_SRC}/sample.war ${APP_DST}/service1.war
cp ${APP_SRC}/sample.war ${APP_DST}/service2.war
cp ${APP_SRC}/sample.war ${APP_DST}/service3.war
ls -la ${APP_DST}

log 'Application installed ...'

cd /tmp
rm -rf ${APP_SRC}

# TODO: validate packages with wildfly

log 'Finished ...'
