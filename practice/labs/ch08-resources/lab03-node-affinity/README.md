# 🧪 LAB 03: Special Placements (Node Affinity)

## 🎯 Lab Goal
In this lab, you will learn how to use **Node Affinity** to influence the Kubernetes Scheduler. You will ensure that a specific shop (Pod) "prefers" to be located in certain Wings (Nodes) of the mall based on zoning labels.

## 🛍️ Mall Analogy
In the **Central Mall**, some shops belong in specific "Zones" for better visibility or logistics.
- **Preferred Wing (`preferredDuringSchedulingIgnoredDuringExecution`):** The shop owner *wants* to be in "Zone 1" (80% preference) but is okay with "Zone 2" (20% preference) if the first choice is full.
- **Zoning Labels:** The Management Office classifies floors (Nodes) with labels like `availability-zone=zone1`.

---

## 📋 Requirements

1.  **Prepare the Mall Wings**: Label your floors (Nodes) so the Scheduler knows where they are.
    - Label `controlplane` as `availability-zone=zone1`.
    - Label `node01` as `availability-zone=zone2`.
2.  **Create the Shop (Pod)**: Create a Pod named `az1-pod` in the namespace `012963bd`.
3.  **Apply Node Affinity**:
    - Use `busybox:1.28` image.
    - **Weight 80:** Prefer a node with label `availability-zone=zone1`.
    - **Weight 20:** Prefer a node with label `availability-zone=zone2`.
4.  **Verify Placement**: Check which floor the shop was finally opened on.

---

## 🛠️ Step-by-Step Solution

### 1. Set up the Zoning Labels
```bash
kubectl create namespace 012963bd
kubectl label node controlplane availability-zone=zone1 --overwrite
kubectl label node node01 availability-zone=zone2 --overwrite
```

### 2. Create the Shop Blueprint
Create a file named `az1-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: az1-pod
  namespace: 012963bd
spec:
  affinity:
    nodeAffinity:
      preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 80
        preference:
          matchExpressions:
          - key: availability-zone
            operator: In
            values:
            - zone1
      - weight: 20
        preference:
          matchExpressions:
          - key: availability-zone
            operator: In
            values:
            - zone2
  containers:
  - name: main
    image: busybox:1.28
    command: ["sh", "-c", "sleep 3600"]
  restartPolicy: Never
```

### 3. Deploy and Inspect
```bash
kubectl apply -f az1-pod.yaml
kubectl -n 012963bd get pod az1-pod -o wide
```

---

## 🔎 Verification Checklist
- [ ] Is the Pod in the correct namespace (`012963bd`)?
- [ ] Does `kubectl describe pod` show the node affinity rules?
- [ ] Did the Scheduler respect the 80/20 weights (usually landing on `controlplane` if it has capacity)?

---
## 🧠 Key Takeaways
- **Soft Affinity:** `preferredDuringScheduling` is a "Soft" rule. The Scheduler will try its best, but won't fail to schedule the Pod if the preferred nodes are absent.
- **Weights:** Use weights to prioritize or "layer" your preferences across different criteria.

---
## 🔗 References
- **Study Guide** → [Chapter 8: Resource Budgets](../../../../sources/study-guide/ch08-resources.md)
- **Docs** → [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
