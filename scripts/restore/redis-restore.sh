#!/usr/bin/env bash
set -euo pipefail

SNAPSHOT_NAME=${1:?"Snapshot name required"}
NEW_REPL_ID=${2:?"New replication group id required"}

aws elasticache create-replication-group \
  --replication-group-id "${NEW_REPL_ID}" \
  --replication-group-description "Restored group" \
  --snapshot-name "${SNAPSHOT_NAME}" \
  --engine redis
