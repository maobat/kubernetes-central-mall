#!/usr/bin/env bash

set -uo pipefail

NS="mall-canary"
FAILED=0

echo "🔍 Verifying Canary Opening..."
echo

# ------------------------------------------------------------
# 1. Verify desired replica counts
# ------------------------------------------------------------

stable_replicas="$(
  kubectl get deployment checkout-stable \
    -n "$NS" \
    -o jsonpath='{.spec.replicas}'
)"

if [[ "$stable_replicas" == "4" ]]; then
  echo "✅ Stable replicas: 4"
else
  echo "❌ Stable replicas: expected 4, found $stable_replicas"
  FAILED=1
fi

canary_replicas="$(
  kubectl get deployment checkout-canary \
    -n "$NS" \
    -o jsonpath='{.spec.replicas}'
)"

if [[ "$canary_replicas" == "1" ]]; then
  echo "✅ Canary replicas: 1"
else
  echo "❌ Canary replicas: expected 1, found $canary_replicas"
  FAILED=1
fi

# ------------------------------------------------------------
# 2. Verify the shared Service selector
# ------------------------------------------------------------

service_app_selector="$(
  kubectl get service checkout \
    -n "$NS" \
    -o jsonpath='{.spec.selector.app}'
)"

service_track_selector="$(
  kubectl get service checkout \
    -n "$NS" \
    -o jsonpath='{.spec.selector.track}'
)"

if [[ "$service_app_selector" == "checkout" ]] &&
   [[ -z "$service_track_selector" ]]; then
  echo '✅ Service selector: {"app":"checkout"}'
else
  actual_selector="$(
    kubectl get service checkout \
      -n "$NS" \
      -o jsonpath='{.spec.selector}'
  )"

  echo "❌ Service selector is incorrect: $actual_selector"
  echo '   Expected only: {"app":"checkout"}'
  FAILED=1
fi

# ------------------------------------------------------------
# 3. Verify Deployment rollouts
# ------------------------------------------------------------

echo
echo "⏳ Checking Deployment rollouts..."

if kubectl rollout status deployment/checkout-stable \
  -n "$NS" \
  --timeout=90s; then
  echo "✅ Stable Deployment rolled out"
else
  echo "❌ Stable Deployment rollout failed"
  FAILED=1
fi

if kubectl rollout status deployment/checkout-canary \
  -n "$NS" \
  --timeout=90s; then
  echo "✅ Canary Deployment rolled out"
else
  echo "❌ Canary Deployment rollout failed"
  FAILED=1
fi

# ------------------------------------------------------------
# 4. Verify Ready Pods by release track
# ------------------------------------------------------------

stable_ready="$(
  kubectl get pods \
    -n "$NS" \
    -l app=checkout,track=stable \
    -o custom-columns='NAME:.metadata.name,READY:.status.conditions[?(@.type=="Ready")].status' \
    --no-headers |
    awk '$2 == "True" { count++ } END { print count+0 }'
)"

canary_ready="$(
  kubectl get pods \
    -n "$NS" \
    -l app=checkout,track=canary \
    -o custom-columns='NAME:.metadata.name,READY:.status.conditions[?(@.type=="Ready")].status' \
    --no-headers |
    awk '$2 == "True" { count++ } END { print count+0 }'
)"

if [[ "$stable_ready" == "4" ]]; then
  echo "✅ Ready stable Pods: 4"
else
  echo "❌ Ready stable Pods: expected 4, found $stable_ready"
  FAILED=1
fi

if [[ "$canary_ready" == "1" ]]; then
  echo "✅ Ready canary Pods: 1"
else
  echo "❌ Ready canary Pods: expected 1, found $canary_ready"
  FAILED=1
fi

# ------------------------------------------------------------
# 5. Verify Service EndpointSlice membership
# ------------------------------------------------------------

endpoint_count="$(
  kubectl get endpointslice \
    -n "$NS" \
    -l kubernetes.io/service-name=checkout \
    -o jsonpath='{range .items[*].endpoints[?(@.conditions.ready==true)]}{.addresses[0]}{"\n"}{end}' |
    grep -c .
)"

if [[ "$endpoint_count" == "5" ]]; then
  echo "✅ Ready Service endpoints: 5"
else
  echo "❌ Ready Service endpoints: expected 5, found $endpoint_count"
  FAILED=1
fi

# Verify that both stable and canary Pods are selected by the Service.
selected_stable=0
selected_canary=0

while IFS= read -r pod_name; do
  [[ -z "$pod_name" ]] && continue

  track="$(
    kubectl get pod "$pod_name" \
      -n "$NS" \
      -o jsonpath='{.metadata.labels.track}'
  )"

  case "$track" in
    stable)
      selected_stable=$((selected_stable + 1))
      ;;
    canary)
      selected_canary=$((selected_canary + 1))
      ;;
  esac
done < <(
  kubectl get endpointslice \
    -n "$NS" \
    -l kubernetes.io/service-name=checkout \
    -o jsonpath='{range .items[*].endpoints[?(@.conditions.ready==true)]}{.targetRef.name}{"\n"}{end}'
)

if [[ "$selected_stable" == "4" ]]; then
  echo "✅ Stable Pods selected by Service: 4"
else
  echo "❌ Stable Pods selected by Service: expected 4, found $selected_stable"
  FAILED=1
fi

if [[ "$selected_canary" == "1" ]]; then
  echo "✅ Canary Pods selected by Service: 1"
else
  echo "❌ Canary Pods selected by Service: expected 1, found $selected_canary"
  FAILED=1
fi

# ------------------------------------------------------------
# 6. Stop before traffic testing if architecture is still broken
# ------------------------------------------------------------

if [[ "$FAILED" -ne 0 ]]; then
  echo
  echo "🔥 Canary challenge is not repaired yet."
  exit 1
fi

# ------------------------------------------------------------
# 7. Send sample traffic
# ------------------------------------------------------------

echo
echo "📊 Sending 30 requests..."
echo "   The observed distribution is approximate, not guaranteed."
echo

kubectl run canary-check \
  -n "$NS" \
  --rm -i \
  --restart=Never \
  --image=busybox:1.36 \
  -- sh -c '
    stable=0
    canary=0
    failed=0

    for i in $(seq 1 30); do
      response="$(wget -T 5 -qO- http://checkout)" || {
        failed=$((failed + 1))
        continue
      }

      case "$response" in
        *STABLE*)
          stable=$((stable + 1))
          ;;
        *CANARY*)
          canary=$((canary + 1))
          ;;
        *)
          echo "⚠️ Unexpected response: $response"
          failed=$((failed + 1))
          ;;
      esac
    done

    echo "STABLE boutique: $stable"
    echo "CANARY boutique: $canary"
    echo "Failed requests: $failed"
    echo "Total responses: $((stable + canary + failed))"
  '

echo
echo "✅ Canary Opening verified successfully."
echo
echo "Expected architecture:"
echo "  4 stable Pods"
echo "  1 canary Pod"
echo "  5 ready Service endpoints"
echo "  approximately 20% canary traffic over many connections"
