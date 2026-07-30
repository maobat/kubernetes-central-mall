#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CAPSTONE_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOLUTIONS_DIR="$CAPSTONE_DIR/solutions"
SHOP_NS="mall-shops"
STS="shoes-boutique"

info() { printf '\n\033[1;34m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[1;32m✔\033[0m %s\n' "$*"; }
fail() { printf '  \033[1;31m✘\033[0m %s\n' "$*" >&2; exit 1; }

command -v kubectl >/dev/null 2>&1 || fail "kubectl is not installed or not in PATH."
kubectl cluster-info >/dev/null 2>&1 || fail "No reachable Kubernetes cluster."

for file in \
  phase1-foundation.yaml \
  phase2-workloads.yaml \
  phase3-networking.yaml \
  phase4-maintenance.yaml; do
  [[ -f "$SOLUTIONS_DIR/$file" ]] || fail "Missing solution file: $SOLUTIONS_DIR/$file"
done

info "🏬 CENTRAL MALL — restoring the approved architecture"

if kubectl get sts "$STS" -n "$SHOP_NS" >/dev/null 2>&1; then
  kubectl scale sts "$STS" -n "$SHOP_NS" --replicas=0 >/dev/null
  kubectl rollout status sts "$STS" -n "$SHOP_NS" --timeout=120s >/dev/null || true
fi

# The challenge recreates storage with an intentionally mismatched selector.
# Delete only those two storage objects so the approved manifests can recreate them.
kubectl delete pvc warehouse-pvc -n "$SHOP_NS" --ignore-not-found --wait=true >/dev/null
kubectl delete pv warehouse-pv --ignore-not-found --wait=true >/dev/null

for file in \
  phase1-foundation.yaml \
  phase2-workloads.yaml \
  phase3-networking.yaml \
  phase4-maintenance.yaml; do
  kubectl apply -f "$SOLUTIONS_DIR/$file" >/dev/null
  ok "Applied $file"
done

kubectl scale sts "$STS" -n "$SHOP_NS" --replicas=2 >/dev/null
kubectl rollout status sts "$STS" -n "$SHOP_NS" --timeout=180s
kubectl rollout status ds/security-camera -n mall-security --timeout=180s

cat <<'TEXT'

============================================================
✅ CENTRAL MALL RESET COMPLETE
============================================================

The approved architecture has been restored from solutions/.
You may run ./challenge/overnight-contractors.sh again.
============================================================
TEXT
