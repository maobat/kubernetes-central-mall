# 🧪 LAB 09: The Multipass System (Ingress OR Logic)

## 🎯 Lab Goal
> **Scenario: The Shared Loading Dock**
> Secure a shop's entrance so that it only opens for two specific types of staff: "Frontend Clerks" OR "Admin Managers". Anyone else (like general "Other" staff) must be blocked.

Learn how to implement **OR logic** in NetworkPolicies by defining multiple separate blocks in the `from` section.

---

## 🛍️ Mall Analogy

In the **Central Mall**, some high-security areas (like the Loading Dock) have a door that accepts multiple types of keycards. 

* **Rule 1:** "If you are a **Frontend Clerk** (role=frontend), the door opens."
* **Rule 2:** "If you are an **Admin Manager** (role=admin), the door opens."
* **The Result:** If you have *either* card, you get in. If you have neither (role=others), the door stays locked. This is **OR logic**.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Multi-Rule Wing
```bash
kubectl create ns multi-rule
```

### 2. Deploy the Protected Shop
Start the server and expose it as a service.

```bash
# Start the server (The Loading Dock)
kubectl run server -n multi-rule --image=busybox:1.36 --restart=Never -- sh -c "nc -lk -p 8080"

# Expose it
kubectl expose pod server --name=svc --port=8080 -n multi-rule
```

### 3. Deploy the Staff (The Clients)
Create three different pods with different labels to test the access rules.

```bash
# Frontend Clerk
kubectl run f -n multi-rule --image=busybox:1.36 --labels=role=frontend --restart=Never -- sleep 3600

# Admin Manager
kubectl run a -n multi-rule --image=busybox:1.36 --labels=role=admin --restart=Never -- sleep 3600

# Other Staff (No allowed label)
kubectl run o -n multi-rule --image=busybox:1.36 --restart=Never -- sleep 3600
```

### 4. Apply the Multipass Policy
Notice that we use two separate `- from:` blocks. This creates an **OR** condition.

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: multi-source
  namespace: multi-rule
spec:
  podSelector: {} # Target all pods in this namespace (including the server)
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend # Condition A
    ports:
    - protocol: TCP
      port: 8080
  - from:
    - podSelector:
        matchLabels:
          role: admin # Condition B
    ports:
    - protocol: TCP
      port: 8080
```

Apply it:
```bash
kubectl apply -f np-20.yaml
```

### 5. Verification (The Stress Test)
Test connectivity from all three staff members.

```bash
# Test Frontend (Should succeed)
kubectl exec f -n multi-rule -- nc -vz svc 8080

# Test Admin (Should succeed)
kubectl exec a -n multi-rule -- nc -vz svc 8080

# Test Others (Should fail/hang)
kubectl exec o -n multi-rule -- nc -vz svc 8080
```

---

## 🧠 Key Takeaways

> [!IMPORTANT]
> **OR vs AND Logic**
> - **OR Logic**: Defined by using multiple `- from:` blocks. (e.g., "From A" OR "From B").
> - **AND Logic**: Defined by putting multiple selectors inside a *single* `- from:` block. (e.g., "From Namespace X" AND "From Pod Y"). 
> 
> Most CKAD scenarios require OR logic for allowing different types of legitimate traffic to a single backend.

---

## 🔗 References
- **Master Map** → [Network Policy Master Map](../../../../visual-learning/comics/ch13-networking/03-network-policy-master-map/README.md)
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
