# 🧪 LAB 07: The "Security Guard Strike" (CNI & NetPol)

## 🎯 Lab Goal
> **Scenario: The Silent Client**
> Fix a shop that can talk to neighbors but can't find them by name.

Diagnose and resolve complex networking issues where a [Pod](../../../../GLOSSARY.md#pod) (the client shop) fails to reach another [Service](../../../../GLOSSARY.md#service) (`svc-server`) due to internal CNI (Calico) failures or restrictive NetworkPolicies blocking essential DNS egress traffic.

---

## 🛍️ Mall Analogy

In the **Central Mall**, two types of security layers manage how shops communicate:

### 1. The CNI (Calico) = The Security & Radio Dispatch
Calico is the security team in charge of giving every new shop (Pod) a walkie-talkie (IP address) and a spot on the mall map (Routing table).
* **The Issue:** When you see a connection is `unauthorized`, it’s like the Security Dispatcher's ID badge expired.
* **The Result:** Even though the store manager (Kubelet) built the shop, the security team refused to give them a radio or unlock the doors because they couldn't verify who was asking.
* **The Fix:** By deleting the Calico pods, you effectively "reset the security office," forcing them to get new badges (tokens) from the Mall Owner (API Server).

### 2. The NetworkPolicy = The VIP Access List
The `allow-internal` policy you found is like a VIP Lounge Rule.
* **The Ingress Rule:** "Anyone already inside the VIP Lounge (the namespace) can walk up to the bar (the Server)."
* **The Hidden Egress Trap:** In Kubernetes, once you write an "Allow" rule for who can come in, the mall assumes you want to be strict. It accidentally locks the exits for the guests!
* **The Result:** The guest (Client Pod) can see the bar, but when they try to call their friend outside to ask for directions (DNS lookup to `kube-system`), the security guard at the exit stops them because "calling outside" isn't on the approved list.
* **Analogy Reference:** "The client shop is trying to call `svc-server`, but the Directory Assistance (CoreDNS) isn't picking up. Diagnostic: Check if the security guards (NetworkPolicy) have accidentally blocked the phone lines (Egress) while trying to keep the hallway private."

---

## 🛠️ The "Mall Repair" Commands

Here are the step-by-step commands to repair the Security Office and check the VIP guest list:

### 1. Reset the Security Office (Restart CNI)
Force the Calico [Node](../../../../GLOSSARY.md#node) agents to restart and fetch fresh authentication tokens:
```bash
kubectl delete pod -n kube-system -l k8s-app=calico-node
```

### 2. Check the VIP Guest List (Inspect NetworkPolicy)
Look for a NetworkPolicy that might be accidentally restricting DNS egress traffic:
```bash
kubectl describe netpol <name> -n <namespace>
```
*Look specifically for missing `Egress` rules allowing traffic to port `53` (DNS) in the `kube-system` namespace.*

### 3. Test the Intercom (Verify Connectivity)
Once the policies and CNI are repaired, verify the client can reach the server using `nc` (netcat):
```bash
kubectl exec -it client -- nc -vz svc-server 8080
```

---

## 🧠 Key Takeaways

> [!WARNING]
> **The NetworkPolicy Egress Trap**
> The most common networking trap in Kubernetes is applying a restrictive NetworkPolicy that blocks DNS. Always remember: if you lock down a namespace with a default deny policy, you **must** explicitly allow Egress to `kube-system` on port `53` (TCP/UDP) so your Pods can resolve Service names!

---

## 🔗 References
- **Comic** → [The Security Guard Strike](../../../../visual-learning/comics/ch15-debugging/07-security-guard-strike/README.md)
- **Study Guide** → [Chapter 13: Network Policies](../../../../sources/study-guide/ch13-networking.md)
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
