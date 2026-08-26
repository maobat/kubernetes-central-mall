#!/usr/bin/env bash

set -euo pipefail

D="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

NS="mall-workshop"
CLUSTER_NAME="${KIND_CLUSTER_NAME:-ckad}"
APPROVED_IMAGE="central-mall/boutique:v2"
BROKEN_IMAGE="central-mall/boutique:broken"

echo "🌙 Overnight contractors entered the Container Workshop..."
echo

kubectl apply -f "$D/manifests/boutique.yaml"

# ------------------------------------------------------------
# 1. Stop the workload so the approved image is no longer in use
# ------------------------------------------------------------

echo "🛑 Closing the boutique before removing its image..."

kubectl scale deployment/container-workshop \
  -n "$NS" \
  --replicas=0

kubectl wait \
  --for=delete pod \
  -n "$NS" \
  -l app=container-workshop \
  --timeout=60s 2>/dev/null || true

# ------------------------------------------------------------
# 2. Remove the approved image from every kind node
# ------------------------------------------------------------

echo "�� Removing the approved image from kind nodes..."

mapfile -t KIND_NODES < <(
  kind get nodes --name "$CLUSTER_NAME"
)

if [[ "${#KIND_NODES[@]}" -eq 0 ]]; then
  echo "❌ No nodes found for kind cluster: $CLUSTER_NAME"
  exit 1
fi

for node in "${KIND_NODES[@]}"; do
  echo "   Checking $node..."

  image_id="$(
    docker exec "$node" crictl images \
      --output json |
    jq -r --arg image "docker.io/${APPROVED_IMAGE}" '
      .images[]
      | select(
          (.repoTags // [])[]
          == ($image)
      )
      | .id
    ' |
    head -n 1
  )"

  if [[ -n "$image_id" ]]; then
    docker exec "$node" crictl rmi "$image_id"
    echo "   ✅ Removed from $node"
  else
    echo "   ℹ️ Image was not present on $node"
  fi
done

# ------------------------------------------------------------
# 3. Configure the Deployment with the broken image
# ------------------------------------------------------------

echo "🏷️ Applying the broken shipping label..."

kubectl set image deployment/container-workshop \
  nginx="$BROKEN_IMAGE" \
  -n "$NS"

kubectl scale deployment/container-workshop \
  -n "$NS" \
  --replicas=1

# ------------------------------------------------------------
# 4. Break the Service targetPort
# ------------------------------------------------------------

echo "🚪 Redirecting the Service to the wrong port..."

kubectl patch service container-workshop \
  -n "$NS" \
  --type=merge \
  -p '{
    "spec": {
      "ports": [
        {
          "port": 80,
          "targetPort": 8080
        }
      ]
    }
  }'

echo
echo "🔥 Overnight contractors caused three real problems:"
echo
echo "   ❌ Deployment image: $BROKEN_IMAGE"
echo "   ❌ Approved image removed from every kind node"
echo "   ❌ Service targetPort: 8080"
