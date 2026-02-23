#!/usr/bin/env bash
set -euo pipefail

ES_ENDPOINT=${1:?"Elasticsearch endpoint required (host:9200)"}
SNAPSHOT_REPO=${2:-"s3-repo"}
SNAPSHOT_NAME=${3:-"es-$(date +%Y%m%d%H%M)"}

cat <<JSON > /tmp/es-repo.json
{
  "type": "s3",
  "settings": {
    "bucket": "<S3_BUCKET>",
    "region": "<AWS_REGION>",
    "role_arn": "<IAM_ROLE_ARN>"
  }
}
JSON

curl -XPUT "http://${ES_ENDPOINT}/_snapshot/${SNAPSHOT_REPO}" -H 'Content-Type: application/json' -d @/tmp/es-repo.json
curl -XPUT "http://${ES_ENDPOINT}/_snapshot/${SNAPSHOT_REPO}/${SNAPSHOT_NAME}" -H 'Content-Type: application/json'

echo "Created Elasticsearch snapshot: ${SNAPSHOT_NAME}"
