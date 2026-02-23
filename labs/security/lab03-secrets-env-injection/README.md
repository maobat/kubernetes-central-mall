# LAB 03 – Using Secrets to Inject Sensitive Configuration

## Security – Secrets & Environment Variables

   

---

## 🎯 Lab Goal

This lab demonstrates how to:
- Store sensitive data using a **Kubernetes Secret**
- Inject secret values into a **Deployment** as environment variables
- Safely configure an application without hardcoding credentials

This is a **high-probability CKAD topic**.

---

## 📖 Related Comic
👉 [comics/secrets/01-secrets-injection/README.md](../../../comics/secrets/01-secrets-injection/README.md)

It explains **Secrets, Deployment, and Environment Variable Injection** in a CKAD-friendly way.

---

## 📘 Reference Docs

- Core Concepts: ConfigMaps & Secrets → [`docs/md-resources/core-concepts-configmaps-secrets-and-security.md`](../../../docs/md-resources/core-concepts-configmaps-secrets-and-security.md)

- Secrets: Use Cases & Application Integration → [`docs/md-resources/secrets-use-cases-and-application-integration.md`](../../../docs/md-resources/secrets-use-cases-and-application-integration.md) 

---

## 📋 Requirements

1. Create a **Deployment** named `secretlab`
   - Image: `mariadb`
2. Create a **Secret** named `supersecret`
   - Key: `ROOT_PASSWORD`
   - Value: `password`
3. Ensure the Deployment receives:
   - `MARIADB_ROOT_PASSWORD=password`

---

## 🏬 Mall Analogy

We are opening a **high-security vault** in the mall.

The password:
- Must be stored in a **locked safe**
- Must be handed to staff **without writing it on the wall**

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| **Secret** | Locked safe with a combination |
| **Deployment** | Vault control room |
| **Env Variable Injection** | Secure whisper to staff |
| **MARIADB_ROOT_PASSWORD** | Master vault code |

---

## 🛠️ Solution
```bash
kubectl create deployment secretlab --image=mariadb
```

### 2️⃣ Create the Secret
```bash
kubectl create secret generic supersecret \
  --from-literal=ROOT_PASSWORD=password
```

Verify it exists:

```bash
kubectl get secret supersecret
```
### 3️⃣ Inject the Secret into the Deployment

```bash
kubectl set env deployment/secretlab \
  --from=secret/supersecret \
  --prefix=MARIADB_
```
This produces:
```nginx
ROOT_PASSWORD  →  MARIADB_ROOT_PASSWORD
```
Exactly what MariaDB expects.

## 🔎 Verification
### Check the Environment Variable
```bash
kubectl exec deploy/secretlab -- env | grep MARIADB
```

✅ **Expected result:**

```
ROOT_PASSWORD=password
```
## 🧠 Expert Summary

- Secrets decouple **sensitive data** from application manifests
- Prefixing allows clean mapping to application-specific variables
- No passwords are stored in YAML or images
- This pattern is **CKAD gold**

### 📝 Key Takeaways (Exam Mode)

- Prefer `kubectl create secret generic`
- Use `kubectl set env --from=secret`
- Know application-specific env variable names
- Never hardcode secrets into Deployments