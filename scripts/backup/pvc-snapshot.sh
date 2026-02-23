#!/usr/bin/env bash
set -euo pipefail

NAMESPACE=${1:?"Namespace required"}
PVC_NAME=${2:?"PVC name required"}
SNAPSHOT_NAME=${3:-"${PVC_NAME}-snapshot-$(date +%Y%m%d%H%M)"}

cat <<YAML | kubectl apply -f -
apiVersion: snapshot.storage.kubernetes.io/v1
kind: VolumeSnapshot
metadata:
  name: ${SNAPSHOT_NAME}
  namespace: ${NAMESPACE}
spec:
  volumeSnapshotClassName: ebs-snapshot
  source:
    persistentVolumeClaimName: ${PVC_NAME}
YAML

echo "Created VolumeSnapshot ${SNAPSHOT_NAME} in ${NAMESPACE}"
