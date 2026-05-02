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

---
[Mall Directory ✨](../../../GLOSSARY.md)
