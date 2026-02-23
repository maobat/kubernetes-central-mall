# 🧪 LAB 01 – NodePort & Cross-Namespace Communication
## Services and Networking – Managing Services

---

## 🎯 Lab Goal
This lab focuses on **Service exposure** and **cross-namespace communication**. You will learn to expose a Pod using a NodePort Service and access it from a different "wing" of the cluster.

---

## 📖 Related Comic
👉 [comics/nodeport/02-cross-namespace/README.md](../../../comics/nodeport/02-cross-namespace/README.md)

---



---

## 🏬 Mall Analogy
We are opening a boutique in a new, separate wing of the mall called **"remote"**.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Namespace: remote** | A new, separate wing of the mall. |
| **Pod: remoteweb** | The Nginx boutique store. |
| **Service: NodePort** | A shop sign with a street-level entrance. |
| **NodePort: 31999** | The specific gate number on the mall exterior. |
| **testpod (BusyBox)** | A worker in the default wing testing the internal intercom. |

---

## 📋 Requirements
1. Create a Namespace named **`remote`**.
2. In the `remote` Namespace:
   - Run an **Nginx Pod** named `remoteweb`.
   - Expose it via **NodePort Service** on port **31999**.
3. In the **default** Namespace:
   - Run a **BusyBox Pod** named `testpod`.
4. **Verification:**
   - Internal: `testpod` must reach `remoteweb` via DNS.
   - External: Reach the page via **Minikube IP + 31999**.

---

## 🛠️ Solution

### 1. Build the Remote Wing and the Store
```bash
# Create the new Namespace
kubectl create ns remote

# Run the Nginx Pod inside it
kubectl -n remote run remoteweb --image=nginx
```

### 2. Install the Side Entrance (NodePort Service)
```bash
# Generate the manifest first
kubectl -n remote expose pod remoteweb \
  --port=80 \
  --type=NodePort \
  --dry-run=client -o yaml > svc-nodeport.yaml
```

**Edit `svc-nodeport.yaml` to add the `nodePort` field:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: remoteweb
  namespace: remote
spec:
  type: NodePort
  selector:
    run: remoteweb
  ports:
    - port: 80
      targetPort: 80
      nodePort: 31999
```

```bash
kubectl apply -f svc-nodeport.yaml
```

### 3. Test Access (The "Mall Phone Call")
Create a worker in the **default** Namespace and call the boutique in the **remote** wing.

```bash
# Start the test worker
kubectl run testpod --image=busybox -- sleep infinity

# Test internal DNS connectivity
kubectl exec testpod -- wget --spider --timeout=1 remoteweb.remote.svc.cluster.local
```

---

## 🔎 Verification Results

✅ **Internal Check:** Successful connection via `remoteweb.remote`.
✅ **External Check:** `curl $(minikube ip):31999` returns "Welcome to nginx!".

---

## 🧰 Study Toolbox

* 🖼️ **Comic:** [The Internal Intercom (ClusterIP)](../../../comics/clusterip/01-internal-intercom/README.md)
* 🖼️ **Comic:** [The NodePort Traffic Adventure](../../../comics/nodeport/02-cross-namespace/README.md)
* 📄 **Doc:** [Service IP Tracker Evolution](../../../docs/md-resources/service-ip-tracker-evolution.md)
