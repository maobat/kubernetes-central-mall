<h3 id="section-5-1">5.1 Creating a PersistentVolume via hostPath</h3>

In Kubernetes Mall terms: You are building a permanent warehouse slot *within* the Mall building (Node).

#### 5.1.1 The Warehouse Slot (PersistentVolume)

Here is the YAML defining the warehouse:

```yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-volume
  labels:
    type: local
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mydata"
```

| CONCEPT | RESOURCE | ANALOGY | DESCRIPTION |
| :--- | :--- | :--- | :--- |
| Warehouse Slot | `PersistentVolume` | A permanent storage room | Fixed storage area created by the administrator. |
| Storage Location | `hostPath` | Physical closet door | Maps the storage to a real folder on the Node. |

#### 5.1.2 Creating the Warehouse

Apply the YAML: `kubectl apply -f pv.yaml`
Check the PV: `kubectl get pv`

#### 5.1.3 Checking the Physical Warehouse Location (Node Filesystem)

`hostPath` volumes exist on the node, not inside Kubernetes.

Connect to the minikube node: `minikube ssh`
List the root directory: `ls /`
  - You will **NOT** see `/mydata` yet, this is normal.

**Why?** Because Kubernetes does not create the `hostPath` directories unless you specify: `type: DirectoryOrCreate`.

**How to Fix This**

Modify the PV:

```yaml
  path: "/mydata"
  type: DirectoryOrCreate
```

Apply: `kubectl apply -f pv.yaml --force`
Check on the node (only **after** a Pod uses it): `minikube ssh`, then `ls /mydata`

#### 5.1.4 Summary Table, hostPath Behavior

| hostPath Type | Behavior |
| :--- | :--- |
| `Directory` | Path must already exist |
| `DirectoryOrCreate` | **Creates the directory if missing** |
| `FileOrCreate` | Creates an empty file if missing |
| (no type) | Kubernetes does not create the path (Strict Check) |


[Back to Documentation](../README.md)
