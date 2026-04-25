# 🧪 LAB 02: The Fixed Boutique (StatefulSets)

## Application Design and Build – Ordered [Deployment](../../../../GLOSSARY.md#deployment) and Persistent Identity

---

## 🎯 Lab Goal

Understand how to manage staff members who need their own specific "locker" and identity. You will deploy a **[StatefulSet](../../../../GLOSSARY.md#statefulset)**, observing how each [pod](../../../../GLOSSARY.md#pod) receives a unique name that persists even if the [pod](../../../../GLOSSARY.md#pod) is replaced.

---

## 🛍️ Mall Analogy

In Most shops, staff are interchangeable. If one leaves, another replaces them. But in a **High-End Boutique ([StatefulSet](../../../../GLOSSARY.md#statefulset))**:

- **The Specialist Pods** → Every worker has a permanent name-tag (e.g., `boutique-0`, `boutique-1`).
- **The Dedicated Lockers (PVCs)** → When `boutique-0` goes home, their unique locker is saved for when they return. A new worker doesn't take over a random locker; they take *their* locker.
- **The Orderly Queue** → Staff arrive one at a time. Worker 1 doesn't enter until Worker 0 is at their post.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[StatefulSet](../../../../GLOSSARY.md#statefulset)** | A boutique with specialized, named workers. |
| **Ordinal Index** | The number on the name-tag (0, 1, 2). |
| **Stable Storage** | A locker that only belongs to one specific staff member. |

---

## 📋 Requirements

The Boutique needs a set of 3 specialized managers.

1. **[Deployment](../../../../GLOSSARY.md#deployment) Type:** [StatefulSet](../../../../GLOSSARY.md#statefulset).
2. **Name:** `boutique`.
3. **Replicas:** 3.
4. **Image:** `nginx:alpine`.
5. **Headless [Service](../../../../GLOSSARY.md#service):** Create a [service](../../../../GLOSSARY.md#service) named `boutique` (ClusterIP: None).

---

## 🛠️ Step-by-Step Solution

### 1. Create the Headless [Service](../../../../GLOSSARY.md#service)
StatefulSets require a [service](../../../../GLOSSARY.md#service) to manage their identities.
```bash
kubectl create service clusterip boutique --tcp=80:80 --clusterip="None"
```

### 2. Create the [StatefulSet](../../../../GLOSSARY.md#statefulset)
```bash
# Using shorthand or generating YAML
kubectl create statefulset boutique --image=nginx:alpine --replicas=3
```

---

## 🔎 Verification

1. **Watch the Rollout:**
   ```bash
   kubectl get pods -w
   # Observe that they start in order: boutique-0, then boutique-1, then boutique-2.
   ```

2. **Check the Names:**
   ```bash
   kubectl get pods -l app=boutique
   # Verify the numbered suffixes.
   ```

---

## 🧠 Key Takeaways

- **Identity Matters:** Use StatefulSets for databases (like MariaDB or MongoDB) or any app where pods aren't identical.
- **Scalability:** They scale up from 0 to N and down from N to 0, always in order.
- **CKAD Tip:** Don't forget the **Headless [Service](../../../../GLOSSARY.md#service)**! Without it, the pods won't have stable network names.

---

## 🔗 References
- **Comic** → [Workload Types](../../../../visual-learning/comics/README.md)
- **Docs** → [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- **Study Guide** → [Chapter 01: Workloads](../../../../sources/study-guide/ch01-workloads.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
