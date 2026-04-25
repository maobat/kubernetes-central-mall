# 🧪 LAB 01: The Health Inspector (Liveness Probes)

## Observability – Automated Self-Healing

---

## 🎯 Lab Goal

Understand how Kubernetes detects and fixes unhealthy containers using **Liveness Probes**. You will observe what happens when a worker "faints" (fails a probe) and how the Mall Manager (Kubernetes) handles the situation based on the `restartPolicy`.

> **CKAD Importance:** Very High. You must know how to configure `livenessProbe` and `readinessProbe` and understand their different effects.

---

## 🛍️ Mall Analogy

In the **Central Mall**, we have a dedicated **Health Inspector** who walks the floors.

- **The Worker (Container)** → A shop assistant at their station.
- **The Health Check (Liveness Probe)** → The Inspector stops by every few minutes and asks, "Are you still conscious?" (HTTP GET).
- **The Startup Time (initialDelaySeconds)** → The worker is allowed 30 seconds to get their coffee and set up before the Inspector starts checking.
- **The Faint (Failure)** → If the worker doesn't respond for 3 checks in a row, the Inspector declares an emergency.
- **The Firing (Never Restart)** → If `restartPolicy` is set to `Never`, the worker is sent home and the station remains empty for safety investigation.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Liveness Probe** | "Are you still alive?" check. |
| **Readiness Probe** | "Are you ready for customers?" check. |
| **initialDelaySeconds** | Grace period to let the app start up. |

---

## 📋 Requirements

1. **Pod**: Create `probed` (nginx).
2. **Liveness Probe**: Add an HTTP check to `/healthz` on port 80.
3. **Restart Policy**: Set to `Never` to observe the terminal failure.
4. **Observe**: Watch the Pod transition from `Running` to `Completed` as the probe fails.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Blueprint
Generate a skeleton:
```bash
k run probed --image=nginx --restart=Never --dry-run=client -o yaml > probe.yaml
```

### 2. Add the Health Inspector
Edit `probe.yaml` to include the probe:
```yaml
livenessProbe:
  httpGet:
    path: /healthz # This will fail in standard Nginx
    port: 80
  initialDelaySeconds: 30
  periodSeconds: 10
```

### 3. Apply and Watch
```bash
k apply -f probe.yaml
k get pod probed -w
```

---

## 🔎 Verification

1. **Observe the Failure:**
   - At 30s: Probes start.
   - At 60s: After 3 failures (Nginx returns 404 for `/healthz`), the container is killed.
   - Status: Moves to `Completed` because `restartPolicy: Never` prevents a reboot.

2. **Check the Management Report:**
   ```bash
   k describe pod probed
   # Look for 'Unhealthy' events in the log.
   ```

---

## 🧠 Key Takeaways

- **Liveness kills Pods:** If a liveness probe fails, Kubernetes terminates the container to try and fix it (if allowed by policy).
- **Readiness hides Pods:** If a readiness probe fails, Kubernetes just stops sending traffic to the pod (Service stops routing to it).
- **Grace Periods are Critical:** If your `initialDelaySeconds` is too short, Kubernetes might kill your app before it even finishes starting up!
- **CKAD Tip:** Confusing Liveness and Readiness is a classic exam trap. Remember: **Liveness restarts, Readiness removes.**

---

## 🔗 References
- **Comic** → [The Health Inspector](../../../../visual-learning/comics/ch14-probes/01-the-health-inspector/README.md)
- **Docs** → [Configure Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- **Study Guide** → [Chapter 14: Observability](../../../../sources/study-guide/ch14-probes.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
