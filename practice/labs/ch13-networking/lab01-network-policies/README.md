# 🧪 LAB 01: Locked Corridors (Network Policies)

## Services and Networking – Securing Internal Traffic

---

## 🎯 Lab Goal

Lock down the mall's internal corridors using **NetworkPolicies**. You will ensure that only the "Cashier" room (Service) can communicate with the "Bank Vault" (Pod).

---

## 🛍️ Mall Analogy

In the **Central Mall**, some corridors are "Staff Only". 

- **The Cashier Pod** → Only this group is allowed to use the specialized tube to the vault.
- **The Security Door (NetworkPolicy)** → A rule that says: "Reject all traffic to the Vault unless it has the label `role=cashier`."

---

## 🛠️ Step-by-Step Solution

### 1. Create the Locked Corridor
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: vault-policy
spec:
  podSelector:
    matchLabels:
      app: vault
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: cashier
```

---

## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)
