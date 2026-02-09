<h3 id="section-5-5">5.5 Lab Analysis: Shared Volume Setup (`lab10.yaml`)</h3>

This manifest demonstrates a successful Static Binding setup using the **ReadWriteMany (RWM)** access mode to allow shared storage access for a web server.

```yaml
# 1. PersistentVolume (The Shared Warehouse Slot)
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteMany # CRITICAL: Allows multiple Nodes (Pods) access
  hostPath:
    path: "/mnt/data" # Physical location on the Node
    type: DirectoryOrCreate
---
# 2. PersistentVolumeClaim (The Shared Storage Request)
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual # CRITICAL: Selector to match the PV above
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 3Gi
---
# 3. Pod (The Worker using the Shared Storage)
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
      image: httpd:alpine
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/local/apache2/htdocs" # Mounts over the HTTPD document root
          name: task-pv-storage
```

| Component | Key Configuration | Analysis |
| :--- | :--- | :--- |
| **PV** | `RWM` + `storageClassName: manual` | Creates a 10Gi shared storage room with a "Manual" contract. |
| **PVC** | `RWM` + `storageClassName: manual` | Requests a shared room with a "Manual" contract (3Gi). **The match succeeds.** |
| **Pod** | Mounts to `/usr/local/apache2/htdocs` | The Pod mounts the bound PV directly into the web server's public folder, making the contents of `/mnt/data` on the Node accessible via the web server. |


[Back to Documentation](../README.md)
