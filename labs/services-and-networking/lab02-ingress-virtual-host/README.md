# LAB 02 – Ingress & Virtual Host Routing

## Services and Networking – Managing Incoming Traffic

<img src="../../../docs/md-resources/images/lab02-ingress-routing.png" alt="lab02 - Services and Networking - Managing Incoming Traffic" width="35%" />

---

## 🧠 Conceptual Comic (Read First)

Before starting, read this short comic:

👉 [Lab 02 - The Virtual Host Gateway Show](../../../comics/ingress/02-virtual-host/README.md)

It explains **how Ingress routes traffic** based on Host headers.

---

## 📘 Reference Docs

- Understanding Traffic Flow (Ingress) → [`docs/md-resources/traffic-flow.md`](../../../docs/md-resources/traffic-flow.md)

- Ingress vs Gateway API → [`docs/md-resources/ingress-vs-gateway.md`](../../../docs/md-resources/ingress-vs-gateway.md)

---

## 🎯 Lab Goal

This lab introduces **Ingress** and **virtual host–based routing**.

You will learn how to:
- Deploy a multi-replica application
- Expose it internally via a **Service**
- Route traffic using an **Ingress** based on the HTTP `Host` header
- Verify Ingress behavior **from inside the cluster** (CKAD-style)

---

## 📋 Requirements

1. Create a **Deployment** named `lab11web`
   - Image: `nginx`
   - Replicas: `3`
2. Expose the Deployment via a **Service** on port `80`
3. Make the application reachable at:
   - `http://lab11web.example.com`

```yaml
using an **Ingress**
```

---
## 🏬 Mall Analogy

We are opening **three identical shops** behind a single branded entrance.

Customers don’t care which shop they enter —  
they just look at the **store sign (hostname)**.

| Kubernetes Concept | Mall Analogy |
|-------------------|--------------|
| **Deployment (3 replicas)** | Three identical shops |
| **Service (ClusterIP)** | Internal hallway connecting the shops |
| **Ingress** | The main mall entrance |
| **Host: lab11web.example.com** | The shop’s name on the sign |

---

## 🛠️ Solution

### 1️⃣ Enable the Ingress Controller (Minikube)

```bash
minikube addons enable ingress
```
### 2️⃣ Create the Deployment

```bash
kubectl create deployment lab11web \
  --image=nginx \
  --replicas=3
```

### 3️⃣ Expose the Deployment with a Service

```bash
kubectl expose deployment lab11web --port=80
```

This creates a **ClusterIP Service**, which is perfect for Ingress.

### 4️⃣ Create the Ingress Resource

Create a file named `ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: lab11web-ingress
spec:
  rules:
  - host: lab11web.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
```

Apply it:

```bash
kubectl apply -f ingress.yaml
```

### 🔎 Verification (CKAD-Style)

> ⚠️ In the CKAD exam, you **won’t edit** `/etc/hosts`.

> You will test **from inside the cluster**.

### 1️⃣ Start a Temporary Tester Pod

```bash
kubectl run dns-test \
  --image=curlimages/curl \
  --rm -it \
  --restart=Never -- sh
```

### 2️⃣ Try Direct Access (Expected to Fail)

```bash
curl -v http://lab11web.example.com
```

❌ Possible results:

- `Could not resolve host`
- `404 Not Found`

**Why?**
CoreDNS doesn’t know about `example.com`.

Ingress routing depends on the **Host header**, not DNS resolution.

---
### 3️⃣ Get the Ingress Controller ClusterIP

```bash
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller \
  -o jsonpath='{.spec.clusterIP}')
echo $INGRESS_IP
```
---
### 4️⃣ Spoof the Host Header (Correct Test)
```bash
curl -v -H "Host: lab11web.example.com" http://$INGRESS_IP
```

✅ **Expected result:**
`Welcome to nginx!`

🔄 Understanding the Traffic Flow

1. **Tester Pod** sends the HTTP request
2. **Ingress Controller** receives it
3. **Ingress rules** inspect the Host header
4. **Service** routes traffic to one of the Pods
5. **One nginx Pod** responds

🧠 **Expert Summary**

- Ingress routing is **header-based**, not DNS-based
- Services remain **ClusterIP**
- External exposure is fully handled by the Ingress Controller
- Internal testing is the **exam-safe approach**

📝 **Key Takeaways (CKAD Mindset)**

- Always test Ingress using a **Host header**
- Don’t rely on `/etc/hosts`
- Think in terms of:
```nginx
    
Ingress is the foundation for:

- Virtual hosting
- Canary & blue-green deployments
- Gateway API evolution