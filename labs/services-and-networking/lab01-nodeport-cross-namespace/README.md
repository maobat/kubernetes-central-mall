# LAB 01 – NodePort & Cross-Namespace Communication

## Services and Networking – Managing Services

<img src="../../../docs/md-resources/images/lab01-services-networking.png" alt="lab01 - Services and Networking - Managing Services" width="35%" />

---

## 🎯 Lab Goal

This lab focuses on **Service exposure** and **cross-namespace communication**.

You will learn how to:
- Expose a Pod using a **NodePort Service**
- Access a Service **from another Namespace**
- Verify both **internal (cluster)** and **external (node-level)** connectivity

---

## 📋 Requirements

1. Create a Namespace named **`remote`**
2. In the `remote` Namespace:
   - Run an **Nginx Pod** named `remoteweb`
   - Expose it using a **NodePort Service**
   - The Service must be reachable on **NodePort `31999`**
3. In the **default** Namespace:
   - Run a Pod named `testpod`
   - Use the **BusyBox** image
   - Command: `sleep infinity`
4. From `testpod`:
   - Verify access to `remoteweb` using `wget --spider`
5. Also verify that:
   - The Nginx page is reachable via **Minikube IP + NodePort**

---

## 🏬 Mall Analogy

We are opening a boutique in a new, separate wing of the mall called **"remote"**.

We must ensure:
- Workers in the **default wing** can call the boutique internally
- Customers can enter directly from the street using a specific gate number

| Kubernetes Concept | Mall Analogy |
|-------------------|--------------|
| **Namespace: remote** | A new, separate wing of the mall |
| **Pod: remoteweb** | The Nginx boutique store |
| **Service: NodePort** | A shop sign with a street-level entrance |
| **NodePort: 31999** | The specific gate number on the mall exterior |
| **testpod (BusyBox)** | A worker testing internal communication |

---

## 🛠️ Solution

### 1️⃣ Build the Remote Wing and the Store

```bash
# Create the new Namespace
kubectl create ns remote

# Run the Nginx Pod inside it
kubectl -n remote run remoteweb --image=nginx
```

### 2️⃣ Install the Side Entrance (NodePort Service)

We want **NodePort 31999**, so we generate the Service manifest first and then edit it.
```bash
kubectl -n remote expose pod remoteweb \
  --port=80 \
  --type=NodePort \
  --dry-run=client -o yaml > svc-nodeport.yaml
```

Edit `svc-nodeport.yaml`:

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


Apply the Service:
```bash
kubectl apply -f svc-nodeport.yaml
```
### 3️⃣ Test from the Default Namespace (Internal Access)

Create a temporary worker (`testpod`) in the **default** Namespace:
```bash
kubectl run testpod --image=busybox -- sleep infinity
```

From `testpod`, test internal connectivity using Kubernetes DNS:
```bash
kubectl exec testpod -- \
  wget --spider --timeout=1 remoteweb.remote.svc.cluster.local
```

✅ Expected result:
`remote file exists`

🔎 Verification Results
✅ **Internal Check – “The Mall Phone Call”**

- **Command:**

```bash
wget --spider --timeout=1 remoteweb.remote
```

- **Meaning:**
A worker in the default wing calls the boutique in the remote wing.

- **Result:**
Successful connection.

💡 Tip: When calling across Namespaces, `service.namespace` is enough.

✅ External Check – “The Street Entrance”

```bash
curl $(minikube ip):31999
```

- **Meaning:**
A customer enters the mall directly from outside through Gate **31999**.

- **Result:**
`Welcome to nginx!`

**Expert Summary**

- **Port 80** → Internal shop entrance

- **remoteweb.remote** → Cross-namespace internal DNS

- **NodePort 31999** → External access via node IP

This lab demonstrates how Kubernetes Services:

- Decouple Pods from access methods

- Enable both **internal discovery** and **external exposure**

- Work consistently across Namespaces

📝 **Key Takeaways (CKAD Mindset)**

- NodePort is **simple but explicit**

- Cross-namespace access relies on **DNS naming**

- Always verify:

    - internal access first

    - external access second