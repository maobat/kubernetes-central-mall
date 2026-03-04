<img src="locked-corridors.png" alt="The Locked Corridor" width="40%" />

# 🎭 The Locked Corridor

This comic explains how **Network Policies** (Network Isolation) work in Kubernetes using the Central Mall's "Locked Corridor" analogy.

---

## 🛍️ Mall Analogy

- **The Shops (Pods) & Floors (Namespaces)** → By default, all corridors are open. Anyone can walk from the "Toy Store" to the "Bank Vault".
- **The Security Gate (Network Policy)** → A high-tech barrier installed in a corridor. It only opens for people with the right **ID Badge** (Labels).
- **Default Deny** → Locking *every* door in the mall. This is the safest way to start—nobody moves until you give them a keycard.
- **Whitelisting** → The specific list of who is allowed through the gate: "Only the ATM (Pod A) can talk to the Bank Vault (Pod B)."

> 🛍️ *Don't wait for a robbery to lock the doors. Set your policies early.*

---

## 🧠 Key Takeaways

- **Default Allow:** In a standard Kubernetes cluster, any Pod can reach any other Pod, even across different namespaces.
- **Label Selectors:** Network Policies use `podSelector` and `namespaceSelector` to identify which traffic to allow.
- **Ingress vs. Egress:** **Ingress** controls who can come *in* to your shop; **Egress** controls where your workers are allowed to go *out* to.
- **CKAD Tip:** When writing a policy, remember that it only applies to the namespace it is created in. If a Pod is not selected by any policy, it remains open.

---

## 🔗 References
- **Lab** → [Network Policies](../../../../practice/labs/ch13-networking/lab06-network-policies/README.md)
- **Docs** → [Network Isolation & Troubleshooting](../../../../reference/md-resources/troubleshooting-kubernetes.md)
- **Study Guide** → [Chapter 13: Network Policies](../../../../sources/study-guide/ch13-networking.md)
