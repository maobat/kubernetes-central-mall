# 🧪 LAB 02: The Grand Entrance (Path-Based Routing)

## Services and Networking – Managing Complex Entry Points

---

## 🎯 Lab Goal

Expose two regional "wings" of the mall (`europe` and `asia`) using a single Ingress resource with different URL paths.

---

## 🛍️ Mall Analogy

- **The Direction Board (Ingress Resource)** → The sign that says "Take the left path for Europe, right path for Asia."
- **Path (/europe)** → The corridor name.

---

## 🛠️ Step-by-Step Solution

### 1. Create `world-ingress.yaml`
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: world
  namespace: world
spec:
  ingressClassName: nginx 
  rules:
  - host: "world.universe.mine"
    http:
      paths:
      - path: /europe
        pathType: Prefix
        backend:
          service:
            name: europe
            port:
              number: 80
      - path: /asia
        pathType: Prefix
        backend:
          service:
            name: asia
            port:
              number: 80
```

---

## 🔗 References
- **Comic** → [The Grand Entrance](../../../../visual-learning/comics/ch12-ingress/02-the-grand-entrance/README.md)
- **Study Guide** → [Chapter 12: Ingress](../../../../sources/study-guide/ch12-ingress.md)
