# 🧪 LAB 02: The Architect's Ledger ([CRD](../../../../GLOSSARY.md#crd) Discovery)

## Extending the Mall – API Discovery & Auditing

---

## 🎯 Lab Goal

Learn how to discover and audit custom extensions that have been added to the Central Mall. You will practice identifying existing **CRDs**, checking their versions, and verifying the schema rules that have been established.

---

## 🛍️ Mall Analogy

In the **Central Mall**, when an architect adds a new legal "Charter" ([CRD](../../../../GLOSSARY.md#crd)), it must be recorded in the **Architect's Ledger**.

- **The Ledger (API Discovery)** → A master list of every active regulation in the mall.
- **The Fine Print (Explain)** → Reading the blueprint to see exactly what fields are required on a form.
- **The Audit (API Resources)** → Walking through the mall to see every "Specialized Shop" currently open.

---

## 📋 Requirements

The Mall Management needs to verify the structure of the `ShoppingItems` extension.

1. **Discovery:** List all custom resource definitions in the cluster.
2. **Schema Audit:** Use `kubectl explain` to find the required fields for `ShoppingItem`.
3. **Instance Check:** Find all instances of `ShoppingItem` across all namespaces.

---

## 🛠️ Step-by-Step Solution

### 1. Consult the Ledger
```bash
# List all CRDs
kubectl get crds
```

### 2. Read the Fine Print
```bash
# Explain the structure of the custom resource
kubectl explain shoppingitem.spec
```

---

## 🔎 Verification

1. **Verify the Schema:**
   ```bash
   kubectl describe crd shoppingitems.mall.k8s.io
   # Look for the 'openAPIV3Schema' section.
   ```

---

## 🧠 Key Takeaways

- **Discovery:** Know that `kubectl api-resources` is your best friend when looking for custom types.
- **Schema:** The `explain` command works for CRDs just like it does for standard Pods or Deployments!

---

## 🔗 References
- **Comic** → [The Nightly Backup Permit](../../../../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- **Study Guide** → [Chapter 04: Extending](../../../../sources/study-guide/ch04-extending-k8s.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
