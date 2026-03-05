<img src="lab01-nodeport-cross-namespace.png" alt="NodePort Cross Namespace" width="40%" />

# 🕵️ The NodePort Traffic Adventure

This comic explains how **NodePorts** allow external traffic to reach your shop, regardless of which floor (Namespace) it's on.

---

## 🛍️ Mall Analogy

- **Mall Building (Node)** → The physical structure housing all the shops.
- **Side Entrance (NodePort)** → A fixed door number on the outside of the building. Once you walk through this door, you are directed to the right shop.
- **Floors (Namespaces)** → Logical divisions inside the mall.
- **The Guide (Service)** → The person at the side entrance who knows that the "Bakery" is on the 2nd floor and directs you there.

> 🛍️ *Traffic doesn't care about floors; it only cares about the door number.*

---

## 🧠 Key Takeaways

- **External Access:** NodePorts open a specific port (30000-32767) on *every* Node in the cluster.
- **Namespace-Agnostic:** Services can route traffic to Pods in any namespace. The external user only interacts with the Node's IP and the NodePort.
- **Simplicity:** This is the easiest way to expose an application to external traffic when you don't have a LoadBalancer or Ingress.
- **CKAD Tip:** Remember that a NodePort service *also* creates a ClusterIP service automatically. You can always access it internally using the ClusterIP.

---

## 🔗 References
- **Study Guide** → [Chapter 11: Services & Networking](../../../../sources/study-guide/ch11-services-networking.md)
- **Lab** → [NodePort & Cross-Namespace](../../../../practice/labs/ch11-services/lab02-nodeport-cross-namespace/README.md)
- **Docs** → [Service IP Tracker Evolution](../../../../reference/md-resources/service-ip-tracker-evolution.md)
