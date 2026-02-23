#!/usr/bin/env bash
set -euo pipefail

ENVIRONMENT=${1:-prod}
ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

cd "${ROOT_DIR}/infra/terraform/envs/${ENVIRONMENT}"
terraform init
terraform plan
