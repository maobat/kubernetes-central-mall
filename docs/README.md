# Documentation

This folder contains the conceptual documentation for **Kubernetes Central Mall**.  
Each section explains core Kubernetes concepts using a consistent **Central Mall analogy**, with a focus on clarity, architecture, and CKAD relevance.

The documents are designed to be read sequentially, but each section is also self-contained.

---

## Contents

- [2.0 The Core Idea: Storage Decoupling](storage-decoupling.md)  
  A concise overview of the Kubernetes storage decoupling principle, explaining PersistentVolumes, PersistentVolumeClaims, and the binding process.

- [3.0 The Cast of Characters (Internal & External Components)](cast-of-characters.md)  
  A complete mapping of core Kubernetes resources to the Central Mall analogy, covering Pods, Deployments, Services, Ingress, RBAC, and Gateway components.

- [3.1 Understanding the Traffic Flow (The "Customer Journey")](traffic-flow.md)  
  A step-by-step walkthrough of how a request travels through the mall, from DNS resolution to Pod execution.

- [3.2 Diagnostic Cheat Sheet for the Cast](diagnostic-cheat-sheet.md)  
  A practical troubleshooting guide that maps common Kubernetes issues to mall characters and the `kubectl` commands used to diagnose them.

- [3.3 Gateway API: The "Smart Transit Hub"](gateway-api.md)  
  An introduction to the modern, role-oriented traffic management model that supersedes Ingress, focusing on GatewayClass, Gateway, and HTTPRoute.

- [3.4 Mall Analogy: Ingress vs. Gateway API](ingress-vs-gateway.md)  
  A side-by-side comparison highlighting the architectural and operational differences between legacy Ingress and the modern Gateway API approach.

- [3.5 Lab 6.3.3.2: Advanced Traffic Splitting](advanced-traffic-splitting.md)  
  A practical lab focused on implementing weighted traffic routing to support canary deployments and progressive delivery strategies.
- [3.6 Lab Exercise: Routing to the Oklahoma Wing](routing-to-oklahoma-wing.md)  
  A hands-on exercise guiding you through routing requests to a specific namespace using Services, Ingress, and Gateway API, simulating a real-world customer journey within the mall.
- [3.7 The "Traffic Flow" Verification](traffic-flow-verification.md)  
  A practical lab focused on implementing weighted traffic routing to support canary deployments and progressive delivery strategies.
- [4.0 The Evolution of the Service IP Tracker](service-ip-tracker-evolution.md)  
  Endpoints vs EndpointSlice.
---

## How to Use This Documentation

- Start with **Section 2.0** to understand foundational Kubernetes principles.
- Continue through **Section 3.x** to explore networking, traffic flow, and diagnostics.
- Pair these documents with the hands-on exercises in the `labs/` directory for practical learning.

This documentation is part of an evolving project and will expand as new sections and labs are added.
