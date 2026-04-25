# 🧪 LAB 02: CCTV and Log Tailing (Logging & Sidecars)

## Observability and Maintenance – Investigating the Shop

In this lab, we will explore two different ways the Central Mall collects "CCTV footage" (Logs) from its shops. First, we look at the standard method where a worker speaks clearly, and the mall records it. Then, we look at a situation where a worker only writes in a journal, requiring us to hire an **Assistant (Sidecar)** to read that journal aloud for the cameras.

---

## 🎯 Lab Goals
- Understand default `STDOUT` logging behavior in Kubernetes.
- Deploy a logging **[sidecar container](../../../../GLOSSARY.md#sidecar-container)** to capture application logs that don't output directly to `STDOUT`.
- Tie logs back to the Central Mall "CCTV" analogy.

---

## 🛠️ Step 1: Standard CCTV (STDOUT Logging)

By default, logs from a container get written to **Standard Output (STDOUT)**. The Kubernetes [node](../../../../GLOSSARY.md#node) agent automatically acts like a mall microphone, collecting these logs so you can view them with `kubectl`.

Let's examine a [pod](../../../../GLOSSARY.md#pod) that simulates a busy shop clerk announcing every time a customer arrives.

### 1. View the manifest
Run the following command to review the [Pod](../../../../GLOSSARY.md#pod) definition:
```bash
vim pod-logging.yaml
```
*Note that the `busybox` container is using a `while` loop that echos the date every 1 second directly to STDOUT.*

### 2. Create the [Pod](../../../../GLOSSARY.md#pod)
```bash
kubectl create -f pod-logging.yaml
```

### 3. Check the CCTV Tapes
You can easily tail the standard logs:
```bash
kubectl logs shop-standard-cctv -f
```
*(Press `Ctrl+C` to exit the live log feed)*

---

## 🛠️ Step 2: The Silent Worker (Sidecar Tailing)

Not all applications log conveniently to `STDOUT`. Some legacy software only writes logs to a local file on disk. If we want to capture these in Kubernetes, we can deploy a **[Sidecar container](../../../../GLOSSARY.md#sidecar-container)** whose sole [job](../../../../GLOSSARY.md#job) is to tail that file and scream it out loud for the mall's microphones to pick up!

### 1. View the multi-container manifest
```bash
cat pod-logging-sidecar.yaml
```
**Key Concepts to notice:**
- There are **two containers** in the single [Pod](../../../../GLOSSARY.md#pod).
- The `main-clerk` is echoing data to `/var/log/main-container.log` every 5 seconds (not to STDOUT).
- The `log-tailer-sidecar` is running the command `tail -f /var/log/main-container.log`.
- Both containers share a `varlog` volume (using `emptyDir`) so they can see the exact same file.

### 2. Create the [Pod](../../../../GLOSSARY.md#pod)
```bash
kubectl create -f pod-logging-sidecar.yaml
```

### 3. Verify the [Pod](../../../../GLOSSARY.md#pod) is running
Ensure both the Main Clerk and the Sidecar are ready (`2/2`):
```bash
kubectl get pods
```

### 4. Check the Assistant's Tape
If you ask the [Pod](../../../../GLOSSARY.md#pod) for its logs generally, Kubernetes might get confused because there are two workers. You must specifically ask the Sidecar what it saw:
```bash
kubectl logs shop-with-tail-sidecar -c log-tailer-sidecar
```

---

## 🧽 Clean Up

Once you are done observing the logs, close the shops:
```bash
kubectl delete -f pod-logging.yaml
kubectl delete -f pod-logging-sidecar.yaml
```

---

## 📝 Key Takeaways
1. **STDOUT is King**: Kubernetes naturally captures whatever a container prints to STDOUT or STDERR. This is the preferred "cloud-native" logging method.
2. **Sidecar Loggers**: For applications that stubbornly log to files, a lightweight sidecar running `tail -f` is the industry-standard bridge to get those logs into standard Kubernetes observability tools.
3. **Shared Volumes**: The sidecar pattern relies on shared `emptyDir` volumes to pass the log files between containers securely.

---

## 🔗 References
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
