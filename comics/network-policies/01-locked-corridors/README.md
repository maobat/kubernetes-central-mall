<img src="locked-corridors.png" alt="The Locked Corridor" width="40%" />

# 🎭 The Locked Corridor

This comic explains how **Network Policies** (Network Isolation) works in Kubernetes using the Central Mall's "Locked Corridor" analogy.

## 🛍️ Mall Analogy

- **Pod** → A Shop in the mall.
- **Traffic** → A person walking from one shop to another.
- **Network Policy** → A high-tech security gate installed in the corridor.
- **Default Deny** → Locking all corridor doors by default.
- **Whitelisting** → Giving a specific "Keycard" to authorized employees only.

## 🧠 Key Takeaways

- By default, all Pods can talk to each other.
- Use **Network Policies** to restrict traffic based on labels.
- **Ingress** controls who can enter your shop.
- **Egress** controls where your employees can go.
- Don't forget to allow **DNS** traffic!

---

## 🔗 References
- Lab → [LAB 06 – Network Policies & Locked Corridors](../../../labs/services-and-networking/lab06-network-policies/README.md)
- Documentation → [Network Isolation and Troubleshooting](../../../docs/md-resources/troubleshooting-kubernetes.md#section-8-3)
