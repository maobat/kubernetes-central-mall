# CKAD Cheatsheet: Namespaces, Config & Storage

Quick reference for Namespaces, ConfigMaps/Secrets, and PV/PVC commands.

## 🏢 Namespaces

```bash
# List namespaces
kubectl get ns

# Create a namespace
kubectl create ns dev

# Switch context to a specific namespace permanently
kubectl config set-context --current --namespace=dev
```

## ⚙️ ConfigMaps & Secrets

```bash
# Create ConfigMap from literal
kubectl create configmap <name> --from-literal=key=value

# Create Secret from literal
kubectl create secret generic <name> --from-literal=key=value

# Inspect ConfigMap
kubectl describe cm <name>

# Inspect Secret
kubectl describe secret <name>
```

> [!TIP]
> For consuming ConfigMaps/Secrets as environment variables (`env` vs `envFrom`), see the [Fundamentals cheat sheet](ckad-cheatsheet-fundamentals.md).

## 💾 Storage

```bash
# List Persistent Volumes and Claims
kubectl get pv
kubectl get pvc

# Apply a PVC manifest
kubectl apply -f pvc.yaml
```

> [!TIP]
> **No Imperative command for PV/PVC!**
> There is no `kubectl create pv` or `kubectl create pvc` command. You **must** use a YAML file. Copy an example from the official documentation during the exam.

### 🧱 PV / PVC / Pod Skeleton (Static Provisioning)

Three objects, three separate concerns: the **PersistentVolume** (the actual storage, provisioned by an admin), the **PersistentVolumeClaim** (a request for storage that binds to a matching PV), and the **Pod** (mounts the PVC, never the PV directly).

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 500Mi        # <-- map[string]Quantity, NOT a list: "storage: 500Mi", no "-"
  accessModes:
  - ReadWriteOnce          # <-- []string, this one IS a list
  persistentVolumeReclaimPolicy: Retain
  storageClassName: ""     # <-- empty string: opts out of dynamic provisioning, forces static matching
  hostPath:
    path: /mnt/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
  - ReadWriteOnce          # <-- must match (or be a subset of) the PV's accessModes
  resources:
    requests:
      storage: 500Mi        # <-- must be <= the PV's capacity to bind
  storageClassName: ""      # <-- empty string here too: pairs it with the static PV above, not a dynamic provisioner
---
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: my-pvc     # <-- the Pod references the PVC, never the PV by name
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: data
      mountPath: /usr/share/nginx/html
```

> [!WARNING]
> **`storageClassName: ""` on both PV and PVC is what makes static binding actually work.** If the cluster has a **default StorageClass** (common on managed clusters) and you leave `storageClassName` unset on the PVC, it auto-binds to a *dynamically provisioned* volume instead of your hand-made PV, and your PV sits unbound while the PVC gets to `Bound` anyway, just against the wrong storage. `kubectl get pv` showing your PV stuck at `Available` (never `Bound`) despite a matching PVC existing is the tell.

Verify the binding:

```bash
kubectl get pv my-pv          # STATUS should be "Bound"
kubectl get pvc my-pvc        # STATUS should be "Bound", VOLUME column should show "my-pv"
```

### 🔒 Stuck on `Released`: The `Retain` Trap

With `persistentVolumeReclaimPolicy: Retain` (the default choice when protecting real data), deleting the PVC does **not** free the PV for reuse. The PV moves to `STATUS: Released` and keeps a stale `spec.claimRef` pointing at the now-deleted PVC (by UID, not just by name), so a *new* PVC with the exact same name still won't bind, it stays `Pending` forever:

```text
persistentvolume/earth-project-earthflower-pv    Released   earth/earth-project-earthflower-pvc
persistentvolumeclaim/earth-project-earthflower-pvc   Pending
```

> [!WARNING]
> **Deleting and recreating only the PVC does not fix this**, verified: the PV stays `Released` no matter how many times the PVC alone is deleted/reapplied, because `claimRef` never clears itself.

Two ways to actually fix it, both verified to work:

**1. Delete and recreate *both* objects from the same file** (simplest to remember on exam day):

```bash
kubectl delete -f pv-pvc.yaml --force --grace-period=0
kubectl apply -f pv-pvc.yaml
```

This destroys the PV entirely and recreates it fresh, so there's no stale `claimRef` left to clear. Since the file already fully describes the desired end state, a brand-new PV object is exam-safe, nothing in a CKAD task cares about the PV keeping the same UID.

**2. Patch out the stale `claimRef`, keeping the same PV object:**

```bash
kubectl patch pv earth-project-earthflower-pv -p '{"spec":{"claimRef": null}}'
```

Use this instead of option 1 only if you actually need to keep the exact same PV object (rare on the exam), option 1 is faster to type and easier to recall under pressure.

### 🏭 StorageClass Skeleton (Dynamic Provisioning)

With a StorageClass, you skip hand-writing a PV entirely: the PVC references the class by name, and a PV is created for you automatically by the class's `provisioner`.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: my-storage-class
provisioner: rancher.io/local-path   # <-- cluster-specific: check `kubectl get storageclass -o yaml` for what your cluster actually supports
reclaimPolicy: Delete                 # <-- what happens to the PV when the PVC is deleted: Delete or Retain
volumeBindingMode: WaitForFirstConsumer
parameters:                           # <-- map[string]string, provisioner-specific options (can be empty)
  type: fast
```

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-dynamic-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 500Mi
  storageClassName: my-storage-class   # <-- references the StorageClass by name; no matching PV to hand-write
```

The Pod side is identical either way, unchanged from the static example above: `volumes[].persistentVolumeClaim.claimName` pointing at the PVC.

> [!TIP]
> **Check what your cluster actually has before inventing a `provisioner`.** `kubectl get storageclass` lists what's installed; `kubectl get storageclass -o yaml` shows the exact `provisioner` string for each. A `provisioner` your cluster doesn't recognize leaves the PVC stuck at `Pending` forever, with no PV ever created, and no error beyond that.
>
> **Only one StorageClass can be the cluster default** at a time, marked with the annotation `storageclass.kubernetes.io/is-default-class: "true"`. If a task says "create it as the default StorageClass", that annotation is the actual mechanism, there's no dedicated `default: true` field.

<!-- -->

> [!WARNING]
> **Two different reasons a dynamic PVC shows `Pending`, don't confuse them:**
>
> - With `volumeBindingMode: WaitForFirstConsumer` (verified above): the PVC stays `Pending` **on purpose** until a Pod that references it actually gets scheduled, that's expected, not a bug. Create the Pod and it resolves.
> - With `volumeBindingMode: Immediate` or a bad/unrecognized `provisioner`: `Pending` means something is actually broken; `kubectl describe pvc <name>` and its Events section says which.

### ⚖️ Static vs Dynamic: When to Actually Use Each

| | **Static** (hand-written PV + PVC) | **Dynamic** (StorageClass + PVC) |
| :--- | :--- | :--- |
| **Who creates the PV** | You, by hand, before the PVC exists | The provisioner, automatically, when the PVC is created |
| **Use when...** | The storage already exists and must be reused as-is (an existing NFS share, a disk with data already on it, a specific `hostPath` a task tells you to reuse) | The cluster has a real provisioner (cloud disk, CSI driver) and you just need "some storage that meets these requirements", not a specific pre-existing volume |
| **No provisioner available** | Works regardless, `hostPath`/NFS/local disks don't need one | Doesn't work at all, the PVC stays `Pending` forever with no PV ever created |
| **Typical `reclaimPolicy`** | Usually `Retain` (you're protecting data you already care about) | Usually `Delete` (throwaway storage, cleaned up automatically with the PVC) |
| **Scales to many apps?** | No, an admin manually creates one PV per claim | Yes, self-service, any number of PVCs reuse the same StorageClass |
| **On a bare kind/minikube-style cluster (most CKAD labs)** | The default and often the *only* option, since there's frequently no real cloud provisioner installed | Only works if the cluster ships one (e.g. `rancher.io/local-path` on `kind`), check `kubectl get storageclass` before assuming it's available |

> [!TIP]
> **If the task says "the following PV already exists" or gives you a specific `hostPath`/NFS server to reuse, that's static, full stop, don't reach for a StorageClass.** If it says "the Pod needs 1Gi of storage" with no mention of a specific existing volume, that's the signal to check `kubectl get storageclass` and go dynamic, if one's available. On most CKAD lab clusters, static `hostPath` PVs are still the more common exam pattern precisely because a real dynamic provisioner often isn't installed.

### 🧠 Fastest Path on Exam Day: Memorize, Don't Look Up

There's no imperative generator for any of PV, PVC, or StorageClass (confirmed: `kubectl create --help` lists nothing for any of them). Given that, the fastest path isn't `kubectl explain` or the official docs, it's **memorizing the skeleton below**: these three objects are short and repetitive enough that the task's own wording gives you every value you need, there's no ambiguity left to look up.

**Priority order, and why:**

1. **Recall the skeleton from memory** (below), fill in the values the task gives you. Zero context-switch, fastest by far.
2. **`kubectl explain <field> --recursive`**, but only as a *targeted* check on one specific field you're unsure of (is it a list, what's the exact enum value), not as a way to generate the whole thing. This is how the `WaitForFirstConsumer` typo earlier in this cheat sheet got caught.
3. **Official docs (browser tab)**, only if you go completely blank on the structure. Costs the most time, so it's the last resort here, unlike NetworkPolicy, where the nesting is complex enough that reaching for the docs first is the safer default.

**The minimal skeleton, all three together:**

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  accessModes: [ReadWriteOnce]
  storageClassName: ""
  hostPath:
    path: /mnt/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes: [ReadWriteOnce]
  resources:
    requests:
      storage: 1Gi
  storageClassName: ""
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: my-sc
provisioner: <check `kubectl get storageclass -o yaml` for the real one>
```

For the full skeletons with the Pod side and every field explained, see above; this compressed version is purely the shape to keep in your head.

---
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
