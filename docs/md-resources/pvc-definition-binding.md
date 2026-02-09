<h3 id="section-5-2">5.2 PVC Definition and Binding: The Request Form Breakdown</h3>

The YAML you are asking about, in the context of the Mall Analogy, represents the Storage Request Form (`PVC`).

#### 5.2.1 The Storage Request Form (PVC)

The YAML manifest below defines the Request Form (PVC) that a Worker (Pod) would use to ask the Mall Manager (Kubernetes Control Plane) for persistent storage.

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

| YAML Field | Kubernetes Resource | Mall Analogy | Explanation |
| :--- | :--- | :--- | :--- |
| `kind: PersistentVolumeClaim` | PVC | Storage Request Form | This declares the resource as the formal request for storage. |
| `metadata: name: pv-claim` | PVC Name | Request Form Name | The name of the request, used by the Worker (Pod) to reference it. |
| `accessModes: ReadWriteOnce` | Access Mode | Keys/Access Type | Requests an exclusive key: only one Node (the physical host) can mount the storage read/write at a time. |
| `resources: requests: storage: 1Gi` | Capacity | Requested Room Size | Requests a storage space of 1 Gigabyte or more. |

#### 5.2.2 The Binding Process Analogy

* **Request Submission (PVC Creation):** A Worker (Pod) needs durable storage, so its Manager (Deployment) submits the Storage Request Form (`pv-claim`) to the Mall Manager (Kubernetes Control Plane).
* **Matchmaking (PV/PVC Binding):** The Mall Manager checks the available Warehouse Slots (PVs). It looks for a PV that:
    * Has at least 1Gi of space.
    * Supports the `ReadWriteOnce` access mode.
    * (Crucially) Matches the `StorageClass` (Contract Type).
* **Slot Reservation (Bound Status):** Upon finding a match, the Mall Manager reserves that specific Warehouse Slot (PV) and marks the Request Form (PVC) status as **`Bound`**. The two are now exclusively paired. **A PVC bind is exclusive: after binding, the PV cannot be used by any other PVC.**
