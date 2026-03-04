# LAB 05 – Canary Deployments with Gateway API (Native Traffic Weighting)

## Deploying Applications the DevOps Way – Advanced Traffic Splitting



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

## 📖 Related Comic
👉 [visual-learning/comics/ch12-ingress/01-the-lost-gateway/README.md](../../../../visual-learning/comics/ch12-ingress/01-the-lost-gateway/README.md)

It explains **why your Gateway has no IP** and how traffic really flows.

---

## 📘 Reference Docs

- Gateway API fundamentals → [`docs/md-resources/gateway-api.md`](../../../../reference/md-resources/gateway-api.md)

- Advanced traffic splitting → [`docs/md-resources/advanced-traffic-splitting.md`](../../../../reference/md-resources/advanced-traffic-splitting.md)

- Ingress vs Gateway API → [`docs/md-resources/ingress-vs-gateway.md`](../../../../reference/md-resources/ingress-vs-gateway.md)

- Traffic Flow Verification → [`docs/md-resources/traffic-flow-verification.md`](../../../../reference/md-resources/traffic-flow-verification.md)

- Canary Deployment Implementation → [`docs/md-resources/implementing-canary-deployments.md`](../../../../reference/md-resources/implementing-canary-deployments.md)

---


## 🧠 What You Will Learn

By completing this lab, you will understand:

- Why replica-based canary releases are a **workaround**, not a feature
- How the **Gateway API** introduces first-class traffic weighting
- How `HTTPRoute.backendRefs.weight` controls traffic flow
- How canary testing becomes **readable, auditable, and reversible**
- Why Gateway API is the **future** of Kubernetes traffic management

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
- Two Services (one per Deployment)
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
---
### 2️⃣ Create the Gateway

👉 [Lab 05 - The Gateway](./gateway.yaml)

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
```    
Apply it:
```bash
kubectl apply -f gateway.yaml
```

✅ **CKAD Best Practice: “Minimum Viable Gateway”**

---
For CKAD labs, you should **always create the smallest possible Gateway** that:

1. Is **valid**
2. Accepts traffic
3. Lets an `HTTPRoute` attach

---
🧠 **What to Remember (Not the Whole YAML)**

Instead of memorizing the file, memorize **this mental checklist:**

  - 1. **Gateway = 3 mandatory things**

    You must have:

    - `gatewayClassName`
    - `listeners`
    - `port + protocol`

If one is missing, **invalid Gateway**.

  - 2. *The “Listener Rule” (super important for exams)*
    
    Every listener needs exactly these three:

    - `name: http`
    - `protocol: HTTP`
    - `port: 80`


That’s it.
No TLS, no hostname, no filters, **keep it dumb**.

---
💡 In CKAD, complex Gateways are a trap.

🧠 **10-second recall** → Gateway = class + 1 HTTP door

When under pressure, remember this sentence:

---
> **“Gateway is just: class + one HTTP door.”**

Then write:
```yaml
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    protocol: HTTP
    port: 80
```

Everything else lives in **HTTPRoute**, not here.

---
So, if it's clear the **concept of Gateway**, let's apply it:
```bash
kubectl apply -f gateway.yaml
```

---

### 3️⃣ Define the Canary Traffic Split with HTTPRoute

👉 [Lab 05 - The HTTPRoute](./httproute.yaml)

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
> 💡 This is the CKAD-native way to do **weighted traffic** without NodePort “hacks”.

---
1️⃣ **Mental model (CKAD-friendly)**

For **HTTPRoute**, always think in **3 blocks**:

1. Who am I attached to? → `parentRefs`
2. What traffic do I match? → `rules.matches` (can be minimal)
3. Where does traffic go? → `rules.backendRefs`

Everything else is optional fluff.

2️⃣ **Absolute minimal HTTPRoute (works with your minimal Gateway)**

This is the **smallest useful HTTPRoute** you can write and still route traffic:
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: demo-route
spec:
  parentRefs:
  - name: oklahoma-entrance
  rules:
  - backendRefs:

```
>**Why this works**
- No `matches` → matches **all HTTP traffic**
- Single rule → default behavior
- One backend → 100% of traffic goes there

👉 This is the **HTTPRoute equivalent of** `kubectl expose`.

---
3️⃣ **Minimal HTTPRoute for Canary (Lab 05 core)**

Now we evolve it just one step to show **why Gateway API exists**:
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
      weight: 90
    - name: canary-nginx
      port: 80
      weight: 10
```

💡 That’s it.
No headers.
No paths.
No filters.

This **directly contrasts Lab 04**, where replica counts were abused to fake weighting.

---
4️⃣ **What you should memorize (exam-safe)**

You do **NOT** need to remember the full spec.
Just this skeleton:
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: <route-name>
spec:
  parentRefs:
  - name: <gateway-name>
  rules:
  - backendRefs:
    - name: <service-name>
      port: <port>
      weight: <optional>
```

If you can reproduce this from memory, you’re golden for CKAD.

---


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
e **Key Takeaways**

- Canary releases are not just about sending less traffic
- They are about declaring intent
- Gateway API turns traffic management into a first-class Kubernetes concern
- Replica weighting is a workaround
- Native traffic weighting is the solution
---
🧪 **CKAD & Real-World Relevance**

- LAB 04 → perfect for **CKAD fundamentals**
- LAB 05 → perfect for **real-world Kubernetes platforms**

---

## 📖 Related Chapter
👉 [sources/study-guide/ch12-ingress.md](../../../../sources/study-guide/ch12-ingress.md)
