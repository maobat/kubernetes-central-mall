# 🧪 LAB 08: The Shift Bulletin (Shared Variables Pattern)

## 🎯 Lab Goal
> **Scenario: The Shift Bulletin**
> Create a [Pod](../../../../GLOSSARY.md#pod) named `env-sharing-app` with two containers:
> 1. `producer`: A container running the `busybox` image that reads an environment variable `MODE=production` and writes its value to a shared file `/data/env.txt`.
> 2. `consumer`: A container running the `busybox` image that continually (every 5 seconds) reads the contents of the shared file `/data/env.txt` and prints it to standard output.
> 
> Both containers must share the file via a shared `emptyDir` volume named `shared-data` mounted at `/data`.

Learn how to implement a **multi-container [Pod](../../../../GLOSSARY.md#pod)** pattern that shares state and configuration via a shared [emptyDir](../../../../GLOSSARY.md#emptydir) volume and environment variables.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a store coordinator (`env-sharing-app`) needs to share dynamic configuration changes inside a shop:

* **The Shift Bulletin (env-sharing-app):** A multi-container [Pod](../../../../GLOSSARY.md#pod) where information flows seamlessly between different departments of the same shop.
* **The Manager Container (producer):** The manager in charge who holds the secret code for today's store mode (`MODE=production`). The manager writes this down on a note in the **Day-Use Locker (Shared Volume)**, then takes a break (`sleep`).
* **The Information Screen Container (consumer):** A digital bulletin screen inside the shop. It continuously checks the **Day-Use Locker (Shared Volume)** every 5 seconds. When it finds the note containing the shift mode, it displays (prints) the message for everyone to see.
* **The Day-Use Locker (shared-data):** A shared [emptyDir](../../../../GLOSSARY.md#emptydir) volume where the note can be safely deposited and retrieved by any worker in the same store.

---

## 🛠️ Step-by-Step Solution

### 1. Scaffold the Pod YAML (Imperative Best Practice)
To maximize speed on the CKAD exam, generate a single container scaffold first.

```bash
kubectl run env-sharing-app --image=busybox --dry-run=client -o yaml > pod.yaml
```

### 2. Manual Surgery (Adding Second Container, Environment Variables, and Volume)
Open the generated `pod.yaml` and modify it to define both the `producer` and `consumer` containers, set the environment variable, and configure the shared volume.

> [!TIP]
> **Key structural points:**
> 1. Both containers must specify a `volumeMounts` entry referencing the exact same volume (`shared-data`) with the same mount path (`/data`).
> 2. The `producer` container needs the `MODE` environment variable defined.
> 3. The `consumer` container runs a simple loop to output the contents of `/data/env.txt`.

Modify `pod.yaml` to look like this:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: env-sharing-app
spec:
  # 3. The Day-Use Locker (Shared Volume)
  volumes:
  - name: shared-data
    emptyDir: {}

  containers:
  # 1. The Manager (Producer Container)
  - name: producer
    image: busybox
    env:
    - name: MODE
      value: production
    command:
    - sh
    - -c
    - |
      echo $MODE > /data/env.txt;
      sleep 3600;
    volumeMounts:
    - name: shared-data
      mountPath: /data

  # 2. The Information Screen (Consumer Container)
  - name: consumer
    image: busybox
    command:
    - sh
    - -c
    - |
      while true; do
        if [ -f /data/env.txt ]; then
          cat /data/env.txt;
        fi
        sleep 5;
      done
    volumeMounts:
    - name: shared-data
      mountPath: /data
```

### 3. Deploy the Pod
Apply the resource configuration to your Kubernetes cluster:

```bash
kubectl apply -f pod.yaml
```

---

## 🔎 Verification

1. **Check Pod Status:**
   Ensure both containers in the Pod start up successfully. You should see `READY: 2/2`.
   ```bash
   kubectl get pods
   ```
   **Expected Output:**
   ```text
   NAME              READY   STATUS    RESTARTS   AGE
   env-sharing-app   2/2     Running   0          10s
   ```

2. **Check the Logs of the Consumer Container:**
   Verify that the `consumer` container successfully reads the `/data/env.txt` file and prints the output:
   ```bash
   kubectl logs env-sharing-app -c consumer
   ```
   **Expected Output:**
   ```text
   production
   production
   ...
   ```

3. **Verify the Shared File Exist on both Containers:**
   Check the `/data/env.txt` file inside the `producer` container:
   ```bash
   kubectl exec env-sharing-app -c producer -- cat /data/env.txt
   ```
   Check the `/data/env.txt` file inside the `consumer` container:
   ```bash
   kubectl exec env-sharing-app -c consumer -- cat /data/env.txt
   ```

---

## 🧠 Key Takeaways

- **Environment-to-File Sharing:** Often in microservices architectures, legacy components can only read configuration from files. This pattern shows how a modern sidecar or helper container can translate standard Kubernetes env variables into a shared configuration file dynamically.
- **`emptyDir` Lifecycle:** The shared storage lives and dies with the Pod. If the Pod is deleted, the shared file is completely wiped.
- **Portability & Decoupling:** The `consumer` has absolutely no direct knowledge of the environment variables inside `producer`. They are cleanly decoupled via the file system interface.

---

## 🔗 References
- **Docs** → [Share a Volume Between Containers in a Pod](https://kubernetes.io/docs/tasks/configure-pod-container/share-volume-container/)
- **Study Guide** → [Chapter 2: Multi-Container Patterns](../../../../sources/study-guide/ch02-multi-container.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
