# 🧪 LAB 07: Revoking the Useless Charter (Cleanup)

## Architecture – API Resource Deletion & Policy Reversion

---

## 🎯 Lab Goal

Sometimes, we realize a new regulation is "useless" and needs to be revoked. Learn how to delete a **[CRD](../../../../GLOSSARY.md#crd)** and all its associated objects.

---

## 📋 Requirements

You spent hours figuring out this "amazing" new [CRD](../../../../GLOSSARY.md#crd) `ShoppingItems` created by the team. But in the end, you realized it's one of the most useless extensions ever encountered in the mall.

1. **Regulation Reversion:** Delete the `ShoppingItems` [CRD](../../../../GLOSSARY.md#crd) and all `ShoppingItem` objects from the cluster.

---

## 🛠️ Step-by-Step Solution

### 1. Identify the Charter
```bash
kubectl get crd | grep shopping
```

### 2. Revoke the Policy
Deleting the [CRD](../../../../GLOSSARY.md#crd) will automatically delete all instances of that resource.
```bash
kubectl delete crd shopping-items.beta.killercoda.com
```

---

## 🔎 Verification

1. **Verify Removal:**
   ```bash
   kubectl get crd | grep shopping
   # Should return nothing
   ```

---

## 🔗 References
- **Comic** → [The Nightly Backup Permit](../../../../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- **Study Guide** → [Chapter 04: Extending](../../../../sources/study-guide/ch04-extending-k8s.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
