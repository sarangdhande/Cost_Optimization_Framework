#!/bin/bash
#Define variables
CREDENTIAL_FILE="$1"

# aws authN
AWS_ACCESS_KEY_ID=$(yq -r '.auth_configs.aws.access_key' $CREDENTIAL_FILE)
AWS_SECRET_ACCESS_KEY=$(yq -r '.auth_configs.aws.secret_access_key' $CREDENTIAL_FILE)
AWS_REGION=$(yq -r '.auth_configs.aws.region' $CREDENTIAL_FILE)
AWS_OUTPUT=$(yq -r '.auth_configs.aws.output' $CREDENTIAL_FILE)

# azure authN
AZURE_CLIENT_ID=$(yq -r '.auth_configs.azure.client_id' $CREDENTIAL_FILE)
AZURE_CLIENT_SECRET=$(yq -r '.auth_configs.azure.client_secret' $CREDENTIAL_FILE)
AZURE_TENANT_ID=$(yq -r '.auth_configs.azure.tenant' $CREDENTIAL_FILE)

# aws login
aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
aws configure set region "${AWS_REGION}"
aws configure set output "${AWS_OUTPUT}"

# Azure login
az login --service-principal \
  -u "${AZURE_CLIENT_ID}" \
  -p  "${AZURE_CLIENT_SECRET}" \
  --tenant "${AZURE_TENANT_ID}" \
  --allow-no-subscriptions

# Validate login
if aws sts get-caller-identity > /dev/null 2>&1; then
  iam_user=$(aws sts get-caller-identity --query 'Arn' --output text)
  echo "INFO: Successfully logged in with AWS IAM User $iam_user"
else
  echo "ERROR: Unexpected error occured while authentication with IAM User"
  exit 1
fi

# Validate login
if az account show > /dev/null 2>&1; then
  azsp_id=$(az ad sp show --query 'user.name' -o tsv)
  azsp_name=$(az ad sp show --id $azsp_id --query 'appDisplayName' -o tsv)
  echo "INFO: Successfully looged in with Azure Service Principle $azsp_name/$azsp_id"
else
  echo "ERROR: Unexpected error occured during authenticating with service principle"
  exit1
fi