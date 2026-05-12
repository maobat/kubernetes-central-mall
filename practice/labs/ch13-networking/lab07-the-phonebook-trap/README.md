# 🧪 LAB 07: The "Phonebook Trap" (DNS Egress)

## 🎯 Lab Goal
> **Scenario: The Silent Client**
> Fix a shop that can talk to neighbors but can't find them by name.

Diagnose and resolve a common NetworkPolicy trap where a [Pod](../../../../GLOSSARY.md#pod) is allowed to reach a specific namespace, but fails to connect because it cannot resolve the target's name via DNS (the Mall Intercom).

---

## 🛍️ Mall Analogy

In the **Central Mall**, when you want to visit a warehouse in the `prod` wing, you first need to check the **Phonebook (DNS)** to find their room number.

* **The Problem:** You have a permit to enter the `prod` wing, but you don't have a permit to call **Directory Assistance (kube-system DNS)**. 
* **The Result:** You try to call `server-svc`, but the intercom is dead. You know the warehouse exists, but you can't "resolve" where it is.
* **The Fix:** Add a permit for the intercom (Port 53) to your security badge (NetworkPolicy).

---

## 🛠️ Step-by-Step Investigation

### 1. Setup the Scene
Create the namespaces and the target server:
```bash
kubectl create ns client-ns
kubectl create ns prod

# Label the prod namespace for our policy selector
kubectl label ns prod env=prod

# Run the server in prod
kubectl run server -n prod --image=busybox:1.36 --restart=Never -- sh -c "nc -lk -p 8080"
```

### 2. The Restrictive Permit (The Trap)
Apply a policy that allows traffic to `prod` but forgets about the intercom:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-egress-prod
  namespace: client-ns
spec:
  podSelector: {} # Target all pods in client-ns
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          env: prod
```

### 3. Verify the Failure
Run a test pod and try to reach the server by its name:
```bash
kubectl run test -n client-ns --image=busybox:1.36 --restart=Never -- sleep 3600

# Try to connect (this will HANG)
kubectl exec test -n client-ns -- nc -vz server-svc.prod 8080
```
*Wait... why does it hang? The policy says we can talk to `prod`!*

### 4. Fix the Intercom
Update the policy to allow access to the Mall Phonebook (DNS on port 53):

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-egress-prod
  namespace: client-ns
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          env: prod
  - ports: # Allow the Intercom!
    - protocol: UDP
      port: 53
    - protocol: TCP
      port: 53
```

### 5. Final Verification
Apply the update and try again:
```bash
kubectl apply -f np-18.yaml

kubectl exec test -n client-ns -- nc -vz server-svc.prod 8080
# Output: server-svc.prod (10.96.x.x:8080) open
```

---

## 🧠 Key Takeaways

> [!WARNING]
> **The DNS Egress Trap**
> In the CKAD exam and real-world clusters, once you apply an `Egress` policy, **all other outgoing traffic is blocked**. This includes DNS resolution. If your pod needs to talk to a service by name, you MUST explicitly allow egress to port `53` (usually in the `kube-system` namespace).

---

## 🔗 References
- **Master Map** → [Network Policy Master Map](../../../../visual-learning/comics/ch13-networking/03-network-policy-master-map/README.md)
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
