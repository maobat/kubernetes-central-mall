# 🧪 LAB 05: The Kitchen Door (Role-Based Ingress)

## Services and Networking – Network Policies

---

## 🎯 Lab Goal

Allow ingress traffic based on specific roles (e.g., allow `frontend` but deny `backend`).

---

## 🛍️ Mall Analogy

**The Kitchen Door** - The mall's restaurant kitchen. Only staff wearing the `frontend` uniform can enter, while those with the `backend` uniform are denied entry by the security guard.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Setup

First, let's create a namespace and deploy our server, frontend, and backend pods.

```shell
kubectl create ns net-secure2

# Create the backend pod (Denied Role)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    role: backend
  name: backend
  namespace: net-secure2
spec:
  containers:
  - args:
    - sleep
    - "3600"
    image: busybox:1.36
    name: backend
EOF

# Create the frontend pod (Allowed Role)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    role: frontend
  name: frontend
  namespace: net-secure2
spec:
  containers:
  - args:
    - sleep
    - "3600"
    image: busybox:1.36
    name: frontend
EOF

# Create the server pod (The Kitchen)
kubectl run server --image=busybox:1.36 -n net-secure2 --labels=app=server -- \
  sh -c "nc -lk -p 8080"

# Expose the server pod as a service
kubectl expose pod server -n net-secure2 --port=8080 --name=server-svc
```

### 2. Apply the Role-Based Policy (`allow-ingress.yaml`)

This policy allows traffic to any pod in the namespace (because `podSelector` is `{}`) ONLY if the source pod has the label `role: frontend`.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-access
  namespace: net-secure2
spec:
  podSelector: {} # Protects all pods in this namespace
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
```

Apply the policy:
```shell
kubectl apply -f allow-ingress.yaml
```

### 3. Test the Roles

Try to access the server from both the `frontend` and `backend` pods.

```shell
# Test from backend (Should FAIL / Timeout)
kubectl exec backend -n net-secure2 -- nc -vz server-svc 8080 
# command terminated with exit code 1 (or hangs)

# Test from frontend (Should SUCCEED)
kubectl exec frontend -n net-secure2 -- nc -vz server-svc 8080
# server-svc (10.96.x.x:8080) open
```

---

## 🧠 Key Takeaways
- You can use `matchLabels` in the `podSelector` within the `from` block to restrict traffic to specific roles or applications.
- Since we specified `podSelector: {}` under `spec`, this policy actually protects *all* pods in the namespace, turning the whole namespace into a default deny for anything not matching `role: frontend`.

---
## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
