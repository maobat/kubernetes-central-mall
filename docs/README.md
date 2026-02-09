# Documentation

This folder contains the conceptual documentation for **Kubernetes Central Mall**.  
Each section explains core Kubernetes concepts using a consistent **Central Mall analogy**, with a focus on clarity, architecture, and CKAD relevance.

The documents are designed to be read sequentially, but each section is also self-contained.

---

## Contents

- [2.0 The Core Idea: Storage Decoupling](md-resources/storage-decoupling.md)  
  A concise overview of the Kubernetes storage decoupling principle, explaining PersistentVolumes, PersistentVolumeClaims, and the binding process.

- [3.0 The Cast of Characters (Internal & External Components)](md-resources/cast-of-characters.md)  
  A complete mapping of core Kubernetes resources to the Central Mall analogy, covering Pods, Deployments, Services, Ingress, RBAC, and Gateway components.

- [3.1 Understanding the Traffic Flow (The "Customer Journey")](md-resources/traffic-flow.md)  
  A step-by-step walkthrough of how a request travels through the mall, from DNS resolution to Pod execution.

- [3.2 Diagnostic Cheat Sheet for the Cast](md-resources/diagnostic-cheat-sheet.md)  
  A practical troubleshooting guide that maps common Kubernetes issues to mall characters and the `kubectl` commands used to diagnose them.

- [3.3 Gateway API: The "Smart Transit Hub"](md-resources/gateway-api.md)  
  An introduction to the modern, role-oriented traffic management model that supersedes Ingress, focusing on GatewayClass, Gateway, and HTTPRoute.

- [3.4 Mall Analogy: Ingress vs. Gateway API](md-resources/ingress-vs-gateway.md)  
  A side-by-side comparison highlighting the architectural and operational differences between legacy Ingress and the modern Gateway API approach.

- [3.5 Lab 6.3.3.2: Advanced Traffic Splitting](md-resources/advanced-traffic-splitting.md)  
  A practical lab focused on implementing weighted traffic routing to support canary deployments and progressive delivery strategies.
- [3.6 Lab Exercise: Routing to the Oklahoma Wing](md-resources/routing-to-oklahoma-wing.md)  
  A hands-on exercise guiding you through routing requests to a specific namespace using Services, Ingress, and Gateway API, simulating a real-world customer journey within the mall.
- [3.7 The "Traffic Flow" Verification](md-resources/traffic-flow-verification.md)  
  A practical lab focused on implementing weighted traffic routing to support canary deployments and progressive delivery strategies.
- [4.0 The Evolution of the Service IP Tracker](md-resources/service-ip-tracker-evolution.md)  
  Endpoints vs EndpointSlice.
- [4.1 Configuration Decoupling](md-resources/configuration-decoupling.md)  
  ConfigMaps, Secrets, Tokens.
- [4.1.1 Core Concepts](md-resources/core-concepts-configmaps-secrets-and-security.md)  
  Intro to ConfigMaps & Secrets.
- [4.1.2 ServiceAccount Secrets](md-resources/serviceaccount-secrets-for-api-access-the-trust-mechanism.md)  
  Pod → API auth.
- [4.1.3 Secrets Use Cases](md-resources/secrets-use-cases-and-application-integration.md)  
  DB, API keys.
- [4.1.4 ConfigMaps Injection](md-resources/configmaps-variables-vs-configuration-files.md)  
  Env vs files.
- [4.1.5 Lab: Full Config](md-resources/lab-comprehensive-configuration-integration.md)  
  Full setup lab.
- [4.1.6 Imperative Workflow](md-resources/lab-imperative-configuration-workflow.md)  
  kubectl → YAML.
- [4.2 API Access](md-resources/api-interaction-and-access.md)  
  API Server & proxy.
- [4.2.1 Understanding the Kubernetes API Core](md-resources/understanding-the-kubernetes-api-core.md)  
  The role of the API server as the single source of truth.
- [4.2.2 Direct API Access and \`kube-proxy\`](md-resources/direct-api-access-and-kube-proxy.md)  
  How to expose and access the API securely.
- [4.2.3 Connecting to the API via Proxy Tunnel](md-resources/connecting-to-the-api-via-proxy-tunnel.md)  
  Steps for using a local proxy to reach the API.
- [4.2.4 Using \`curl\` to Work with API Objects](md-resources/using-curl-to-work-with-api-objects.md)  
  Examples of querying the API using command line tools.
- [4.3 API Deprecations and Stability](md-resources/api-deprecations-and-stability.md)  
  Handling removed APIs and ensuring manifest file currency.
- [4.4 Authentication and Authorization (The Security Team)](md-resources/authentication-and-authorization-the-security-team.md)  
  Explaining AuthN, AuthZ, and the RBAC model.
- [4.4.1 Authentication (AuthN)](md-resources/authentication-authn.md)  
  Proving who you are (Certificates, Tokens).
- [4.4.2 Authorization (AuthZ)](md-resources/authorization-authz.md)  
  Determining what you can do (RBAC, Node, ABAC).
- [4.4.3 Understanding Role-Based Access Control (RBAC)](md-resources/understanding-role-based-access-control-rbac.md)  
  Detailed breakdown of Roles, ClusterRoles, and Bindings.
- [4.5 Understanding ServiceAccounts (The Shop's Internal Badge)](md-resources/understanding-serviceaccounts-the-shops-internal-badge.md)  
  Explaining default access, token mounting, and the need for custom SAs.
- [4.6 Implementing RBAC with Roles and Bindings (The HR Process)](md-resources/implementing-rbac-with-roles-and-bindings-the-hr-process.md)  
  Full lab demo showing forbidden access (default SA) vs. granted access (custom SA).
- [4.6.1 Defining the Custom Components](md-resources/defining-the-custom-components.md)  
  Creating the ServiceAccount, Role (Job Description), and RoleBinding (HR Assignment).
- [4.6.2 Lab: Imperative Pod and ServiceAccount Inspection](md-resources/lab-imperative-pod-and-serviceaccount-inspection.md)  
  Step-by-step commands to create a Pod via imperative dry-run and inspect its generated YAML configuration, specifically regarding the default ServiceAccount setting.
- [4.6.3 One More Example of Implementing RBAC (The HR Process)](md-resources/one-more-example-of-implementing-rbac-the-hr-process.md)
- [4.7 SecurityContext (Worker Safety & Conduct)](md-resources/securitycontext-worker-safety-and-conduct.md)  
- [4.8 Resource Requests, Limits, and Quotas (The Resource Budget)](md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)
- [4.8.1 Requests vs. Limits](md-resources/requests-vs-limits.md)
- [4.8.2 Resource Quotas (The Department Budget)](md-resources/resource-quotas.md)
- [4.8.3 Lab: Managing Resource Constraints](md-resources/lab-managing-resource-constraints.md)  
- [4.9 Lab: Managing Security Settings](md-resources/lab-managing-security-settings.md)  
- [4.9.1 Lab Objectives](md-resources/lab-objectives.md)  
- [4.9.2 Mall Analogy: The "High-Value Vault" Setup](md-resources/mall-analogy-the-high-value-vault-setup.md)  
- [4.9.3 Lab Solution & Verification](md-resources/lab-solution-and-verification.md)  
- [5.0 Storage and Logistics (Persistent & Local Data)](md-resources/storage-and-logistics-persistent-local-data.md)  
  Deep dive into PVs, PVCs, StorageClasses, and Pod volumes.
- [5.0.1 Static vs. Dynamic Provisioning](md-resources/static-vs-dynamic-provisioning.md)  
  Explains the 3-file vs. 1-file difference in storage setup.
- [5.1 Creating a PersistentVolume](md-resources/creating-a-persistentvolume.md)  
  YAML for a `hostPath` PV and how to verify its creation on the Node.
- [5.2 PVC Definition & Binding](md-resources/pvc-definition-binding.md)  
  Breakdown of the `PVC` request form and the PV/PVC matchmaking process.
- [5.3 The Role of StorageClass](md-resources/the-role-of-storageclass.md)  
  Explains Dynamic Provisioning and Static Selection using StorageClass.
- [5.3.1 The Spectrum of Storage Class Names](md-resources/the-spectrum-of-storage-class-names.md)  
  Clarifies that the name can be anything and details the three main categories (Empty, Default, Custom).
- [5.4 Access Modes: RWO vs. RWM](md-resources/access-modes-rwo-vs-rwm.md)  
  Explaining the different access capabilities of storage.
- [5.5 Lab Analysis: Shared Volume Setup](md-resources/lab-analysis-shared-volume-setup.md)  
  Comprehensive analysis of the shared volume lab exercise.
- [5.6 Decoupling Pods](md-resources/decoupling-pods.md)  
  The architecture principle behind separating application needs from storage specifics.
- [5.7 Connecting the Worker](md-resources/connecting-the-worker.md)  
  Concrete files for PV/PVC/Pod binding and usage.
- [5.8 Storage Recap for Dummies](md-resources/storage-recap-for-dummies.md)  
  A simple three-line table comparing PV, PVC, and Pod Volume lifecycles.
- [5.8.1 Dynamic Binding (1-File Approach)](md-resources/dynamic-binding-1-file-approach.md)  
  Breakdown of the Dynamic Provisioning (1-File) binding process.
- [5.8.2 Static Binding (Manual Matching)](md-resources/static-binding-manual-matching.md)  
  Breakdown of the Static Provisioning (Manual Matching) binding process.
- [6.0 Deploying Applications the DevOps Way (Helm, Kustomize, CD)](md-resources/deploying-applications-the-devops-way.md)  
  Advanced deployment strategies packaging, and lifecycle management.
- [6.1 Using the Helm Package Manager](md-resources/using-the-helm-package-manager.md)  
  Overview of Helm as the package manager.
- [6.2 Working with Helm Charts](md-resources/working-with-helm-charts.md)  
  Installing and customizing charts.
- [6.3 Core Deployment Topics](md-resources/core-deployment-topics.md)  
  Kustomize, Blue/Green, Canary, CRDs, Operators, and StatefulSets.
- [6.3.1 Using Kustomize](md-resources/using-kustomize.md)  
  Customizing YAML manifests declaratively using overlays for different environments.
- [6.3.2 Implementing Blue/Green Deployments](md-resources/implementing-bluegreen-deployments.md)  
  Zero-downtime, low-risk deployment via simultaneous stable and new environments.
- [6.3.2.1 Lab Demo Recap: Traffic Transition with Kubernetes Service](md-resources/lab-deployment-steps-full-traffic-transition-demo.md)  
  Actions executed in the terminal to demonstrate switching traffic. 
- [6.3.3 Implementing Canary Deployments](md-resources/implementing-canary-deployments.md)  
  Progressive rollout strategy releasing the new version to a small subset of users.
- [6.3.3.1 Demo Recap: Progressive Traffic Demo](md-resources/demo-recap-progressive-traffic-demo.md)  
  Gradual scaling of Stable and Canary deployments using kubectl scale to achieve controlled traffic distribution. 
- [6.3.4 Related Deployment Strategies Comparison](md-resources/related-deployment-strategies-comparison.md)  
  Comparison: Blue/Green vs. Canary Deployments
- [6.3.5 Understanding Custom Resource Definitions (CRDs)](md-resources/understanding-custom-resource-definitions-crds.md)  
  Extending the Kubernetes API with new, custom resource types.
- [6.3.5.1 Phase 1: Defining the New Permit Type (The CRD)](md-resources/phase-1-defining-the-new-permit-type-the-crd.md)  
  Defines the structure and requirements for the "Nightly Backup Service" (BackUp) permit, establishing the official ruleset that extends the Central Mall Management's capabilities. 
- [6.4 Extending K8s: CRDs & Operators](md-resources/extending-k8s-crds-operators.md)  
  Automation of complex operational tasks (backup, scaling) using CRDs and Controllers.
- [6.4.3 CRD Demo (Creating a Custom Service)](md-resources/crd-demo-creating-a-custom-service.md)  
  A step-by-step guide on defining a Custom Resource Definition (CRD) and creating a simple Controller/Operator to manage the custom resource. 
- [6.4.4 Using StatefulSets](md-resources/using-statefulsets.md)  
  Specialized workload for managing stateful applications (stable identity and storage).
- [6.4.5 Case Study: The Vault Recovery (The "Hard Way")](md-resources/lab-case-study-the-vault-recovery.md)  
  A real-world troubleshooting flow covering StatefulSet persistence, CNI network failures, and Readiness Probe unsealing.
- [6.5 Service Mesh and Security](md-resources/service-mesh-and-security.md)  
  Advanced networking and security patterns for inter-service communication.
- [6.7 Lab: Canary Deployments (The "New Recipe" Test)](md-resources/lab-canary-deployments-the-new-recipe-test.md)  
  Advanced networking and security patterns for inter-service communication.
- [7.0 The Chronicles of the Central Mall: The Full Narrative](md-resources/the-chronicles-of-the-central-mall-the-full-narrative.md)  
  The definitive epic of the Central Mall
- [8.0 Troubleshooting Kubernetes](md-resources/troubleshooting-kubernetes.md)  
  A hands-on example of using shared volumes between two containers in a single Pod.
- [9.0 Sample Exam](md-resources/sample-ckad-exam-flow.md)  
  Final practice simulation, time management, and triage.
- [10.0 The Final Simulation](md-resources/the-final-simulation.md)  
  **The Final Simulation: 15 Tasks including Sidecars, Probes, NetworkPolicy, and Canaries.**

## How to Use This Documentation

- Start with **Section 2.0** to understand foundational Kubernetes principles.
- Continue through **Section 3.x** to explore networking, traffic flow, and diagnostics.
- Pair these documents with the hands-on exercises in the `labs/` directory for practical learning.

This documentation is part of an evolving project and will expand as new sections and labs are added.
