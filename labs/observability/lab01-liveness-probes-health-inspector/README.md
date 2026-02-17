# Lab 01 —  👁️ Observability. The Health Inspector (Liveness Probes)


---
## 🎯 Lab Goal

Ensure that a running application is actually alive.

If the application hangs or its internal health check fails, Kubernetes must **automatically restart** it by killing the old Pod and creating a new one.

This lab focuses on **Liveness Probes** and how Kubernetes decides when a Pod must die.

---

## 🧠 Conceptual Comic (Read First)

Before starting the lab, read the conceptual comic:

👉 [The Health Inspector](../../../comics/observability/01-the-health-inspector/README.md)

---

## 📘 Reference Docs

- Troubleshooting: Probes & Health Checks → [`docs/md-resources/troubleshooting-kubernetes.md`](../../../docs/md-resources/troubleshooting-kubernetes.md)

---



## 🛍️ Mall Analogy

| **Kubernetes Concept** | **Mall Analogy** |
|-------------------|-------------|
| Liveness Probe | Security Guard checking the worker |
| initialDelaySeconds | Time to put on the uniform before inspection |
| periodSeconds | Guard walks by every X seconds |
| HTTP GET `/healthz` | “Are you okay?” check |

If the worker doesn’t respond, the Guard **immediately replaces them**.

---

## 🛠️ Steps

### Step 1 — Create the Blueprint

Define a Pod with a **Liveness Probe** using an HTTP check.

> ⚠️ CKAD-style note
> nginx does not expose /healthz by default.
> This is intentional: a failing probe lets you **observe restart behavior**, which is exactly what this lab is about.

📄 `healthz_probe.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: probed
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
    livenessProbe:
      httpGet:
        path: /healthz
        port: 80
      initialDelaySeconds: 30  # Time to start up
      periodSeconds: 10        # Check every 10 seconds
```

### Step 2 — Apply and Observe

Apply the manifest:

```bash
kubectl apply -f healthz_probe.yaml
```


Watch the Pod status and restart count:
```shell
kubectl get pods probed -w
```

🔍 **What You Are Observing**

Typical lifecycle:

- `0/1 Running`
  Pod exists, but the probe hasn’t run or passed yet

- `1/1 Running`
  Probe passed → worker is “open for business”

- `RESTARTS` **increasing**
  Probe is failing → Kubernetes kills and recreates the Pod

In this lab, `/healthz` returns 404, so the Liveness Probe fails and the Pod is **restarted repeatedly**.

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

Kubernetes is ruthless by design:

- Failing health → **replace immediately**
- No debugging, no mercy

Mastering Liveness Probes means mastering **self-healing workloads**, a core CKAD skill.