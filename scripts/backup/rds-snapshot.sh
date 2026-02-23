#!/usr/bin/env bash
set -euo pipefail

DB_INSTANCE_ID=${1:?"RDS instance id required"}
SNAPSHOT_ID="${DB_INSTANCE_ID}-$(date +%Y%m%d%H%M)"

aws rds create-db-snapshot \
  --db-instance-identifier "${DB_INSTANCE_ID}" \
  --db-snapshot-identifier "${SNAPSHOT_ID}"

echo "Created RDS snapshot: ${SNAPSHOT_ID}"
