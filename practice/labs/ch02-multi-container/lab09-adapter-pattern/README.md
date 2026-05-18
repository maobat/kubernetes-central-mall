# 🧪 LAB 09: The Bookkeeper's Desk (Adapter Pattern)

## 🎯 Lab Goal
> **Scenario: The Bookkeeper's Desk (Adapter Pattern)**
> Create a [Pod](../../../../GLOSSARY.md#pod) named `metrics-adapter` with two containers:
> 1. `metrics`: A container running the `busybox` image that initializes two files in a shared volume: `/data/raw.txt` and `/data/processed.txt`. Every 5 seconds, it appends a lowercase line `"minuscolo"` to `/data/raw.txt`.
> 2. `adapter`: A container running the `busybox` image that continually (every 5 seconds) processes `/data/raw.txt`, translates all lowercase characters to uppercase using `tr`, and writes the reformatted results to `/data/processed.txt`.
> 
> Both containers must share the file system via a shared [emptyDir](../../../../GLOSSARY.md#emptydir) volume named `data-volume` mounted at `/data`.

Learn how to implement the **Adapter Pattern** inside a multi-container [Pod](../../../../GLOSSARY.md#pod) to normalize or format application output before exposing it to external systems.

---

## 🛍️ Mall Analogy

In the **Central Mall**, the Sales Department (`metrics`) records sales in a raw, informal format. However, the Central Management Office requires all transactions to be formatted in standard uppercase before being sent to the mainframe.

* **The Bookkeeper's Desk (metrics-adapter):** A multi-container [Pod](../../../../GLOSSARY.md#pod) where a main container and a helper adapter container work in tandem to normalize raw outputs.
* **The Sales Clerk (metrics container):** Writes down raw sales records in lowercase (`minuscolo`) into a **Sales Log (raw.txt)** inside the **Store Register (Shared Volume)**.
* **The Bookkeeper (adapter container):** Sits at the same desk, watches the **Sales Log (raw.txt)**, translates every entry into uppercase (`MINUSCOLO`), and saves them into the official **Tax Report (processed.txt)**.
* **The Store Register (data-volume):** A shared [emptyDir](../../../../GLOSSARY.md#emptydir) volume (Day-Use Locker) that allows both workers to collaborate on the logs simultaneously.

---

## 🛠️ Step-by-Step Solution

### 1. Scaffold the Pod YAML (Imperative Best Practice)
Generate the base single-container manifest to save typing time in the exam:

```bash
kubectl run metrics-adapter --image=busybox --dry-run=client -o yaml > pod.yaml
```

### 2. Manual Surgery (Adding Second Container and Shared Volume)
Modify `pod.yaml` to define both the `metrics` and `adapter` containers, set up the shared volume, and declare their mount paths.

> [!TIP]
> **Key structural points:**
> 1. Both containers must mount the same volume `data-volume` to `/data`.
> 2. The `metrics` container initializes `/data/raw.txt` and `/data/processed.txt` using `touch` to avoid any file-not-found errors when the `adapter` starts up.
> 3. The `adapter` container uses the Unix tool `tr '[:lower:]' '[:upper:]'` to continuously translate lowercase characters to uppercase.

Open `pod.yaml` and configure it as follows:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: metrics-adapter
  name: metrics-adapter
spec:
  # 3. The Store Register (Shared Volume)
  volumes:
  - name: data-volume
    emptyDir: {}

  containers:
  # 1. The Sales Clerk (Metrics Producer Container)
  - name: metrics
    image: busybox
    command:
    - sh
    - -c
    - |
      touch /data/raw.txt /data/processed.txt
      while true; do
        echo "minuscolo" >> /data/raw.txt
        sleep 5
      done
    volumeMounts:
    - name: data-volume
      mountPath: /data

  # 2. The Bookkeeper (Adapter Container)
  - name: adapter
    image: busybox
    command:
    - sh
    - -c
    - |
      while true; do
        tr '[:lower:]' '[:upper:]' < /data/raw.txt > /data/processed.txt
        sleep 5
      done
    volumeMounts:
    - name: data-volume
      mountPath: /data
```

### 3. Deploy the Pod
Apply the resource to your Kubernetes cluster:

```bash
kubectl apply -f pod.yaml
```

---

## 🔎 Verification

1. **Check Pod Status:**
   Verify both containers inside the Pod are healthy and running (`READY: 2/2`).
   ```bash
   kubectl get pods metrics-adapter
   ```
   **Expected Output:**
   ```text
   NAME              READY   STATUS    RESTARTS   AGE
   metrics-adapter   2/2     Running   0          12s
   ```

2. **Verify the Lowercase Log:**
   Check the `/data/raw.txt` file in either container:
   ```bash
   kubectl exec metrics-adapter -c metrics -- cat /data/raw.txt
   ```
   **Expected Output:**
   ```text
   minuscolo
   minuscolo
   ```

3. **Verify the Uppercase Adapted Log:**
   Check the `/data/processed.txt` file in either container. It must contain the upper-cased normalized output!
   ```bash
   kubectl exec metrics-adapter -c adapter -- cat /data/processed.txt
   ```
   **Expected Output:**
   ```text
   MINUSCOLO
   MINUSCOLO
   ```

---

## 🧠 Key Takeaways

- **The Adapter Pattern:** Used when the primary application outputs data in a format that does not match what the downstream monitoring or API engine expects. The adapter container translates the output format on the fly without modifying the main application's code.
- **Shared Local State:** `emptyDir` volumes provide low-latency, shared storage on the local node file system, allowing separate processes to read/write concurrently.
- **Exam Strategy:** Semicolons are not needed when using a multi-line YAML block scalar (`|`), but in single-line command strings (`args`), command chaining with semicolons (`;`) is vital.

---

## 🔗 References
- **Docs** → [Share a Volume Between Containers](https://kubernetes.io/docs/tasks/configure-pod-container/share-volume-container/)
- **Study Guide** → [Chapter 2: Multi-Container Patterns](../../../../sources/study-guide/ch02-multi-container.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
