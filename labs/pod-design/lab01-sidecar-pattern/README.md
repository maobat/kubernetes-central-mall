# Lab 01 – Multi-Container Pods: Sidecars & InitContainers

## Pod Design – Advanced Pod Patterns



## 🎯 Lab Goal

This lab introduces the **Multi-Container Pod** pattern. You will learn how to:

- Run multiple containers in a single Pod.
- Use an **InitContainer** to perform setup tasks (creating configuration files).
- Use a **Sidecar Container** to assist the main application.
- Share data between containers using a shared **Volume (`emptyDir`)**.

This is a **high-probability CKAD topic**.

---

## 📖 Related Comic
👉 [comics/pod-design/01-sidecar/README.md](../../../comics/pod-design/01-sidecar/README.md)

It explains **Sidecars, InitContainers, and Shared Volumes**.

---

## 📘 Reference Docs

- Multi-Container Pods → [`docs/md-resources/decoupling-pods.md`](../../../docs/md-resources/decoupling-pods.md)
- Init Containers → [Kubernetes Docs: Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- Volumes (emptyDir) → [`docs/md-resources/storage-recap-for-dummies.md`](../../../docs/md-resources/storage-recap-for-dummies.md)

---

## 📋 Requirements

1. Create a Pod named `sidecar-example`
2. **InitContainer** (`init-myfile`):
   - Image: `busybox`
   - Command: Create a file `message` with content "hello" in `/data`
3. **Main Container** (`nginx`):
   - Image: `nginx`
   - Mount `/data` to `/usr/share/nginx/html` (so it serves the file created by init)
4. **Sidecar Container** (`busybox`):
   - Image: `busybox`
   - Command: Sleep forever (just to keep running)
   - Mount `/data` to access the shared file
5. **Volume**:
   - Type: `emptyDir`
   - Name: `shared-data`

---

## 🏬 Mall Analogy

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| **Pod** | A single **Store** unit. |
| **Main Container** | The **Salesperson** serving customers (Nginx). |
| **InitContainer** | The **Renovation Crew** that sets up the store before it opens. |
| **Sidecar Container** | The **Assistant** checking inventory in the back (Busybox). |
| **Shared Volume** | The **Stockroom** accessible by all staff. |

---

## 🛠️ Solution

### 1️⃣ Define the Multi-Container Pod

We will use an `emptyDir` volume to share data between the InitContainer and the Main Container.

👉 [Lab 01 - The Sidecar](./pod-sidecar.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: sidecar-example
  name: sidecar-example
spec:
  # 1. InitContainers run to completion BEFORE the main containers start
  initContainers:
  - name: init-myfile
    image: busybox
    command:
    - sh
    - -c
    - echo "Hello from Init" > /data/index.html
    volumeMounts:
    - name: shared-data
      mountPath: /data

  # 2. Main Containers run in parallel
  containers:
  - image: nginx
    name: sidecar-example
    ports:
      - containerPort: 80
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html

  - name: sidecar-helper
    image: busybox
    command:
    - sh
    - -c
    - tail -f /dev/null
    volumeMounts:
    - name: shared-data
      mountPath: /data

  # 3. Shared Volume
  volumes:
  - name: shared-data
    emptyDir: {}
```

## 🛠️ Solution

### Imperative way: smart solution

```bash
k run sidecar-example --image=nginx --port=80 $do > pod-sidecar.yaml
```
---

## 🛠️ The "Surgery" (vi routine)
Open `pod-sidecar.yaml`. You need to add the **Setup Crew**, the **Assistant**, and the **Shared Locker** (emptyDir).

### 1. The Setup Crew (InitContainer)
Add this **above** the `containers:` block. These workers finish their job *before* the shop opens.
```yaml
spec:
  initContainers:
  - name: init-myfile
    image: busybox
    command:
    - sh
    - -c
    - echo "Hello from Init" > /data/index.html
    volumeMounts:
    - name: shared-data
      mountPath: /data
```
---

### 2. The Assistant (Sidecar Container)
Add this **below** the first container. This worker watches the main app.
```yaml
  - name: sidecar-helper
    image: busybox
    command: 
    - sh
    - -c
    - tail -f /dev/null
    volumeMounts:
    - name: shared-data
      mountPath: /data
```
---

### 3. The Shared Locker (Volume)
At the bottom of the `spec:`, create the space where they exchange tools.
```yaml
  volumes:
  - name: shared-data
    emptyDir: {}
```
---

### 4. Adding the Volume Mount to the Clerk (Main Container)
```yaml
  ...
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html
  ...
```
---
### Apply and Verify

Apply the manifest:
```bash
k apply -f pod-sidecar.yaml
```

**Verify the Init Stage:**
Watch the Pod status carefully. You should see `Init:0/1` -> `PodInitializing` -> `Running`.

```bash
k get pod sidecar-example -w
```

**Verify the Shared Content:**
The InitContainer created `index.html` in the shared volume.
The Nginx container mounted that volume to its web root.

Let's curl the Nginx container:
```bash
k exec sidecar-example -c sidecar-example -- curl localhost 
```

✅ **Expected Output:**
`Hello from Init`

**Verify from the Sidecar:**
The sidecar also has access to the data.
```bash
kubectl exec sidecar-example -c sidecar-helper -- cat /data/index.html
```

---

### 🧠 Key Takeaways

- **InitContainers** run **sequentially** and **first**. If they fail, the Pod restarts.
- **Sidecars** run **alongside** the main app.
- **emptyDir** is perfect for ephemeral shared data within a Pod.

---

## 📖 Related Chapter
👉 [sources/study-guide/ch02-multi-container.md](../../../sources/study-guide/ch02-multi-container.md)
