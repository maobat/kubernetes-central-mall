# 🧪 LAB 01: Expanding the Mall Charter (CRD Install & Object)

## Architecture – API Extension Deployment & Custom Schema Validation

---

## 🎯 Lab Goal

Learn how to register a brand new API extension in Kubernetes. You will introduce the **Shopping-Items** category to the "Mall Charter" (CRD) and create the first official entry in the ledger.

> **CKAD Importance:** Medium. Installing CRDs and creating custom objects is a core part of the "Extending Kubernetes" section (approx. 10% of the exam).

---

## 🛍️ Mall Analogy

In the **Central Mall**, installing a **CRD** is like adding a new official "Service Category" to the mall's legal regulations (the **Charter**). 

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **CRD** | The legal definition of a new shop category in the Charter. |
| **Custom Resource (CR)** | A specific instance or order (e.g., "Bananas"). |
| **API Server** | The Clerk checking if your order follows the new rules. |

---

## 📋 Requirements

The development team has finalized the `Shopping-Items` blueprint. As the Architect, you must register it and create the first entry.

1. **Blueprint (CRD):** Located at `/code/crd.yaml`.
2. **Target Object:** A `ShoppingItem` named `bananas`.
3. **Data (Spec):** `dueDate: tomorrow`, `description: buy yellow ones`.

---

## 🛠️ Step-by-Step Solution

### 1. Register the New Blueprint (Install CRD)
Tell the Mall Manager about the new charter extension.
```bash
kubectl apply -f /code/crd.yaml
```

### 2. Create the Custom Object
Submit the first "Shopping Item" entry to the manager.
```bash
vi shopping-item.yaml
```

**Manifest content:**
```yaml
apiVersion: "beta.killercoda.com/v1"
kind: ShoppingItem
metadata:
  name: bananas
  namespace: default
spec:
  description: "buy yellow ones"
  dueDate: "tomorrow"
```

Apply it:
```bash
kubectl apply -f shopping-item.yaml
```

---

## 🔎 Verification

1. **Check API Knowledge:**
   ```bash
   kubectl get crd | grep shopping
   # Should see 'shopping-items.beta.killercoda.com'
   ```

2. **Verify the Entry:**
   ```bash
   kubectl get shoppingitem bananas -o yaml
   # Ensure the data matches your manifest exactly.
   ```

---

## 🧠 Key Takeaways

- **Dynamic Vocabulary:** You didn't have to restart the cluster. The `kube-apiserver` updated its "dictionary" on the fly.
- **Validation:** Once the CRD is installed, the API acts as a "validator". If your order doesn't follow the blueprint's rules, it will be rejected.
- **CKAD Tip:** If you don't know the exact name of the new resource, use `kubectl api-resources` to find the `KIND` and `SHORTNAMES`.

---

## 🔗 References
- **Comic** → [The Nightly Backup Permit](../../../../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- **Docs** → [Understanding CRDs](../../../../reference/md-resources/understanding-custom-resource-definitions-crds.md)
- **Study Guide** → [Chapter 4: Extending K8s](../../../../sources/study-guide/ch04-extending-k8s.md)
