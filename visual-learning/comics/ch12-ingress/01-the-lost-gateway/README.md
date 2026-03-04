<img src="lab05-il-giallo-del-gateway-perduto.png" alt="The Lost Gateway" width="40%" />

# 🕵️ The Mystery of the Lost Gateway

This comic explains the complexities of the **Gateway API** and why your gateway might seem "lost" or unresponsive.

---

## 🛍️ Mall Analogy

- **The Blueprint (GatewayClass)** → The general architect's plan for how gateways should work in the mall.
- **The Physical Gate (Gateway)** → The actual door being built. If it has no address, it means the contractor (Controller) hasn't finished the installation yet.
- **The Red Tape (Programmed: False)** → The Mall Manager hasn't approved the gate yet, likely because there's another gate (Conflict) trying to use the same spot.
- **The Forwarding Rules (HTTPRoute)** → The instructions the guard at the gate follows to send you to the right wing of the mall.

> 🛍️ *A gate without a guard is just a wall.*

---

## 🧠 Key Takeaways

- **Gateway vs. Controller:** Creating a Gateway object only records your *intent*. You need a **Gateway Controller** (like Istio or Envoy) to actually provision the underlying infrastructure (like a LoadBalancer).
- **Status Fields:** Always check `kubectl describe gateway`. `Programmed: True` means the infrastructure is ready; `Accepted: True` mean the configuration is valid.
- **Role Separation:** Gateway API separates the roles of Infrastructure Provider (GatewayClass), Cluster Operator (Gateway), and Application Developer (HTTPRoute).
- **CKAD Tip:** The Gateway API is the modern successor to Ingress. Focus on how **HTTPRoutes** attach to **Gateways** using parent references.

---

## 🔗 References
- **Lab** → [Canary with Gateway API](../../../../practice/labs/ch12-ingress/lab05-canary-deployment-gateway-api/README.md)
- **Docs** → [Understanding Gateway API](../../../../reference/md-resources/gateway-api.md)
- **Study Guide** → [Chapter 12: Ingress & Gateway API](../../../../sources/study-guide/ch12-ingress.md)
