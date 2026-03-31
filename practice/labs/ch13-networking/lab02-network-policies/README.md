# 🧪 LAB 02: One-Way Corridors (Namespace Egress)

## Services and Networking – Egress Rules & Namespace Isolation

In the **Central Mall**, a **NetworkPolicy** is a security protocol for the corridors. By default, every worker can talk to anyone in any wing (Namespace). This lab creates a "One-Way Corridor" from **Space1** to **Space2**, demonstrating how to restrict outgoing traffic (**Egress**) using Namespace selectors and handling **DNS** exceptions.

---

## 🎭 The Story: The One-Way Corridor

### 🎬 Panel 1 – The Wild West

**Worker A (Space1):** "I'm going to the Default Wing for lunch!"

**Worker B (Space2):** "I'm calling Space1 to check inventory!"
> **NOTE** > By default, all Pods can talk to all Pods (Non-isolated) across the entire cluster.

### 🎬 Panel 2 – The New Protocol
**Manager:** "New rule! If you are in Space1, you can ONLY walk to Space2. Nowhere else."
**Worker A:** "But what if I need to use the Phonebook (DNS)?"
**Manager:** "Fine. DNS calls are allowed, but that's it."

### 🎬 Panel 3 – The Firewall
**Security Guard (NetworkPolicy):** "Halt! You're from Space1 trying to reach 'Default'? Denied. Go to Space2 or stay put."
> [!IMPORTANT]
> **Egress** rules restrict outgoing traffic. Once an Egress policy is applied to a Pod, all other outgoing traffic is blocked by default (Isolation).

---

## 🎯 Lab Objectives
Restrict all Pods in the `space1` namespace so they can only send traffic to `space2`. 
- **Rule 1:** Allow Egress to all Pods in Namespace `space2`.
- **Rule 2:** Allow Egress for DNS (Port 53 TCP/UDP) so they can still resolve internal Mall addresses.
- **Note:** Incoming traffic (Ingress) remains untouched in this lab.

---

## 🔍 Pre-check: Identifying the Targets
NetworkPolicies use **Labels**. To target a Namespace, we need to know its label. Since Kubernetes v1.22+, every namespace has a default label: `kubernetes.io/metadata.name`.

```bash
# Check namespace labels to verify the target wings
kubectl get ns --show-labels
```

---

## 🛠️ The Solution (Two-Step Process)

For the CKAD exam, the best way to build a NetworkPolicy is to generate a **Skeleton Blueprint** first and then add the specific rules manually.

### 🏁 Step 1: Generate the Skeleton
Run this command to create the initial file:
```bash
kubectl create networkpolicy space1-policy --namespace space1 --dry-run=client -o yaml > egress-policy.yaml
```

### ✍️ Step 2: Add the "Missing Pieces"
Now, open `egress-policy.yaml` and manually add the **Egress** rules under `.spec`. 

1.  Set `policyTypes: ["Egress"]`
2.  Add the `egress:` section for **DNS** and **Space2**.

**The Final Manifest should look like this:**
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: space1-policy
  namespace: space1
spec:
  # *******************************************************************
  # * Egress rules
  # *******************************************************************
  podSelector: {} # Target ALL pods in Space1
  policyTypes:
  - Egress
  egress:
  # Missing Piece A: Allow DNS (Port 53)
  - ports:
    - port: 53
      protocol: TCP
    - port: 53
      protocol: UDP
  # Missing Piece B: Allow visiting Space2 wing
  - to:
     - namespaceSelector:
        matchLabels:
         kubernetes.io/metadata.name: space2
  # *******************************************************************
  # * End of Egress rules
  # *******************************************************************
```

---

## 🧪 Verification: Testing the Corridor

**✅ These should work:**
```bash
# Visit Space2 (Allowed)
kubectl -n space1 exec app1-0 -- curl -m 1 microservice1.space2.svc.cluster.local

# Check the Phonebook (Allowed)
kubectl -n space1 exec app1-0 -- nslookup google.com
```

**❌ These should FAIL:**
```bash
# Try to visit the Default wing (Blocked!)
kubectl -n space1 exec app1-0 -- curl -m 1 tester.default.svc.cluster.local
```

---

## 🧠 CKAD Insights & Exam Traps

> **The Isolation Trap:** As soon as you define an `Egress` policy, ALL other outgoing traffic not explicitly allowed is **BLOCKED**. That is why we MUST add the DNS rule, or the Pod won't even find `space2` by name!

- **Namespace Selector vs Pod Selector:** 
  - `podSelector`: Who are we protecting/restricting in the current namespace?
  - `to.namespaceSelector`: Which other wings (Namespaces) are they allowed to visit?
- **Standard Port:** Port 53 is the standard for DNS. Don't forget both **TCP** and **UDP**!

---

## 🛠️ Tool Spotlight: The NetworkPolicy Editor
If you are struggling with YAML, the [Cilium Network Policy Editor](https://editor.networkpolicy.io/) is the "Blueprinting Tool" of the Mall.

### **How to use it for this Lab:**
1.  **Select "Egress"** on the right side.
2.  **Left Side (Source):** Set Namespace to `space1`.
3.  **Right Side (Destination):** 
    - Click **"Add Rule"** -> **"To Namespaces"**.
    - Set Label to `kubernetes.io/metadata.name = space2`.
    - Click **"Add Rule"** -> **"To Entities"** -> Select **"DNS"** (or manually add Port 53).

---

## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)
- **Comic** → [One-Way Corridors](../../../../visual-learning/comics/ch13-networking/02-one-way-corridors/README.md)