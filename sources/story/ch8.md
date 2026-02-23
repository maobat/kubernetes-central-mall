# 📖 Chapter 8: Resource Budgets
*Water and Electricity (Requests & Limits)*

In the **Central Mall**, resources are finite. If one shop turns on 500 air conditioners, the rest of the mall might suffer a blackout. To prevent this, the Mall Manager requires every shop to state exactly how much they *need* to start and the *maximum* they are allowed to use.

---

## 🎭 8.1 Requests vs. Limits

Think of these as your "Usage Contract."

| Term | Mall Analogy | K8s Concept |
| :--- | :--- | :--- |
| **Request** | **The Minimum Guarantee.** "I need at least 2 sockets to open my doors." | The scheduler uses this to find a Node with enough room. |
| **Limit** | **The Circuit Breaker.** "If I try to use more than 10 sockets, cut my power." | Prevents a Pod from starving other Pods of resources. |



---

## 🛠️ 8.2 The Consequences: Throttling & Eviction

If a shop breaks its contract, the Mall Manager takes action:

1. **CPU Over-limit:** The manager slows down your machines (Throttling). The shop stays open, but things move very slowly.
2. **Memory Over-limit:** Memory is like water; once it's gone, it's gone. If you go over your limit, the manager shuts down the shop immediately (**OOMKilled** - Out Of Memory Killed).

---

## 🛠️ 8.3 The Blueprint: Setting the Budget

You must define these at the **container** level within your Pod blueprint.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: budget-conscious-shop
spec:
  containers:
  - name: clerk
    image: nginx
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"   # 250 milli-cores (1/4 of a CPU)
      limits:
        memory: "128Mi"
        cpu: "500m"   # 1/2 of a CPU
```



---

## 🏗️ 8.4 Resource Quotas: Floor-Wide Limits

What if you want to limit the total electricity used by an **entire floor** (Namespace)? You use a **ResourceQuota**. This ensures that the "Food Court" floor doesn't use 90% of the Mall's total capacity.

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: floor-budget
  namespace: food-court
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "10"
    limits.memory: 16Gi
```

---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. Check Current Usage
In the exam, use `top` to see who is hogging the resources:
```bash
kubectl top pod
kubectl top node
```

### 2. Spotting the Resource Hog
If a Pod keeps restarting, check for the OOMKilled status:
```bash
kubectl describe pod <pod-name>
# Look for: Last State: Terminated, Reason: OOMKilled
```

---

## 🧰 Study Toolbox

* 📄 **Doc:** [The Resource Budget (Requests, Limits, & Quotas)](../../docs/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)
* 🧪 **Lab:** [Lab: Managing Resource Constraints](../../docs/md-resources/lab-managing-resource-constraints.md)
* 🖼️ **Comic:** [The Resource Hog - Why Limits Matter](../../comics/resources/01-the-resource-hog/README.md)