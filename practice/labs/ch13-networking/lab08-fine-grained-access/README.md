# 🧪 LAB 08: Keycard Access (Fine-Grained Pod Selection)

## 🎯 Lab Goal
> **Scenario: The Exclusive Counter**
> Secure a specific shop so that only customers with a "VIP Label" can enter, while other shops in the same wing remain open.

Learn how to use `podSelector` to target specific pods within a namespace, rather than applying a policy to the entire wing (namespace).

---

## 🛍️ Mall Analogy

In the **Central Mall**, usually a security guard stands at the entrance of a whole wing (`namespaceSelector`). But for a high-end jewelry store, you want the guard standing **directly at the door** of that specific shop.

* **The Target:** The Jewelry Store (Pod with label `app=server`).
* **The Keycard:** Only customers with a "VIP Label" (`app=client`) are allowed in.
* **The Result:** Other shops in the same hallway are unaffected, but the Jewelry Store is locked down tight.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Fine-Grain Wing
```bash
kubectl create ns fine-grain
```

### 2. Deploy the Shops
Run a server and a client. Note that initially, they can talk to each other because there are no rules.

```bash
# Start the server
kubectl run server -n fine-grain --image=busybox:1.36 --restart=Never -- sh -c "nc -lk -p 8080"

# Expose it with a service
kubectl expose pod server --name=server-svc --port=8080 -n fine-grain

# Start the client
kubectl run client -n fine-grain --image=busybox:1.36 --restart=Never -- sleep 3600
```

### 3. Apply the Fine-Grained Policy
Create a policy that **only** targets the `server` pod and only allows traffic from pods with the `app=client` label.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: fine-grain-policy
  namespace: fine-grain
spec:
  podSelector:
    matchLabels:
      run: server # Target the server pod
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: client # Allow only "app=client"
    ports:
    - protocol: TCP
      port: 8080
```

Apply it:
```bash
kubectl apply -f np-19.yaml
```

### 4. The "Access Denied" Moment
Try to connect from the client. It will fail because the client doesn't have the `app=client` label yet!

```bash
kubectl exec client -n fine-grain -- nc -vz server-svc 8080
# (The command will hang or timeout)
```

### 5. Presenting the Keycard (Labeling)
Give the client the required "VIP" label:

```bash
kubectl label pods client -n fine-grain app=client
```

### 6. Final Verification
Now that the client has the keycard, the door opens!

```bash
kubectl exec client -n fine-grain -- nc -vz server-svc 8080
# Output: server-svc (10.96.x.x:8080) open
```

---

## 🧠 Key Takeaways

> [!TIP]
> **Label Precision**
> NetworkPolicies are "Label-Driven". If your `podSelector` doesn't exactly match the labels on your Pods, the policy either won't apply at all (leaving the shop open) or will block the wrong thing. Always use `kubectl get pods --show-labels` to verify your target.

---

## 🔗 References
- **Master Map** → [Network Policy Master Map](../../../../visual-learning/comics/ch13-networking/03-network-policy-master-map/README.md)
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
