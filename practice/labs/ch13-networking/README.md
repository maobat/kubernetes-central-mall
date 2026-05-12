# Chapter 13: Networking - Overview

Control and secure network traffic between your Pods and Namespaces using Network Policies.

| Lab Name | Description |
| --- | --- |
| [Lab 01: Network Policies](./lab01-network-policies/README.md) | Implement NetworkPolicies to control traffic flow between Pods. |
| [Lab 02: Advanced Network Policies](./lab02-network-policies/README.md) | Practice complex scenarios with egress rules and CIDR-based filtering. |
| [Lab 03: Allow All Ingress](./lab03-allow-all-ingress/README.md) | Create a NetworkPolicy that allows all incoming traffic to all Pods in a specific namespace. |
| [Lab 04: Default Deny Ingress](./lab04-default-deny-ingress/README.md) | Implement a "Default Deny" ingress policy to lock down a namespace, and then allow a client. |
| [Lab 05: Role-Based Ingress](./lab05-role-based-ingress/README.md) | Allow ingress traffic based on specific roles (e.g., allow `frontend` but deny `backend`). |
| [Lab 06: Allow DNS Egress](./lab06-dns-egress/README.md) | Restrict a pod's egress traffic so it can only make DNS queries. |
| [Lab 07: The Phonebook Trap](./lab07-the-dns-egress-trap/README.md) | Troubleshoot why a pod can't reach another namespace due to DNS being blocked. |
| [Lab 08: Fine-Grained Access](./lab08-fine-grained-access/README.md) | Secure specific pods using label-based selectors and specific ports. |
| [Lab 09: Multiple Keys (OR Logic)](./lab09-multiple-keys-or/README.md) | Implement OR logic to allow ingress from multiple different sources. |
| [Lab 10: Double Lockdown (AND Logic)](./lab10-double-lockdown-and/README.md) | Combine namespace and pod selectors to create highly specific AND rules. |

---
[Mall Directory ✨](../../../GLOSSARY.md)
