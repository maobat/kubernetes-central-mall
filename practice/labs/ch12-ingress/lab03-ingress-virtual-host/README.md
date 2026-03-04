# 🧪 LAB 03: The Branded Entrance (Ingress & Virtual Hosts)

## Services and Networking – Managing Incoming Traffic

---

## 🎯 Lab Goal

This lab introduces **Ingress** and **virtual host–based routing**. You will learn how to route traffic using the HTTP `Host` header, allowing multiple "branded" shops to share a single mall entrance (the Ingress Controller).

> **CKAD Importance:** Very High. Ingress is a core component of the exam. You must know how to write an Ingress resource and how to test it without DNS.

---

## 🛍️ Mall Analogy

In the **Central Mall**, we have one massive **Main Entrance (Ingress Controller)**.

- **The Shop (Pod)** → The actually physical store where goods are sold.
- **The Internal Walkway (Service)** → The hallway that leads customers to the shop.
- **The Branded Sign (Host Header)** → The name on the entrance door (e.g., `fashion.example.com`).
- **The Concierge (Ingress Controller)** → The person standing at the main entrance. When a customer says "I'm here for Fashion," the concierge looks at the sign and points them to the correct hallway.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Ingress Controller** | The main mall entrance and concierge. |
| **Ingress Resource** | The instruction manual for the concierge. |
| **Host Header** | The name of the store written on the customer's invite. |

---

## 📋 Requirements

1. **Deployment**: `lab11web` (nginx, 3 replicas).
2. **Service**: Expose as ClusterIP on port 80.
3. **Ingress**: Create a rule for `lab11web.example.com` to route to the service.
4. **Internal Test**: Spoof the Host header using `curl` from a test pod.

---

## 🛠️ Step-by-Step Solution

### 1. Enable the Gateway (Minikube)
```bash
minikube addons enable ingress
```

### 2. Deploy the Shops
```bash
k create deploy lab11web --image=nginx --replicas=3
k expose deploy lab11web --port=80
```

### 3. Create the Ingress Rule
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
            name: lab11web
            port:
              number: 80
```

---

## 🔎 Verification

1. **The Spoof Test (CKAD-style):**
   In the exam, you can't edit DNS. You must test from inside a pod:
   ```bash
   # Get the Ingress Controller IP
   IC_IP=$(k get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.clusterIP}')

   # Test with the Host header
   k run tester --image=curlimages/curl --rm -it --restart=Never -- \
     curl -v -H "Host: lab11web.example.com" http://$IC_IP
   ```

---

## 🧠 Key Takeaways

- **DNS vs Headers:** Ingress routing is about the **HTTP Host Header**, not just the IP address.
- **Path Types:** `Prefix` means anything starting with `/` matches. `Exact` is for specific pages.
- **CKAD Tip:** Never use `minikube ip` in the exam. Always test from a pod using the Ingress Controller's internal Service IP.

---

## 🔗 References
- **Comic** → [Virtual Host Routing](../../../../visual-learning/comics/ch12-ingress/01-virtual-host/README.md)
- **Docs** → [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- **Study Guide** → [Chapter 12: Ingress](../../../../sources/study-guide/ch12-ingress.md)
