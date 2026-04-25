# 🧪 LAB 01: The Branded Entrance ([Ingress](../../../../GLOSSARY.md#ingress) & Virtual Hosts)

## Services and Networking – Managing Incoming Traffic

---

## 🎯 Lab Goal

Learn how to route traffic using the HTTP `Host` header, allowing multiple "branded" shops to share a single mall entrance (the [Ingress](../../../../GLOSSARY.md#ingress) Controller).

---

## 🛍️ Mall Analogy

In the **Central Mall**, we have one massive **Main Entrance ([Ingress](../../../../GLOSSARY.md#ingress) Controller)**.

- **The Shop ([Pod](../../../../GLOSSARY.md#pod))** → The physical store.
- **The Branded Sign (Host Header)** → The name on the entrance door (e.g., `fashion.mall.k8s`).
- **The Concierge ([Ingress](../../../../GLOSSARY.md#ingress) Controller)** → The guard who reads your invite and points you to the right wing.

---

## 🛠️ Step-by-Step Solution

### 1. Create the [Ingress](../../../../GLOSSARY.md#ingress) Rule
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mall-ingress
spec:
  rules:
  - host: fashion.mall.k8s
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: fashion-svc
            port:
              number: 80
```

---

## 🧠 Key Takeaways

- **Host Header:** [Ingress](../../../../GLOSSARY.md#ingress) uses the domain name, not just the IP.

---

## 🔗 References
- **Comic** → [The Lost Gateway](../../../../visual-learning/comics/ch12-ingress/01-the-lost-gateway/README.md)
- **Study Guide** → [Chapter 12: Ingress](../../../../sources/study-guide/ch12-ingress.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
