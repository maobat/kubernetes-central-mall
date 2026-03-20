# 🧪 LAB 03: The Rewrite Policy (Advanced Ingress)

## Services and Networking – Fine-Tuning Routing Behavior

---

## 🎯 Lab Goal

Use the `rewrite-target` annotation to ensure that internal shops receive clean requests even if customers enter through complex paths like `/europe`.

---

## 🛡️ Step-by-Step Solution

### 1. The Rewrite Surgery
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: world-advanced
  namespace: world
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: world.universe.mine
    http:
      paths:
      - path: /europe
        pathType: Prefix
        backend:
          service:
            name: europe
...
```

---

## 🔗 References
- **Comic** → [The Grand Entrance](../../../../visual-learning/comics/ch12-ingress/02-the-grand-entrance/README.md)
- **Study Guide** → [Chapter 12: Ingress](../../../../sources/study-guide/ch12-ingress.md)
