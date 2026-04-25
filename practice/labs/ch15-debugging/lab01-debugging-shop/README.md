# 🧪 LAB 01: The Broken Shop (Debugging & Logs)

## Observability and Maintenance – Incident Investigation

---

## 🎯 Lab Goal

Investigate why a shop has crashed. You will use `kubectl logs` and `describe` to find the root cause of an **ErrImagePull** and a **CrashLoopBackOff**.

---

## 🛠️ Step 0: Setting the Scene

Before you can investigate, we need to "break" the shops. Run the following command to deploy the broken pods:

```bash
kubectl apply -f pod-broken.yaml
```

Wait a few seconds, then check the status:
```bash
kubectl get pods
```
*You should see one [pod](../../../../GLOSSARY.md#pod) stuck in `ImagePullBackOff` and another in `CrashLoopBackOff`.*

---

## 🛠️ Step-by-Step Investigation

### 1. The Warehouse Error (ImagePullBackOff)
One of the clerks is waiting for a uniform that doesn't exist in the warehouse.

```bash
# Check the security logbook for the image error
kubectl describe pod shop-invalid-image
```
*Look at the **Events** section at the bottom. What is the name of the image it's trying to pull?*

### 2. The Fainting Clerk (CrashLoopBackOff)
The other clerk starts working but immediately collapses.

```bash
# Check the CCTV tapes to see what happened inside
kubectl logs shop-crashing-app
```
*What was the last thing the clerk said before the shop closed?*

---

## 🧽 Clean Up

```bash
kubectl delete -f pod-broken.yaml
```

---

## 🔗 References
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
