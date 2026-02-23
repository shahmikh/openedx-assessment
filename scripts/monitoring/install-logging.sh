#!/usr/bin/env bash
set -euo pipefail

helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm upgrade --install aws-for-fluent-bit eks/aws-for-fluent-bit \
  -n logging --create-namespace \
  -f ../../helm-values/fluent-bit-values.yaml
