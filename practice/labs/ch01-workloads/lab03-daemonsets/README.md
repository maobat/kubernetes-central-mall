# 🧪 LAB 03: Floor Security Guard ([DaemonSet](../../../../GLOSSARY.md#daemonset))

## Application Design and Build – Uniform [Deployment](../../../../GLOSSARY.md#deployment) across the Mall

---

## 🎯 Lab Goal

Understand how to deploy a "Safety Officer" or "Guarddog" to every single floor of the mall simultaneously. You will use a **[DaemonSet](../../../../GLOSSARY.md#daemonset)** to ensure that one [pod](../../../../GLOSSARY.md#pod) runs on every eligible [node](../../../../GLOSSARY.md#node) in the cluster, providing consistent security services everywhere.

---

## 🛍️ Mall Analogy

In the **Central Mall**, some services must be present on every single floor.

- **The Security Post ([DaemonSet](../../../../GLOSSARY.md#daemonset))** → You want a guard station on Floor 1, Floor 2, and Floor 3. If the mall expands and Floor 4 is built, a new station is automatically added. You don't "scale" it; it simply exists wherever there is floor space.
- **The Specialized Floor ([Node](../../../../GLOSSARY.md#node) Selector)** → Maybe only floors with "Luxury" shops need a specific type of guard. You can tell the [DaemonSet](../../../../GLOSSARY.md#daemonset): "Only deploy on floors with the label `type=luxury`."

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[DaemonSet](../../../../GLOSSARY.md#daemonset)** | A mandatory [service](../../../../GLOSSARY.md#service) on every floor. |
| **Automatic Scaling** | If a new [node](../../../../GLOSSARY.md#node) is added, a new [pod](../../../../GLOSSARY.md#pod) is automatically started. |
| **Tolerations** | Allowing a guard to enter a "Staff Only" or "Under Construction" floor. |

---

## 📋 Requirements

The Mall's surveillance system must be deployed on every [node](../../../../GLOSSARY.md#node).

1. **Name:** `mall-guard`.
2. **Type:** [DaemonSet](../../../../GLOSSARY.md#daemonset).
3. **Image:** `nginx:alpine`.
4. **[Namespace](../../../../GLOSSARY.md#namespace):** `default`.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Security Mandate
```bash
# Generating YAML or using create
kubectl create daemonset mall-guard --image=nginx:alpine --namespace=default
```

### 2. Verify Presence
Look at the [node](../../../../GLOSSARY.md#node) count and [pod](../../../../GLOSSARY.md#pod) count to ensure they match.
```bash
# Check the nodes
kubectl get nodes

# Check the pods
kubectl get pods -l app=mall-guard -o wide
```

---

## 🔎 Verification

1. **[Node](../../../../GLOSSARY.md#node) Coverage:**
   ```bash
   kubectl get ds mall-guard
   # DESIRED should match the number of worker nodes.
   ```

2. **Test Automated Expansion:**
   In a real cluster, if you added a [node](../../../../GLOSSARY.md#node), you'd see a new `mall-guard` [pod](../../../../GLOSSARY.md#pod) instantly. 

---

## 🧠 Key Takeaways

- **Infrastructure First:** DaemonSets are ideal for logging (Fluentd), monitoring (Prometheus [Node](../../../../GLOSSARY.md#node) Exporter), or networking (Calico/Cilium).
- **Control:** Use `nodeSelector` or `tolerations` to control where the "Guards" go.
- **CKAD Tip:** Remember that DaemonSets don't have a `replicas` field. The number of pods is controlled by the number of nodes.

---

## 🔗 References
- **Comic** → [Workload Types](../../../../visual-learning/comics/README.md)
- **Docs** → [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
- **Study Guide** → [Chapter 01: Workloads](../../../../sources/study-guide/ch01-workloads.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
