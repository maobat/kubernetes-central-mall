# Lab 01 —  👁️ Observability. The Health Inspector (Liveness Probes)


---
## 🎯 Lab Goal

Understand **how Kubernetes detects unhealthy containers** using **Liveness Probes** and what happens **when a probe fails**.

You will observe how Kubernetes:

- Checks if a container is still alive
- Marks a Pod as failed when health checks fail
- **Does NOT restart** the Pod when `restartPolicy: Never` is used
---

## 📖 Related Comic
👉 [comics/observability/01-the-health-inspector/README.md](../../../comics/observability/01-the-health-inspector/README.md)

---

## 📘 Reference Docs

- Troubleshooting: Probes & Health Checks → [`docs/md-resources/troubleshooting-kubernetes.md`](../../../docs/md-resources/troubleshooting-kubernetes.md)

---



## 🛍️ Mall Analogy

| **Kubernetes Concept** | **Mall Analogy** |
|-------------------|-------------|
| Liveness Probe | Security Guard checking the worker |
| `initialDelaySeconds` | Time to put on the uniform before inspection |
| `periodSeconds` | Guard walks by every X seconds |
| httpGet `/healthz` | “Are you okay?” check |
| `restartPolicy: Never` | The worker is fired and **never rehired** |

A **Security Guard** periodically checks a shop worker.
If the worker doesn’t respond, the shift is terminated.

---

## 🛠️ Steps

### Step 1 — Create the Blueprint

Define a Pod with a **Liveness Probe** using an HTTP check.

> ⚠️ CKAD-style note
> nginx does not expose /healthz by default.
> This is intentional: a failing probe lets you **no observe restart behavior** beacuse of `--restart=Never` parameter, which is exactly what this lab is about.

### 1️⃣ Generate a skeleton imperatively
```bash
kubectl run probed \
  --image=nginx \
  --restart=Never \
  --port=80 \
  --dry-run=client -o yaml > healthz_probe.yaml
```
---
### 2️⃣ Edit and add the livenessProbe

Open the file and add **only** the probe:

```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 80
  initialDelaySeconds: 30
  periodSeconds: 10
```

Then apply:

```bash
kubectl apply -f healthz_probe.yaml
```


Watch the Pod status and no restart count:
```shell
k get pod probed -w

NAME     READY   STATUS              RESTARTS   AGE
probed   0/1     ContainerCreating   0          2s
probed   1/1     Running             0          3s
probed   1/1     Running             0          61s
probed   0/1     Completed           0          61s
probed   0/1     Completed           0          63s
```

Here is the step-by-step breakdown of what happened:

## 1. The Startup (0s - 3s)
The Pod goes from `ContainerCreating` to `Running`. At this point, Nginx is up, but the **Liveness Probe** hasn't started yet because of your `initialDelaySeconds: 30`.

## 2. The Grace Period (3s - 61s)
For about 58 seconds, the Pod stays `1/1 Running`.

- **The First 30s:** Kubernetes is waiting (initial delay).
- **The Next 30s:** The probe starts running every 10 seconds. It checks `http://<pod-ip>:80/healthz`.
- **The Failure:** Since standard Nginx does not have a `/healthz` path by default, it returns a `404 Not Found`.

## 3. The "Death" (61s)
By default, the `failureThreshold` is 3.

- Probe 1 (at 30s): Fails.
- Probe 2 (at 40s): Fails.
- Probe 3 (at 50s): Fails.
- Once the threshold is hit, Kubernetes decides the container is "dead" and kills the process.

## 4. Why it says Completed instead of Error
This is the most interesting part of your output. Because Nginx received the "kill" signal from Kubernetes and shut down gracefully, and because you set:
`restartPolicy: Never`

Kubernetes says: <i>"The container finished. I'm not allowed to restart it, so I'll just mark the Pod as 'Completed' and leave it there."</i> If your policy was `Always`, you would see the `RESTARTS` count jump to 1 and the status go back to `Running`.

---

### Summary Table

| Time | Status | Ready | What's happening? |
|------|--------|-------|-------------------|
| 2s | ContainerCreating | 0/1 | Pulling image/Starting. |
| 3s | Running | 1/1 | Nginx is alive; Probe is waiting 30s. |
| 61s | Running | 1/1 | 3 failed probes later, Kube kills the container. |
| 61s+ | Completed | 0/1 | Process exited. restartPolicy: Never prevents a reboot. |

---

🔍 **What You Are Observing**

Typical lifecycle:

- `0/1 Running`
  Pod exists, but the probe hasn’t run or passed yet

- `1/1 Running`
  Probe passed → worker is “open for business”

- `RESTARTS` **no increasing**
  Probe is failing → Because of `restartPolicy: Never` Kubernetes kills and **does not recreate** the Pod

In this lab, `/healthz` returns 404, so the Liveness Probe fails and the Pod is **not restarted**.

If you want this Pod to stay running, you should change the path to one that actually exists in Nginx (like the default index):
```yaml
      httpGet:
        path: /  # Use / instead of /healthz
        port: 80
```

---

### ⚠️ CKAD Notes

**Liveness ≠ Readiness**

- **Liveness** → kills and restarts the Pod
- **Readiness** → removes the Pod from traffic

Confusing the two is a **classic exam trap**.

### Initial Delay Matters

- Too short → `CrashLoopBackOff`

- Always give the app time to start before probing

---

### Endpoints Must Exist

- Wrong path or port = **infinite restarts**

- Always verify:
  - Path
  - Port
  - Startup time

---

🧠 Key Takeaways

Liveness Probes answer **one brutal question**:

> “Should this Pod be restarted?”

Kubernetes is strict by design:

- Failing health → **replace immediately**
- No debugging, no mercy

Mastering Liveness Probes means mastering **self-healing workloads**, a core CKAD skill.