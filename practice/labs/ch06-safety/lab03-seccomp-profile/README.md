# 🧪 LAB 03: The Seccomp Filter (System Call Restrictions)

## 🎯 Lab Goal
Learn how to restrict which **system calls** ([syscalls](https://en.wikipedia.org/wiki/System_call)) a worker is allowed to make to the underlying Node's kernel, using `seccompProfile`. You will apply the container runtime's default filter and verify it is active.

## 🛍️ Mall Analogy
So far, workers have had an ID badge, a locked manual, and a trimmed set of tool permits. But even a fully compliant clerk could still try to shout directly into the **Building's Central Intercom System (the kernel)** and issue commands it was never meant to send. A **Seccomp Profile** is the switchboard operator that only patches through a pre-approved list of intercom commands — anything else is blocked before it ever reaches the building's core systems.

---

## 📋 Requirements

1. **Deploy the Filtered Shop**: Create a Pod named `filtered-worker` using image `busybox:1.36`, running `sleep 3600`.
2. **Apply the Runtime's Default Filter**: Set the Pod-level `seccompProfile.type` to `RuntimeDefault`.
3. **Verify the Filter is Active**: Confirm the profile is present on the live object.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Blueprint

Create a file named `filtered-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: filtered-worker
spec:
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  containers:
  - name: clerk
    image: busybox:1.36
    command: ["sh", "-c", "sleep 3600"]
```

```bash
kubectl apply -f filtered-pod.yaml
```

### 2. Inspect the Worker's Filter

```bash
kubectl get pod filtered-worker -o jsonpath='{.spec.securityContext.seccompProfile}'
```

*Output should show `{"type":"RuntimeDefault"}`.*

---

## 🔎 Verification

1. Confirm the Pod reached `Running`:
   ```bash
   kubectl get pod filtered-worker
   ```
2. Confirm the seccomp type on the live object matches `RuntimeDefault`:
   ```bash
   kubectl get pod filtered-worker -o jsonpath='{.spec.securityContext.seccompProfile.type}'
   ```

## 🧠 Key Takeaways
- **`RuntimeDefault` vs `Localhost`:** `RuntimeDefault` uses the container runtime's built-in allow-list (the safe default for almost every CKAD task). `Localhost` points to a custom JSON profile file staged on the Node itself — far less common on the exam, but worth recognizing by name.
- **Pod-level is the norm:** Unlike `capabilities` (Container-only), `seccompProfile` is most often set at the **Pod level** so it applies uniformly to every container inside it, though it can be overridden per-container too.
- **CKAD Tip:** If a task mentions "restrict system calls" or "syscall filtering," that's a `seccompProfile` keyword match — don't confuse it with `capabilities`, which restrict *Linux privileges*, not raw syscalls.

---
## 🔗 References
- **Study Guide** → [Chapter 6: Security & Safety](../../../../sources/study-guide/ch06-security.md)
- **Docs** → [Restrict a Container's Syscalls with seccomp](https://kubernetes.io/docs/tutorials/security/seccomp/)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
