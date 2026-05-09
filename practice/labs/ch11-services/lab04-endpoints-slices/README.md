# 🧪 LAB 04: The Scaling Ledger (Endpoints vs EndpointSlices)

## Services - Understanding the Backend

---

## 🎯 Lab Goal

This lab explores the **backend mechanics** of how Kubernetes tracks Pods associated with a Service. You will learn:
- The difference between the legacy **[Endpoints](../../../../GLOSSARY.md#service)** and the modern **[EndpointSlice](../../../../GLOSSARY.md#endpointslice)**.
- Why EndpointSlices were introduced for **scalability**.
- How to inspect both objects for troubleshooting.

> **CKAD Importance:** Medium. While you usually work with Services, understanding Endpoints is crucial for debugging connection issues. EndpointSlices are the modern standard you'll see in production clusters.

---

## 🛍️ Mall Analogy

In the **Central Mall**, managing a massive team of shop workers requires an efficient system.

- **The Shop Directory ([Service](../../../../GLOSSARY.md#service))** → The public board showing "The Pizza Shop is at extension 80".
- **The Old Paper Ledger (Endpoints)** → A single, gigantic sheet of paper listing every single worker's personal phone number. If the shop has 1,000 workers, this paper becomes impossible to update or read without causing a bottleneck at the information desk.
- **The Digital Roll-Call ([EndpointSlice](../../../../GLOSSARY.md#endpointslice))** → A modern digital system that breaks the massive worker list into smaller, organized "slices" (e.g., 100 workers per slice). Updating one slice is fast and doesn't affect the rest of the directory.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[Service](../../../../GLOSSARY.md#service)** | The stable storefront sign/extension. |
| **Endpoints** | The legacy, monolithic list of all backend Pod IPs. |
| **[EndpointSlice](../../../../GLOSSARY.md#endpointslice)** | The modern, partitioned, and scalable list of backend Pod IPs. |

---

## 🖼️ Visual Evolution

![EndpointSlice Evolution](./endpointslice.png)
*Figure 1: How EndpointSlices partition large sets of endpoints to reduce API pressure.*

---

## 📋 Requirements

1. **Deploy the "Staff" ([Pod](../../../../GLOSSARY.md#pod)s)**:
   - Create a Deployment named `staff-backend` using `nginx`.
   - Scale it to 3 replicas.
2. **Create the "Directory" ([Service](../../../../GLOSSARY.md#service))**:
   - Expose the deployment on port 80.
3. **Investigation**:
   - Inspect the legacy **Endpoints** object.
   - Inspect the modern **EndpointSlice** object.

---

## 🛠️ Step-by-Step Solution

### 1. Deploy the Backend
Create the workers and ensure they are on duty.
```bash
kubectl create deployment staff-backend --image=nginx --replicas=3
```

### 2. Expose the Service
Create the "storefront sign" that links to these workers.
```bash
kubectl expose deployment staff-backend --port=80 --target-port=80
```

### 3. Inspect the Legacy Ledger (Endpoints)
Check the old-school way of listing IPs.
```bash
kubectl get endpoints staff-backend
```
*Note the `ENDPOINTS` column showing a comma-separated list of all Pod IPs.*

### 4. Inspect the Modern Ledger (EndpointSlice)
Check the scalable, modern representation.
```bash
kubectl get endpointslice
```
*Look for a slice associated with the `staff-backend` service. Notice how it tracks the same information but is designed to be split if the number of Pods grows.*

---

## 🔎 Verification

1. **Compare the Data:**
   Compare the output of both commands. They should point to the same 3 Pod IPs.
   ```bash
   kubectl describe endpoints staff-backend
   kubectl describe endpointslice staff-backend
   ```

2. **The Scalability Test (Mental Lab):**
   Imagine if you had 2,000 replicas.
   - **Endpoints**: One massive object (~1MB+) sent to every Node every time *one* Pod changes.
   - **EndpointSlice**: Multiple smaller objects (~2KB each). Only the affected slice is updated and sent.

---

## 🧠 Key Takeaways

- **Automatic Management:** You almost never create these objects manually; Kubernetes creates them when you define a Service.
- **Scalability:** EndpointSlices solve the "massive object" problem in large clusters.
- **Debugging Flow:**
  - `kubectl get ep` is a quick way to see if a Service has *any* backends.
  - `kubectl get endpointslice` is the more accurate, modern view of what's happening under the hood.
- **CKAD Tip:** In the exam, you might see `kubectl get ep` in older questions, but `EndpointSlice` is what you'll encounter in the real world.

---

## 🔗 References
- **Docs** → [Endpoint Slices](https://kubernetes.io/docs/concepts/services-networking/endpoint-slices/)
- **Guide** → [Chapter 11: Services](../../../../sources/study-guide/ch11-services.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
