# 📖 Chapter 13: Network Policies
*Locked Corridors (Network Isolation)*

By default, the **Central Mall** has an "Open Door Policy." Every shop ([Pod](../../GLOSSARY.md#pod)) can talk to every other shop. While this sounds friendly, it is a security nightmare. If a hacker takes over the "Juice Bar," they can walk straight into the "Main Cashier." We use **Network Policies** to lock the doors.

---

## 🎭 13.1 [Ingress](../../GLOSSARY.md#ingress) vs. Egress

In the world of Locked Corridors, we look at which way the person is walking:

| Term | Mall Analogy | K8s Concept |
| :--- | :--- | :--- |
| **[Ingress](../../GLOSSARY.md#ingress)** | **The Front Door.** Who is allowed to enter your shop? | Traffic coming *into* the [Pod](../../GLOSSARY.md#pod). |
| **Egress** | **The Staff Exit.** Where are your workers allowed to go? | Traffic leaving *from* the [Pod](../../GLOSSARY.md#pod). |



---

## 🎭 13.2 The "Default Deny" Strategy

The safest way to run a mall is to lock *every* door and then only unlock the ones you need. 

1. **Lock Everything:** Apply a policy that says "Nobody can talk to anyone."
2. **Whitelist:** Add specific rules like: "Only the Cashier can talk to the Bank."



---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. The "Only My Friends" Rule
Imagine the `database` shop only wants to hear from the `backend` shop.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
spec:
  podSelector:
    matchLabels:
      app: database # This policy protects the database
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: backend # Only Pods with this label can enter
    ports:
    - protocol: TCP
      port: 5432
```

### 2. The [Namespace](../../GLOSSARY.md#namespace) Wall
You can also lock doors based on which floor ([Namespace](../../GLOSSARY.md#namespace)) the person is coming from.
```yaml
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          floor: finance # Only people from the Finance floor allowed
```

---

## ⚠️ The "Gotcha" (Exam Tip)
In the CKAD, if you apply a Network Policy and everything stops working, it’s usually because you forgot to allow **DNS**. If the clerk can't talk to the Mall Directory (DNS), they can't find the address of the shop they are supposed to visit!

```bash
# Check if a policy is blocking your Pod
kubectl describe netpol <policy-name>
```

---

## ⚠️ Common Exam Traps
- **Default Deny Is Instant:** The moment you create a [NetworkPolicy](../../GLOSSARY.md#networkpolicy) that selects a [Pod](../../GLOSSARY.md#pod), the default behavior for that [Pod](../../GLOSSARY.md#pod) changes from "Allow All" to "Deny All" for any traffic direction ([Ingress](../../GLOSSARY.md#ingress)/Egress) not explicitly allowed by the policy rule.
- **[Namespace](../../GLOSSARY.md#namespace) Selector Pitfalls:** To allow traffic from another [namespace](../../GLOSSARY.md#namespace), that [namespace](../../GLOSSARY.md#namespace) *must* have the correct labels applied, and your policy must use `namespaceSelector`. If you just use `podSelector`, it only checks pods *in the same [namespace](../../GLOSSARY.md#namespace)*.

---

## 🧰 Study Toolbox

**🎨 Visualize the Analogy**
* [Explore Chapter 13 Comics](../../visual-learning/comics/ch13-networking/README.md)

**📘 Technical Deep Dive**
* [Network Isolation and Troubleshooting](../../reference/md-resources/troubleshooting-kubernetes.md#section-8-3)

**🛠️ Hands-on Practice**
* [Explore Chapter 13 Labs](../../practice/labs/ch13-networking/README.md)

---
[<< Previous: Ingress & Gateway API](ch12-ingress.md) | [Back to Story Index](../story.md) | [Next: Health Checks & Probes >>](ch14-probes.md)

---
[Mall Directory ✨](../../GLOSSARY.md)
