# 📖 Chapter 6: Worker Safety & Conduct
*SecurityContexts, Capabilities, and User IDs*

In the **Central Mall**, just because you hire a clerk doesn't mean you give them the keys to the entire building. If a clerk only needs to sell shoes, they shouldn't have the "Capability" to rewire the mall's electrical grid. We use **SecurityContexts** to define exactly what an employee can and cannot do.

---

## 🎭 6.1 The Safety Gear (SecurityContext)

A **SecurityContext** defines the "Privilege" level of your worker. It ensures that if a worker is "compromised" (goes rogue), they can't do much damage to the rest of the mall.

| Safety Rule | Mall Analogy | K8s Parameter |
| :--- | :--- | :--- |
| **User ID** | Every clerk has an ID badge. | `runAsUser` |
| **Non-Root** | No clerk should be the "Owner" of the mall. | `runAsNonRoot` |
| **Read-Only** | The clerk can see the manual, but can`t draw in it. | `readOnlyRootFilesystem` |
| **Capabilities** | Specialized tools (e.g., only the plumber can touch pipes). | `capabilities` |



---

## 🛠️ 6.2 The Blueprint: Setting the Rules

You can set safety rules for the **entire shop** (Pod level) or for **individual workers** (Container level).

### 1. The Shop-Wide Rules
Everyone in this shop must wear an ID badge (User 1000).

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-shop
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
  containers:
  - name: clerk
    image: nginx
```

### 2. The Specialized Tool (Capabilities)
By default, workers are "unskilled" in system tasks. If a clerk needs to change the "System Time" (a specialized tool), we must explicitly give it to them.

```yaml
spec:
  containers:
  - name: technician
    image: fedora
    securityContext:
      capabilities:
        add: ["SYS_TIME"]
        drop: ["CHOWN"] # Taking away the ability to change file owners
```



---

## 🛠️ The Blueprint (CKAD Speed-Run)

In the exam, you often have to "harden" a Pod. This usually means adding these three lines to an existing YAML:

### 1. Hardening Checklist
* **Disallow Root:** `runAsNonRoot: true`
* **Specific User:** `runAsUser: 1000`
* **Lock Filesystem:** `readOnlyRootFilesystem: true`

### 2. Testing Conduct
How do you check which user the clerk is actually running as?
```bash
kubectl exec secure-shop -- id
```

---

## 🧰 Study Toolbox

* �️ **Comic:** [The Secure Badge - Pod Identity](../../comics/security/01-the-secure-badge/README.md)
* 🧪 **Lab:** [Lab 01 - Managing Security Settings](../../labs/security/lab01-serviceaccount-identity/README.md)
* � **Doc:** [Worker Safety and Conduct (SecurityContexts)](../../docs/md-resources/securitycontext-worker-safety-and-conduct.md)
