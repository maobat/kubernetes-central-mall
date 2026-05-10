# 🧪 LAB 03: The Mall Dashboard (Metrics Server)

## Observability and Maintenance – Electricity & Water Meters

In the **Central Mall**, if the CNI is the security team, the **Metrics Server** is the Mall's Utility Metering System. It tells the owner how much "electricity" (CPU) and "water" (Memory) each shop is consuming. If a shop starts using too many resources, it might cause a mall-wide blackout! To prevent this, we use the central dashboard to read the meters on every shop door. Without it, running commands is like looking at a blank utility bill—the data simply isn't being collected.

---

## 🎯 Lab Goals
- Use `kubectl top` to monitor resource consumption of Nodes and Pods.
- Understand how the **Metrics Server** acts as the mall's resource dashboard.
- Sort shops by their "utility bills" (resource usage).

---

## 🛠️ Step 0: The Missing Meters (Metrics Server Setup)

In our Central Mall analogy, `kubectl top` is like a **Real-Time Energy Meter**. It tells you exactly how much electricity (CPU) and water (RAM) each shop is using. But by default, **Kind** clusters arrive without the meters installed!

### 🕵️ Why it doesn't work out-of-the-box
By default, **Kind** clusters arrive without the meters installed in the basement. 
- **The Error:** If you see `Metrics API not available`, it means the mall was built, but the meters weren't installed.
- **The Command:** When you run `kubectl top pod`, you are asking for the consumption report. Since there are no meters, the API server has no data to give you.
- **The Check:** Running `kubectl get pods -n kube-system` confirms this—you will see `coredns`, `kube-proxy`, and `calico`, but no pod named `metrics-server`.

### 🚚 Choose Your Truck: Minikube vs. Kind
Depending on which "mall construction kit" you are using, the setup is different:

- **Minikube (The Automatic Setup)**: Minikube includes the meters by default; you just have to flip the switch:
  ```bash
  minikube addons enable metrics-server
  ```

### 🛠️ How to "Install the Meters" in Kind (The CKAD Way)
If you want to practice for the CKAD (where YAML editing is essential), you have to install the Metrics Server manually. However, there is a **"Kind-specific" trap**. Because Kind uses local self-signed certificates, the Metrics Server will refuse to talk to the nodes unless you add an "insecure" tweak.

**1. Download the official manifest:**
```bash
wget https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

**2. Add the "Insecure" flag:**
Edit `components.yaml` and add `--kubelet-insecure-tls` to the container arguments for the Metrics Server deployment:
```yaml
    # Inside the Metrics Server Deployment spec -> containers -> args
    - args:
      - --cert-dir=/tmp
      - --secure-port=4443
      - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
      - --kubelet-use-node-status-port
      - --metric-resolution=15s
      - --kubelet-insecure-tls  # <--- ADD THIS
```

**3. Apply it:**
```bash
kubectl apply -f components.yaml
```

**4. Wait for the Billing Cycle:**
Once the `metrics-server` pod shows up as `Running` in your `kube-system` list, **wait about 60 seconds** for it to gather the first "billing cycle" of data before testing.

### 📊 Alternative: Checking the "Truck" from the "Street"
If you don't want to install the Metrics Server, you can still see how much "Gas" your Kind nodes are using by looking from your Laptop (Outside). Since the nodes are just Docker containers, run this on your terminal:

```bash
docker stats
```
This will show you the CPU and Memory usage of `kind-control-plane`. It’s not as detailed as `kubectl top` (it won't show you individual Pods), but it tells you if your laptop is about to melt!

### 🧠 CKAD Tip
In the real exam, the Metrics Server is **already installed**. You won't have to fix it or patch it. You just need to remember the commands:
```bash
kubectl top node
kubectl top pod --sort-by=cpu
```

---

## 🛠️ Step 1: Checking the Mall Infrastructure ([Node](../../../../GLOSSARY.md#node) Metrics)

The **Metrics Server** collects data from every floor ([Node](../../../../GLOSSARY.md#node)) in the mall. This allows the Manager to see if a specific floor is becoming overcrowded or running out of power.

### 1. View [Node](../../../../GLOSSARY.md#node) Usage
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

## 🛠️ Step 2: Inspecting Individual Shops ([Pod](../../../../GLOSSARY.md#pod) Metrics)

Sometimes, the whole floor is fine, but one specific shop is "leaving the lights on." We can use the dashboard to zoom in on individual shops (Pods).

### 1. View [Pod](../../../../GLOSSARY.md#pod) Usage
Run the following command to see the metrics for a specific [pod](../../../../GLOSSARY.md#pod):
```bash
kubectl top pod shop-standard-cctv
```

### 2. 🏆 CHALLENGE
Find the [pod](../../../../GLOSSARY.md#pod) named `shop-with-tail-sidecar` and check its resource usage. 

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
Show the metrics for all containers inside the `shop-with-tail-sidecar` [pod](../../../../GLOSSARY.md#pod) and sort them by memory usage to see if the clerk or the sidecar is the bigger "water hog."

<details>
<summary><b>Solution</b></summary>

```bash
kubectl top pod shop-with-tail-sidecar --containers --sort-by=memory
```
</details>

---

## 🔍 Common Troubleshooting Traps

If you get an error like `unknown command "client"` when running `kubectl top client -n internal-only`:
* **The Reason:** `kubectl top` needs to know the *resource type* (`pod` or `node`) before the name.
* **Correct Syntax:** `kubectl top pod client -n internal-only`

*(Are you planning to add an **HPA (Horizontal Pod Autoscaler)** to your mall lab next? That would be the perfect use case for these metrics!)*

---

## 📝 Key Takeaways
1. **The Dashboard**: The Metrics Server is the engine behind `kubectl top`. Without it, the "meters" would show no data.
2. **Resource Visibility**: Monitoring CPU and Memory is the first step in preventing **[OOMKilled](../../../../GLOSSARY.md#oomkilled)** (Out Of Memory) incidents.
3. **Scaling**: These metrics are also used by the **Horizontal [Pod](../../../../GLOSSARY.md#pod) Autoscaler (HPA)** to decide when to "hire more staff" (add replicas).

---

## 🔗 References
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
