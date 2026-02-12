# LAB 05 – Canary Deployments with Gateway API (Native Traffic Weighting)

## Deploying Applications the DevOps Way – Advanced Traffic Splitting

<img src="../../../docs/md-resources/images/gateway-traffic-flow.png" alt="lab05 - Gateway API Canary Traffic Splitting" width="40%" />

---

## 🎯 Lab Goal

This lab demonstrates how to implement a **canary deployment** using the **Gateway API**, where traffic splitting is:

- **Explicit**
- **Declarative**
- **Natively supported by Kubernetes**

Unlike **LAB 04**, where traffic distribution was achieved indirectly through **replica weighting**, this lab shows how modern Kubernetes networking allows you to **declare traffic intent directly** using `HTTPRoute`.

> Same canary concept.  
> Completely different level of control.

---

## 🧠 What You Will Learn

By completing this lab, you will understand:

- Why replica-based canary releases are a workaround, not a feature
- How the **Gateway API** introduces first-class traffic weighting
- How `HTTPRoute.backendRefs.weight` controls traffic flow
- How canary testing becomes **readable, auditable, and reversible**
- Why Gateway API is the future of Kubernetes traffic management

---

## 🧩 Lab Context: LAB 04 vs LAB 05

| Aspect | LAB 04 – NodePort | LAB 05 – Gateway API |
|-----|------------------|---------------------|
| Traffic split | Indirect (replica count) | Explicit (`weight`) |
| Declarative intent | ❌ | ✅ |
| Readability | Low | High |
| Precision | Approximate | Deterministic |
| CKAD relevance | Core fundamentals | Modern Kubernetes |

LAB 04 teaches **how Kubernetes works internally**.  
LAB 05 teaches **how Kubernetes wants you to work today**.

---

## 🏗️ Architecture Overview

- Two Deployments:
  - `stable-nginx` (old, reliable version)
  - `canary-nginx` (new version)
- One **Gateway**
- One **HTTPRoute**
- Traffic split:
  - **90% → stable**
  - **10% → canary**

No replica hacks.  
No guesswork.  
Pure API-driven routing.

---

## 🚀 Step-by-Step Implementation

### 1️⃣ Create the Deployments

```bash
kubectl create deployment stable-nginx --image=nginx:1.18
kubectl create deployment canary-nginx --image=nginx:latest
```

Expose both via Services:
```bash
kubectl expose deployment stable-nginx --port=80
kubectl expose deployment canary-nginx --port=80
```
### 2️⃣ Create the Gateway 
> gateway.yaml
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: oklahoma-entrance
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    protocol: HTTP
    Apply it:
```
```bash
kubectl apply -f gateway.yaml
```
### 3️⃣ Define the Canary Traffic Split with HTTPRoute
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: canary-route
spec:
  parentRefs:
  - name: oklahoma-entrance
  rules:
  - backendRefs:
    - name: stable-nginx
      port: 80
      weight: 90   # 90% to Old Reliable
    - name: canary-nginx
      port: 80
      weight: 10   # 10% to the Canary
```
Apply it:
```bash
kubectl apply -f httproute.yaml
```
### 🔍 Verification
### 1️⃣ Get the Gateway IP
```bash
kubectl get gateway
```
Retrieve the external address (or NodePort / LoadBalancer, depending on your setup).
### 2️⃣ Test the Traffic Split (Host Header Trick)
```bash
curl -H "Host: canary.example.com" http://<GATEWAY_IP>
```

Repeat the request multiple times and observe responses being served by both versions.
>The testing technique is the same as LAB 04.
>What changed is who controls the routing logic.

### 🔬 Why This Is Better Than Replica Weighting

In LAB 04, traffic distribution depended on:
```bash
kubectl scale deployment oldbird --replicas=9
```
This works, but:

- It is **implicit**
- It affects **capacity**, not traffic intent
- It is hard to audit and reason about

In this lab, the intent is **written in YAML**:
```yaml
weight: 90
weight: 10
```
This is:
- Clear
- Versionable
- Reversible
- Observable
---
🧠 **Key Takeaways**

- Canary releases are not just about sending less traffic
- They are about declaring intent
- Gateway API turns traffic management into a first-class Kubernetes concern
- Replica weighting is a workaround
- Native traffic weighting is the solution
---
🧪 **CKAD & Real-World Relevance**

- LAB 04 → perfect for **CKAD fundamentals**
- LAB 05 → perfect for **real-world Kubernetes platforms**
