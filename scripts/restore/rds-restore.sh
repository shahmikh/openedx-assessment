#!/usr/bin/env bash
set -euo pipefail

SNAPSHOT_ID=${1:?"Snapshot id required"}
NEW_INSTANCE_ID=${2:?"New instance id required"}

aws rds restore-db-instance-from-db-snapshot \
  --db-snapshot-identifier "${SNAPSHOT_ID}" \
  --db-instance-identifier "${NEW_INSTANCE_ID}"
