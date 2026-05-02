#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="netpol-demo"

echo "==> Deleting Kind cluster: $CLUSTER_NAME"
kind delete cluster --name "$CLUSTER_NAME"
echo "==> Done. Cluster deleted."
