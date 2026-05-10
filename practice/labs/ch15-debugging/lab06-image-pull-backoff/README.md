# 🧪 LAB 06: The IPv6 Illusion (ImagePullBackOff)

## 🎯 Lab Goal
> **Scenario: The Lost Delivery Truck**
> Investigate why a backend shop refuses to open, tracing the issue down to the Node's external network resolution.

Diagnose a tricky `ImagePullBackOff` error where the image name is perfectly valid, but the underlying [Node](../../../../GLOSSARY.md#node) cannot reach the external container registry due to an IPv6 resolution timeout.

---

## 🛍️ Mall Analogy

In the **Central Mall**, when a new shop opens, the Mall Manager orders the Mannequins (Container Images) from the Central Warehouse (Docker Hub). 

If the Delivery Truck (`crictl pull`) tries to use an unfinished highway (IPv6) suggested by a faulty GPS, it will get stuck in traffic forever (`i/o timeout`). The solution is to either fix the GPS (disable IPv6) or buy locally available goods (use a cached image tag like `nginx:1.14`).

---

## 🛠️ Step-by-Step Solution

### 1. Identify the Failing Shop
Check the pods in the default namespace:
```bash
kubectl get pods
```
*You will see `staff-back-end` stuck in `ImagePullBackOff`.*

### 2. Read the Security Logbook
Find out *why* it can't pull the image:
```bash
kubectl describe pod staff-back-end
```
*Look at the Events. You will see an `i/o timeout` when trying to lookup `registry-1.docker.io`.*

### 3. Dispatch a Manual Truck (Node Investigation)
Enter the node directly to test the connection:
```bash
docker exec -it ckad-control-plane bash
```

Inside the node, test the exact command the [Kubelet](../../../../GLOSSARY.md#kubelet) was running:
```bash
crictl pull nginx:alpine
```
*It fails. Now check the DNS resolution:*
```bash
getent hosts registry-1.docker.io
```
*If you see multiple IPv6 addresses (`2600:1f18...`), the node is trying to route via IPv6 but failing.*

### 4. Test the Old Highway (IPv4)
Test if standard IPv4 works:
```bash
curl -4 https://registry-1.docker.io/v2/
```
*If it returns `UNAUTHORIZED`, the connection was successful!*

### 5. Apply the Fix
Edit the pod deployment to use a known stable/cached image (e.g., `nginx:1.14`) to bypass the faulty external network fetch:
```bash
kubectl edit pod staff-back-end
# Change image: nginx:alpine to image: nginx:1.14
```

---

## 🧠 Key Takeaways

> [!TIP]
> **Not all Pull Errors are Typos!**
> While most `ErrImagePull` issues are due to misspelled image names, always read the full error string in the Events log. If it mentions `dial tcp` or `i/o timeout`, the cluster is having physical networking issues reaching the outside world.

---

## 🔗 References
- **Comic** → [The IPv6 Illusion](../../../../visual-learning/comics/ch15-debugging/06-image-pull-backoff/README.md)
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
