# CKAD Cheatsheet & Keymap

A quick reference guide for common `kubectl` commands and exam-wording traps, split by topic.

## 📖 Index

- 🧰 **[YAML & kubectl Fundamentals](ckad-cheatsheet-fundamentals.md)**
  General commands, List vs Map in YAML, `env` vs `envFrom`.
- 🏗️ **[Workloads (Pods, Deployments, Jobs, Sidecars)](ckad-cheatsheet-workloads.md)**
  Deployment scaling, imperative Pod/Deployment creation, label and container-naming traps, multi-container and native sidecar patterns.
- 🏢 **[Namespaces, Config & Storage](ckad-cheatsheet-config-storage.md)**
  Namespaces, ConfigMaps/Secrets commands, PV/PVC.
- 🌐 **[Services & NetworkPolicy](ckad-cheatsheet-networking.md)**
  Service port mapping, layered connectivity testing, NodePort, NetworkPolicy skeleton and AND/OR selector logic.
- 🩺 **[Probes & SecurityContext](ckad-cheatsheet-security-probes.md)**
  Probe timing wording traps, SecurityContext placement (Pod vs Container).
- 🔍 **[Observability & Debugging](ckad-cheatsheet-debugging.md)**
  `kubectl describe`/`logs`/`top`/`events`, custom output with jsonpath.

## 🛠️ Related

- 🧭 **[Pod vs Container & Decision Cheat Sheet](pod-vs-container-and-decisions.md)** — field placement plus "which one should I pick" tables for workloads, probes, volumes, Services, ConfigMaps/Secrets, and RBAC.

---
[Mall Directory ✨](../../GLOSSARY.md)
