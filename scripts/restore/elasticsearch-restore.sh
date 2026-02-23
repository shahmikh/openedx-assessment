#!/usr/bin/env bash
set -euo pipefail

ES_ENDPOINT=${1:?"Elasticsearch endpoint required (host:9200)"}
SNAPSHOT_REPO=${2:-"s3-repo"}
SNAPSHOT_NAME=${3:?"Snapshot name required"}

curl -XPOST "http://${ES_ENDPOINT}/_snapshot/${SNAPSHOT_REPO}/${SNAPSHOT_NAME}/_restore" -H 'Content-Type: application/json' -d '{"indices":"*"}'
