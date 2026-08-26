#!/usr/bin/env bash

set -uo pipefail

NS="mall-workshop"
FAILED=0

echo "🔍 Verifying Container Workshop..."
echo

#
# Deployment
#

echo "📦 Deployment"

if kubectl rollout status deployment/container-workshop \
  -n "$NS" \
  --timeout=90s
then
  echo "✅ Rolled out"
else
  echo "❌ Rollout failed"
  FAILED=1
fi

echo

#
# Image
#

echo "🐳 Image"

image="$(
  kubectl get deployment container-workshop \
    -n "$NS" \
    -o jsonpath='{.spec.template.spec.containers[0].image}'
)"

if [[ "$image" == "central-mall/boutique:v2" ]]
then
  echo "✅ $image"
else
  echo "❌ Expected central-mall/boutique:v2"
  echo "   Found: $image"
  FAILED=1
fi

echo

#
# Service
#

echo "🚪 Service"

target_port="$(
  kubectl get service container-workshop \
    -n "$NS" \
    -o jsonpath='{.spec.ports[0].targetPort}'
)"

if [[ "$target_port" == "80" ]]
then
  echo "✅ targetPort 80"
else
  echo "❌ targetPort should be 80"
  echo "   Found: $target_port"
  FAILED=1
fi

echo

#
# Ready Endpoints
#

echo "📍 Endpoints"

if ! command -v jq >/dev/null 2>&1
then
  echo "❌ jq is required to verify ready EndpointSlice members."
  exit 1
fi

ready_endpoints="$(
  kubectl get endpointslice \
    -n "$NS" \
    -l kubernetes.io/service-name=container-workshop \
    -o json |
  jq '
    [
      .items[]
      | (.endpoints // [])
      | .[]
      | select(.conditions.ready == true)
    ]
    | length
  '
)"

if [[ "$ready_endpoints" == "1" ]]
then
  echo "✅ 1 Ready endpoint"
else
  echo "❌ Expected 1 Ready endpoint"
  echo "   Found: $ready_endpoints"
  FAILED=1
fi

echo

if [[ "$FAILED" -ne 0 ]]
then
  echo "🔥 Container Workshop is not repaired yet."
  exit 1
fi

#
# HTTP
#

echo "🌐 HTTP"

response="$(
  kubectl run workshop-check \
    -n "$NS" \
    --rm \
    -i \
    --restart=Never \
    --image=busybox:1.36 \
    -- sh -c '
      attempts=10

      for i in $(seq 1 "$attempts")
      do
        response="$(wget -T 3 -qO- http://container-workshop 2>/dev/null)"

        if [ "$?" -eq 0 ]
        then
          printf "%s" "$response"
          exit 0
        fi

        sleep 2
      done

      exit 1
    ' 2>/dev/null
)"

http_status=$?

if [[ "$http_status" -ne 0 ]]
then
  echo "❌ Boutique did not answer."
  exit 1
fi

if [[ "$response" == *"Welcome to the Container Workshop!"* ]]
then
  echo "✅ Boutique serves the approved page"
else
  echo "❌ Unexpected page:"
  echo "$response"
  exit 1
fi

echo
echo "🎉 Container Workshop verified successfully."
