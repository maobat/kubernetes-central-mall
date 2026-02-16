<img src="lab01-the-secure-badge.png" alt="The Secure Badge" width="40%" />

# 🛡️ The Secure Badge

This comic explains **how identity works in Kubernetes** using the *Central Mall* analogy.  
Every Pod enters the cluster wearing a **badge**, which determines **what it is allowed to do**.

📌 Read this if:
- You are working on **LAB 01**
- You want to understand **ServiceAccounts & Pod identity**
- You want a quick **mental model** using the mall analogy 😄

🔗 References:
- Docs → [`docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md`](../docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md)  
- Lab → [`labs/security/lab01-serviceaccount-identity`](../labs/security/lab01-serviceaccount-identity/README.md)

**Key Takeaways (CKAD exam mode):**
- Pods **always inherit identity** from a ServiceAccount
- Deployments **assign the badge** to Pods
- Use `kubectl set sa deployment <name> <sa>` or `serviceAccountName` in Pod spec
- `--serviceaccount` flag works only with standalone Pods
- Verify identity with `kubectl describe pod <pod-name>`

**Pairs with Secrets Comic:** [`lab03-secrets-env-injection`](../labs/security/lab03-secrets-env-injection/README.md)
