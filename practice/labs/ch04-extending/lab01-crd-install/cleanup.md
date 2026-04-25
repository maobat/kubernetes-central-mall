# 🧪 Lab Supplement: Revoking the Charter ([CRD](../../../../GLOSSARY.md#crd) Deletion)

## Architecture – Resource Lifecycle & Cascading Deletion

---

## 🎯 Lab Goal

Understand what happens when an API extension is removed. You will learn how deleting a **[CRD](../../../../GLOSSARY.md#crd)** automatically cleans up all associated resources (Cascading Deletion).

---

## 🛍️ Mall Analogy

In the **Central Mall**, deleting a **[CRD](../../../../GLOSSARY.md#crd)** is like officially removing a [service](../../../../GLOSSARY.md#service) category from the mall's bylaws. 

The moment the category is deleted, all existing shops or orders belonging to that category are automatically evicted. **No charter, no shops.**

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[CRD](../../../../GLOSSARY.md#crd) Deletion** | Revoking a legal charter. |
| **Cascading Deletion** | The automatic eviction of all shops using that charter. |
| **API Endpoint** | The Management Office closing the specialized desk. |

---

## 📋 Requirements

The Management Office has decided the `Shopping-Items` experiment is over. Wipe every trace of it from the Cluster.

- **Target:** The [CRD](../../../../GLOSSARY.md#crd) `shopping-items.beta.killercoda.com`.

---

## 🛠️ Step-by-Step Solution

### 1. Identify the Full Title
Find the exact legal name in the ledger.
```bash
kubectl get crd | grep shopping
```

### 2. The "Great Clean-up"
Delete the **Definition**.
```bash
kubectl delete crd shopping-items.beta.killercoda.com
```

---

## 🔎 Verification

1. **Check for Ghost Objects:**
   ```bash
   kubectl get shoppingitem
   # Use 'kubectl get shoppingitems' - should return an error as the resource type no longer exists.
   ```

2. **Confirm Global Registry is Clean:**
   ```bash
   kubectl get crd | grep shopping
   ```

---

## 🧠 Key Takeaways

- **Garbage Collection:** Since every `ShoppingItem` exists only because the `CRD` allowed it, they are automatically destroyed when their parent definition is removed.
- **Safety Warning:** In production, deleting a [CRD](../../../../GLOSSARY.md#crd) is **dangerous**. It destroys all your custom data instantly. Always perform a backup first.
- **Finalizers Trap:** If a [CRD](../../../../GLOSSARY.md#crd) gets "stuck" in a *Terminating* state, check for **Finalizers** in the YAML. You might need to edit them to allow the deletion to finish.

---

## 🔗 References
- **Back to Main Lab** → [Expanding the Mall Charter](./README.md)
- **Study Guide** → [Chapter 4: Extending K8s](../../../../sources/study-guide/ch04-extending-k8s.md)