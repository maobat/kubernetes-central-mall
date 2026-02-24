# LAB 01 – Managing Resource Constraints

---

## 🎯 Lab Goal
In this lab, we simulate a worker who asks for too little "space" and gets "evicted" (OOMKilled), and learn how to fix the budget.

---

## 📖 Related Chapter
👉 [Chapter 8: Resource Budgets](../../../sources/study-guide/ch08-resources.md)

---

## 📖 Related Comic
👉 [The Resource Hog](../../../comics/resources/01-the-resource-hog/README.md)

---

**Step 1: Defining the Initial Budget (**`frontend-resources.yaml`**)** 
We start with a Pod containing two containers: a database (**db**) and a website (**wp**). Notice the small memory request of **64Mi**.
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: frontend
spec:
  containers:
  - name: db
    image: mysql
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: "password"
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
  - name: wp
    image: wordpress
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```
**Step 2: Observing the Crisis (OOMKilled)**
After applying the manifest, we check the status.
```Bash
kubectl apply -f frontend-resources.yaml
kubectl get pods
```
**The Result:** The Pod shows `STATUS: CrashLoopBackOff` or `Terminated`.
**Mall Analogy:** The worker tried to cram a massive MySQL filing cabinet into a tiny 64Mi locker. The locker burst, and the worker was kicked out.
**Step 3: Diagnostic - Inspecting the "Eviction"**
To see exactly why the worker failed, we check the Management Ledger:
```Bash
kubectl describe pod frontend
```
Look for the **Reason**: `OOMKilled` (Out Of Memory Killed) and **Exit Code**: `137`. This proves the container exceeded its allocated limit.
**Step 4: Fixing the Budget**
We update the YAML to provide a realistic budget. In this case, we increase the memory to **64Mi** (Request) and **128Mi** (Limit) but ensure the container doesn't try to use **Gi** (Gigabytes) by mistake, which would prevent it from ever finding an empty building.
**Corrected Spec Snippet:**
```YAML
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "256Mi" # Increased limit to prevent OOM
        cpu: "500m"
```        
**Step 5: Final Verification**
```Bash
kubectl delete -f frontend-resources.yaml
kubectl apply -f frontend-resources.yaml
kubectl get pods
```
**Output:** `frontend  2/2  Running`. The worker now has enough "desk space" to perform their tasks.
**Resource Diagnostic Cheat Sheet**
|Command|Mall Analogy|Purpose|
|--|--|--|
|`kubectl describe node`|Check the Building Capacity|See how much total CPU/RAM is left in the node.|
|`kubectl top pod`|Spot the "Resource Hog"|See real-time usage of CPU and Memory.|
|`kubectl set resources`|Change the Budget on the Fly|Update limits for a Deployment without deleting it.|
|`kubectl create quota`|Set Department Spending|Restrict a Namespace's total footprint.|
