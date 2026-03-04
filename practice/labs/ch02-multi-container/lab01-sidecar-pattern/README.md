# 🧪 LAB 01: The Sidecar & The Renovation Crew

## Pod Design – Advanced Pod Patterns

---

## 🎯 Lab Goal

This lab introduces the **Multi-Container Pod** patterns. You will learn how to:
- Use an **InitContainer** to perform setup tasks (creating configuration files).
- Use a **Sidecar Container** to assist the main application (logging/monitoring).
- Share data between containers using a shared **Volume (`emptyDir`)**.

> **CKAD Importance:** Very High. Pod design patterns like these are a staple of the exam.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a single shop (Pod) might have multiple workers:

- **The Renovation Crew (InitContainer)** → They come in *before* the shop opens, paint the walls, and set up the shelves. Once they finish, they leave. The shop can't open until they are done.
- **The Salesperson (Main Container)** → The person serving customers (Nginx).
- **The Assistant (Sidecar Container)** → Someone in the back room watching inventory or security cameras (Busybox). They work while the salesperson works.
- **The Stockroom (Shared Volume)** → A common closet inside the shop where all three can leave notes or tools for each other.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Pod** | A single shop unit. |
| **Main Container** | The primary business logic. |
| **InitContainer** | Setup script that runs once. |
| **Sidecar** | Helper process that runs alongside. |
| **emptyDir** | A temporary storage closet for that shop only. |

---

## 📋 Requirements

1. **Create a Pod** named `sidecar-example`.
2. **InitContainer** (`init-myfile`):
   - Image: `busybox`
   - Action: Create `index.html` in `/data` with content "Hello from Init".
3. **Main Container** (`nginx`):
   - Image: `nginx`
   - Action: Serve the shared `/data` folder.
4. **Sidecar Container** (`sidecar-helper`):
   - Image: `busybox`
   - Action: Stay alive and monitor the shared file.
5. **Shared Storage**: Use an `emptyDir` named `shared-data`.

---

## 🛠️ Step-by-Step Solution

### 1. Generate the Scaffold
You can't create multiple containers with a single command, so we start with one and edit.
```bash
k run sidecar-example --image=nginx --port=80 $do > pod-multi.yaml
```

### 2. Manual Surgery (vi)
Add the Init and Sidecar blocks.

```yaml
spec:
  initContainers:
  - name: init-myfile
    image: busybox
    command: ["sh", "-c", "echo 'Hello from Init' > /data/index.html"]
    volumeMounts:
    - name: shared-data
      mountPath: /data
  containers:
  - name: sidecar-example # Main Nginx
    image: nginx
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html
  - name: sidecar-helper # Sidecar
    image: busybox
    command: ["sh", "-c", "tail -f /dev/null"]
    volumeMounts:
    - name: shared-data
      mountPath: /data
  volumes:
  - name: shared-data
    emptyDir: {}
```

---

## 🔎 Verification

1. **Check Startup Sequence:**
   ```bash
   k apply -f pod-multi.yaml
   k get pods -w
   # Watch it go from Init:0/1 -> PodInitializing -> Running
   ```

2. **Test Shared Data:**
   ```bash
   # Check Nginx output (served from the shared volume)
   k exec sidecar-example -c sidecar-example -- curl localhost
   
   # Check the sidecar can see the same file
   k exec sidecar-example -c sidecar-helper -- cat /data/index.html
   ```

---

## 🧠 Key Takeaways

- **Initialization:** InitContainers run one by one and *must* exit successfully before the main containers even start.
- **Shared Lifecycle:** All containers in a Pod are scheduled on the same Node and share the same network (localhost).
- **Communication:** `emptyDir` is only shared between containers *in the same Pod*. If the Pod is deleted, the data is gone.
- **CKAD Tip:** If your Pod is stuck in `Init:CrashLoopBackOff`, check the logs of the Init container specifically: `k logs pod-name -c init-container-name`.

---

## 🔗 References
- **Comic** → [Sidecars](../../../../visual-learning/comics/ch02-multi-container/01-sidecar/README.md)
- **Docs** → [Decoupling Pods](../../../../reference/md-resources/decoupling-pods.md) | [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- **Study Guide** → [Chapter 2: Multi-Container Patterns](../../../../sources/study-guide/ch02-multi-container.md)
