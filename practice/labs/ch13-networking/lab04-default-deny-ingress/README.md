# 🧪 LAB 04: The VIP Lounge Lockdown (Default Deny & Allow Client)

## Services and Networking – Network Policies

---

## 🎯 Lab Goal

Implement a "Default Deny" ingress policy to lock down a namespace, and then introduce a specific policy to allow a client access.

---

## 🛍️ Mall Analogy

**The VIP Lounge Lockdown** - First, the manager locks the doors completely (Default Deny). Everyone is blocked from entering. Then, they issue a specific VIP badge allowing only one specific guest (`run: client`) to enter.

---

## 🛠️ Step-by-Step Solution

### 1. Setup the Namespace and Client
```shell
kubectl create ns net-secure1

# Deploy the Client pod
kubectl run client -n net-secure1 --image=busybox:1.36 --restart=Never --labels=run=client -- sleep 3600
```

### 2. Implement "Default Deny" (`np-1.yaml`)

This policy locks down the entire namespace.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: net-secure1
spec:
  podSelector: {} # Targets ALL pods in the namespace
  policyTypes: 
  - Ingress
  # Notice there is no "ingress:" section! This means NO ingress is allowed.
```

Apply the policy and deploy the server:
```shell
kubectl apply -f np-1.yaml

# Deploy the Server pod (the VIP Lounge)
kubectl run server -n net-secure1 --image=busybox:1.36 --restart=Never --labels=app=server -- \
  sh -c "while true; do nc -l -p 8080; done"

# Expose the server pod as a service
kubectl expose pod server -n net-secure1 --port=8080 --name=server-svc
```

### 3. Test the Lockdown

Try to access the server. The connection should **fail** (timeout) because of the default deny policy.

```shell
kubectl exec client -n net-secure1 -- nc -vz server-svc 8080
```

### 4. Grant VIP Access (`allow-ingress.yaml`)

Now, we introduce a new policy that grants access specifically to the client.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-client-access
  namespace: net-secure1
spec:
  podSelector:
    matchLabels:
      app: server
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          run: client
    ports:
    - protocol: TCP
      port: 8080
```

Apply the new policy:
```shell
kubectl apply -f allow-ingress.yaml
```

### 5. Test Access Again

Now the client should be able to connect!

```shell
# Verify policies
kubectl get netpol -n net-secure1

# Test connection
kubectl exec client -n net-secure1 -- nc -vz server-svc 8080
# Output should show: server-svc (10.96.x.x:8080) open
```

---

## 🧠 Key Takeaways
- **Default Deny** is a best practice. It ensures that no traffic is allowed unless explicitly whitelisted.
- Network Policies are additive. Even if a `default-deny` policy is in place, creating an explicit `allow` policy will override the denial for that specific traffic.

---
## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
