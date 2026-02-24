# 🧪 LAB 06 – Network Policies & Locked Corridors

## 🎯 Lab Goal
Secure communication between your mall shops by implementing a "Default Deny" policy and then whitelisting only authorized traffic.

## 🏢 Mall Analogy
The **Central Mall** security team has decided that having all corridors open is too risky. You are tasked with locking all doors and only giving keycards to specific shop employees.

## 📖 Related Comic
👉 [comics/network-policies/01-locked-corridors/README.md](../../../comics/network-policies/01-locked-corridors/README.md)

## 🛠️ Step-by-Step Solution

### 1. The "Lock Everything" Rule (Default Deny)
Create a policy that blocks all incoming traffic to all pods in the `default` namespace.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
spec:
  podSelector: {} # Selects all pods in the namespace
  policyTypes:
  - Ingress
```

### 2. The "Backend to DB" Whitelist
Allow the `backend` shop to talk to the `database` shop on port 5432.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
spec:
  podSelector:
    matchLabels:
      app: database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend
    ports:
    - protocol: TCP
      port: 5432
```

### 3. The "Allow DNS" (Critical!)
Without DNS, your clerks can't find the addresses of other shops.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-egress
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
```

## ✅ Verification

```bash
# Verify that the policies are applied
kubectl get netpol

# Describe a specific policy
kubectl describe netpol allow-backend-to-db
```

## 💡 Key Takeaways
- Network Policies are **Namespace-scoped**.
- By default, Pods are **Non-Isolated** (all open).
- Once a policy selects a Pod, that Pod becomes **Isolated** (deny what's not allowed).
- Always ensure **DNS** is whitelisted for egress if you use hostnames.

---

## 📖 Related Chapter
👉 [sources/study-guide/ch13-networking.md](../../../sources/study-guide/ch13-networking.md)
