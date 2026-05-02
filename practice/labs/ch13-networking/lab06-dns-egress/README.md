# 🧪 LAB 06: The Intercom System (Allow DNS Egress)

## Services and Networking – Network Policies

---

## 🎯 Lab Goal

Restrict a pod's egress traffic so it can only make DNS queries.

---

## 🛍️ Mall Analogy

**The Intercom System (Phonebook only)** - A worker is isolated in a room. They cannot leave or communicate with the outside world, EXCEPT to look up names in the Mall's internal intercom directory (DNS). If they try to call outside (e.g., Google), the call is blocked.

---

## 🛠️ Step-by-Step Solution

### 1. Setup the Test Pod
First, let's create a namespace and a test pod.

```shell
kubectl create ns net-secure3

# Create the test pod
kubectl run test-pod -n net-secure3 --image=busybox:1.36 --restart=Never -- sleep 3600
```

### 2. Apply the DNS Egress Policy (`np-3.yaml`)

This policy targets all pods in the namespace. It sets the `policyTypes` to `Egress`, which means it blocks all outgoing traffic by default. Then, it explicitly allows only traffic to port 53 (TCP and UDP), which is used for DNS.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-egress
  namespace: net-secure3
spec:
  podSelector: {} # Target all pods
  policyTypes:
  - Egress
  egress:
  - to:
    ports: # Allow DNS (Port 53)
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53
```

Apply the policy:
```shell
kubectl apply -f np-3.yaml
```

### 3. Test DNS Resolution and External Access

First, test if the pod can resolve a name inside the cluster using `nslookup`. This should work because DNS is allowed.

```shell
kubectl exec test-pod -n net-secure3 -- nslookup kubernetes.default 

# Expected Output:
# Server:		10.96.0.10
# Address:	10.96.0.10:53
```

Now, try to reach the outside world. Since we ONLY allowed DNS (port 53) and nothing else, downloading a webpage on port 80 or 443 should fail.

```shell
kubectl exec test-pod -n net-secure3 -- wget -qO- http://google.com
# The command will hang and eventually timeout because HTTP (port 80) is blocked.
# Use ^C to cancel if needed.
```

---

## 🧠 Key Takeaways
- Egress policies isolate outgoing traffic. Once an `Egress` policy applies to a pod, ALL other egress traffic is dropped unless whitelisted.
- If you apply an egress policy to allow communication to another pod but forget to include DNS (port 53), your pod won't be able to resolve the other pod's domain name, effectively breaking the communication anyway! Always remember the "Phonebook".

---
## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
