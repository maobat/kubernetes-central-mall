<h3 id="section-5-7">5.7 Connecting the Worker to the Storage: Concrete Example</h3>

The final step in the storage process is to connect the Worker (Pod) to the reserved Warehouse Slot (PV) using the Storage Request Form (PVC). This demonstrates the full decoupling.

---
#### 5.7.1 The Three Required Files (Static Binding Demo)

For this example, we use **Static Binding** by assigning a matching `storageClassName: manual` to both the PV and PVC.

**File 1: The Warehouse Slot (PV)**: `pv-rwo.yaml`
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-rwo
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi # The available size
  accessModes:
    - ReadWriteOnce # RWO access mode
  hostPath:
    path: "/mnt/storage-rwo" # Actual location on the Node
    type: DirectoryOrCreate
```

**File 2: The Storage Request Form (PVC)**: `pvc-rwo.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-rwo-claim
spec:
  storageClassName: manual # Must match PV for static binding
  accessModes:
    - ReadWriteOnce # Must match PV
  resources:
    requests:
      storage: 1Gi # Requested size (must be <= PV capacity)
```

**File 3: The Worker Definition (Pod)**: `pod-rwo.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-rwo-worker
spec:
  volumes:
    - name: app-storage
      persistentVolumeClaim:
        claimName: pvc-rwo-claim # References the PVC by name
  containers:
    - name: nginx-container
      image: nginx:alpine
      volumeMounts:
        - name: app-storage # Must match the volume name above
          mountPath: /usr/share/nginx/html/data # Mounts the PV inside the container
```
---
#### 5.7.2 The Storage Lifecycle in Action (Demo Static Binding Steps)

This sequence mirrors the steps often executed in a lab environment to confirm the binding and usage:

| Action | Kubernetes Command | Result in Analogy |
| :--- | :--- | :--- |
| **1. Admin Prepares** | `kubectl apply -f pv-rwo.yaml` | The Cluster Admin builds the physical Warehouse Slot (PV). |
| **2. App Requests** | `kubectl apply -f pvc-rwo.yaml` | The App Manager submits the Request Form (PVC). **Status goes to `Bound`.** |
| **3. Binding Status Check** | `kubectl get pv,pvc` | Confirms the PV and PVC are bound, linking their names. |
| **4. Hiring the Worker** | `kubectl apply -f pod-rwo.yaml` | The Worker (Pod) is hired and references the now-bound Request Form. |
| **5. Writing Data** | `kubectl exec app-rwo-worker -- touch /usr/share/nginx/html/data/hello.txt` | The Worker places a file inside their Locker via the mounted path. |
| **6. Checking the Source** | `minikube ssh` then `ls /mnt/storage-rwo` | The Mall Administrator checks the physical Utility Closet on the Node and sees the file (`hello.txt`). **Persistence is achieved.** |

--- 
#### 5.7.3 The 1-File/Demo Dynamic Binding Steps
**Step 1: The Request Form (PVC):** `pvc-dynamic.yaml`
Notice we no longer use `manual`. We use a "Contract Name" provided by the mall (like `standard` or `gp2`).
```YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-dynamic-claim
spec:
  storageClassName: standard  # The "Contract" that triggers automation
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
**Step 2: The Worker (Pod):** `pod-dynamic.yaml`
The Pod stays almost exactly the same, just pointing to the new claim name.
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: dynamic-worker
spec:
  volumes:
    - name: data-storage
      persistentVolumeClaim:
        claimName: pvc-dynamic-claim
  containers:
    - name: nginx
      image: nginx:alpine
      volumeMounts:
        - name: data-storage
          mountPath: /data
```
---
#### 5.7.3.5 The Dynamic Lifecycle
Because this is automated, the sequence is shorter and the "Magic" happens at step 2.
|Action|Kubernetes Command|Result in Analogy|
|--|--|--|
|**1. Admin Sets Rule**|`kubectl get sc`|Admin ensures a Logistics Officer (StorageClass) is on duty.|
|**2. App Requests**|`kubectl apply -f pvc-dynamic.yaml`|The Request is submitted. The Officer sees it and instantly builds a new PV.|
|**3. Verify Magic**|`kubectl get pv,pvc`|You will see a PV with a long, random name. The Mall built it just for you!|
|**4. Hiring**|`kubectl apply -f pod-dynamic.yaml`|The Worker starts and immediately has a key to the new room.|
---
#### 5.7.4 The The Worker's Temporary Locker `emptyDir` 
When two workers in the same shop need to pass files back and forth (e.g., one worker writes a log, another worker processes it).

```File: lab574-emptydir.yaml```
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: helper-worker-pod
spec:
  volumes:
    - name: shared-bench  # The "Blueprint" for the emptyDir
      emptyDir: {}        # No extra config needed!
  containers:
    - name: writer-worker
      image: alpine
      command: ["/bin/sh", "-c", "echo 'Work in progress' > /data/task.txt; sleep 3600"]
      volumeMounts:
        - name: shared-bench
          mountPath: /data # Access point for the first worker
    - name: reader-worker
      image: alpine
      command: ["/bin/sh", "-c", "cat /data/task.txt; sleep 3600"]
      volumeMounts:
        - name: shared-bench
          mountPath: /data # Access point for the second worker
```
---
#### 5.7.4.5 The emptyDir Lifecycle in Action
|Action|Result in Analogy|
|--|--|
|**1. Pod Starts**|The Mall Manager sets up a clean, empty workbench inside the shop.|
|**2. Writer Worker acts**|The first worker scribbles a note on the workbench at `/data/task.txt`.|
|**3. Reader Worker acts**|The second worker looks at the same workbench and reads the note.|
|**4. Container Crashes**|If one worker faints and is replaced, the **workbench stays put**. The data survives.|
|**5. Pod is Deleted**|The shop is closed. The Mall Janitor comes by and **throws the whole workbench in the trash**. The data is gone forever.|


[Back to Documentation](../README.md)
