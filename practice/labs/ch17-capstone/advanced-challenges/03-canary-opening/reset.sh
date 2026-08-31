#!/usr/bin/env bash
set -euo pipefail
D="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
kubectl delete ns mall-canary --ignore-not-found
kubectl apply -f "$D/manifests/canary.yaml"
