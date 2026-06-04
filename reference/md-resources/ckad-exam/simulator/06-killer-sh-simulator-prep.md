# 🛠️ CKAD Simulator Lab Environment Setup Guide

This guide provides the necessary commands and scripts to set up the lab environment for practicing the **2 CKAD Simulator Questions** on your own Kubernetes cluster (such as Minikube, Kind, or a local VM).

---

## 🧭 How to Handle SSH and Hostnames Locally

In the official Killer.sh simulator environment, you are working across a multi-node, multi-cluster topology, which requires you to SSH into specific hostnames (e.g., `ssh ckad5601`) and switch contexts.

When practicing **locally** using this preparation guide and your own single-node Kubernetes cluster (like Kind or Minikube):
1. **Do not run `ssh ckadXXXX`**: Since `ckadXXXX` hostnames do not exist in your local network, running those commands will result in name resolution failures. Simply skip the `ssh` command and perform all operations directly on your active terminal.
2. **Ignore hostnames in file paths**: When a question states to *Save the list to `/opt/course/1/namespaces` on `ckad5601`*, save it to `/opt/course/1/namespaces` directly on your local system (which has been prepared by running the script with `sudo`).
3. **No context switching required**: Perform all tasks against your local active Kubernetes cluster context (e.g., `kind-ckad` or `minikube`).
4. **Fixing Permission Denied on `/opt/course`**: Because the `/opt/course` directories are created under root privilege, attempting to write files to them directly (such as `k get ns > /opt/course/1/namespaces`) will fail with a `Permission denied` error. To make practice seamless and avoid using `sudo` for output redirection, grant ownership of the directory to your current user by running:
   ```bash
   sudo chown -R $(whoami) /opt/course
   ```

---

## 🚀 Quick Setup (Automated Script)

Save the script below as `setup-labs.sh` on your node and run it with root privileges (or run sections of it that correspond to the questions you want to practice).

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "=========================================="
echo "🏗️  Starting CKAD Simulator Lab Prep..."
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

# 2. Create Namespaces
echo "🌐 Creating namespaces..."
for ns in mercury neptune saturn pluto earth moon mars jupiter venus sun; do
  kubectl create namespace "$ns" --dry-run=client -o yaml | kubectl apply -f -
done

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
```

---

## 🧼 Tear Down & Cleanup

To wipe the sandbox environments cleanly, you can execute the provided cleanup script:

```bash
./reference/md-resources/ckad-exam/scripts/cleanup-labs.sh
```

