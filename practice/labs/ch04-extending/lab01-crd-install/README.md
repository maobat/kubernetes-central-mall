# 🧪 LAB 01: Expanding the Mall Charter ([CRD](../../../../GLOSSARY.md#crd) Install & Object)

## Architecture – API Extension [Deployment](../../../../GLOSSARY.md#deployment) & Custom Schema Validation

---

## 🎯 Lab Goal

Learn how to register a brand new API extension in Kubernetes. You will introduce the **"Shopping-Items" Charter** to the cluster, defining what a shopping item looks like (name, priority, price) and then creating a specific item instance.

---

## 🛍️ Mall Analogy

In the **Central Mall**, installing a **[CRD](../../../../GLOSSARY.md#crd)** is like adding a new official "[Service](../../../../GLOSSARY.md#service) Category" to the mall's legal regulations.

- **The New Regulation ([CRD](../../../../GLOSSARY.md#crd))** → "Starting today, the Mall officially recognizes 'ShoppingItems' as a valid legal entity with specific rules (Schema)."
- **The Order Form (Custom Object)** → Now that the rules exist, any shop can fill out a form to create a specific "ShoppingItem" order.
- **The Validator (Schema)** → If someone tries to create an item without a "Price," the management office rejects the form because it breaks the mall's regulations.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Custom Resource Definition ([CRD](../../../../GLOSSARY.md#crd))** | A new legal "Charter" for the mall. |
| **Custom Resource (CR)** | A specific instance/item created using that charter. |
| **OpenAPI V3 Schema** | The validation rules on the form. |

---

## 📋 Requirements

The Mall Logistics department wants to track customer orders using custom K8s objects.

1. **Definition:** Create a [CRD](../../../../GLOSSARY.md#crd) named `shoppingitems.mall.k8s.io`.
2. **Group:** `mall.k8s.io`.
3. **Scope:** Namespaced.
4. **Validation:** Ensure each item must have a `spec.priority` (string).
5. **Instance:** Create one `ShoppingItem` named `order-66`.

---

## 🛠️ Step-by-Step Solution

### 1. Register the Charter ([CRD](../../../../GLOSSARY.md#crd))
Apply the blueprint that defines the new resource.
```bash
kubectl apply -f crd.yaml
```

### 2. Create a Specific Order (CR)
```bash
kubectl apply -f shopping-item.yaml
```

---

## 🔎 Verification

1. **Check the Charter:**
   ```bash
   kubectl get crd shopping-items.mall.k8s.io
   ```

2. **List the Orders:**
   ```bash
   kubectl get shoppingitems
   # Should see 'order-66'
   ```

---

## 🧠 Key Takeaways

- **Extensibility:** CRDs allow you to use Kubernetes as a database for *anything* (Users, Tickets, Shopping Items).
- **Validation:** Always use a schema to prevent "dirty data" from entering your cluster.
- **CKAD Tip:** You don't need to write the [CRD](../../../../GLOSSARY.md#crd) from scratch in the exam, but you must know how to `get` and `describe` them.

---

## 🔗 References
- **Comic** → [The Nightly Backup Permit](../../../../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- **Docs** → [Custom Resources](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
- **Study Guide** → [Chapter 04: Extending](../../../../sources/study-guide/ch10-management.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
