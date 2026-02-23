#!/usr/bin/env bash
set -euo pipefail

REPL_ID=${1:?"Redis replication group id required"}
SNAPSHOT_NAME="${REPL_ID}-$(date +%Y%m%d%H%M)"

aws elasticache create-snapshot \
  --replication-group-id "${REPL_ID}" \
  --snapshot-name "${SNAPSHOT_NAME}"

echo "Created Redis snapshot: ${SNAPSHOT_NAME}"
