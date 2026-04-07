# 🧪 LAB 05: ServiceAccount Token Decode

## Identity & Access – The Magnetic ID Badge

---

## 🎯 Lab Goal

Learn how to locate the **Secret** linked to a **ServiceAccount**, extract the base64-encoded token, and decode it into a human-readable string.

---

## 🛍️ Mall Analogy

In the **Central Mall**, every specialized worker (ServiceAccount) has a digital chip in their **Magnetic ID Badge**. Sometimes, the Security Office needs to "dump" the data from that chip to verify the encrypted authorization token stored inside.

- **ServiceAccount** → The worker's ID card.
- **Secret** → The encrypted digital chip on the card.
- **Token** → The actual access code stored on the chip.

---

## 📋 Requirements & Step-by-Step

### Part 1: Local Setup

If you are running this in a local environment, you need to create the namespace and the ServiceAccount first. Since modern Kubernetes (1.24+) does not create secrets automatically for ServiceAccounts, we will create one manually.

```bash
# 1. Create the namespace
kubectl create ns neptune

# 2. Create the ServiceAccount
kubectl -n neptune create sa neptune-sa-v2

# 3. Create the Secret linked to the ServiceAccount
# Create the file with vim
vim sa-secret.yaml

# Paste the following:
apiVersion: v1
kind: Secret
metadata:
  name: neptune-sa-v2-token
  namespace: neptune
  annotations:
    kubernetes.io/service-account.name: neptune-sa-v2
type: kubernetes.io/service-account-token

# Apply the secret
kubectl apply -f sa-secret.yaml
```

---

### Part 2: Retrieve and Decode the Token

Your task is to locate the Secret linked to the ServiceAccount `neptune-sa-v2` in the `neptune` namespace, decode the token, and save it.

1. Find the Secret associated with the ServiceAccount `neptune-sa-v2`.
2. Extract the `token` from the Secret's data.
3. Decode the base64 string.
4. Save the exact decoded token string to `/tmp/token` (locally) or `/opt/course/5/token` (if in exam env).

**Solution:**

```bash
# 1. Find the Secret name using jsonpath
SECRET=$(kubectl -n neptune get sa neptune-sa-v2 -o jsonpath='{.secrets[0].name}')

# 2. Extract the base64 token and decode it
# Note: In modern K8s, if you created the secret manually, 
# you can just get it by name if you know it (e.g., neptune-sa-v2-token)
kubectl -n neptune get secret $SECRET -o jsonpath='{.data.token}' | base64 -d > /tmp/token

# 3. Verify the content
cat /tmp/token
```

---

## 🔗 References
- **Study Guide** → [Chapter 7: Identity & Access](../../../../sources/study-guide/ch07-identity.md)
- **Docs** → [Understanding ServiceAccounts](../../../../reference/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md)
