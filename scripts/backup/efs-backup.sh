#!/usr/bin/env bash
set -euo pipefail

VAULT_NAME=${1:?"Backup vault name required"}
RESOURCE_ARN=${2:?"EFS ARN required"}
ROLE_ARN=${3:?"IAM role ARN required"}

aws backup start-backup-job \
  --backup-vault-name "${VAULT_NAME}" \
  --resource-arn "${RESOURCE_ARN}" \
  --iam-role-arn "${ROLE_ARN}"
