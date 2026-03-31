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

## 🏗️ Lab Setup

Before you start, you need to build the Mall's wings (Namespaces and Pods). Run the setup script provided in this directory:

```bash
# 1. Give execution permission
chmod +x setup.sh

# 2. Run the setup
./setup.sh
```

This will create:
-   **Namespace `space2`** (The Destination).
-   **Pod `app1-0`** in `space1` (The Source worker).
-   **Pod `microservice1`** in `space2` (The Allowed Target).
-   **Pod `tester`** in `default` (The Forbidden Target).

---

## 🔍 Pre-check: Identifying the Targets
NetworkPolicies use **Labels**. To target a Namespace, we need to know its label. Since Kubernetes v1.22+, every namespace has a default label: `kubernetes.io/metadata.name`.

```bash
# Check namespace labels to verify the target wings
kubectl get ns --show-labels
```

---

## 🛠️ The Solution (egress-policy.yaml)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: space1-one-way-policy
  namespace: space1 # The policy lives where the traffic STARTS (Source)
spec:
  # *******************************************************************
  # * Egress rules
  # *******************************************************************
  podSelector: {} # Target ALL pods in Space1
  policyTypes:
  - Egress
  egress:
  # 1. Allow the Mall's Phonebook (DNS)
  - ports:
    - port: 53
      protocol: TCP
    - port: 53
      protocol: UDP
  # 2. Allow visiting Space2 wing
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: space2
```

---

## 🧪 Verification: Testing the Corridors

Test the connectivity from a worker in `space1` (`app1-0`):

```bash
# ✅ This should work (Talking to Space2)
kubectl -n space1 exec app1-0 -- curl -m 1 microservice1.space2.svc.cluster.local

# ✅ This should work (DNS Check)
kubectl -n space1 exec app1-0 -- nslookup google.com

# ❌ This should FAIL (Trying to leave the allowed corridor to 'default')
kubectl -n space1 exec app1-0 -- curl -m 1 tester.default.svc.cluster.local
```

---

## 🧠 CKAD Insights & Exam Traps

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

> **The Isolation Trap:** As soon as you define an `Egress` policy, ALL other outgoing traffic not explicitly allowed is **BLOCKED**. That is why we MUST add the DNS rule, or the Pod won't even find `space2` by name!

- **Namespace Selector vs Pod Selector:** 
  - `podSelector`: Who are we protecting/restricting in the current namespace?
  - `to.namespaceSelector`: Which other wings (Namespaces) are they allowed to visit?
- **Standard Port:** Port 53 is the standard for DNS. Don't forget both **TCP** and **UDP**!

---

## 🛠️ Tool Spotlight: The NetworkPolicy Editor
If you are struggling with YAML, the [Cilium Network Policy Editor](https://editor.networkpolicy.io/) is the "Blueprinting Tool" of the Mall.

### 🏗️ **The Mall Manager's Logic (For Dummies):**
Think of the editor like setting permissions for a **security badge**:
1.  **Select "Egress"**: You are defining where the worker is **leaving** to.
2.  **Left Side (Source)**: This is the **Room** the worker is currently standing in (`space1`).
3.  **Right Side (Destination)**: This is the **Wing** they are allowed to enter (`space2`).
4.  **Allow DNS**: This is like giving them a **Phonebook**. Without it, they can't even "search" for the address of `space2`!

---

## 🧐 **Standard K8s vs. Calico: The API Puzzle**

You might wonder: *"Why did we use `networking.k8s.io/v1` instead of something named `calico`?"*

### 1. **The Standard Blueprint (`networking.k8s.io/v1`)**
This is the **Universal Mall Regulatory Code**. Every major Kubernetes network provider (Calico, Cilium, Azure CNI, etc.) is built to understand this standard format. 
- **Pros:** Portable! This exact YAML works on Google Cloud, AWS, or your local Kind cluster.
- **CKAD Exam:** This is **exactly** what you use in the exam.

### 2. **The Calico Interpretation**
Once you install Calico, it follows these rules and creates the actual "locked doors" (using Linux `iptables` or `eBPF`) on your nodes. It acts as the **Security Agent** who reads the Mall's Regulatory Code and enforces it.

> [!NOTE]
> Calico *does* have its own advanced API (`projectcalico.org/v3`) for things like Layer 7 filtering or global policies, but for 99% of CKAD-level tasks, the standard Kubernetes version is all you need!

---

## 🔗 References
- **Study Guide** → [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md)
- **Comic** → [One-Way Corridors](../../../../visual-learning/comics/ch13-networking/02-one-way-corridors/README.md)