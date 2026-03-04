# 🧪 LAB 05: The Modern Gate (Gateway API & Canary)

## Services and Networking – Advanced Traffic Splitting

---

## 🎯 Lab Goal

Implement a **Canary Deployment** using the **Gateway API**. Unlike the manual replica hacks in Chapter 9, you will learn the modern way to **explicitly declare traffic percentages** (e.g., 90/10) directly in your YAML using `HTTPRoute`.

> **CKAD Importance:** Medium. The Gateway API is the successor to Ingress. While Ingress is the primary exam focus, understanding the "Backend Weighting" pattern is becoming essential for modern Kubernetes engineering.

---

## 🛍️ Mall Analogy

In the **Central Mall**, we've upgraded our main gate to a high-tech **Digital Turnstile (Gateway API)**.

- **The Old Design (stable-nginx)** → The standard shop everyone knows.
- **The New Design (canary-nginx)** → An experimental layout.
- **The Smart Gate (Gateway Controller)** → A turnstile that can count.
- **The Routing Rule (HTTPRoute)** → A digital instruction that says: "Send 9 customers to the old shop, and every 10th customer to the experimental one."

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Gateway** | The high-tech physical entrance. |
| **HTTPRoute** | The digital logic governing the entrance. |
| **Backend Weight** | The explicit instruction for traffic splitting. |

---

## 📋 Requirements

1. **Deployments**: `stable-nginx` (v1.18) and `canary-nginx` (latest).
2. **Gateway**: Create a minimal Gateway that accepts HTTP on port 80.
3. **HTTPRoute**: Split traffic **90% stable** / **10% canary**.
4. **Verify**: Test that traffic splits as declared without changing pod counts.

---

## 🛠️ Step-by-Step Solution

### 1. Deploy the Shop Versions
```bash
k create deploy stable-nginx --image=nginx:1.18
k create deploy canary-nginx --image=nginx:latest
k expose deploy stable-nginx --port=80
k expose deploy canary-nginx --port=80
```

### 2. Install the High-Tech Gate (Gateway)
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
    port: 80
```

### 3. Set the Canary Rules (HTTPRoute)
```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: canary-route
spec:
  parentRefs: [{ name: oklahoma-entrance }]
  rules:
  - backendRefs:
    - { name: stable-nginx, port: 80, weight: 90 }
    - { name: canary-nginx, port: 80, weight: 10 }
```

---

## 🔎 Verification

1. **Check the Logic:**
   ```bash
   k describe httproute canary-route
   # Ensure the weights are correctly applied.
   ```

2. **Test Traffic Split:**
   ```bash
   # Run multiple curls and count the versions
   for i in {1..20}; do curl -s $GATEWAY_IP | grep "nginx"; done
   ```

---

## 🧠 Key Takeaways

- **Explicit vs Implicit:** Gateway API allows you to state "10% traffic" explicitly. You don't need 10 pods to achieve a 10% split.
- **Decoupling:** The Gateway (physical) is separate from the Route (logical), allowing different teams to manage them.
- **CKAD Tip:** If asked to do a "weighted" traffic split, look for the **weight** field in the `backendRefs` section of the HTTPRoute.

---

## 🔗 References
- **Comic** → [The Lost Gateway](../../../../visual-learning/comics/ch12-ingress/01-the-lost-gateway/README.md)
- **Docs** → [Gateway API](https://gateway-api.sigs.k8s.io/)
- **Study Guide** → [Chapter 12: Ingress & Gateway API](../../../../sources/study-guide/ch12-ingress.md)
