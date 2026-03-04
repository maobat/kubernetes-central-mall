# 🧪 LAB 06: Locked Corridors (Network Policies)

## Services and Networking – Securing Internal Traffic

---

## 🎯 Lab Goal

Secure communication between your mall shops by implementing a **"Default Deny"** policy and then explicitly whitelisting only authorized traffic. You will learn how to lock down a namespace and open specific "corridors" for microservices.

> **CKAD Importance:** Very High. Network Policies are a staple of the CKAD exam. You must know how to isolate pods and allow specific ingress/egress.

---

## 🛍️ Mall Analogy

In the **Central Mall**, security used to be relaxed—anyone could walk from any shop into any other shop's storage room.

- **The Corridors (Networking)** → The paths between the shops.
- **The Security Guard (Network Policy)** → A guard standing outside a shop's door with a list of allowed names.
- **The Lockdown (Default Deny)** → A new mall-wide rule: "All doors are locked by default. No one enters unless they are on the whitelist."
- **The Keycard (Policy Rule)** → A specific permit that says: "Employees from the Backend Shop are allowed to enter the Database Storage Room."

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **NetworkPolicy** | The security guard's set of instructions. |
| **PodSelector** | Which shop the guard is protecting. |
| **Ingress Rule** | Who is allowed to come *in*. |
| **Egress Rule** | Who is allowed to go *out*. |

---

## 📋 Requirements

1. **Default Deny**: Block all incoming traffic in the `default` namespace.
2. **Whitelist**: Allow the `backend` pod to access the `database` pod on port `5432`.
3. **DNS**: Ensure pods can still reach the mall's internal intercom (DNS) in `kube-system`.

---

## 🛠️ Step-by-Step Solution

### 1. Lock Everything Down
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny
spec:
  podSelector: {} # Selects all pods
  policyTypes: [Ingress]
```

### 2. Open the Database Corridor
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
spec:
  podSelector:
    matchLabels: { app: database }
  ingress:
  - from:
    - podSelector: { matchLabels: { app: backend } }
    ports: [{ protocol: TCP, port: 5432 }]
```

---

## 🔎 Verification

1. **Policy Audit:**
   ```bash
   k get netpol
   k describe netpol allow-backend-to-db
   ```

2. **Connectivity Test:**
   ```bash
   # From a 'backend' pod (should work)
   k exec backend -- nc -zv database 5432

   # From a 'stranger' pod (should fail)
   k run stranger --image=busybox -- rm -it --restart=Never -- nc -zv database 5432
   ```

---

## 🧠 Key Takeaways

- **Non-Isolated by Default:** If no policy selects a pod, it is "open to the world." As soon as one policy selects it, it is isolated.
- **Namespace Scope:** Policies only apply to the namespace where they are created.
- **The DNS Trap:** If you block all Egress, your pods can't resolve names. Always allow UDP 53 to the `kube-system` namespace.
- **CKAD Tip:** Use labels for everything. Policies use `matchLabels`, not pod names.

---

## 🔗 References
- **Comic** → [Locked Corridors](../../../../visual-learning/comics/ch13-networking/01-locked-corridors/README.md)
- **Docs** → [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- **Study Guide** → [Chapter 13: Networking](../../../sources/study-guide/ch13-networking.md)
