# 🧪 LAB 03: The Mall Dashboard (Metrics Server)

## Observability and Maintenance – Electricity & Water Meters

In the **Central Mall**, the Mall Manager needs to know how much "electricity" (CPU) and "water" (Memory) each shop is consuming. If a shop starts using too many resources, it might cause a mall-wide blackout! To prevent this, we use the **Metrics Server**—a central dashboard that reads the meters on every shop door.

---

## 🎯 Lab Goals
- Use `kubectl top` to monitor resource consumption of Nodes and Pods.
- Understand how the **Metrics Server** acts as the mall's resource dashboard.
- Sort shops by their "utility bills" (resource usage).

---

## 🛠️ Step 1: Checking the Mall Infrastructure (Node Metrics)

The **Metrics Server** collects data from every floor (Node) in the mall. This allows the Manager to see if a specific floor is becoming overcrowded or running out of power.

### 1. View Node Usage
Run the following command to see the total "electricity" and "water" being used by the control plane:
```bash
kubectl top node controlplane
```

### 2. 🏆 CHALLENGE
Use the dashboard to check the resource usage of the other floor in the cluster (`node01`).

<details>
<summary><b>Solution</b></summary>

```bash
# Get the node names
kubectl get nodes

# Check metrics for node01
kubectl top node node01
```
</details>

---

## 🛠️ Step 2: Inspecting Individual Shops (Pod Metrics)

Sometimes, the whole floor is fine, but one specific shop is "leaving the lights on." We can use the dashboard to zoom in on individual shops (Pods).

### 1. View Pod Usage
Run the following command to see the metrics for a specific pod:
```bash
kubectl top pod shop-standard-cctv
```

### 2. 🏆 CHALLENGE
Find the pod named `shop-with-tail-sidecar` and check its resource usage. 

<details>
<summary><b>Solution</b></summary>

```bash
kubectl top pod shop-with-tail-sidecar
```
</details>

---

## 🛠️ Step 3: Finding the Resource Hogs (Sorting)

If the mall is busy, you don't want to check every shop one by one. You want a list of the "biggest spenders."

### 1. Sort by Electricity (CPU)
Run this command to see which shops are using the most CPU:
```bash
kubectl top pod --sort-by=cpu
```

### 2. Sort by Water (Memory)
Run this command to see which shops are using the most Memory:
```bash
kubectl top pod --sort-by=memory
```

### 3. 🏆 CHALLENGE
Show the metrics for all containers inside the `shop-with-tail-sidecar` pod and sort them by memory usage to see if the clerk or the sidecar is the bigger "water hog."

<details>
<summary><b>Solution</b></summary>

```bash
kubectl top pod shop-with-tail-sidecar --containers --sort-by=memory
```
</details>

---

## 📝 Key Takeaways
1. **The Dashboard**: The Metrics Server is the engine behind `kubectl top`. Without it, the "meters" would show no data.
2. **Resource Visibility**: Monitoring CPU and Memory is the first step in preventing **OOMKilled** (Out Of Memory) incidents.
3. **Scaling**: These metrics are also used by the **Horizontal Pod Autoscaler (HPA)** to decide when to "hire more staff" (add replicas).

---

## 🔗 References
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)
