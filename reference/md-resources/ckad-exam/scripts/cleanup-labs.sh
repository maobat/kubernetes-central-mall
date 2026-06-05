#!/usr/bin/env bash
# cleanup-labs.sh
# Safely tears down and cleans up the CKAD simulator lab environment

set -euo pipefail

echo "=========================================="
echo "🧼 Starting CKAD Simulator Lab Cleanup..."
echo "=========================================="

# If running as root via sudo, inherit the calling user's KUBECONFIG
if [ "${EUID:-0}" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
  USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
  export KUBECONFIG="${KUBECONFIG:-$USER_HOME/.kube/config}"
fi

# 1. Delete created resources in default namespace
echo "🧹 Cleaning up resources in default namespace..."
kubectl delete pod pod1 -n default --force --grace-period=0 2>/dev/null || true

# 2. Clean up directory structures
echo "📁 Removing workspace directories under /opt/course..."
if [ -d "/opt/course" ]; then
  # Try removing without sudo first (if current user has permissions)
  rm -rf /opt/course 2>/dev/null || {
    echo "🔑 Sudo privileges needed to remove /opt/course directory..."
    sudo rm -rf /opt/course
  }
fi

echo "=========================================="
echo "🎉 CKAD Simulator Lab Environment Cleaned!"
echo "=========================================="
