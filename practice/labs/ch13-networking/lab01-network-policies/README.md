# 🧪 LAB 01: Locked Corridors (Network Policies)

## Services and Networking – Securing Internal Traffic

---

## 🎯 Lab Goal

Lock down the mall's internal corridors using **NetworkPolicies**. You will ensure that only the "Cashier" room (Service) can communicate with the "Bank Vault" (Pod).

---

## 🛍️ Mall Analogy

In the **Central Mall**, some corridors are "Staff Only". 

- **The Cashier Pod** → Only this group is allowed to use the specialized tube to the vault.
- **The Security Door (NetworkPolicy)** → A rule that says: "Reject all traffic to the Vault unless it has the label `role=cashier`."

---

## 🛠️ Step-by-Step Solution

### 1. Create the Locked Corrido (ingress-policy.yaml)
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: vault-policy
spec:
  podSelector:
    matchLabels:
      app: vault
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: cashier
```

---

## 🧠 Key Takeaways

> [!CAUTION]
> **CNI Support Requirement:** NetworkPolicies are not enforced by Kubernetes itself; they require a **CNI Plugin**.
> - **In the Exam:** The CKAD environment always uses a CNI that supports NetworkPolicies (usually Calico).
> - **In this Lab (Local):** 
>   - **Kind:** Uses `kindnet` by default, which **does not** support NetworkPolicies. 
>   - **Minikube:** You can easily enable support by starting with: `minikube start --cni calico`.
>
> **How to fix Kind locally (Using the `kind` CLI):**
> 1. Create a `kind-config.yaml`:
>    ```yaml
>    kind: Cluster
>    apiVersion: kind.x-k8s.io/v1alpha4
>    networking:
>      disableDefaultCNI: true
>    ```
> 2. Recreate the cluster: 
>    ```bash
>    # ⚠️ NOTE: Use the 'kind' command, NOT 'kubectl' or 'k'!
>    kind create cluster --config kind-config.yaml
>    ```
> 3. Install Calico: 
>    ```bash
>    kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
>    ```

-   **Isolation Strategy:** The moment you select a Pod in a `NetworkPolicy`, it becomes "Isolated" for that traffic type. If it's an Ingress policy, all unwhitelisted incoming traffic is blocked!
-   **Label-Based Security:** NetworkPolicies rely heavily on labels. Always double-check your `matchLabels`!

---
## 🛠️ Tool Spotlight: The NetworkPolicy Editor
If you are struggling with YAML, the [Cilium Network Policy Editor](https://editor.networkpolicy.io/) is the "Blueprinting Tool" of the Mall.

## 🏗️ **The Mall Manager's Logic (For Dummies):**
Think of the policy like setting permissions for a **security badge**:
1.  **Select "Ingress"**: You are defining who is **entering** the room.
2.  **Left Side (Source)**: This is the **Room** where the visitor is coming from (`cashier`).
3.  **Right Side (Destination)**: This is the **Room** they are trying to enter (`vault`).

---

## 🧐 **Standard K8s vs. Calico: The API Puzzle**

You might wonder: *"Why did we use `networking.k8s.io/v1` instead of something named `calico`?"*

### 1. **The Standard Blueprint (`networking.k8s.io/v1`)**
This is the **Universal Mall Regulatory Code**. Every major Kubernetes network provider (Calico, Cilium, Azure CNI, etc.) is built to understand this standard format. 
- **Pros:** Portable! This exact YAML works on Google Cloud, AWS, or your local Kind cluster.
- **CKAD Exam:** This is **exactly** what you use in the exam.

### 2. **The Calico Interpretation**
Once you install Calico, it follows these rules and creates the actual "locked doors" (using Linux `iptables` or `eBPF`) on your nodes. It acts as the **Security Agent** who reads the Mall's Regulatory Code and enforces it.

---

## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)
- **Comic** → [Locked Corridors](../../../../visual-learning/comics/ch13-networking/01-locked-corridors/README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
