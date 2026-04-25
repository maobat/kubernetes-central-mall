<img src="one-way-corridors.png" alt="The One-Way Corridor" width="40%" />

# 🖼️ Comic: The One-Way Corridor
## Chapter 13: Networking – Egress Control

This comic explains how **Egress Rules** work in Kubernetes using the Central Mall's "One-Way Corridor" analogy.

---

## 🛍️ Mall Analogy

-   **The Wild West (Default Allow):** Initially, all corridors are open. Workers from the "Warehouse" can wander to the "Food Court" or even leave the mall entirely to call home (Internet).
-   **The Exit Pass (Egress Policy):** A new rule is posted at the shop door. "If you work here, you can ONLY walk to the Shipping Bay."
-   **Default Deny (Isolation):** The moment an exit pass is issued, **all other doors are locked**. You can't even go to the bathroom unless it's on the pass!
-   **The Phonebook (DNS Exception):** To find the Shipping Bay, workers still need to reach the **Mall's Phonebook** (DNS on Port 53). Always remember to whitelist the phonebook!

> 🛍️ *In the Central Mall, we don't just control who comes in; we make sure our staff doesn't get lost on the way out.*

---

## 🧠 Key Takeaways

-   **Egress Control:** While Ingress handles incoming traffic, **Egress** limits what your Pods can connect to (external APIs, databases, or other services).
-   **Isolation Trigger:** As soon as a `NetworkPolicy` selects a Pod for `Egress`, that Pod can no longer initiate *any* connections unless explicitly allowed.
-   **DNS is Critical:** Most applications fail if they can't resolve hostnames. Always allow Egress to `kube-dns` in the `kube-system` namespace.
-   **CKAD Tip:** Pay close attention to `ipBlock` for external traffic and `podSelector/namespaceSelector` for internal mall traffic.

---

## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)
- **Lab** → [Lab 02 - One-Way Corridors](../../../../practice/labs/ch13-networking/lab02-network-policies/README.md)
- **Docs** → [Network Isolation & Troubleshooting](../../../../reference/md-resources/troubleshooting-kubernetes.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
