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

export APP_BASE=/usr/local/src
export APP_DIR=django-dashboard-black
export APP_SRC=${APP_BASE}/${APP_DIR}
export APP_VERSION=feature/decoupling
export APP_REPO=https://github.com/btower-labz/django-dashboard-black.git

log 'Variables configured ...'

mkdir -p ${APP_BASE}
git clone ${APP_REPO} ${APP_SRC}
cd ${APP_SRC}
git checkout ${APP_VERSION}

log 'Application downloaded ...'

touch .env
docker-compose -f docker-compose-cloud.yml config
docker-compose -f docker-compose-cloud.yml pull
docker-compose -f docker-compose-cloud.yml build
log 'Finished ...'
