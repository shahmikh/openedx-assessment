#!/usr/bin/env bash
set -euo pipefail

MONGO_URI=${1:?"MongoDB URI required"}
S3_BUCKET=${2:?"S3 bucket required"}
BACKUP_NAME=${3:?"Backup name required"}

aws s3 cp "s3://${S3_BUCKET}/${BACKUP_NAME}" "/tmp/${BACKUP_NAME}"
mongorestore --uri "${MONGO_URI}" --archive="/tmp/${BACKUP_NAME}" --gzip --drop

echo "MongoDB restore completed"
