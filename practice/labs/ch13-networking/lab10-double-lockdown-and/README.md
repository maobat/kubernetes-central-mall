# 🧪 LAB 10: The Double Lockdown (AND Logic)

## 🎯 Lab Goal
> **Scenario: The High-Security Vault**
> Protect a shop so that only a specific worker from a specific wing can enter. If a worker has the right ID but comes from the wrong wing, or comes from the right wing but has the wrong ID, they are blocked.

Learn how to implement **AND logic** in NetworkPolicies by combining `namespaceSelector` and `podSelector` within the same rule block.

---

## 🛍️ Mall Analogy

In the **Central Mall**, some high-security vaults (like the Cash Room) have a door that requires two forms of identification.

* **Condition 1:** You must come from the **Red Wing** (namespace `red` with label `team=red`).
* **Condition 2:** You must have a **Client ID** (pod with label `app=client`).
* **The Result:** The door ONLY opens if you satisfy **BOTH** conditions. This is **AND logic**. If you are a manager from the Blue Wing, or a janitor from the Red Wing, you stay outside!

---

## 🛠️ Step-by-Step Solution

### 1. Create the Mall Wings (Namespaces)
```bash
kubectl create ns and-logic
kubectl create ns red

# Label the red wing
kubectl label ns red team=red
```

### 2. Deploy the Protected Vault
Start the server in the `and-logic` wing and expose it.

```bash
# Start the server (The Cash Room)
kubectl run server -n and-logic --image=busybox:1.36 --restart=Never -- sh -c "nc -lk -p 8080"

# Expose it
kubectl expose pod server --name=svc --port=8080 -n and-logic
```

### 3. Deploy the Staff (The Clients)
Create two different pods in the `red` wing to test the access rules.

```bash
# Authorized Staff (Right Wing + Right ID)
kubectl run ok -n red --image=busybox:1.36 --labels=app=client --restart=Never -- sleep 3600

# Unauthorized Staff (Right Wing + WRONG ID)
kubectl run bad -n red --image=busybox:1.36 --restart=Never -- sleep 3600
```

### 4. Apply the Double Lockdown Policy
Notice that we put `namespaceSelector` and `podSelector` inside the **SAME** `- from:` block. This creates an **AND** condition.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: and-logic
  namespace: and-logic
spec:
  podSelector: {} # Target all pods in this namespace
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          team: red
      podSelector:
        matchLabels:
          app: client
    ports:
    - protocol: TCP
      port: 8080
```

Apply it:
```bash
kubectl apply -f np-21.yaml
```

### 5. Final Verification
Test connectivity from both staff members in the `red` wing.

```bash
# Test Authorized Staff (Should succeed)
kubectl exec ok -n red -- nc -vz svc.and-logic 8080

# Test Unauthorized Staff (Should fail/hang)
kubectl exec bad -n red -- nc -vz svc.and-logic 8080
```

---

## 🧠 Key Takeaways

> [!CAUTION]
> **YAML Structure Matters!**
> - **AND Logic**: `namespaceSelector` and `podSelector` are in the same block (no leading dash on the second one).
> - **OR Logic**: They are in separate blocks (each starting with its own `-`).
> 
> Mixing these up is the most common mistake in the CKAD exam. Always double-check your indentation and dashes!

---

## 🔗 References
- **Master Map** → [Network Policy Master Map](../../../../visual-learning/comics/ch13-networking/03-network-policy-master-map/README.md)
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
