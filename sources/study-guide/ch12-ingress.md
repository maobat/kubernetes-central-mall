# 📖 Chapter 12: [Ingress](../../GLOSSARY.md#ingress) & [Gateway API](../../GLOSSARY.md#gateway-api)
*The Grand Entrance & The Information Desk*

In the **Central Mall**, customers don't want to memorize 50 different "Gate Numbers" (NodePorts). They want to walk through one **Grand Entrance** and see a sign that says: *"Go Left for Shoes.com, Go Right for Food.com."* This is what **[Ingress](../../GLOSSARY.md#ingress)** and the **[Gateway API](../../GLOSSARY.md#gateway-api)** do.

---

## 🎭 12.1 [Ingress](../../GLOSSARY.md#ingress): The Smart Directory

**[Ingress](../../GLOSSARY.md#ingress)** is like a smart directory board at the entrance. It looks at the "Host" (the URL) or the "Path" (/shoes) and directs the customer to the right internal [Service](../../GLOSSARY.md#service).

| Feature | Mall Analogy | K8s Concept |
| :--- | :--- | :--- |
| **Host Routing** | "If you want the Boutique, go to Hall A." | `host: boutique.com` |
| **Path Routing** | "If you want the Food Court, go to Hall B." | `path: /food` |
| **The Concierge** | The person actually moving the people. | **[Ingress](../../GLOSSARY.md#ingress) Controller** (Nginx, Traefik) |



---

## 🎭 12.2 [Gateway API](../../GLOSSARY.md#gateway-api): The Next-Gen Lobby

If [Ingress](../../GLOSSARY.md#ingress) is a simple directory board, the **[Gateway API](../../GLOSSARY.md#gateway-api)** is a high-tech, multi-tenant reception system. It separates the "Mall Owner" (who manages the building infrastructure) from the "Store Manager" (who manages the routes to their specific store).

* **GatewayClass:** The brand of the doors (e.g., "Google Cloud Doors" or "Nginx Doors").
* **Gateway:** The physical entrance itself.
* **HTTPRoute:** The specific instructions for reaching a store.



---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. Creating an [Ingress](../../GLOSSARY.md#ingress) Rule
In the exam, you often use an [Ingress](../../GLOSSARY.md#ingress) to connect a domain name to a [service](../../GLOSSARY.md#service).

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mall-ingress
spec:
  rules:
  - host: boutique.mall.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: boutique-service
            port:
              number: 80
```

### 2. Troubleshooting "The Lost Gateway"
If your [Ingress](../../GLOSSARY.md#ingress) or Gateway isn't working, check the **Controller**. Without a Controller (the concierge), the [Ingress](../../GLOSSARY.md#ingress) is just a sign in an empty room.

```bash
# Check if the Ingress has been assigned an IP
kubectl get ingress

# Check if the Gateway is "Programmed"
kubectl get gateway -o wide
```

---

## 🧪 Lab Highlight: Canary with [Gateway API](../../GLOSSARY.md#gateway-api)
The [Gateway API](../../GLOSSARY.md#gateway-api) is much better at **Traffic Splitting** than standard Services. You can tell a Gateway to send exactly 10% of people to the "Canary" version without messing with replica counts!

```yaml
spec:
  rules:
  - backendRefs:
    - name: nginx-v1
      weight: 90
    - name: nginx-canary
      weight: 10
```

---

## ⚠️ Common Exam Traps
- **Missing [Ingress](../../GLOSSARY.md#ingress) Controller:** Creating an `Ingress` resource does nothing if an [Ingress](../../GLOSSARY.md#ingress) Controller (like NGINX) is not installed in the cluster. It will just sit there without an `ADDRESS`. Always check if the controller is running.
- **PathType Exact vs Prefix:** In the `rules.http.paths` array, `pathType: Exact` means `/app` only matches `/app`. `pathType: Prefix` means `/app` matches `/app/login` and `/app/images`. Choosing the wrong one is a common exam mistake.

---

## 🧰 Study Toolbox

**🎨 Visualize the Analogy**
* [Explore Chapter 12 Comics](../../visual-learning/comics/ch12-ingress/README.md)

**📘 Technical Deep Dive**
* [Ingress vs Gateway](../../reference/md-resources/ingress-vs-gateway.md)

**🛠️ Hands-on Practice**
* [Explore Chapter 12 Labs](../../practice/labs/ch12-ingress/README.md)

---
[<< Previous: Networking Services](ch11-services.md) | [Back to Story Index](../story.md) | [Next: Network Policies >>](ch13-networking.md)

---
[Mall Directory ✨](../../GLOSSARY.md)
