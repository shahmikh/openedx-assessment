#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=${1:-openedx}

kubectl -n "${NAMESPACE}" patch deployment lms --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/volumes/-","value":{"name":"openedx-media","persistentVolumeClaim":{"claimName":"openedx-media"}}},
  {"op":"add","path":"/spec/template/spec/containers/0/volumeMounts/-","value":{"name":"openedx-media","mountPath":"/openedx/media"}}
]'

kubectl -n "${NAMESPACE}" patch deployment cms --type='json' -p='[
  {"op":"add","path":"/spec/template/spec/volumes/-","value":{"name":"openedx-media","persistentVolumeClaim":{"claimName":"openedx-media"}}},
  {"op":"add","path":"/spec/template/spec/containers/0/volumeMounts/-","value":{"name":"openedx-media","mountPath":"/openedx/media"}}
]'
