# 🧪 LAB 01: The Employee Badge (ServiceAccounts)

## Security – Assigning Identity to Pods

---

## 🎯 Lab Goal

Learn how Kubernetes assigns **identity** to Pods. Instead of providing user credentials, Pods use **ServiceAccounts** to prove who they are when talking to the Mall Management ([API Server](../../../../GLOSSARY.md#api-server)).

> **CKAD Importance:** High. You must know how to create and assign ServiceAccounts to ensure Pods have minimum necessary privileges.

---

## 🛍️ Mall Analogy

Every worker inside the **Central Mall** must wear an ID badge.

- **The Anonymous Badge (Default)** → If you don't give a worker a specific badge, they get a "General Guest" badge that has almost no access.
- **The Custom Badge ([ServiceAccount](../../../../GLOSSARY.md#serviceaccount))** → A badge created for a specific shop (e.g., "The Security Guard Badge").
- **The Badge Clip (Assignment)** → Clipping the badge to the worker's uniform (`spec.serviceAccountName`).
- **The Security Check ([API Server](../../../../GLOSSARY.md#api-server))** → Whenever a worker tries to enter a restricted area, the guard checks their badge to see if it's valid.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[ServiceAccount](../../../../GLOSSARY.md#serviceaccount)** | An automated identity (ID Badge) for a [Pod](../../../../GLOSSARY.md#pod). |
| **[Namespace](../../../../GLOSSARY.md#namespace)** | The wing of the mall the badge belongs to. |
| **[API Server](../../../../GLOSSARY.md#api-server)** | The security guard checking badges. |

---

## 📋 Requirements

1. **[Namespace](../../../../GLOSSARY.md#namespace)**: Create a [namespace](../../../../GLOSSARY.md#namespace) named `secure`.
2. **Badge**: Create a [ServiceAccount](../../../../GLOSSARY.md#serviceaccount) named `secure-clerk` in that [namespace](../../../../GLOSSARY.md#namespace).
3. **[Deployment](../../../../GLOSSARY.md#deployment)**: Create a [Deployment](../../../../GLOSSARY.md#deployment) named `securedeploy` using the `secure-clerk` badge.

---

## 🛠️ Step-by-Step Solution

### 1. Preparing the Wing ([Namespace](../../../../GLOSSARY.md#namespace))
```bash
k create ns secure
```

### 2. Printing the Badge ([ServiceAccount](../../../../GLOSSARY.md#serviceaccount))
```bash
k create sa secure-clerk -n secure
```

### 3. Assigning the Badge ([Deployment](../../../../GLOSSARY.md#deployment))
You can assign it directly during creation!
```bash
k create deploy securedeploy --image=nginx --port=80 -n secure --serviceaccount=secure-clerk
```

---

## 🔎 Verification

1. **Verify Assignment:**
   ```bash
   k describe deploy securedeploy -n secure | grep "Service Account"
   # Output: Service Account:  secure-clerk
   ```

2. **Check the Live [Pod](../../../../GLOSSARY.md#pod):**
   ```bash
   k get pods -n secure
   k describe pod <pod-name> -n secure | grep Account
   ```

---

## 🧠 Key Takeaways

- **Default State:** Every [namespace](../../../../GLOSSARY.md#namespace) has a `default` [ServiceAccount](../../../../GLOSSARY.md#serviceaccount) that is used if skip the assignment.
- **Auto-Mount:** Kubernetes automatically mounts a token into the [Pod](../../../../GLOSSARY.md#pod) so the application can "show" its badge to the API.
- **Security Best Practice:** Never use the `default` account for important applications. Give them their own specific identity.
- **CKAD Tip:** You can't change the [ServiceAccount](../../../../GLOSSARY.md#serviceaccount) of an existing [Pod](../../../../GLOSSARY.md#pod). You must delete the [Pod](../../../../GLOSSARY.md#pod) or update the [Deployment](../../../../GLOSSARY.md#deployment) template to trigger a rollout.

---

## 🔗 References
- **Comic** → [The Secure Badge](../../../../visual-learning/comics/ch07-identity/01-the-secure-badge/README.md)
- **Docs** → [Understanding ServiceAccounts](../../../../reference/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md)
- **Study Guide** → [Chapter 7: Identity & RBAC](../../../../sources/study-guide/ch07-identity.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
