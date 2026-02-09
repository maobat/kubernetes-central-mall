### 6.4.4 Using StatefulSets

**StatefulSets** are a specialized workload object designed for managing stateful applications (which require persistent storage and stable network identity). They provide guarantees for ordered deployment, scaling, and unique, stable network identifiers for each Pod (e.g., `web-0`, `web-1`). They are commonly used for databases and message queues.

## (The Bank Row Analogy)

In the Kubernetes **"Mall,"** a **StatefulSet** is used for applications that aren't just temporary shops, but permanent institutions, like a row of **Numbered Private Banks**.

---

## 🏗️ 1. The Core Concept

The main purpose is to provide a **persistent identity** and **specific storage** to each Pod.

### 🔐 Persistent Identifiers
Each Pod is named with a strict index:

- `web-0`
- `web-1`
- `web-2`

If `web-0` is demolished, it is rebuilt as **`web-0`**, never with a random name.

### 📦 Ordered Deployment
Unlike regular stores, these are built **one-by-one**:

- `web-0` must be **"Open for Business"**
- Only then does construction start on `web-1`

### 🏦 Stable Storage
Every bank branch has its own **Private Underground Vault** (Persistent Volume):

- The vault is permanently tied to the branch number  
- Storage survives Pod restarts and rescheduling  

---

## 📐 2. The Blueprint Integration (`sfs.yaml`)

### Part A: The Private Switchboard (Headless Service)

**YAML**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  clusterIP: None  # <--- The "Headless" magic
```
## 🏦 Analogy:
Instead of a general mall receptionist, this is a Direct-Dial Directory.

## Function:
It allows you to dial a specific branch directly (e.g., web-0.nginx) rather than hitting a load balancer.

### Part B: The Bank Row (StatefulSet)

**YAML**
```yaml


apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 3
  template:
    spec:
      terminationGracePeriodSeconds: 10 # Emergency evacuation time
```
## 🏦 Analogy:
You are ordering 3 numbered branches.
The terminationGracePeriodSeconds gives staff 10 seconds to lock the safe before the building is removed.

### Part C: The Automatic Vault Permit (VolumeClaimTemplates)
**YAML**
```yaml
volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "standard" # The "Digging Machine"
      resources:
        requests:
          storage: 1Gi
```
## 🏦 Analogy

This is a permit that says:

> "For every bank built, automatically dig a 1Gi vault using the standard digging machine."

---

## 💾 Persistence

If the building (`web-0`) is destroyed, the vault (`www-web-0`) is **not deleted**.  
It waits in the ground for the next `web-0`.

---

## 📝 3. Limitations & Rules

### Storage Provisioning
A **StorageClass** (like the standard `hostpath` in Minikube) must be available.

### Manual Cleanup
To ensure data safety, the Mall Manager (Kubernetes) will **never delete the vaults (PVCs)** automatically.  
You must manually *"fill in the holes"* (delete PVCs) if you want the data gone.

### Headless Requirement
A **Headless Service MUST** be created to provide direct-dial access.

### Graceful Removal
To remove the banks, you should **scale the number of Pods down to 0** before deleting the StatefulSet.

---

## Summary Table
While a Deployment creates "Disposable Workers," a StatefulSet creates "Named Institutions."

| Feature   | Deployment (Pop-up Shop) | StatefulSet (Private Bank) |
|-----------|--------------------------|-----------------------------|
| Naming    | Random (web-7fc...)      | Strict Index (web-0, web-1) |
| Startup   | All at once (Parallel)   | One-by-one (Ordered)        |
| Storage   | Shared or Temporary      | Unique Private Vault        |
| Network   | Single Shared Number     | Direct Extension per Pod   |

---

## 🔍 Construction Progress (From Logs)
- `web-0` in `ContainerCreating`  
- Other Pods waiting  

This confirms **Ordered Deployment**.

The PVC `www-web-0` was **Bound** to the digging machine before the Nginx "Bank" could open.


[Back to Documentation](../README.md)
