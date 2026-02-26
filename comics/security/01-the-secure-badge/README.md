<img src="lab01-the-secure-badge.png" alt="The Secure Badge" width="40%" />

# 🛡️ The Secure Badge

This comic explains **how identity works in Kubernetes** using the *Central Mall* analogy.  
Every Pod enters the cluster wearing a **badge**, which determines **what it is allowed to do**.

📌 Read this if:
- You are working on **[LAB 01](/labs/security/lab01-serviceaccount-identity/README.md)**.
- You want to understand **ServiceAccounts & Pod identity**
- You want a quick **mental model** using the mall analogy 😄

---

## 🎯 What This Comic Explains

- Why **every Pod always has an identity**
- What the **default ServiceAccount** really represents
- How **Deployments assign identity to Pods**
- Why ServiceAccounts are a **security boundary**
- Why Pods **cannot choose or change permissions themselves**

> 🛍️ *Pods don’t ask for access, they wear the badge they’re given.*

---

## 🧠 CKAD Mental Model

- **ServiceAccounts = identity**
- **Pods inherit identity at creation time**
- **Deployments decide which badge Pods wear**
- Permissions are attached to the **badge**, not the Pod

In exam terms:
> If a Pod can access something, it’s because of its **ServiceAccount**, not magic.

---
# 🔐 How This Aligns with the Secrets Lab

This comic pairs directly with:

- 🤫 **Secrets Comic:** The Secret of the High-Security Vault
🧪 **Lab:** [`lab03-secrets-env-injection`](/labs/security/lab03-secrets-env-injection/README.md)

**The combined security story:**

1. 🛡️ **ServiceAccounts** decide who you are
2. 🤫 **Secrets** decide what sensitive data you receive
3. 🔗 **RBAC** (later) decides what actions you’re allowed to perform

> Identity first → permissions second → data access last

This is exactly how Kubernetes security is designed, and how CKAD expects you to reason.

---
🔗 **References:**
- **Docs** → [`docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md`](../../../docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md)  
- **Lab** → [`labs/security/lab01-serviceaccount-identity`](../../../labs/security/lab01-serviceaccount-identity/README.md)

**Key Takeaways (CKAD exam mode):**
- Pods **always inherit identity** from a ServiceAccount
- Deployments **assign the badge** to Pods
- Use `kubectl set sa deployment <name> <sa>` or `serviceAccountName` in Pod spec
- `--serviceaccount` flag works only with standalone Pods
- Verify identity with `kubectl describe pod <pod-name>`

**Pairs with Secrets Comic:** [`lab03-secrets-env-injection`](/labs/security/lab03-secrets-env-injection/README.md)

---

## 🔗 References
- Chapter → [Chapter 7: Identity & RBAC](../../../sources/study-guide/ch07-identity.md)
