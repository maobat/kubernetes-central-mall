#!/bin/bash

# Lab 02: One-Way Corridors Setup Script

echo "🏗️  Building the Mall Wings..."

# 1. Create Namespaces if they don't exist
kubectl create ns space1 --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns space2 --dry-run=client -o yaml | kubectl apply -f -

# 2. Deploy the Worker (Source) in Space1
echo "🚀 Deploying Worker app1-0 in space1..."
kubectl run app1-0 -n space1 \
  --image=radial/busyboxplus:curl \
  --labels="app=app1" \
  --restart=Always \
  -- /bin/sh -c "while true; do sleep 30; done"

# 3. Deploy the Service (Target) in Space2
echo "🚀 Deploying Microservice in space2..."
kubectl run microservice1 -n space2 \
  --image=nginx \
  --labels="app=microservice1" \
  --port=80 \
  --restart=Always

kubectl expose pod microservice1 -n space2 \
  --name=microservice1 \
  --port=80

# 4. Deploy the Forbidden Target in Default
echo "🚀 Deploying Forbidden Tester in default..."
kubectl run tester -n default \
  --image=nginx \
  --labels="app=tester" \
  --port=80 \
  --restart=Always

kubectl expose pod tester -n default \
  --name=tester \
  --port=80

echo "✅  Mall wings are ready! Wait a few seconds for pods to be Running."
kubectl get pods -A | grep -E "space1|space2|tester"
