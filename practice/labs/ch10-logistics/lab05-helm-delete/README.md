# 🧪 LAB 05: The Shop Closure (Helm Decommissioning)

## Logistics Tools – Decommissioning Prefab Kits

---

## 🎯 Lab Goal

Learn how to formally decommission a specialized shop manager by deleting an active **Helm Release**.

---

## 🛍️ Mall Analogy

In the **Central Mall**, if a specialized shop (like a high-tech server farm) is no longer needed, you must formally "uninstall" its prefab manager. This ensures that all the safes, shelves, and permits associated with that shop are properly cleared out.

---

## 🛠️ Lab Setup

Before you can decommission the shop, you must first ensure the manager is active in the cluster.

```bash
# 1. Ensure the namespace exists
kubectl create ns team-yellow

# 2. Install the 'apiserver' manager kit
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm -n team-yellow install apiserver bitnami/apache
```

---

## 📋 Requirements

The Management Office has decided to close a specific specialized shop.

1. **Identify the Manager:** Locate the Helm release named `apiserver`.
2. **Decommission:** Delete the `apiserver` Helm release.

---

## 🛠️ Step-by-Step Solution

### 1. Locate the Shop
First, find out which wing (namespace) the `apiserver` manager is operating in.
```bash
helm ls -A
```

### 2. Formally Uninstall
Once you've identified the namespace (likely `team-yellow`), uninstall the release.
```bash
# Assuming the release is in team-yellow as per the logs
helm -n team-yellow uninstall apiserver
```

---

## 🔎 Verification

1. **Verify Removal:**
   ```bash
   helm ls -A | grep apiserver
   # Should return nothing.
   ```

---

## 🧠 Key Takeaways

- **Total Cleanup:** Uninstalling a release via Helm clears all associated Kubernetes objects automatically.
- **Namespace Precision:** You often need the `-n` flag to specify where the manager was originally hired.

---

## 🔗 References
- **Comic** → [The Logistics Chain](../../../../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
- **Docs** → [Helm Uninstall](https://helm.sh/docs/helm/helm_uninstall/)
- **Study Guide** → [Chapter 10: Management](../../../../sources/study-guide/ch10-management.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
