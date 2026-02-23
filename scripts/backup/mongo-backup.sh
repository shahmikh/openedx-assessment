#!/usr/bin/env bash
set -euo pipefail

MONGO_URI=${1:?"MongoDB URI required"}
S3_BUCKET=${2:?"S3 bucket required"}
BACKUP_NAME=${3:-"mongodb-$(date +%Y%m%d%H%M).archive.gz"}

mongodump --uri "${MONGO_URI}" --archive="/tmp/${BACKUP_NAME}" --gzip
aws s3 cp "/tmp/${BACKUP_NAME}" "s3://${S3_BUCKET}/${BACKUP_NAME}"

echo "MongoDB backup uploaded to s3://${S3_BUCKET}/${BACKUP_NAME}"
