# Lab 01 – Storage: Persistent Volumes & Claims

## Storage – Data Persistence & Volume Management

---

## 🎯 Lab Goal

This lab focuses on **managing stateful data** in Kubernetes using **PersistentVolumes (PV)** and **PersistentVolumeClaims (PVC)**.

You will learn how to:
- Create a **PersistentVolume (PV)** representing physical storage.
- Create a **PersistentVolumeClaim (PVC)** to request storage.
- Mount the PVC into a **Pod** to persist data.
- Verify that data survives Pod restarts (persistence).

This is a **core CKAD topic**.

---

## 🧠 Conceptual Comic (Read First)

Before starting, read this short comic:

👉 [Lab 01 - The Warehouse & The Rental Contract](../../../comics/storage/01-persistent-volume/README.md)

It explains **PVs, PVCs, and Mounting** using a warehouse analogy.

---

## 📘 Reference Docs

- Access Modes (RWO vs RWM) → [`docs/md-resources/access-modes-rwo-vs-rwm.md`](../../../docs/md-resources/access-modes-rwo-vs-rwm.md)
- PV Creation → [`docs/md-resources/creating-a-persistentvolume.md`](../../../docs/md-resources/creating-a-persistentvolume.md)
- PVC Binding → [`docs/md-resources/pvc-definition-binding.md`](../../../docs/md-resources/pvc-definition-binding.md)
- Static vs Dynamic → [`docs/md-resources/static-vs-dynamic-provisioning.md`](../../../docs/md-resources/static-vs-dynamic-provisioning.md)

---

## 📋 Requirements

1. Create a **PersistentVolume** named `task-pv-volume`
   - Class: `manual`
   - Capacity: `1Gi`
   - Access: `ReadWriteOnce`
   - HostPath: `/mnt/data`

2. Create a **PersistentVolumeClaim** named `task-pv-claim`
   - Request: `500Mi`
   - Class: `manual`

3. Create a **Pod** named `task-pv-pod`
   - Image: `nginx`
   - Mount the PVC to `/usr/share/nginx/html`

4. **Verify Persistence**:
   - Write a file to the mount path.
   - Delete and recreate the Pod.
   - Verify the file still exists.

---

## 🏬 Mall Analogy

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| **PersistentVolume (PV)** | A physical **Warehouse Unit** in the mall basement. |
| **PersistentVolumeClaim (PVC)** | A **Rental Contract** (ticket) allowing a shop to use a unit. |
| **Volume Mount** | The **Elevator/Chute** connecting the shop to the warehouse. |
| **StorageClass** | The **Type of Warehouse** (Standard, Premium/SSD, etc.). |

---

## 🛠️ Solution

### 1️⃣ Create the PersistentVolume (PV)

This represents the actual physical storage available in the cluster (or on the node, in this case).

👉 [Lab 01 - The Nightly Backup Permit](./pv.yaml)

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
```

Apply it:
```bash
kubectl apply -f pv.yaml
```

### 2️⃣ Create the PersistentVolumeClaim (PVC)

This is the request for storage. Kubernetes looks for a PV that matches the request.

👉 [Lab 01 - The Rental Contract](./pvc.yaml)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
```

Apply it:
```bash
kubectl apply -f pvc.yaml
```

**Verify Binding:**
```bash
kubectl get pvc task-pv-claim
# STATUS should be 'Bound'
```

### 3️⃣ Create the Pod with the Mounted Volume

👉 [Lab 01 - The Delivery Truck](./pod.yaml)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: task-pv-storage
```

Apply it:
```bash
kubectl apply -f pod.yaml
```

---

### 🔎 Verification (Persistence Test)

1. **Exec into the Pod and create a file in the volume:**
   ```bash
   kubectl exec task-pv-pod -- sh -c "echo 'Hello from Persistent Storage' > /usr/share/nginx/html/index.html"
   ```

2. **Verify the file exists:**
   ```bash
   kubectl exec task-pv-pod -- cat /usr/share/nginx/html/index.html
   ```

3. **Delete the Pod (simulate a crash/restart):**
   ```bash
   kubectl delete pod task-pv-pod
   ```

4. **Recreate the Pod:**
   ```bash
   kubectl apply -f pod.yaml
   ```

5. **Verify the file is still there:**
   ```bash
   kubectl exec task-pv-pod -- cat /usr/share/nginx/html/index.html
   ```

✅ **If you see "Hello from Persistent Storage", persistence is working!**
