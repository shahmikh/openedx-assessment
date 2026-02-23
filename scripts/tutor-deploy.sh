#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

if [ -f "${ROOT_DIR}/tutor/external.env" ]; then
  # shellcheck source=/dev/null
  source "${ROOT_DIR}/tutor/external.env"
fi

# Base config
python3 -m tutor config save --set K8S_NAMESPACE=openedx --set ENABLE_HTTPS=0 --set CADDY_ENABLED=0

# External services (only set if env vars provided)
if [ -n "${MYSQL_HOST:-}" ]; then
  python3 -m tutor config save --set MYSQL_HOST="${MYSQL_HOST}" --set MYSQL_USERNAME="${MYSQL_USERNAME}" --set MYSQL_PASSWORD="${MYSQL_PASSWORD}" --set MYSQL_DATABASE="${MYSQL_DATABASE:-openedx}"
fi
if [ -n "${MONGO_HOST:-}" ]; then
  python3 -m tutor config save --set MONGO_HOST="${MONGO_HOST}" --set MONGO_USERNAME="${MONGO_USERNAME}" --set MONGO_PASSWORD="${MONGO_PASSWORD}"
fi
if [ -n "${ELASTICSEARCH_HOST:-}" ]; then
  python3 -m tutor config save --set ELASTICSEARCH_HOST="${ELASTICSEARCH_HOST}" --set ELASTICSEARCH_USERNAME="${ELASTICSEARCH_USERNAME}" --set ELASTICSEARCH_PASSWORD="${ELASTICSEARCH_PASSWORD}" --set ELASTICSEARCH_USE_SSL=false
fi
if [ -n "${REDIS_HOST:-}" ]; then
  python3 -m tutor config save --set REDIS_HOST="${REDIS_HOST}"
fi

# Deploy
python3 -m tutor k8s init
python3 -m tutor k8s start
