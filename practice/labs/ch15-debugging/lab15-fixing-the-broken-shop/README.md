# 🧪 LAB 15: The Broken Shop (Debugging & Logs)

## Maintenance – Troubleshooting the Microservice Mall

---

## 🎯 Lab Goal

Investigate and repair a "broken" shop that refuses to serve customers. You will master the standard Kubernetes troubleshooting trinity: **Describe**, **Logs**, and **Exec** to find and fix infrastructure, application, and connectivity issues.

> **CKAD Importance:** Critical. This is the heart of the exam. You will spend a significant portion of your time debugging pods that won't start or won't respond.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a shop has reported a major operational failure.

- **The Management Ledger (Describe)** → The inspector's notes on the shop's shell. It tells you if the lights are on, if the rent is paid (resources), and if the delivery truck (image) actually arrived.
- **The CCTV Tapes (Logs)** → Recording of what happened *inside* the shop. If the clerk is shouting errors or the cash register crashed, you'll see it here.
- **Walking inside (Exec)** → Going into the shop yourself to manually test the phone lines or check the inventory.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **kubectl describe** | Checking the building's infrastructure. |
| **kubectl logs** | Watching internal application behavior. |
| **kubectl exec** | Stepping inside for manual diagnostics. |

---

## 📋 Requirements

1. **Deploy**: The "broken-shop" blueprint (provided).
2. **Issue 1**: Find and fix the image typo.
3. **Issue 2**: Find and fix the resource constraint (OOM).
4. **Issue 3**: Find and fix the application crash (exit 1).
5. **Verify**: Ensure the shop is `Running` and `READY 1/1`.

---

## 🛠️ Step-by-Step Solution

### 1. Deploy the Disaster
```bash
k apply -f broken-shop.yaml
```

### 2. Check the Ledger (Describe)
```bash
k get pods
# Status: ErrImagePull
k describe pod broken-shop | grep Events -A 5
# FIX: Change image to 'nginx'
```

### 3. Watch the CCTV (Logs)
```bash
# After fixing the image, the pod crashes again (CrashLoopBackOff)
k logs broken-shop
# FIX: App is exiting; fix the command and increase memory limits.
```

---

## 🔎 Verification

1. **The Pulse Check:**
   ```bash
   k get pod broken-shop
   # Expect: Running, Restarts: 0
   ```

2. **The Final Report:**
   ```bash
   k describe pod broken-shop
   # Ensure no new 'BackOff' events are occurring.
   ```

---

## 🧠 Key Takeaways

- **Order of Operations:** Always `get` → `describe` → `logs`.
- **Describe for YAML Errors:** If the pod is `Pending` or `ErrImagePull`, logs won't exist. Use describe.
- **Logs for App Errors:** If the pod is `Running` but not `Ready`, or in `CrashLoopBackOff`, use logs.
- **CKAD Tip:** If you see `Exit Code 137`, it's almost always OOM (Out of Memory). If you see `Exit Code 0`, the pod just finished its job and shouldn't have been a long-running service.

---

## 🔗 References
- **Docs** → [Troubleshoot Applications](https://kubernetes.io/docs/tasks/debug/debug-application/)
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
