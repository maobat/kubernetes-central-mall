# 🧪 LAB 02: The Magnetic ID Badge (RBAC)

## Identity & Access – Defining Permissions

---

## 🎯 Lab Goal

Learn how to control *what* a worker can do inside the mall. You will create a ServiceAccount, bind it to a Role with specific permissions, and verify that a Pod can only perform actions allowed by its assigned "magnetic ID badge."

> **CKAD Importance:** Critical. RBAC is a core security topic. You must be able to create Roles and RoleBindings to solve security tasks.

---

## 🛍️ Mall Analogy

In the **Central Mall**, just having a badge (ServiceAccount) isn't enough. You need permission to open specific doors.

- **The Stock Clerk Badge (ServiceAccount)** → A new identity for our inventory team.
- **The Stockroom Rules (Role)** → A rulebook that says: "Whoever has this badge can READ the inventory (Pods) but cannot CHANGE the prices (Services)."
- **The Magnetic Clip (RoleBinding)** → Attaching the rules to the badge. Without the clip, the badge is just a piece of plastic with no power.
- **The Security Drill (auth can-i)** → Testing the badge against a door without actually sending a worker there.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **ServiceAccount** | The person's identity. |
| **Role** | The specific permissions (verbs + resources). |
| **RoleBinding** | The link that gives an identity its permissions. |

---

## 📋 Requirements

1. **Identity**: Create a ServiceAccount named `stock-clerk`.
2. **Permissions**: Create a Role named `pod-reader` that allows `get, list, watch` on Pods.
3. **The Link**: Create a RoleBinding named `stock-clerk-binding`.
4. **Test**: Deploy a Pod named `api-tester` and verify its limited access.

---

## 🛠️ Step-by-Step Solution

### 1. Printing the Badge (SA)
```bash
k create sa stock-clerk
```

### 2. Writing the Rulebook (Role)
```bash
k create role pod-reader --verb=get,list,watch --resource=pods
```

### 3. Clipping the Rules (Binding)
```bash
k create rolebinding stock-clerk-binding --role=pod-reader --serviceaccount=default:stock-clerk
```

### 4. Running a Drill (Optional but Recommended)
```bash
k auth can-i list pods --as=system:serviceaccount:default:stock-clerk
# Should say: yes
```

### 5. Hiring the Worker (Pod)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: api-tester
spec:
  serviceAccountName: stock-clerk
  containers:
  - name: tester
    image: bitnami/kubectl:latest
    command: ["sleep", "3600"]
```

---

## 🔎 Verification

1. **Inside the Shop:**
   ```bash
   # Try to list pods (Should Succeed)
   k exec api-tester -- kubectl get pods
   
   # Try to list services (Should Fail)
   k exec api-tester -- kubectl get services
   ```

2. **Check Forbidden Message:**
   The error should explicitly mention that the `stock-clerk` cannot list services because of RBAC policies.

---

## 🧠 Key Takeaways

- **Least Privilege:** Always give workers the minimum power they need to do their job.
- **Verbs & Resources:** Roles are built from actions (`get`, `list`, `delete`) and objects (`pods`, `secrets`, `nodes`).
- **Authorization Flow:** SA identifies the worker; RBAC decides if they can enter the room.
- **CKAD Tip:** In the exam, use `k create role --help` to quickly see the syntax for resources and verbs.

---

## 🔗 References
- **Comic** → [The Secure Badge](../../../../visual-learning/comics/ch07-identity/01-the-secure-badge/README.md)
- **Docs** → [RBAC Identity](../../../../reference/md-resources/managing-identity-and-access-the-mall-pass-system.md)
- **Study Guide** → [Chapter 7: Identity & Access](../../../../sources/study-guide/ch07-identity.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
