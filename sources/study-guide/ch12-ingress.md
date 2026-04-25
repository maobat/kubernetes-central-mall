# 📖 Chapter 12: Ingress & Gateway API
*The Grand Entrance & The Information Desk*

In the **Central Mall**, customers don't want to memorize 50 different "Gate Numbers" (NodePorts). They want to walk through one **Grand Entrance** and see a sign that says: *"Go Left for Shoes.com, Go Right for Food.com."* This is what **Ingress** and the **Gateway API** do.

---

## 🎭 12.1 Ingress: The Smart Directory

**Ingress** is like a smart directory board at the entrance. It looks at the "Host" (the URL) or the "Path" (/shoes) and directs the customer to the right internal Service.

| Feature | Mall Analogy | K8s Concept |
| :--- | :--- | :--- |
| **Host Routing** | "If you want the Boutique, go to Hall A." | `host: boutique.com` |
| **Path Routing** | "If you want the Food Court, go to Hall B." | `path: /food` |
| **The Concierge** | The person actually moving the people. | **Ingress Controller** (Nginx, Traefik) |



---

## 🎭 12.2 Gateway API: The Next-Gen Lobby

If Ingress is a simple directory board, the **Gateway API** is a high-tech, multi-tenant reception system. It separates the "Mall Owner" (who manages the building infrastructure) from the "Store Manager" (who manages the routes to their specific store).

* **GatewayClass:** The brand of the doors (e.g., "Google Cloud Doors" or "Nginx Doors").
* **Gateway:** The physical entrance itself.
* **HTTPRoute:** The specific instructions for reaching a store.



---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. Creating an Ingress Rule
In the exam, you often use an Ingress to connect a domain name to a service.

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
If your Ingress or Gateway isn't working, check the **Controller**. Without a Controller (the concierge), the Ingress is just a sign in an empty room.

```bash
# Check if the Ingress has been assigned an IP
kubectl get ingress

# Check if the Gateway is "Programmed"
kubectl get gateway -o wide
```

---

## 🧪 Lab Highlight: Canary with Gateway API
The Gateway API is much better at **Traffic Splitting** than standard Services. You can tell a Gateway to send exactly 10% of people to the "Canary" version without messing with replica counts!

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
- **Missing Ingress Controller:** Creating an `Ingress` resource does nothing if an Ingress Controller (like NGINX) is not installed in the cluster. It will just sit there without an `ADDRESS`. Always check if the controller is running.
- **PathType Exact vs Prefix:** In the `rules.http.paths` array, `pathType: Exact` means `/app` only matches `/app`. `pathType: Prefix` means `/app` matches `/app/login` and `/app/images`. Choosing the wrong one is a common exam mistake.

---

## 🧰 Study Toolbox

* 🖼️ **Comic 01:** [Virtual Host Gateway Show - Host-based Routing](../../visual-learning/comics/ch12-ingress/01-virtual-host/README.md)
* 🖼️ **Comic 02:** [The Lost Gateway - Troubleshooting Gateway API](../../visual-learning/comics/ch12-ingress/01-the-lost-gateway/README.md)
* 🖼️ **Comic 03:** [The Grand Entrance (Path-Based Routing)](../../visual-learning/comics/ch12-ingress/02-the-grand-entrance/README.md)
* 📄 **Doc:** [Ingress vs Gateway](../../reference/md-resources/ingress-vs-gateway.md)
* 🧪 **Labs:** [Explore Chapter 12 Labs](../../practice/labs/ch12-ingress/README.md)

---
[<< Previous: Networking Services](ch11-services.md) | [Back to Story Index](../story.md) | [Next: Network Policies >>](ch13-networking.md)

---
[Mall Directory ✨](../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
