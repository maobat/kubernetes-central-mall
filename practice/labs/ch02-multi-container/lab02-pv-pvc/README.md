# 🧪 LAB 02: Warehouse Safes (PV & PVC)

## Storage – Data Persistence & Volume Management

---

## 🎯 Lab Goal

This lab focuses on **managing stateful data** using **PersistentVolumes (PV)** and **PersistentVolumeClaims (PVC)**. You will learn how to:
- Create a **PersistentVolume (PV)** representing physical storage.
- Create a **PersistentVolumeClaim (PVC)** to request storage.
- Mount the PVC into a **Pod** to persist data across restarts.

> **CKAD Importance:** Very High. You will almost certainly have to mount a volume or create a PVC during the exam.

---

## 🛍️ Mall Analogy

In the **Central Mall**, if a shop wants to keep inventory safe even when the staff changes, they need a dedicated space in the basement.

- **The Warehouse Unit (PV)** → A physical safe located in the mall's basement. It has a specific size (1Gi) and access rules (Who can open it).
- **The Rental Contract (PVC)** → A ticket the shop owner takes to the Mall Manager. "I need a 500MB safe." The manager looks at the basement and matches the contract to an available unit.
- **The Chute (Volume Mount)** → The physical connection between the shop upstairs and the safe in the basement.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **PersistentVolume** | The actual physical storage units in the basement. |
| **PersistentVolumeClaim** | The request for a unit. |
| **accessModes** | "Is this unit for one clerk (RWO) or many (RWM)?" |
| **storageClassName** | "Is this a standard locker or a high-speed SSD safe?" |

---

## 📋 Requirements

1. **Create a PersistentVolume** named `task-pv-volume`:
   - Capacity: `1Gi`
   - Access: `ReadWriteOnce`
   - StorageClass: `manual`
   - Path: `/mnt/data` (on the host)

2. **Create a PersistentVolumeClaim** named `task-pv-claim`:
   - Request: `500Mi`
   - Access: `ReadWriteOnce`
   - StorageClass: `manual`

3. **Create a Pod** named `task-pv-pod`:
   - Image: `nginx`
   - Mount: Connect `task-pv-claim` to `/usr/share/nginx/html`.

---

## 🛠️ Step-by-Step Solution

### 1. The Warehouse Unit (PV)
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
spec:
  storageClassName: manual
  capacity:
    storage: 1Gi
  accessModes: [ "ReadWriteOnce" ]
  hostPath:
    path: "/mnt/data"
```

### 2. The Rental Contract (PVC)
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes: [ "ReadWriteOnce" ]
  resources:
    requests:
      storage: 500Mi
```

### 3. The Shop (Pod)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
spec:
  volumes:
  - name: storage-locker
    persistentVolumeClaim:
      claimName: task-pv-claim
  containers:
  - name: clerk
    image: nginx
    volumeMounts:
    - name: storage-locker
      mountPath: "/usr/share/nginx/html"
```

---

## 🔎 Verification

1. **Check Binding:**
   ```bash
   k get pv,pvc
   # The PVC status must be 'Bound'. If it's 'Pending', check the StorageClass.
   ```

2. **Test Persistence:**
   ```bash
   # 1. Write data
   k exec task-pv-pod -- sh -c "echo 'Warehouse Secret' > /usr/share/nginx/html/index.html"
   
   # 2. Simulate a crash
   k delete pod task-pv-pod
   
   # 3. Recreate and verify
   k apply -f pod.yaml
   k exec task-pv-pod -- cat /usr/share/nginx/html/index.html
   ```

---

## 🧠 Key Takeaways

- **Static Provisioning:** This lab uses static provisioning (pre-creating the PV). In production, `StorageClasses` usually create the PV automatically when you submit a PVC.
- **Labels & Selectors:** You can use labels on PVs and selectors on PVCs to ensure a specific shop gets a specific safe.
- **Reclaim Policy:** `Retain` means the safe isn't wiped when the contract ends; `Delete` means the safe is destroyed.
- **CKAD Tip:** If your PVC is stuck in `Pending`, use `kubectl describe pvc` to find out why. Usually, it's a mismatch in `accessModes` or `storageClassName`.

---

## 🔗 References
- **Comic** → [Warehouse Safes](../../../../visual-learning/comics/ch02-multi-container/02-the-warehouse/README.md)
- **Docs** → [PV Creation](../../../../reference/md-resources/creating-a-persistentvolume.md) | [PVC Binding](../../../../reference/md-resources/pvc-definition-binding.md)
- **Study Guide** → [Chapter 2: Storage](../../../../sources/study-guide/ch02-multi-container.md)
