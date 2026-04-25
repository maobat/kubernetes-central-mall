# 🧪 Lab 05: The Simplest Shop, Running a Standalone [Pod](../../../../GLOSSARY.md#pod)

## [Pod](../../../../GLOSSARY.md#pod) Design – Creating and Inspecting a Bare [Pod](../../../../GLOSSARY.md#pod)

---

## 🎯 Lab Goal

Create a **standalone [Pod](../../../../GLOSSARY.md#pod)** (not managed by a [Deployment](../../../../GLOSSARY.md#deployment)) and verify it is running using `kubectl describe`. This is one of the most frequent CKAD warm-up tasks.

> **CKAD Importance:** Medium-High. The `kubectl run --restart=Never` pattern appears often in the exam as a quick way to spin up a diagnostic or test [Pod](../../../../GLOSSARY.md#pod).

---

## 🛍️ Mall Analogy

Most shops in the mall are managed by the Owner through a Franchise System ([Deployment](../../../../GLOSSARY.md#deployment) → ReplicaSet → [Pod](../../../../GLOSSARY.md#pod)). But sometimes you just need a **temporary pop-up stall**, no franchise, no manager, just a table and a worker. That's a standalone **[Pod](../../../../GLOSSARY.md#pod)**.

| Concept | Mall Analogy |
| :--- | :--- |
| **[Pod](../../../../GLOSSARY.md#pod)** | A single pop-up stall |
| `--restart=Never` | No franchise system, if this worker leaves, they don't get replaced |
| `kubectl describe pod` | Reading the inspector's report card for this stall |

---

## 🛠️ Step-by-Step

### 1. Create the [Pod](../../../../GLOSSARY.md#pod)

```bash
kubectl run nginx --image=nginx:1.25 --restart=Never
```

> `--restart=Never` is what makes this a **bare [Pod](../../../../GLOSSARY.md#pod)** instead of a [Deployment](../../../../GLOSSARY.md#deployment). Without it, `kubectl run` creates a [Deployment](../../../../GLOSSARY.md#deployment).

### 2. Verify it is Running

```bash
kubectl get pod nginx
```

Expected:
```
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          10s
```

### 3. Inspect the Details

```bash
kubectl describe pod nginx
```

Key fields to note in the output:

| Field | What it tells you |
| :--- | :--- |
| **Status** | `Running` = healthy |
| **Image** | Confirms the image that was pulled |
| **[Node](../../../../GLOSSARY.md#node)** | Which cluster [node](../../../../GLOSSARY.md#node) is hosting this [pod](../../../../GLOSSARY.md#pod) |
| **Events** | Shows any scheduling or pull errors |

---

## 🔎 Bonus, Quick Shell Access

Since this is a standalone [pod](../../../../GLOSSARY.md#pod), `exec` into it to confirm it's serving:

```bash
kubectl exec -it nginx -- /bin/sh
# Inside the pod:
curl localhost
exit
```

---

## 🧹 Cleanup

```bash
kubectl delete pod nginx
```

---

## 🧠 Key Takeaways

- `kubectl run <name> --image=<image> --restart=Never` = bare [Pod](../../../../GLOSSARY.md#pod), not managed.
- `kubectl describe pod <name>` is your first debugging tool, always check the **Events** section at the bottom.
- Bare Pods are **not restarted** if they crash or are deleted. Use a [Deployment](../../../../GLOSSARY.md#deployment) for production workloads.

---

## 🔗 References

- **Study Guide** → [Chapter 3: Pod Design](../../../../sources/study-guide/ch03-pod-design.md)
- **Lab 03** → [Image Updates](../lab03-image-updates/README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
