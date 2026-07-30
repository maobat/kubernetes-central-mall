#!/usr/bin/env bash
set -Eeuo pipefail

SHOP_NS="mall-shops"
SECURITY_NS="mall-security"
STS="shoes-boutique"
PVC="warehouse-pvc"
PV="warehouse-pv"

info()  { printf '\n\033[1;34m%s\033[0m\n' "$*"; }
ok()    { printf '  \033[1;32m✔\033[0m %s\n' "$*"; }
fail()  { printf '  \033[1;31m✘\033[0m %s\n' "$*" >&2; exit 1; }

command -v kubectl >/dev/null 2>&1 || fail "kubectl is not installed or not in PATH."
kubectl cluster-info >/dev/null 2>&1 || fail "No reachable Kubernetes cluster."

required=(
  "namespace/${SHOP_NS}"
  "namespace/${SECURITY_NS}"
  "serviceaccount/cashier -n ${SHOP_NS}"
  "role/shop-manager -n ${SHOP_NS}"
  "rolebinding/cashier-shop-manager -n ${SHOP_NS}"
  "statefulset/${STS} -n ${SHOP_NS}"
  "service/shoes-boutique-svc -n ${SHOP_NS}"
  "networkpolicy/secure-shops -n ${SHOP_NS}"
  "daemonset/security-camera -n ${SECURITY_NS}"
)

info "🏬 CENTRAL MALL — overnight contractor pre-flight"
for entry in "${required[@]}"; do
  # shellcheck disable=SC2086
  kubectl get ${entry} >/dev/null 2>&1 || fail "Required resource not found: kubectl get ${entry}"
done
ok "The mall is present and ready to be sabotaged."

ORIGINAL_REPLICAS="$(kubectl get sts "$STS" -n "$SHOP_NS" -o jsonpath='{.spec.replicas}')"
ORIGINAL_REPLICAS="${ORIGINAL_REPLICAS:-2}"

info "[1/6] Who removed the permits?"
kubectl patch role shop-manager -n "$SHOP_NS" --type=merge \
  -p='{"rules":[{"apiGroups":[""],"resources":["services"],"verbs":["get","list","watch"]}]}' >/dev/null
ok "The cashier can no longer read Pods."

info "[2/6] The warehouse reservation is stuck."
kubectl scale sts "$STS" -n "$SHOP_NS" --replicas=0 >/dev/null
kubectl rollout status sts "$STS" -n "$SHOP_NS" --timeout=120s >/dev/null

kubectl delete pvc "$PVC" -n "$SHOP_NS" --ignore-not-found --wait=true >/dev/null
kubectl delete pv "$PV" --ignore-not-found --wait=true >/dev/null

kubectl apply -f - >/dev/null <<'YAML'
apiVersion: v1
kind: PersistentVolume
metadata:
  name: warehouse-pv
  labels:
    warehouse: unavailable
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadWriteOnce
  storageClassName: ""
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /mnt/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: warehouse-pvc
  namespace: mall-shops
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: ""
  selector:
    matchLabels:
      warehouse: reserved
  resources:
    requests:
      storage: 500Mi
YAML
ok "The PVC now requests the same size, but its reservation cannot match the PV."

info "[3/6] The welcome sign has disappeared."
kubectl patch sts "$STS" -n "$SHOP_NS" --type=json \
  -p='[{"op":"replace","path":"/spec/template/spec/initContainers/0/volumeMounts/0/mountPath","value":"/tmp/welcome-sign"}]' >/dev/null
ok "The init container writes the sign into the wrong path."

info "[4/6] The corridor reaches no boutiques."
kubectl patch svc shoes-boutique-svc -n "$SHOP_NS" --type=merge \
  -p='{"spec":{"selector":{"app":"shoes-boutique-broken"}}}' >/dev/null
ok "The headless Service selector no longer matches the Pod labels."

info "[5/6] A contractor locked every entrance."
kubectl patch networkpolicy secure-shops -n "$SHOP_NS" --type=json \
  -p='[{"op":"replace","path":"/spec/ingress/0/ports/0/port","value":8080}]' >/dev/null
ok "Approved traffic is now allowed only on the wrong TCP port."

info "[6/6] The security team is in the wrong district."
kubectl patch daemonset security-camera -n "$SECURITY_NS" --type=merge \
  -p='{"spec":{"template":{"spec":{"affinity":null}}}}' >/dev/null
ok "The DaemonSet is no longer restricted to secure nodes."

kubectl scale sts "$STS" -n "$SHOP_NS" --replicas="$ORIGINAL_REPLICAS" >/dev/null

cat <<'TEXT'

============================================================
🔥 OVERNIGHT MAINTENANCE COMPLETE
============================================================

The Inspector arrives at 09:00.
Six operational faults are now live in the cluster.

Rules:
  • inspect before editing;
  • repair only the affected resources;
  • keep warehouse-pvc requested storage at 500Mi;
  • do not rebuild the entire mall from the solution files.

Start with:
  kubectl get pods -A
  kubectl get events -n mall-shops --sort-by=.lastTimestamp

Good luck, Mall Operator.
============================================================
TEXT
