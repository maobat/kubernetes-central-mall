# 🏙️ The Central Mall: A CKAD Adventure
> **Narrative Guide:** Master the Certified Kubernetes Application Developer (CKAD) exam through the story of a bustling urban mall.

---

## 🗺️ Welcome to the Grand Opening
In this journey, you aren't just an engineer; you are the **Mall Architect**. You will hire staff (Pods), define their conduct (SecurityContext), set up their intercoms (Services), and manage the warehouse (Storage).

**How to use this guide:**
1. **Read the Chapter:** Build the mental model.
2. **Consult the Study Guide:** Get the technical theory.
3. **Open the Toolbox:** Practice with Labs and visualize with Comics.

**🎭 Before you start:**
- 🖼️ [Comic: The Grand Ensemble – Full Cast of Characters](./../visual-learning/comics/ch00-introduction/01-the-cast-of-characters/README.md)


---

## 🏗️ Part 1: Application Design and Build `[ 20% ]`
> **Focus:** Understanding the core blueprints of the mall, how we hire staff, organize departments, and deploy our "mannequin" images.

### 📖 Chapter 1: [Choosing the Right Workload](./story/ch01-choosing-the-right-workload.md) 
Deciding between a Shop Clerk (**Pod**), a Manager (**Deployment**), or specialized crews (**Jobs/CronJobs**).

**⚡ Study Guide:** [Workloads & Contracts](./study-guide/ch01-workloads.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 1 Comics](./../visual-learning/comics/ch01-workloads/README.md)

**📘 Technical Deep Dive**
* [Using StatefulSets - The Bolted-Down Safe](./../reference/md-resources/using-statefulsets.md)

**🛠️ Hands-on Practice**
* [Lab 01 - Jobs & CronJobs](./../practice/labs/ch01-workloads/lab01-jobs-cronjobs/README.md)
* [Lab 02 - StatefulSets](./../practice/labs/ch01-workloads/lab02-statefulsets/README.md)
* [Lab 03: Floor Security (DaemonSets)](./../practice/labs/ch01-workloads/lab03-daemonsets/README.md)
* [Lab 04: Automated Tasks (Countdown & Reports)](./../practice/labs/ch01-workloads/lab04-automated-tasks-countdown/README.md)

---

### 📖 Chapter 2: [Multi-container Design Patterns](./story/ch02-multi-container-design-patterns.md)
The Clerk and their Helper (**Sidecar** and **Init Containers**).

**⚡ Study Guide:** [Sidecars & Helpers](./study-guide/ch02-multi-container.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 2 Comics](./../visual-learning/comics/ch02-multi-container/README.md)

**📘 Technical Deep Dive**
* [Decoupling Pods](../reference/md-resources/decoupling-pods.md)

**🛠️ Hands-on Practice**
* [Sidecar & InitContainers](./../practice/labs/ch02-multi-container/lab01-sidecar-pattern/README.md)
* [Warehouse (PV/PVC)](./../practice/labs/ch02-multi-container/lab02-pv-pvc/README.md)
* [Shared Volumes (emptyDir)](./../practice/labs/ch02-multi-container/lab03-shared-volumes-empty-dir/README.md)
* [NFS Shared Volumes](./../practice/labs/ch02-multi-container/lab04-nfs-shared-volumes/README.md)

---

### 📖 Chapter 3: [Images & Modifications: The Perfect "Mannequin"](./story/ch03-images-and-modifications.md)
Mastering the art of building and updating your store's display models (**Docker/OCI Images**).

**⚡ Study Guide:** [Pod Design & Images](./study-guide/ch03-pod-design.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 3 Comics](./../visual-learning/comics/ch03-images/README.md)

**📘 Technical Deep Dive**
* [Managing Images & Rollouts](../reference/md-resources/managing-container-images-and-rollouts.md)

**🛠️ Hands-on Practice**
* [Build Container from Scratch](./../practice/labs/ch03-images/lab01-build-container-from-scratch/README.md)
* [Dockerfile & Local Registry](./../practice/labs/ch03-images/lab02-dockerfile-args-registry/README.md)
* [Image Updates & Rollouts](./../practice/labs/ch03-images/lab03-image-updates/README.md)
* [Custom Nginx & Docker Hub](./../practice/labs/ch03-images/lab04-custom-nginx-image/README.md)

---

### 📖 Chapter 4: [Extending the Mall: Special Permits](./story/ch04-extending-the-mall.md)
Hiring external contractors and obtaining special building permits (**CRDs & Operators**).

**⚡ Study Guide:** [Extending K8s](./study-guide/ch04-extending-k8s.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 4 Comics](./../visual-learning/comics/ch04-extending/README.md)

**📘 Technical Deep Dive**
* [Extending K8s with CRDs](../reference/md-resources/extending-k8s-crds-operators.md)

**🛠️ Hands-on Practice**
* [Shopping Items CRD](./../practice/labs/ch04-extending/lab01-crd-install/README.md)
* [Nightly Backup Permit](./../practice/labs/ch04-extending/lab02-crd-custom-backup-service/README.md)
* [CRD Discovery & Auditing](./../practice/labs/ch04-extending/lab03-crd-discovery/README.md)
* [Operators & Helm Packages](./../practice/labs/ch04-extending/lab04-operators-helm/README.md)
* [Backup Service Audit](./../practice/labs/ch04-extending/lab05-backup-audit/README.md)
* [Shopping Charter (Beta)](./../practice/labs/ch04-extending/lab06-crd-shopping-install/README.md)
* [Revoking the Charter](./../practice/labs/ch04-extending/lab07-crd-shopping-cleanup/README.md)

---

## 🔐 Part 2: Environment, Configuration and Security `[ 25% ]`
> **Focus:** Managing the mall's vault, setting employee conduct rules, and balancing the utility budget.

### 📖 Chapter 5: [ConfigMaps & Secrets: The Price List and the Vault](story/ch05-configmaps-and-secrets.md)
Managing shop data and keeping the combinations safe (**ConfigMaps & Secrets**).

**⚡ Study Guide:** [Configuration](./study-guide/ch05-configuration.md)

**🧰 Study Toolbox:**
**🎙️ Audio Overview**
* * Request the audio briefing from the Mall Manager (**@maobat**) via repository issues.

**🎨 Visualize the Analogy**
* [Explore Chapter 5 Comics](./../visual-learning/comics/ch05-config-secrets/README.md)

**📘 Technical Deep Dive**
* [Configuration Decoupling](../reference/md-resources/configuration-decoupling.md)

**🛠️ Hands-on Practice**
* [Price List (ConfigMaps)](./../practice/labs/ch05-config-secrets/lab01-configmaps/README.md)
* [Breakroom Rules (Access)](./../practice/labs/ch05-config-secrets/lab02-configmap-access/README.md)
* [Vault (Secrets & Env Injection)](./../practice/labs/ch05-config-secrets/lab03-secrets-env-injection/README.md)
* [Reading the Rules (Pod Access)](./../practice/labs/ch05-config-secrets/lab04-configmap-pod-access/README.md)
* [Automated Config Writer (InitContainers)](./../practice/labs/ch05-config-secrets/lab05-configmap-init-container/README.md)

---

### 📖 Chapter 6: [Worker Safety: Safety Gear and Conduct](story/ch06-worker-safety-and-conduct.md)
Setting strict rules for how employees handle equipment (**SecurityContexts & Capabilities**).

**⚡ Study Guide:** [Security & Safety](./study-guide/ch06-security.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 6 Comics](./../visual-learning/comics/ch06-safety/README.md)

**📘 Technical Deep Dive**
* [Worker Safety and Conduct](../reference/md-resources/securitycontext-worker-safety-and-conduct.md)

**🛠️ Hands-on Practice**
* [Worker Safety (SecurityContext)](./../practice/labs/ch06-safety/lab01-worker-safety/README.md)

---

### 📖 Chapter 7: [Identity & Access (RBAC): The Magnetic ID Badge](story/ch07-identity-and-access.md)
Assigning roles and permissions to ensure only authorized staff access the backrooms (**Roles & ServiceAccounts**).

**⚡ Study Guide:** [Identity & RBAC](./study-guide/ch07-identity.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 7 Comics](./../visual-learning/comics/ch07-identity/README.md)

**📘 Technical Deep Dive**
* [Understanding RBAC](../reference/md-resources/understanding-role-based-access-control-rbac.md)

**🛠️ Hands-on Practice**
* [The Employee Badge (ServiceAccounts)](./../practice/labs/ch07-identity/lab01-serviceaccount-identity/README.md)
* [RBAC & Identity](./../practice/labs/ch07-identity/lab02-rbac-identity/README.md)
* [Entry Permits (Admission Control)](./../practice/labs/ch07-identity/lab03-admission-control-entry-permit/README.md)
* [Office Configuration (Advanced Admission)](./../practice/labs/ch07-identity/lab04-admission-control-configuration/README.md)

---

### 📖 Chapter 8: [Resource Budgets: Water and Electricity](story/ch08-resource-budgets.md)
Preventing "Resource Hogs" from causing mall-wide blackouts (**Requests, Limits & Quotas**).

**⚡ Study Guide:** [Resources & Quotas](./study-guide/ch08-resources.md)

**🧰 Study Toolbox:**
**🎙️ Audio Overview**
* * Request the audio briefing from the Mall Manager (**@maobat**) via repository issues.

**🎨 Visualize the Analogy**
* [Explore Chapter 8 Comics](./../visual-learning/comics/ch08-resources/README.md)

**📘 Technical Deep Dive**
* [The Resource Budget](../reference/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)

**🛠️ Hands-on Practice**
* [Managing Constraints](../practice/labs/ch08-resources/lab01-managing-resource-constraints/README.md)
* [Resource Checker (Requests & Limits)](../practice/labs/ch08-resources/lab02-resource-checker/README.md)
* [Special Placements (Node Affinity)](../practice/labs/ch08-resources/lab03-node-affinity/README.md)

---

## 🚀 Part 3: Application Deployment `[ 20% ]`
> **Focus:** Grand openings, logistics pipelines, and managing change without disappointing customers.

### 📖 Chapter 9: [Launch Strategies: The Sign Swap and the Taste Test](story/ch09-launch-strategies.md)
Mastering **Blue/Green** and **Canary** deployments to ensure zero downtime.

**⚡ Study Guide:** [Deployment Strategies](./study-guide/ch09-deployments.md)

**🧰 Study Toolbox:**
**🎙️ Audio Overview**
* * Request the audio briefing from the Mall Manager (**@maobat**) via repository issues.

**🎨 Visualize the Analogy**
* [Explore Chapter 9 Comics](./../visual-learning/comics/ch09-launch/README.md)

**📘 Technical Deep Dive**
* [Implementing Canary Deployments](../reference/md-resources/implementing-canary-deployments.md)
* [Implementing Blue/Green Deployments](../reference/md-resources/implementing-bluegreen-deployments.md)

**🛠️ Hands-on Practice**
* [Rolling Update Boutique](../practice/labs/ch09-launch/lab01-rolling-update-wonderful/README.md)
* [Blue-Green Sign Swap](./../practice/labs/ch09-launch/lab02-blue-green-wonderful/README.md)
* [Canary Taste Test](./../practice/labs/ch09-launch/lab03-canary-wonderful/README.md)
* [Blue-Green Java App (Guided + Challenge)](../practice/labs/ch09-launch/lab04-blue-green-java/README.md)
* [Deployment Lifecycle (Create, Scale & Update)](../practice/labs/ch09-launch/lab05-deployment-lifecycle/README.md)

---

### 📖 Chapter 10: [Logistics & API Management: Shipping Containers and Blueprints](story/ch10-logistics-tools.md)
Using standardized tools like **Helm** and **Kustomize** to manage mall layout templates and **API Versions** to maintain the Management Office.

**⚡ Study Guide:** [Management Tools](./study-guide/ch10-management.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 10 Comics](./../visual-learning/comics/ch10-logistics/README.md)

**📘 Technical Deep Dive**
* [Using Helm](../reference/md-resources/using-the-helm-package-manager.md)
* [Using Kustomize](../reference/md-resources/using-kustomize.md)

**🛠️ Hands-on Practice**
* [Mall Catalog Audit (Helm)](./../practice/labs/ch10-logistics/lab01-helm-audit/README.md)
* [Logistics Tools (Helm/Kustomize)](./../practice/labs/ch10-logistics/lab02-helm-kustomize/README.md)
* [Mapping the API (Versions & Deprecations)](./../practice/labs/ch10-logistics/lab03-api-versions/README.md)
* [Inventory Report (Helm List)](./../practice/labs/ch10-logistics/lab04-helm-list/README.md)
* [Shop Closure (Helm Delete)](./../practice/labs/ch10-logistics/lab05-helm-delete/README.md)

---

## 🌐 Part 4: Services and Networking `[ 20% ]`
> **Focus:** Intercoms, signage, and managing the grand entrances of the mall.

### 📖 Chapter 11: [Finding the Stores: Intercoms and Delivery Bays](story/ch11-finding-the-stores.md)
Connecting shops and drivers via **ClusterIP** and **NodePort** services.

**⚡ Study Guide:** [Networking Services](./study-guide/ch11-services.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 11 Comics](./../visual-learning/comics/ch11-services/README.md)

**📘 Technical Deep Dive**
* [Service IP Trackers](../reference/md-resources/service-ip-tracker-evolution.md)

**🛠️ Hands-on Practice**
* [ClusterIP & Internal Communication](../practice/labs/ch11-services/lab01-clusterip-internal-traffic/README.md)
* [NodePort Traffic Adventure](../practice/labs/ch11-services/lab02-nodeport-cross-namespace/README.md)
* [Intercom Investigation (Service Debugging)](../practice/labs/ch11-services/lab03-service-debugging/README.md)

---

### 📖 Chapter 12: [Ingress & Gateway API: The Grand Entrance](story/ch12-ingress-and-gateway-api.md)
Routing customers through the main doors and specialized directories (**Ingress & Gateway API**).

**⚡ Study Guide:** [Ingress & Gateway API](./study-guide/ch12-ingress.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 12 Comics](./../visual-learning/comics/ch12-ingress/README.md)

**📘 Technical Deep Dive**
* [Ingress vs Gateway API](../reference/md-resources/ingress-vs-gateway.md)

**🛠️ Hands-on Practice**
* [Branded Entrance (Host Routing)](../practice/labs/ch12-ingress/lab01-virtual-host/README.md)
* [Grand Entrance (Path Routing)](../practice/labs/ch12-ingress/lab02-path-routing/README.md)
* [Rewrite Policy (Advanced Ingress)](../practice/labs/ch12-ingress/lab03-advanced-ingress/README.md)
* [Canary Deployments (Gateway API)](../practice/labs/ch12-ingress/lab04-gateway-api-canary/README.md)

---

### 📖 Chapter 13: [Network Policies: Locked Corridors](story/ch13-network-policies.md)
Restricting movement between departments to protect the mall's security.

**⚡ Study Guide:** [Network Policies](./study-guide/ch13-networking.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 13 Comics](./../visual-learning/comics/ch13-networking/README.md)

**📘 Technical Deep Dive**
* [Network Isolation Concept](../reference/md-resources/troubleshooting-kubernetes.md#section-8-3)

**🛠️ Hands-on Practice**
* [Locked Corridors (Network Policies)](../practice/labs/ch13-networking/lab01-network-policies/README.md)
* [One-Way Corridors (Egress Control)](../practice/labs/ch13-networking/lab02-network-policies/README.md)

---

## 🩺 Part 5: Observability and Maintenance `[ 15% ]`
> **Focus:** Health inspections, incident investigations, and the mall control room.

### 📖 Chapter 14: [Probes & Health Checks: The Health Inspector](story/ch14-probes-and-health-checks.md)
Ensuring shops are alive and ready to serve customers (**Liveness & Readiness Probes**).

**⚡ Study Guide:** [Health Checks & Probes](./study-guide/ch14-probes.md)

**🧰 Study Toolbox:**
**🎙️ Audio Overview**
* * Request the audio briefing from the Mall Manager (**@maobat**) via repository issues.

**🎨 Visualize the Analogy**
* [Explore Chapter 14 Comics](./../visual-learning/comics/ch14-probes/README.md)

**📘 Technical Deep Dive**
* [Worker Safety and Probes](../reference/md-resources/troubleshooting-kubernetes.md#section-2)

**🛠️ Hands-on Practice**
* [Liveness Probes: The Health Inspector](../practice/labs/ch14-probes/lab01-liveness-probes-health-inspector/README.md)
* [Readiness Probes](../practice/labs/ch14-probes/lab02-readiness-probes/README.md)

---

### 📖 Chapter 15: [Debugging & Logs: CCTV and Incident Reports](story/ch15-debugging-and-logs.md)
Investigating "incidents" using logs and real-time inspections (**Logs, Describe & Exec**).

**⚡ Study Guide:** [Debugging & Logs](./study-guide/ch15-debugging.md)

**🧰 Study Toolbox:**
**🎨 Visualize the Analogy**
* [Explore Chapter 15 Comics](./../visual-learning/comics/ch15-debugging/README.md)

**📘 Technical Deep Dive**
* [Troubleshooting Guide](../reference/md-resources/troubleshooting-kubernetes.md)
* [Diagnostic Cheat Sheet](../reference/md-resources/diagnostic-cheat-sheet.md)

**🛠️ Hands-on Practice**
* [CCTV Log Investigation](../practice/labs/ch15-debugging/lab01-debugging-shop/README.md)
* [Logging & Sidecar Tailing](../practice/labs/ch15-debugging/lab02-logging-sidecars/README.md)
* [The Mall Dashboard (Metrics Server)](../practice/labs/ch15-debugging/lab03-metrics-server/README.md)

---

## 🎓 Part 6: CKAD Exam Preparation
> **Focus:** Specialized tips, analogies, and guides for the CKAD certification.

### 📖 [Exam Guide: Setup & Strategies](../reference/md-resources/ckad-exam/README.md)
Quick guides for surviving the practical exam enviornment.

**🧰 Study Toolbox:**
**🎙️ Audio Overview**
* * Request the audio briefing from the Mall Manager (**@maobat**) via repository issues.

**🎨 Visualize the Analogy**
* [Explore Chapter 15 Comics](./../visual-learning/comics/ch15-debugging/README.md)

**📘 Technical Deep Dive**
* [Doc: Study Environments & Tools](../reference/md-resources/ckad-exam/00-study-environments.md)
* [Doc: Linux Setup Tips](../reference/md-resources/ckad-exam/01-linux-setup.md)
* [Doc: Time Management](../reference/md-resources/ckad-exam/03-time-management.md)

---
---
[Mall Directory ✨](../GLOSSARY.md)
