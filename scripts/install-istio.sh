#!/usr/bin/env bash
set -euo pipefail

curl -L https://istio.io/downloadIstio | sh -
ISTIO_DIR=$(ls -d istio-*/ | head -n1)
"${ISTIO_DIR}/bin/istioctl" install -y -f ./helm-values/istio-operator.yaml
