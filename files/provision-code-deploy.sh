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

# See: https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html
# See: https://docs.aws.amazon.com/codedeploy/latest/userguide/resource-kit.html#resource-kit-bucket-names

# TODO: HardCode

yum -y update
yum -y install ruby
yum -y install curl wget

export CODE_DEPLOY_REGION=$(curl --silent --location http://169.254.169.254/latest/meta-data/placement/region)
export CODE_DEPLOY_BUCKET=aws-codedeploy-${CODE_DEPLOY_REGION}
export CODE_DEPLOY_URL=https://${CODE_DEPLOY_BUCKET}.s3.${CODE_DEPLOY_REGION}.amazonaws.com/latest/install
export CODE_DEPLOY_SRC=/usr/local/src/code-deploy

mkdir -p /usr/local/src/code-deploy
cd /usr/local/src/code-deploy

echo "URL: ${CODE_DEPLOY_URL}"
wget ${CODE_DEPLOY_URL}
cat install
chmod +x ./install
./install auto

cd /tmp
rm -rf /usr/local/src/code-deploy

# See: https://github.com/aws/aws-codedeploy-agent/issues/205
chmod -x /usr/lib/systemd/system/codedeploy-agent.service
log 'Fixed permissions ...'

service codedeploy-agent start
service codedeploy-agent status

log 'Finished ...'
