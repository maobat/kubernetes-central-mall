# 🧪 LAB 07: The Prep Cook (InitContainer Pattern)

## 🎯 Lab Goal
> **Scenario: The Recipe Book Setup**
> Create a pod named `init-config-app` where a setup script (`initContainers`) must write configuration parameters into `/config/settings.conf` inside a shared volume. The main container (`nginx`) must wait for the init container to finish, mount the same volume, and read those parameters.

Learn how to implement **InitContainers** to perform crucial setup tasks and configurations before your main application starts.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a specialty restaurant (`init-config-app`) follows strict kitchen rules:

* **The Prep Cook (Init Container):** Arrives *before* the restaurant opens. The Prep Cook writes down the daily recipes and secret sauces inside a notebook (`settings.conf`) on the **Kitchen Counter (Shared Volume)**, then exits.
* **The Chef (Main Container):** Arrives only *after* the Prep Cook has completely finished. The Chef opens the restaurant (`nginx`), mounts the Kitchen Counter, and reads the notebook to cook food for customers.
* **The Kitchen Counter (config-data):** A shared `emptyDir` storage space where the Prep Cook writes the configurations and the Chef reads them.

---

## 🛠️ Step-by-Step Solution

### 1. Generate the Scaffold (Imperative Best Practice)
To maximize speed on the CKAD exam, generate the base YAML definition for the main application container first.

```bash
kubectl run init-config-app --image=nginx --dry-run=client -o yaml > pod.yaml
```

### 2. Manual Surgery (Adding the Prep Cook & Counter)
Open `pod.yaml` with your editor (`vim pod.yaml`) and add the `volumes` and `initContainers` definitions.

> [!TIP]
> **Key structural points:**
> 1. `initContainers` is a top-level block inside the `spec` namespace (just like `containers`).
> 2. Both `initContainers` and `containers` must mount the exact same volume (`config-data`) to `/config`.
> 3. The `init` container writes to `/config/settings.conf` and immediately exits.

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: init-config-app
  name: init-config-app
spec:
  # 3. The Kitchen Counter (Shared Volume)
  volumes:
  - name: config-data
    emptyDir: {}

  # 1. The Prep Cook (Init Container)
  initContainers:
  - name: init-config
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
    - |
      echo "settings=enabled" > /config/settings.conf
      echo "config" >> /config/settings.conf
    volumeMounts:
    - name: config-data
      mountPath: /config

  # 2. The Chef (Main Container)
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: config-data
      mountPath: /config
```

### 3. Apply the Configuration
```bash
kubectl apply -f pod.yaml
```

---

## 🔎 Verification

1. **Check Pod Lifecycle:**
   Watch the Pod initialize. You will see it transition from `Init:0/1` ➔ `PodInitializing` ➔ `Running`.
   ```bash
   kubectl get pods -w
   ```

2. **Verify Shared Configuration:**
   Execute a command inside the main container (`app`) to check if the file written by the Prep Cook exists and contains the correct configuration data.
   ```bash
   kubectl exec init-config-app -c app -- cat /config/settings.conf
   ```
   **Expected Output:**
   ```text
   settings=enabled
   config
   ```
---

## 🧠 Key Takeaways

- **Sequential Execution:** InitContainers always execute sequentially, one after another. If there are multiple, they do not run in parallel.
- **Strict Dependencies:** The main containers will **never** start if any of the `initContainers` fail. If an init container crashes, Kubernetes will restart the entire Pod (depending on `restartPolicy`) and try again.
- **Resource Limits:** Because init containers run before the main container, the Pod's overall resource requests/limits are calculated dynamically based on whichever is higher: the sum of the main containers or the highest request of any individual init container!

---

## 🔗 References
- **Docs** → [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)
- **Study Guide** → [Chapter 2: Multi-Container Patterns](../../../../sources/study-guide/ch02-multi-container.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
