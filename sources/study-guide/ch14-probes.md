# 📖 Chapter 14: Probes & Health Checks
*The Health Inspector (Liveness & Readiness)*

In the **Central Mall**, the Mall Manager acts as a strict Health Inspector. Instead of waiting for a shop to go bankrupt, the inspector periodically pokes their head through the door to ask: "Are you okay?" (Liveness) and "Are you ready for customers?" (Readiness).

---

## 🎭 14.1 The Two Types of Check-ups

| Check-up | Mall Analogy | K8s Action if it Fails |
| :--- | :--- | :--- |
| **Liveness Probe** | **"Are you alive?"** If the clerk has fainted, they can't recover. | **Restart:** The manager fires the clerk and hires a new one (Restarts the container). |
| **Readiness Probe** | **"Are you ready?"** The shop is open, but the shelves are still empty. | **Isolation:** The manager takes the shop's sign down. No customers are sent here until it passes. |



---

## 🛠️ 14.2 The Inspection Methods

The Health Inspector has three ways to check on a shop:
1. **The Shout (HTTP):** Sends a request to a specific URL (e.g., `/healthz`).
2. **The Knock (TCP):** Checks if the door is physically open (Port check).
3. **The Task (Exec):** Tells the clerk to run a specific command (e.g., `cat /tmp/healthy`).

---

## 🛠️ The Blueprint: Setting Up Inspections

You define these checks inside the `containers` section of your blueprint.

### 1. The Liveness Check (The "Faint" Test)
```yaml
livenessProbe:
  httpGet:
    path: /healthz
    port: 80
  initialDelaySeconds: 5  # Give the clerk 5 seconds to wake up first
  periodSeconds: 10       # Check every 10 seconds
```

### 2. The Readiness Check (The "Stocked Shelves" Test)
```yaml
readinessProbe:
  exec:
    command:
    - cat
    - /tmp/ready-to-serve
  initialDelaySeconds: 2
  periodSeconds: 5
```



---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. The Crash Loop
If you see a Pod with `CrashLoopBackOff`, the **Liveness Probe** is likely failing because the shop is "dying" faster than the inspector can check it. 

### 2. The "Hidden" Shop
If a Pod is `Running` but `READY 0/1`, the **Readiness Probe** is failing. The clerk is alive, but the manager won't let customers in yet.

```bash
# See WHY the inspector is unhappy
kubectl describe pod <pod-name>
# Look at the "Events" section at the bottom!
```

---

## ⚠️ Common Exam Traps
- **The `initialDelaySeconds` Death Loop:** If your app takes 30 seconds to start, but your Liveness probe has `initialDelaySeconds: 5`, Kubernetes will constantly kill the container before it ever finishes starting.
- **Liveness vs Readiness:** A failing **Liveness** probe restarts the container. A failing **Readiness** probe simply removes the Pod from the Service endpoint (stopping traffic) but leaves it running. Don't use a Liveness probe for a database connection issue, or your app will endlessly restart.

---

## 🧰 Study Toolbox

* 🎙️ **Audio Overview:** Request the audio briefing from the Mall Manager (**@maobat**) via repository issues.
* 🖼️ **Comic 01:** [The Health Inspector - Liveness vs Readiness](../../visual-learning/comics/ch14-probes/01-the-health-inspector/README.md)
* 🖼️ **Comic 02:** [The Health Inspector - Readiness](../../visual-learning/comics/ch14-probes/02-readiness-probes/README.md)
* 📄 **Doc:** [Worker Safety and Probes](../../reference/md-resources/troubleshooting-kubernetes.md#section-2)
* 🧪 **Labs:** [Explore Chapter 14 Labs](../../practice/labs/ch14-probes/README.md)

---
[<< Previous: Network Policies](ch13-networking.md) | [Back to Story Index](../story.md) | [Next: Debugging & Logs >>](ch15-debugging.md)

---
[Mall Directory ✨](../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
