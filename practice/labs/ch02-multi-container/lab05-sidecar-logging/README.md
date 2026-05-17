# 🧪 LAB 05: The Auditor's Desk (Sidecar Logging)

## 🎯 Lab Goal
> **Scenario: The Receipt Auditor**
> Create a shop where the salesperson writes receipts (logs) to a local file, and an auditor (sidecar) constantly reads them to ensure everything is recorded correctly.

Learn how to implement the classic **Sidecar Logging Pattern**, a common CKAD exam objective. You will use a shared `emptyDir` volume to stream logs from an application container to a logging container.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a high-end boutique (`order-app`) needs strict accounting:

* **The Salesperson (App Container):** Generates sales and writes receipts every 5 seconds into a ledger located in the shop's back room (`/var/log/app.log`).
* **The Auditor (Sidecar Container):** Sits in the exact same back room, constantly reading the ledger (`tail -f`) and reporting the findings.
* **The Back Room (Shared Volume):** An `emptyDir` storage space shared between the two workers so they can look at the same ledger at the same time.

---

## 🛠️ Step-by-Step Solution

### 1. Generate the Scaffold (Imperative Best Practice)
In the exam, it is much faster to generate a base YAML file and edit it, rather than typing everything from scratch.

```bash
kubectl run order-app --image=nginx:1.14 --port=80 --dry-run=client -o yaml > pod.yaml
```

### 2. Manual Surgery (Adding the Auditor & Back Room)
Open `pod.yaml` with your editor (`vim pod.yaml`) and modify it to match the following.

> [!TIP]
> **What to add:**
> 1. The `volumes` block at the bottom.
> 2. The `volumeMounts` and custom `command/args` for the existing `nginx` container.
> 3. The entirely new `logger` container block.

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: order-app
  name: order-app
spec:
  # 3. The "Back Room" (Shared Volume)
  volumes:
  - name: shared-logs
    emptyDir: {}

  containers:
  # 1. The Salesperson (Main App)
  - name: app
    image: nginx:1.14
    ports:
    - containerPort: 80
    command: ["/bin/sh", "-c"]
    args:
    - |
      touch /var/log/app.log;
      while true; do
        echo "$(date) order-app running" >> /var/log/app.log;
        sleep 5;
      done
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log

  # 2. The Auditor (Sidecar Logger) --> tail -F keeps retrying to read the file
  - name: logger
    image: busybox
    command: ["/bin/sh", "-c"]
    args:
    - tail -F /var/log/app.log
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log
```

### 3. Apply the Configuration
```bash
kubectl apply -f pod.yaml
```

---

## 🔎 Verification

1. **Check Pod Status:** Ensure both containers start successfully.
   ```bash
   kubectl get pods
   # Wait for READY 2/2
   ```

2. **Verify the Auditor:** Check the logs of the `logger` sidecar container. You should see the receipts being streamed every 5 seconds.
   ```bash
   kubectl logs order-app -c logger
   # Output:
   # Mon May 17 15:30:00 UTC 2026 order-app running
   # Mon May 17 15:30:05 UTC 2026 order-app running
   ```

---

## 🧠 Key Takeaways

> [!IMPORTANT]
> **The Sidecar Logging Pattern**
> Some legacy applications write logs to a file on disk instead of `stdout`. Kubernetes' native `kubectl logs` command only captures `stdout`. By adding a sidecar that simply `tail -f`'s the file, you expose those legacy logs to Kubernetes' standard logging mechanisms!

---

## 🔗 References
- **Docs** → [Logging Architecture - Sidecar container with a logging agent](https://kubernetes.io/docs/concepts/cluster-administration/logging/#sidecar-container-with-a-logging-agent)
- **Study Guide** → [Chapter 2: Multi-Container Patterns](../../../../sources/study-guide/ch02-multi-container.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
