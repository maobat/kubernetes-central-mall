# 🧪 LAB 03: Special Placements ([Node](../../../../GLOSSARY.md#node) Affinity)
*Focus: Preferred Scheduling, Weights, and Availability Zones*

## 🎯 Lab Goal
In this lab, you will learn how to use **[Node](../../../../GLOSSARY.md#node) Affinity** to influence the Kubernetes Scheduler. You will ensure that a specific shop ([Pod](../../../../GLOSSARY.md#pod)) "prefers" to be located in certain Wings (Nodes) of the mall based on zoning labels.

## 🛍️ Mall Analogy
In the **Central Mall**, some shops belong in specific "Zones" for better visibility or logistics.
- **Preferred Wing (`preferredDuringSchedulingIgnoredDuringExecution`):** The shop owner *wants* to be in "Zone 1" (80% preference) but is okay with "Zone 2" (20% preference) if the first choice is full.
- **Zoning Labels:** The Management Office classifies floors (Nodes) with labels like `availability-zone=zone1`.

---

## 📋 Requirements

1.  **Prepare the Mall Wings**: Label your floors (Nodes) so the Scheduler knows where they are.
    - Label `minikube` as `availability-zone=zone1`.
    - Label `minikube-m02` as `availability-zone=zone2`.
2.  **Create the Shop ([Pod](../../../../GLOSSARY.md#pod))**: Create a [Pod](../../../../GLOSSARY.md#pod) named `az1-pod` in the [namespace](../../../../GLOSSARY.md#namespace) `012963bd`.
3.  **Apply [Node](../../../../GLOSSARY.md#node) Affinity**:
    - Use `busybox:1.28` image.
    - **Weight 80:** Prefer a [node](../../../../GLOSSARY.md#node) with label `availability-zone=zone1`.
    - **Weight 20:** Prefer a [node](../../../../GLOSSARY.md#node) with label `availability-zone=zone2`.
4.  **Verify Placement**: Check which floor the shop was finally opened on.

---

## 🛠️ Step-by-Step Solution

### 1. Set up the Zoning Labels
```bash
kubectl create namespace 012963bd
kubectl label node minikube availability-zone=zone1 --overwrite
kubectl label node minikube-m02 availability-zone=zone2 --overwrite
```

### 2. Create the Shop Blueprint
You can use the **Fast-Build** technique to generate the base YAML:

```bash
kubectl run az1-pod -n 012963bd --image=busybox:1.28 --restart=Never --dry-run=client -o yaml -- /bin/sh -c "sleep 3600" > az1-pod.yaml
```

Now, open `az1-pod.yaml` and add the `affinity` block:

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: az1-pod
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
  - args:
    - /bin/sh
    - -c
    - sleep 3600
    image: busybox:1.28
    name: az1-pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
status: {}
```

### 3. Deploy and Inspect
```bash
kubectl apply -f az1-pod.yaml
kubectl -n 012963bd get pod az1-pod -o wide
```

---

## 🔎 Verification Checklist
- [ ] Is the [Pod](../../../../GLOSSARY.md#pod) in the correct [namespace](../../../../GLOSSARY.md#namespace) (`012963bd`)?
- [ ] Does `kubectl describe pod` show the [node](../../../../GLOSSARY.md#node) affinity rules?
    > [!NOTE]
    > **The "Missing Section" Quirk:** Sometimes `kubectl describe` won't show the `preferredDuringScheduling` section if there are no "hard" constraints or if the output is truncated. If `kubectl get pod az1-pod -o yaml` shows the rules, the Scheduler is using them!
- [ ] Did the Scheduler respect the 80/20 weights (usually landing on `minikube` if it has capacity)?

---
## 🧠 Key Takeaways
- **Soft Affinity:** `preferredDuringScheduling` is a "Soft" rule. The Scheduler will try its best, but won't fail to schedule the [Pod](../../../../GLOSSARY.md#pod) if the preferred nodes are absent.
- **Weights:** Use weights to prioritize or "layer" your preferences across different criteria.

---
## 🔗 References
- **Study Guide** → [Chapter 8: Resource Budgets](../../../../sources/study-guide/ch08-resources.md)
- **Docs** → [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
