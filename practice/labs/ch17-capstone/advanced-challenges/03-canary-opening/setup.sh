#!/usr/bin/env bash
set -euo pipefail

D="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$D/manifests/canary.yaml"

kubectl scale deploy checkout-stable \
  -n mall-canary \
  --replicas=5

kubectl scale deploy checkout-canary \
  -n mall-canary \
  --replicas=3

kubectl patch svc checkout \
  -n mall-canary \
  --type=merge \
  -p '{"spec":{"selector":{"app":"checkout","track":"stable"}}}'

echo '🔥 Canary ratio broken and Service selects only stable Pods.'
