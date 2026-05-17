# 🧪 LAB 11: The Private Tunnel (Egress to Pod Selector)

## 🎯 Lab Goal
> **Scenario: The Secret Warehouse**
> Secure a shop so it can ONLY communicate with its dedicated Database Warehouse. Any attempt to talk to other shops or external services must be blocked.

Learn how to implement **Egress to Pod Selector** rules to strictly control where your pods can send data.

---

## 🛍️ Mall Analogy

In the **Central Mall**, most shops are free to call any other shop. However, for a high-security pharmacy, you want to ensure the clerk can ONLY call the **Secret Inventory Warehouse** (`app=db`).

* **The Rule:** "You can only leave through the private tunnel that leads to the inventory room."
* **The Result:** If the pharmacist tries to call a pizza delivery or another shop, the connection is instantly cut. The pharmacist is effectively "locked into" a private conversation with the warehouse.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Secure Wing
```bash
kubectl create ns egress-pod
```

### 2. Deploy the Secret Warehouse (The Target)
Start the database pod and expose it so others can find it.

```bash
# Start the Warehouse (DB)
kubectl run db -n egress-pod --image=busybox:1.36 --labels=app=db --restart=Never -- sh -c "nc -lk -p 8080"

# Expose it as a service
kubectl expose pod db --name=svc --port=8080 -n egress-pod
```

### 3. Deploy the Pharmacist (The Client)
```bash
kubectl run test -n egress-pod --image=busybox:1.36 --restart=Never -- sleep 3600
```

### 4. Apply the Private Tunnel Policy
This policy targets all pods in the namespace (`podSelector: {}`) but only allows egress to pods with the `app=db` label.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: egress-to-db
  namespace: egress-pod
spec:
  podSelector: {} # Target all pods (The Pharmacist)
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: db # Allow only to the Warehouse
    ports:
    - protocol: TCP
      port: 8080
```

Apply it:
```bash
kubectl apply -f np-22.yaml
```

### 5. Final Verification
Test if the pharmacist can reach the warehouse.

```bash
# Test connection to the Warehouse (Should succeed)
kubectl exec test -n egress-pod -- nc -vz svc 8080

# Test connection to anything else (Should fail)
# e.g., trying to reach Google or another internal service
kubectl exec test -n egress-pod -- nc -vz google.com 80
```

---

## 🧠 Key Takeaways

> [!IMPORTANT]
> **Egress Whitelisting**
> Remember that once an `Egress` policy is active, the "Default Deny" rule kicks in for all outgoing traffic. If you want your pods to still be able to resolve names (DNS), you would need to add another egress rule for Port `53` (The Phonebook), as we learned in Lab 07.

---

## 🔗 References
- **Master Map** → [Network Policy Master Map](../../../../visual-learning/comics/ch13-networking/03-network-policy-master-map/README.md)
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
