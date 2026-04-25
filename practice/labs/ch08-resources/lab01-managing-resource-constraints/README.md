# 🧪 LAB 01: The Resource Hogs (Resource Constraints)

## Resource Budgets – Managing CPU and Memory

---

## 🎯 Lab Goal

In this lab, we simulate a worker who asks for too little "space" and gets "evicted" (**[OOMKilled](../../../../GLOSSARY.md#oomkilled)**). You will learn how to diagnose resource failures and adjust the budget to keep the shop running.

> **CKAD Importance:** Very High. You must know how to set `requests` and `limits` and understand the difference between them.

---

## 🛍️ Mall Analogy

In the **Central Mall**, space is expensive. Every shop needs to tell the manager exactly how much room they need.

- **The Minimum Desk Space (Requests)** → The absolute minimum space a worker needs to sit down. If the mall is full, the manager won't even let the worker in unless there's at least this much space.
- **The Maximum Office Size (Limits)** → The hard ceiling. If a worker tries to expand their desk beyond this line, the security guard (Linux OOM Killer) will literally kick them out of the building.
- **The Eviction ([OOMKilled](../../../../GLOSSARY.md#oomkilled))** → When a shop tries to store too much inventory in a tiny locker, the locker bursts, and the shop is closed for safety.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Requests** | [Guaranteed](../../../../GLOSSARY.md#guaranteed) space for the worker. |
| **Limits** | The point where the worker gets kicked out for oversharing. |
| **[OOMKilled](../../../../GLOSSARY.md#oomkilled)** | Being fired for trying to use more RAM than allowed. |

---

## 📋 Requirements

1. **Deploy a [Pod](../../../../GLOSSARY.md#pod)** named `frontend`:
   - Two containers: `db` (mysql) and `wp` (wordpress).
   - Resources: Set low memory limits (e.g., 64Mi) to trigger a crash.
2. **Diagnose**: Identify the `OOMKilled` status and the `137` exit code.
3. **Fix**: Increase the memory limits to allow the [Pod](../../../../GLOSSARY.md#pod) to stabilize.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Resource Hog
Apply the manifest with insufficient memory:
```bash
k apply -f frontend-resources.yaml
```

### 2. Observe the Crisis
```bash
k get pods
# Status: CrashLoopBackOff or OOMKilled
```

### 3. Diagnostic - Inspecting the Management Ledger
```bash
k describe pod frontend
# Look for 'Last State: Terminated', 'Reason: OOMKilled', and 'Exit Code: 137'.
```

### 4. Fixing the Budget
Update the YAML to provide more "desk space."
```yaml
resources:
  requests:
    memory: "64Mi"
  limits:
    memory: "256Mi" # Increased to prevent the crash
```

---

## 🔎 Verification

1. **Final Check:**
   ```bash
   k apply -f frontend-resources.yaml
   k get pods
   # Output: frontend 2/2 Running
   ```

2. **Real-time Monitoring:**
   ```bash
   k top pod frontend
   # See how much memory the containers are actually using.
   ```

---

## 🧠 Key Takeaways

- **Exit Code 137:** This is the universal sign for "Out Of Memory."
- **Requests vs Limits:** Requests are for scheduling (finding a home); Limits are for enforcement (safety).
- **Quality of [Service](../../../../GLOSSARY.md#service) (QoS):** Pods with equal requests and limits are "[Guaranteed](../../../../GLOSSARY.md#guaranteed)"—the highest priority in the mall.
- **CKAD Tip:** If a [Pod](../../../../GLOSSARY.md#pod) stays in `Pending`, use `k describe node` to see if you've requested more resources than the building actually has.

---

## 🔗 References
- **Comic** → [The Resource Hog](../../../../visual-learning/comics/ch08-resources/01-the-resource-hog/README.md)
- **Docs** → [Resource Management](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
- **Study Guide** → [Chapter 8: Resource Budgets](../../../../sources/study-guide/ch08-resources.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
