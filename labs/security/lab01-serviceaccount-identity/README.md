# LAB 01 – Managing Security Settings (ServiceAccount)

## 🎯 Objective

Learn how Kubernetes assigns **identity** to Pods using **ServiceAccounts**.

You will:
- Create a custom ServiceAccount
- Start a Deployment using that ServiceAccount
- Verify which identity the Pod is running as

This is a **high-probability CKAD topic**.

---

## 🛍️ Mall Analogy

Every worker inside the mall must wear a **badge**.

- No badge → default access
- Custom badge → controlled identity
- The badge is checked at every secure door (API access)

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| Namespace | Mall Wing |
| ServiceAccount | Employee badge |
| Pod | Worker |
| API Server | Security gate |

---

## 📁 Lab Requirements

- Namespace: `secure`
- ServiceAccount: `secure`
- Deployment: `securedeploy`
- Image: `nginx`

---

## 🧪 Steps (CKAD-style)

### 1️⃣ Create the Namespace
```bash
kubectl create namespace secure
```

### 2️⃣ Create a Custom ServiceAccount
```bash
kubectl create serviceaccount secure -n secure
```

Verify:
```bash
kubectl get sa -n secure
```

### 3️⃣ Create a Deployment using the ServiceAccount
```bash
kubectl create deployment securedeploy \
  --image=nginx \
  --namespace=secure
```
### 4️⃣ Assign the ServiceAccount to the Deployment
```bash
kubectl set sa -n secure deploy securedeploy secure
```
**🔎 Verification:**

**Check the Pod**
```bash
kubectl get pods -n secure
```

**Inspect the Pod identity**
```bash
kubectl describe pod securedeploy-xxxxx -n secure
```
✅ **Expected result:**
```
Service Account:  secure
```

---

## 🧠 Expert Summary

- ServiceAccounts provide **identity** for Pods
- They are **namespaced**
- They are automatically mounted as **volumes** inside Pods
- They are the foundation for RBAC and authorization

### 📝 Key Takeaways (Exam Mode)

- Use `--serviceaccount` flag
- Or set `serviceAccountName` in the Pod spec
- Always verify with `kubectl describe pod`
- ServiceAccounts are **not** the same as RBAC policies

---

🛍️ *In the Kubernetes Central Mall, every worker needs the right badge to enter the right departments.*
