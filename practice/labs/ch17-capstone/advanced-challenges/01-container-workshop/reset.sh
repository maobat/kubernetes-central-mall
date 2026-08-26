#!/usr/bin/env bash

set -euo pipefail

D="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

CLUSTER_NAME="${KIND_CLUSTER_NAME:-ckad}"
IMAGE="central-mall/boutique:v2"

echo "🏭 Building approved boutique image..."

docker build \
  -t "$IMAGE" \
  "$D"

echo
echo "📦 Loading image into kind cluster: $CLUSTER_NAME"

kind load docker-image \
  "$IMAGE" \
  --name "$CLUSTER_NAME"

echo
echo "♻️ Recreating Container Workshop..."

kubectl delete namespace mall-workshop \
  --ignore-not-found \
  --wait=true

kubectl apply \
  -f "$D/manifests/boutique.yaml"

kubectl rollout status deployment/container-workshop \
  -n mall-workshop \
  --timeout=90s

echo
echo "✅ Container Workshop restored."
