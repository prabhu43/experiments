#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="netpol-demo"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

if kind get clusters 2>/dev/null | grep -qx "$CLUSTER_NAME"; then
  echo "==> Kind cluster '$CLUSTER_NAME' already exists, skipping creation"
else
  echo "==> Creating Kind cluster: $CLUSTER_NAME"
  kind create cluster --name "$CLUSTER_NAME" --config "$SCRIPT_DIR/kind-config.yaml"
fi

echo "==> Installing Calico CNI"
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.2/manifests/calico.yaml

echo "==> Waiting for Calico pods to be ready..."
kubectl -n kube-system wait --for=condition=Ready pods -l k8s-app=calico-node --timeout=120s

echo "==> Waiting for all nodes to be Ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s

echo ""
echo "==> Cluster is ready!"
kubectl get nodes
echo ""
