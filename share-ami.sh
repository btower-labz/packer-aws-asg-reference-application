#!/usr/bin/env bash

set -o nounset
set -o noclobber
set -o errexit
set -o pipefail

source packer-vars.sh

aws sts get-caller-identity --profile ${PACKER_PROFILE}

aws ec2 describe-images \
    --owners self \
    --filters 'Name=name,Values=aws-ec2-reference-application-*' 'Name=state,Values=available' \
    --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' \
    --output json --profile ${PACKER_PROFILE} --region eu-west-2

exit 0

aws ec2 modify-image-attribute \
    --image-id ami-0abcdef1234567890 \
    --launch-permission "Add=[{UserId=${PACKER_SHARE_ACC}}]"
