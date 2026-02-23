#!/usr/bin/env bash
set -euo pipefail

ES_ENDPOINT=${1:?"Elasticsearch endpoint required (host:9200)"}

curl -XPUT "http://${ES_ENDPOINT}/_template/openedx" \
  -H 'Content-Type: application/json' \
  -d '{
    "index_patterns": ["openedx-*"]
  }'
