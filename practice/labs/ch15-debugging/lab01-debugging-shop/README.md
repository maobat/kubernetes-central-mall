# 🧪 LAB 01: The Broken Shop (Debugging & Logs)

## Observability and Maintenance – Incident Investigation

---

## 🎯 Lab Goal

Investigate why a shop has crashed. You will use `kubectl logs` and `describe` to find the root cause of an **ErrImagePull** and a **CrashLoopBackOff**.

---

## 🛠️ Step-by-Step Solution

### 1. Investigate the CCTV (Logs)
```bash
kubectl logs my-broken-pod
kubectl describe pod my-broken-pod
```

---

## 🔗 References
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
