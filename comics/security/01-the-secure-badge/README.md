<img src="lab01-the-secure-badge.png" alt="The Secure Badge" width="40%" />

# 🛡️ The Secure Badge

This comic explains **how identity works inside Kubernetes** using the *Central Mall* analogy.

Every Pod enters the cluster wearing a **badge** — and that badge determines **what it is allowed to do**.

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
> If a Pod can access something — it’s because of its **ServiceAccount**, not magic.

---

## 🧪 Lab Connection

📌 This comic is tightly coupled with:

- 📖 **Docs:**  [`docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md`](../docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md)

- 🧪 **Lab:** [`lab01-serviceaccount-identity`](../labs/security/lab01-serviceaccount-identity/README.md)

In the lab you learn how to:
- Create a custom ServiceAccount
- Assign it to a Deployment
- Verify which identity Pods are running with

---

## ⚙️ Key Takeaways (CKAD Exam Mode)

- **Pods don’t choose permissions** — they inherit them
- **ServiceAccounts define Pod identity**
- To assign a ServiceAccount to Pods created by a Deployment:

### ✅ Imperative (fast & exam-safe)
```bash
kubectl set sa deployment securedeploy secure -n secure
```

### ✅ Declarative (exam-safe)
```yaml 
spec:
  template:
    spec:
      serviceAccountName: secure
```

⚠️ About --serviceaccount

- Works only with standalone Pods
- Example:
```bash
kubectl run securepod --image=nginx --serviceaccount=secure -n secure
```
- ❌ **Not valid** for `kubectl create deployment`

---
🔐 How This Aligns with the Secrets Lab
This comic pairs directly with:
- 🤫 Secrets Comic: The Secret of the High-Security Vault [`lab03-secrets-env-injection`](../labs/security/lab03-secrets-env-injection/README.md)

### The combined security story:

1. 🛡️ **ServiceAccounts** decide **who you are**
2. 🤫 **Secrets** decide **what sensitive data you receive**
3. 🔗 **RBAC** (later) decides **what actions you’re allowed to perform**

> Identity first → permissions second → data access last

**📖 References**
- 📖 **Docs:** [`docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md`](../docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md)
