# 🧪 LAB 01: The Internal Intercom (ClusterIP)

## Services and Networking – Managing Internal Traffic

---

## 🎯 Lab Goal

This lab focuses on **ClusterIP Services**. You will learn how to create a stable entry point for a group of Pods, enabling internal communication within the "mall" (cluster).

> **CKAD Importance:** Fundamental. Every microservice communication scenario starts with understanding ClusterIP.

---

## 🛍️ Mall Analogy

In the **Central Mall**, shops needs to talk to each other (e.g., The Cafe needs to check the Warehouse inventory).

- **The Worker (Pod)** → A staff member at a specific desk. Their desk might move (Pod IP changes), making it hard to find them.
- **The Intercom Extension (Service Name)** → A stable phone number (DNS name) like `extension-101`. No matter which desk the worker is at, if you dial `101`, the intercom finds them.
- **The Switchboard (ClusterIP)** → The internal wiring of the mall. It only works for people *inside* the building. You can't call this extension from your house.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **ClusterIP** | The internal intercom system. |
| **DNS Name** | The extension number everyone dials. |
| **Selector** | The rule that determines which workers belong to that extension. |

---

## 📋 Requirements

1. **Deployment**: Create `staff-support` (nginx, 2 replicas).
2. **Service**: Create a ClusterIP named `support-svc` on port 80.
3. **Internal Test**: Use a BusyBox Pod (`testpod`) to call the service by name.

---

## 🛠️ Step-by-Step Solution

### 1. Deploy the Support Team
```bash
k create deploy staff-support --image=nginx --replicas=2
```

### 2. Install the Intercom (Service)
Fastest way:
```bash
k expose deploy staff-support --name=support-svc --port=80
```

### 3. Dial the Extension
```bash
# Run a test worker
k run testpod --image=busybox -- sleep infinity

# Test the connection via DNS
k exec testpod -- wget -qO- support-svc
```

---

## 🔎 Verification

1. **Check DNS Resolution:**
   ```bash
   k exec testpod -- nslookup support-svc
   # Should return the ClusterIP of the service.
   ```

2. **Check Endpoints:**
   ```bash
   k get ep support-svc
   # You should see two IP addresses (one for each support pod).
   ```

---

## 🧠 Key Takeaways

- **Internal Only:** ClusterIP is the default service type. It is NOT reachable from the internet.
- **Service Discovery:** Kubernetes handles the DNS automatically. You don't need to know the IP, just the name.
- **Load Balancing:** If you have multiple pods, the intercom automatically sends your call to the next available worker.
- **CKAD Tip:** `kubectl expose` is your best friend. It automatically creates the selectors and ports based on your deployment.

---

## 🔗 References
- **Comic** → [Internal Intercom](../../../../visual-learning/comics/ch11-services/01-internal-intercom/README.md)
- **Docs** → [Service DNS](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)
- **Study Guide** → [Chapter 11: Services](../../../../sources/study-guide/ch11-services.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
