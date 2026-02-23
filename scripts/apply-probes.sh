#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=${1:-openedx}

kubectl -n "${NAMESPACE}" patch deployment lms --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/livenessProbe","value":{"httpGet":{"path":"/","port":8000},"initialDelaySeconds":60,"periodSeconds":15}},
  {"op":"add","path":"/spec/template/spec/containers/0/readinessProbe","value":{"httpGet":{"path":"/","port":8000},"initialDelaySeconds":30,"periodSeconds":10}}
]'

kubectl -n "${NAMESPACE}" patch deployment cms --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/containers/0/livenessProbe","value":{"httpGet":{"path":"/","port":8000},"initialDelaySeconds":60,"periodSeconds":15}},
  {"op":"add","path":"/spec/template/spec/containers/0/readinessProbe","value":{"httpGet":{"path":"/","port":8000},"initialDelaySeconds":30,"periodSeconds":10}}
]'
