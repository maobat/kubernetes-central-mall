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
- 🖼️ **Comic:** [Jobs & CronJobs - The Contractor's Visit](./../visual-learning/comics/ch01-workloads/02-jobs-cronjobs/README.md)
- 🖼️ **Comic:** [StatefulSets - The Fixed Boutique](./../visual-learning/comics/ch01-workloads/02-statefulsets/README.md)
- 🖼️ **Comic:** [Floor Security (DaemonSet)](./../visual-learning/comics/ch01-workloads/03-daemonset-floor-security/README.md)
- 📄 **Doc:** [Using StatefulSets - The Bolted-Down Safe](./../reference/md-resources/using-statefulsets.md)
- 🧪 **Lab:** [Lab 01 - Jobs & CronJobs](./../practice/labs/ch01-workloads/lab01-jobs-cronjobs/README.md)
- 🧪 **Lab:** [Lab 02 - StatefulSets](./../practice/labs/ch01-workloads/lab02-statefulsets/README.md)
- 🧪 **Lab:** [Lab 03: Floor Security (DaemonSets)](./../practice/labs/ch01-workloads/lab03-daemonsets/README.md)
- 🧪 **Lab:** [Lab 04: Automated Tasks (Countdown & Reports)](./../practice/labs/ch01-workloads/lab04-automated-tasks-countdown/README.md)

---

### 📖 Chapter 2: [Multi-container Design Patterns](./story/ch02-multi-container-design-patterns.md)
The Clerk and their Helper (**Sidecar** and **Init Containers**).

**⚡ Study Guide:** [Sidecars & Helpers](./study-guide/ch02-multi-container.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [Sidecar Pattern](./../visual-learning/comics/ch02-multi-container/01-sidecar/README.md)
- 🖼️ **Comic 02:** [The Warehouse (PV/PVC)](./../visual-learning/comics/ch02-multi-container/02-the-warehouse/README.md)
- 🖼️ **Comic 03:** [The Shared Stockroom (emptyDir)](./../visual-learning/comics/ch02-multi-container/03-shared-stockroom/README.md)
- 🖼️ **Comic 04:** [The External Warehouse (NFS)](./../visual-learning/comics/ch02-multi-container/04-external-warehouse/README.md)
- 📄 **Doc:** [Decoupling Pods](../../reference/md-resources/decoupling-pods.md)
- 🧪 **Lab 01:** [Sidecar & InitContainers](./../practice/labs/ch02-multi-container/lab01-sidecar-pattern/README.md)
- 🧪 **Lab 02:** [Warehouse (PV/PVC)](./../practice/labs/ch02-multi-container/lab02-pv-pvc/README.md)
- 🧪 **Lab 03:** [Shared Volumes (emptyDir)](./../practice/labs/ch02-multi-container/lab03-shared-volumes-empty-dir/README.md)
- 🧪 **Lab 04:** [NFS Shared Volumes](./../practice/labs/ch02-multi-container/lab04-nfs-shared-volumes/README.md)

---

### 📖 Chapter 3: [Images & Modifications: The Perfect "Mannequin"](./story/ch03-images-and-modifications.md)
Mastering the art of building and updating your store's display models (**Docker/OCI Images**).

**⚡ Study Guide:** [Pod Design & Images](./study-guide/ch03-pod-design.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 03:** [The Perfect Mannequin](./../visual-learning/comics/ch03-images/03-image-updates/README.md)
- 📄 **Doc:** [Managing Images & Rollouts](../../reference/md-resources/managing-container-images-and-rollouts.md)
- 🧪 **Lab 01:** [Build Container from Scratch](./../practice/labs/ch03-images/lab01-build-container-from-scratch/README.md)
- 🧪 **Lab 02:** [Dockerfile & Local Registry](./../practice/labs/ch03-images/lab02-dockerfile-args-registry/README.md)
- 🧪 **Lab 03:** [Image Updates & Rollouts](./../practice/labs/ch03-images/lab03-image-updates/README.md)
- 🧪 **Lab 04:** [Custom Nginx & Docker Hub](./../practice/labs/ch03-images/lab04-custom-nginx-image/README.md)

---

### 📖 Chapter 4: [Extending the Mall: Special Permits](./story/ch04-extending-the-mall.md)
Hiring external contractors and obtaining special building permits (**CRDs & Operators**).

**⚡ Study Guide:** [Extending K8s](./study-guide/ch04-extending-k8s.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Nightly Backup Permit](./../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- 🖼️ **Comic 03:** [The Operator - The Manager with the Manual](./../visual-learning/comics/ch04-extending/04-operators/README.md)
- 📄 **Doc:** [Extending K8s with CRDs](../../reference/md-resources/extending-k8s-crds-operators.md)
- 🧪 **Lab 01:** [Shopping Items CRD](./../practice/labs/ch04-extending/lab01-crd-install/README.md)
- 🧪 **Lab 02:** [Nightly Backup Permit](./../practice/labs/ch04-extending/lab02-crd-custom-backup-service/README.md)
- 🧪 **Lab 03:** [CRD Discovery & Auditing](./../practice/labs/ch04-extending/lab03-crd-discovery/README.md)
- 🧪 **Lab 04:** [Operators & Helm Packages](./../practice/labs/ch04-extending/lab04-operators-helm/README.md)
- 🧪 **Lab 05:** [Backup Service Audit](./../practice/labs/ch04-extending/lab05-backup-audit/README.md)
- 🧪 **Lab 06:** [Shopping Charter (Beta)](./../practice/labs/ch04-extending/lab06-crd-shopping-install/README.md)
- 🧪 **Lab 07:** [Revoking the Charter](./../practice/labs/ch04-extending/lab07-crd-shopping-cleanup/README.md)

---

## 🔐 Part 2: Environment, Configuration and Security `[ 25% ]`
> **Focus:** Managing the mall's vault, setting employee conduct rules, and balancing the utility budget.

### 📖 Chapter 5: [ConfigMaps & Secrets: The Price List and the Vault](story/ch05-configmaps-and-secrets.md)
Managing shop data and keeping the combinations safe (**ConfigMaps & Secrets**).

**⚡ Study Guide:** [Configuration](./study-guide/ch05-configuration.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Rulebook & The Uniform](./../visual-learning/comics/ch05-config-secrets/01-configmap/README.md)
- 🖼️ **Comic 03:** [The Secret of the High-Security Vault](./../visual-learning/comics/ch05-config-secrets/01-secrets-injection/README.md)
- 📄 **Doc:** [Configuration Decoupling](../reference/md-resources/configuration-decoupling.md)
- 🧪 **Lab 01:** [Price List (ConfigMaps)](./../practice/labs/ch05-config-secrets/lab01-configmaps/README.md)
- 🧪 **Lab 02:** [Breakroom Rules (Access)](./../practice/labs/ch05-config-secrets/lab02-configmap-access/lab02-configmap-access.md)
- 🧪 **Lab 03:** [Vault (Secrets & Env Injection)](./../practice/labs/ch05-config-secrets/lab03-secrets-env-injection/README.md)
- 🧪 **Lab 04:** [Reading the Rules (Pod Access)](./../practice/labs/ch05-config-secrets/lab04-configmap-pod-access/lab04-configmap-pod-access.md)
- 🧪 **Lab 05:** [Automated Config Writer (InitContainers)](./../practice/labs/ch05-config-secrets/lab05-configmap-init-container/README.md)

---

### 📖 Chapter 6: [Worker Safety: Safety Gear and Conduct](story/ch06-worker-safety-and-conduct.md)
Setting strict rules for how employees handle equipment (**SecurityContexts & Capabilities**).

**⚡ Study Guide:** [Security & Safety](./study-guide/ch06-security.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [Worker Safety & SecurityContext](./../visual-learning/comics/ch06-safety/02-worker-safety/README.md)
- 📄 **Doc:** [Worker Safety and Conduct](../../reference/md-resources/securitycontext-worker-safety-and-conduct.md)
- 🧪 **Lab 01:** [Worker Safety (SecurityContext)](./../practice/labs/ch06-safety/lab01-worker-safety/README.md)

---

### 📖 Chapter 7: [Identity & Access (RBAC): The Magnetic ID Badge](story/ch07-identity-and-access.md)
Assigning roles and permissions to ensure only authorized staff access the backrooms (**Roles & ServiceAccounts**).

**⚡ Study Guide:** [Identity & RBAC](./study-guide/ch07-identity.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Secure Badge](./../visual-learning/comics/ch07-identity/01-the-secure-badge/README.md)
- 🖼️ **Comic 02:** [The HR Manual (Role)](./../visual-learning/comics/ch07-identity/02-the-hr-manual/README.md)
- 🖼️ **Comic 03:** [The Entry Permit Office (Admission Control)](./../visual-learning/comics/ch07-identity/03-admission-control/README.md)
- 📄 **Doc:** [Understanding RBAC](../../reference/md-resources/understanding-role-based-access-control-rbac.md)
- 🧪 **Lab 01:** [The Employee Badge (ServiceAccounts)](./../practice/labs/ch07-identity/lab01-serviceaccount-identity/README.md)
- 🧪 **Lab 02:** [RBAC & Identity](./../practice/labs/ch07-identity/lab02-rbac-identity/README.md)
- 🧪 **Lab 03:** [Entry Permits (Admission Control)](./../practice/labs/ch07-identity/lab03-admission-control-entry-permit/README.md)
- 🧪 **Lab 04:** [Office Configuration (Advanced Admission)](./../practice/labs/ch07-identity/lab04-admission-control-configuration/README.md)

---

### 📖 Chapter 8: [Resource Budgets: Water and Electricity](story/ch08-resource-budgets.md)
Preventing "Resource Hogs" from causing mall-wide blackouts (**Requests, Limits & Quotas**).

**⚡ Study Guide:** [Resources & Quotas](./study-guide/ch08-resources.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Resource Hog](../visual-learning/comics/ch08-resources/01-the-resource-hog/README.md)
- 📄 **Doc:** [The Resource Budget](../reference/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)
- 🧪 **Lab 01:** [Managing Constraints](../practice/labs/ch08-resources/lab01-managing-resource-constraints/README.md)
- 🧪 **Lab 02:** [Resource Checker (Requests & Limits)](../practice/labs/ch08-resources/lab02-resource-checker/lab02-resource-checker.md)
- 🧪 **Lab 03:** [Special Placements (Node Affinity)](../practice/labs/ch08-resources/lab03-node-affinity/README.md)

---

## 🚀 Part 3: Application Deployment `[ 20% ]`
> **Focus:** Grand openings, logistics pipelines, and managing change without disappointing customers.

### 📖 Chapter 9: [Launch Strategies: The Sign Swap and the Taste Test](story/ch09-launch-strategies.md)
Mastering **Blue/Green** and **Canary** deployments to ensure zero downtime.

**⚡ Study Guide:** [Deployment Strategies](./study-guide/ch09-deployments.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Trend Spot - Rolling Renovation](../visual-learning/comics/ch09-launch/01-rolling-update/README.md)
- 🖼️ **Comic 02:** [The Sign Swap (Blue/Green)](./../visual-learning/comics/ch09-launch/01-blue-green-sign-swap/README.md)
- 🖼️ **Comic 03:** [The Canary Side Entrance](../visual-learning/comics/ch09-launch/01-canary-nodeport/README.md)
- 📄 **Doc:** [Implementing Canary Deployments](../reference/md-resources/implementing-canary-deployments.md)
- 📄 **Doc:** [Implementing Blue/Green Deployments](../reference/md-resources/implementing-bluegreen-deployments.md)
- 🧪 **Lab 01:** [Rolling Update Boutique](../practice/labs/ch09-launch/lab01-rolling-update-wonderful/README.md)
- 🧪 **Lab 02:** [Blue-Green Sign Swap](./../practice/labs/ch09-launch/lab02-blue-green-wonderful/README.md)
- 🧪 **Lab 03:** [Canary Taste Test](./../practice/labs/ch09-launch/lab03-canary-wonderful/README.md)
- 🧪 **Lab 04:** [Blue-Green Java App (Guided + Challenge)](../practice/labs/ch09-launch/lab04-blue-green-java/README.md)
- 🧪 **Lab 05:** [Deployment Lifecycle (Create, Scale & Update)](../practice/labs/ch09-launch/lab05-deployment-lifecycle/README.md)

---

### 📖 Chapter 10: [Logistics & API Management: Shipping Containers and Blueprints](story/ch10-logistics-tools.md)
Using standardized tools like **Helm** and **Kustomize** to manage mall layout templates and **API Versions** to maintain the Management Office.

**⚡ Study Guide:** [Management Tools](./study-guide/ch10-management.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Logistics Chain](../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
- 📄 **Doc:** [Using Helm](../reference/md-resources/using-the-helm-package-manager.md)
- 📄 **Doc:** [Using Kustomize](../reference/md-resources/using-kustomize.md)
- 🧪 **Lab 01:** [Mall Catalog Audit (Helm)](./../practice/labs/ch10-logistics/lab01-helm-audit/README.md)
- 🧪 **Lab 02:** [Logistics Tools (Helm/Kustomize)](./../practice/labs/ch10-logistics/lab02-helm-kustomize/README.md)
- 🧪 **Lab 03:** [Mapping the API (Versions & Deprecations)](./../practice/labs/ch10-logistics/lab03-api-versions/README.md)
- 🧪 **Lab 04:** [Inventory Report (Helm List)](./../practice/labs/ch10-logistics/lab04-helm-list/README.md)
- 🧪 **Lab 05:** [Shop Closure (Helm Delete)](./../practice/labs/ch10-logistics/lab05-helm-delete/README.md)

---

## 🌐 Part 4: Services and Networking `[ 20% ]`
> **Focus:** Intercoms, signage, and managing the grand entrances of the mall.

### 📖 Chapter 11: [Finding the Stores: Intercoms and Delivery Bays](story/ch11-finding-the-stores.md)
Connecting shops and drivers via **ClusterIP** and **NodePort** services.

**⚡ Study Guide:** [Networking Services](./study-guide/ch11-services.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Internal Intercom (ClusterIP)](../visual-learning/comics/ch11-services/01-internal-intercom/README.md)
- 🖼️ **Comic 02:** [The NodePort Traffic Adventure](../visual-learning/comics/ch11-services/02-cross-namespace/README.md)
- 📄 **Doc:** [Service IP Trackers](../reference/md-resources/service-ip-tracker-evolution.md)
- 🧪 **Lab 01:** [ClusterIP & Internal Communication](../practice/labs/ch11-services/lab01-clusterip-internal-traffic/README.md)
- 🧪 **Lab 02:** [NodePort Traffic Adventure](../practice/labs/ch11-services/lab02-nodeport-cross-namespace/README.md)
- 🧪 **Lab 03:** [Intercom Investigation (Service Debugging)](../practice/labs/ch11-services/lab03-service-debugging/README.md)

---

### 📖 Chapter 12: [Ingress & Gateway API: The Grand Entrance](story/ch12-ingress-and-gateway-api.md)
Routing customers through the main doors and specialized directories (**Ingress & Gateway API**).

**⚡ Study Guide:** [Ingress & Gateway API](./study-guide/ch12-ingress.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [Virtual Host Gateway Show](../visual-learning/comics/ch12-ingress/01-virtual-host/README.md)
- 🖼️ **Comic 02:** [The Lost Gateway](../visual-learning/comics/ch12-ingress/01-the-lost-gateway/README.md)
- 🖼️ **Comic 03:** [The Grand Entrance (Path Routing)](../visual-learning/comics/ch12-ingress/02-the-grand-entrance/README.md)
- 📄 **Doc:** [Ingress vs Gateway API](../reference/md-resources/ingress-vs-gateway.md)
- 🧪 **Lab 01:** [Branded Entrance (Host Routing)](../practice/labs/ch12-ingress/lab01-virtual-host/README.md)
- 🧪 **Lab 02:** [Grand Entrance (Path Routing)](../practice/labs/ch12-ingress/lab02-path-routing/README.md)
- 🧪 **Lab 03:** [Rewrite Policy (Advanced Ingress)](../practice/labs/ch12-ingress/lab03-advanced-ingress/README.md)
- 🧪 **Lab 04:** [Canary Deployments (Gateway API)](../practice/labs/ch12-ingress/lab04-gateway-api-canary/README.md)

---

### 📖 Chapter 13: [Network Policies: Locked Corridors](story/ch13-network-policies.md)
Restricting movement between departments to protect the mall's security.

**⚡ Study Guide:** [Network Policies](./study-guide/ch13-networking.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Locked Corridor](../visual-learning/comics/ch13-networking/01-locked-corridors/README.md)
- 🖼️ **Comic 02:** [The One-Way Corridor (Egress Control)](../visual-learning/comics/ch13-networking/02-one-way-corridors/README.md)
- 📄 **Doc:** [Network Isolation Concept](../reference/md-resources/troubleshooting-kubernetes.md#section-8-3)
- 🧪 **Lab 01:** [Locked Corridors (Network Policies)](../practice/labs/ch13-networking/lab01-network-policies/README.md)
- 🧪 **Lab 02:** [One-Way Corridors (Egress Control)](../practice/labs/ch13-networking/lab02-network-policies/README.md)

---

## 🩺 Part 5: Observability and Maintenance `[ 15% ]`
> **Focus:** Health inspections, incident investigations, and the mall control room.

### 📖 Chapter 14: [Probes & Health Checks: The Health Inspector](story/ch14-probes-and-health-checks.md)
Ensuring shops are alive and ready to serve customers (**Liveness & Readiness Probes**).

**⚡ Study Guide:** [Health Checks & Probes](./study-guide/ch14-probes.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Health Inspector - Liveness vs Readiness](../visual-learning/comics/ch14-probes/01-the-health-inspector/README.md)
- 🖼️ **Comic 02:** [The Health Inspector - Readiness](../visual-learning/comics/ch14-probes/02-readiness-probes/README.md)
- 📄 **Doc:** [Worker Safety and Probes](../reference/md-resources/troubleshooting-kubernetes.md#section-2)
- 🧪 **Lab 01:** [Liveness Probes: The Health Inspector](../practice/labs/ch14-probes/lab01-liveness-probes-health-inspector/README.md)
- 🧪 **Lab 02:** [Readiness Probes](../practice/labs/ch14-probes/lab02-readiness-probes/README.md)

---

### 📖 Chapter 15: [Debugging & Logs: CCTV and Incident Reports](story/ch15-debugging-and-logs.md)
Investigating "incidents" using logs and real-time inspections (**Logs, Describe & Exec**).

**⚡ Study Guide:** [Debugging & Logs](./study-guide/ch15-debugging.md)

**🧰 Study Toolbox:**
- 🖼️ **Comic 01:** [The Broken Shop](../visual-learning/comics/ch15-debugging/03-the-broken-shop/README.md)
- 🖼️ **Comic 02:** [SSH and Contexts (Service Elevator)](../visual-learning/comics/ckad-exam/05-ssh-and-contexts/README.md)
- 📄 **Doc:** [Troubleshooting Guide](../reference/md-resources/troubleshooting-kubernetes.md)
- 📄 **Doc:** [Diagnostic Cheat Sheet](../reference/md-resources/diagnostic-cheat-sheet.md)
- 🧪 **Lab 01:** [CCTV Log Investigation](../practice/labs/ch15-debugging/lab01-debugging-shop/README.md)
- 🧪 **Lab 02:** [Logging & Sidecar Tailing](../practice/labs/ch15-debugging/lab02-logging-sidecars/README.md)
- 🧪 **Lab 03:** [The Mall Dashboard (Metrics Server)](../practice/labs/ch15-debugging/lab03-metrics-server/README.md)

---

## 🎓 Part 6: CKAD Exam Preparation
> **Focus:** Specialized tips, analogies, and guides for the CKAD certification.

### 📖 [Exam Guide: Setup & Strategies](../reference/md-resources/ckad-exam/README.md)
Quick guides for surviving the practical exam enviornment.

**🧰 Study Toolbox:**
- 📄 [Doc: Study Environments & Tools](../reference/md-resources/ckad-exam/00-study-environments.md)
- 🖼️ [Comic: SSH and Contexts (Service Elevator)](../visual-learning/comics/ckad-exam/05-ssh-and-contexts/README.md)
- 📄 [Doc: Linux Setup Tips](../reference/md-resources/ckad-exam/01-linux-setup.md)
- 📄 [Doc: Time Management](../reference/md-resources/ckad-exam/03-time-management.md)

---