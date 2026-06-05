#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "🏗️  Starting CKAD Simulator Lab Prep (Q1-Q2)..."
echo "=========================================="

# If running as root via sudo, inherit the calling user's KUBECONFIG to avoid connection errors
if [ "${EUID:-0}" -eq 0 ] && [ -n "${SUDO_USER:-}" ]; then
  USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
  export KUBECONFIG="${KUBECONFIG:-$USER_HOME/.kube/config}"
  echo "🔑 Inherited KUBECONFIG from user $SUDO_USER: $KUBECONFIG"
fi

# 1. Create directory structures locally
echo "📁 Creating workspace directories..."
mkdir -p /opt/course/1 \
         /opt/course/2

# ==========================================
# Question 1 Setup
# ==========================================
# No cluster setup required. Script creates /opt/course/1 directory.

# ==========================================
# Question 2 Setup
# ==========================================
# No cluster setup required. Script creates /opt/course/2 directory.

echo "=========================================="
echo "🎉 CKAD Simulator Lab Environment Ready!"
echo "=========================================="
