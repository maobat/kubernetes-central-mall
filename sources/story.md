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
- 🖼️ [Comic: Jobs & CronJobs](./../visual-learning/comics/ch01-workloads/02-jobs-cronjobs/README.md)
- 🧪 [Lab: Jobs & CronJobs](./../practice/labs/ch01-workloads/lab02-jobs-cronjobs/README.md)
- 🖼️ [Comic: The Fixed Boutique (StatefulSets)](./../visual-learning/comics/ch01-workloads/02-statefulsets/README.md)
- 🧪 [Lab: The Fixed Boutique (StatefulSets)](./../practice/labs/ch01-workloads/lab02-statefulsets/README.md)
- 🖼️ [Comic: Floor Security (DaemonSet)](./../visual-learning/comics/ch01-workloads/03-daemonset-floor-security/README.md)
- 📄 [Doc: Using StatefulSets](./../reference/md-resources/using-statefulsets.md)

---

### 📖 Chapter 2: [Multi-container Design Patterns](./story/ch02-multi-container-design-patterns.md)
The Clerk and their Helper (**Sidecar** and **Init Containers**).

**⚡ Study Guide:** [Sidecars & Helpers](./study-guide/ch02-multi-container.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: Sidecar Pattern](./../visual-learning/comics/ch02-multi-container/01-sidecar/README.md)
- 🧪 [Lab: Sidecar Pattern](./../practice/labs/ch02-multi-container/lab01-sidecar-pattern/README.md)
- 🖼️ [Comic: The Warehouse (PV/PVC)](./../visual-learning/comics/ch02-multi-container/02-the-warehouse/README.md)
- 🧪 [Lab: The Warehouse (PV/PVC)](./../practice/labs/ch02-multi-container/lab02-pv-pvc/README.md)
- 📄 [Doc: Decoupling Pods]../../reference/md-resources/decoupling-pods.md)

---

### 📖 Chapter 3: [Images & Modifications: The Perfect "Mannequin"](./story/ch03-images-and-modifications.md)
Mastering the art of building and updating your store's display models (**Docker/OCI Images**).

**⚡ Study Guide:** [Pod Design & Images](./study-guide/ch03-pod-design.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Perfect Mannequin](./../visual-learning/comics/ch03-images/03-image-updates/README.md)
- 🧪 [Lab: Build Container from Scratch](./../practice/labs/ch03-images/lab01-build-container-from-scratch/README.md)
- 🧪 [Lab: Image Updates & Rollouts](./../practice/labs/ch03-images/lab03-image-updates/README.md)
- 📄 [Doc: Managing Images & Rollouts]../../reference/md-resources/managing-container-images-and-rollouts.md)

---

### 📖 Chapter 4: [Extending the Mall: Special Permits](./story/ch04-extending-the-mall.md)
Hiring external contractors and obtaining special building permits (**CRDs & Operators**).

**⚡ Study Guide:** [Extending K8s](./study-guide/ch04-extending-k8s.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Nightly Backup Permit](./../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- 🧪 [Lab: Custom Backup Service (CRD)](./../practice/labs/ch04-extending/lab01-crd-custom-backup-service/README.md)
- 🖼️ [Comic: The Manager with the Manual (Operators)](./../visual-learning/comics/ch04-extending/04-operators/README.md)
- 🧪 [Lab: CRDs & Operators](./../practice/labs/ch04-extending/lab04-crds-operators/README.md)
- 📄 [Doc: Extending K8s with CRDs]../../reference/md-resources/extending-k8s-crds-operators.md)

---

## 🔐 Part 2: Environment, Configuration and Security `[ 25% ]`
> **Focus:** Managing the mall's vault, setting employee conduct rules, and balancing the utility budget.

### 📖 Chapter 5: [ConfigMaps & Secrets: The Price List and the Vault](story/ch05-configmaps-and-secrets.md)
Managing shop data and keeping the combinations safe (**ConfigMaps & Secrets**).

**⚡ Study Guide:** [Configuration](./study-guide/ch05-configuration.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Rulebook & The Uniform](./../visual-learning/comics/ch05-config-secrets/01-configmap/README.md)
- 🧪 [Lab: Configuration: ConfigMaps](./../practice/labs/ch05-config-secrets/lab01-configmaps/README.md)
- 🧪 [Lab: Breakroom Rules (ConfigMap Access)](./../practice/labs/ch05-config-secrets/lab02-configmap-access/lab02-configmap-access.md)
- 🧪 [Lab: Reading the Rules (ConfigMap Pod Access)](./../practice/labs/ch05-config-secrets/lab04-configmap-pod-access/lab04-configmap-pod-access.md)
- 🖼️ [Comic: The Secret of the High-Security Vault](./../visual-learning/comics/ch05-config-secrets/01-secrets-injection/README.md)
- 🧪 [Lab: Secrets & Env Injection](./../practice/labs/ch05-config-secrets/lab03-secrets-env-injection/README.md)
- 📄 [Doc: Configuration Decoupling](../reference/md-resources/configuration-decoupling.md)

---

### 📖 Chapter 6: [Worker Safety: Safety Gear and Conduct](story/ch06-worker-safety-and-conduct.md)
Setting strict rules for how employees handle equipment (**SecurityContexts & Capabilities**).

**⚡ Study Guide:** [Security & Safety](./study-guide/ch06-security.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: Worker Safety & SecurityContext](./../visual-learning/comics/ch06-safety/02-worker-safety/README.md)
- 📄 [Doc: Worker Safety and Conduct]../reference/md-resources/securitycontext-worker-safety-and-conduct.md)
- 🧪 [Lab: Worker Safety (SecurityContext) - TBD](./../practice/labs/README.md)

---

### 📖 Chapter 7: [Identity & Access (RBAC): The Magnetic ID Badge](story/ch07-identity-and-access.md)
Assigning roles and permissions to ensure only authorized staff access the backrooms (**Roles & ServiceAccounts**).

**⚡ Study Guide:** [Identity & RBAC](./study-guide/ch07-identity.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Secure Badge](./../visual-learning/comics/ch07-identity/01-the-secure-badge/README.md)
- 🧪 [Lab 01: Employee Badge (ServiceAccounts)](./../practice/labs/ch07-identity/lab01-serviceaccount-identity/README.md)
- 🧪 [Lab 02: Identity & Access (RBAC)](./../practice/labs/ch07-identity/lab02-rbac-identity/README.md)
- 🧪 [Lab 03: Entry Permit Office (Admission Control)](./../practice/labs/ch07-identity/lab03-admission-control-entry-permit/README.md)
- 🧪 [Lab 04: Office Configuration (Advanced Admission)](./../practice/labs/ch07-identity/lab04-admission-control-configuration/README.md)
- 🖼️ [Comic: The HR Manual (Role)](./../visual-learning/comics/ch07-identity/02-the-hr-manual/README.md)
- 🖼️ [Comic: The Entry Permit Office (Admission Control)](./../visual-learning/comics/ch07-identity/03-admission-control/README.md)
- 📄 [Doc: Understanding RBAC]../reference/md-resources/understanding-role-based-access-control-rbac.md)

---

### 📖 Chapter 8: [Resource Budgets: Water and Electricity](story/ch08-resource-budgets.md)
Preventing "Resource Hogs" from causing mall-wide blackouts (**Requests, Limits & Quotas**).

**⚡ Study Guide:** [Resources & Quotas](./study-guide/ch08-resources.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Resource Hog](../visual-learning/comics/ch08-resources/01-the-resource-hog/README.md)
- 🧪 [Lab: Managing Resource Constraints](../practice/labs/ch08-resources/lab01-managing-resource-constraints/README.md)
- 🧪 [Lab: Resource Checker (Requests & Limits)](../practice/labs/ch08-resources/lab02-resource-checker/lab02-resource-checker.md)
- 📄 [Doc: The Resource Budget](../reference/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)

---

## 🚀 Part 3: Application Deployment `[ 20% ]`
> **Focus:** Grand openings, logistics pipelines, and managing change without disappointing customers.

### 📖 Chapter 9: [Launch Strategies: The Sign Swap and the Taste Test](story/ch09-launch-strategies.md)
Mastering **Blue/Green** and **Canary** deployments to ensure zero downtime.

**⚡ Study Guide:** [Deployment Strategies](./study-guide/ch09-deployments.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Canary Side Entrance](../visual-learning/comics/ch09-launch/01-canary-nodeport/README.md)
- 🖼️ [Comic: The Sign Swap (Blue/Green)](./../visual-learning/comics/ch09-launch/01-blue-green-sign-swap/README.md)
- 📄 [Doc: Implementing Canary Deployments](../reference/md-resources/implementing-canary-deployments.md)
- 🧪 [Lab: Canary Deployments with NodePort](../practice/labs/ch09-launch/lab04-canary-nodeport/README.md)

---

### 📖 Chapter 10: [Logistics & API Management: Shipping Containers and Blueprints](story/ch10-logistics-tools.md)
Using standardized tools like **Helm** and **Kustomize** to manage mall layout templates and **API Versions** to maintain the Management Office.

**⚡ Study Guide:** [Management Tools](./study-guide/ch10-management.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Logistics Chain](../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
- 🧪 [Lab 01: Helm Audit](./../practice/labs/ch10-logistics/lab01-helm-audit/README.md)
- 🧪 [Lab 02: Logistics Overlays](./../practice/labs/ch10-logistics/lab02-helm-kustomize/README.md)
- 🧪 [Lab 03: Renovating the Blueprints (API Versions)](./../practice/labs/ch10-logistics/lab03-api-versions/README.md)
- 📄 [Doc: Using Helm](../reference/md-resources/using-the-helm-package-manager.md)
- 📄 [Doc: Using Kustomize](../reference/md-resources/using-kustomize.md)

---

## 🌐 Part 4: Services and Networking `[ 20% ]`
> **Focus:** Intercoms, signage, and managing the grand entrances of the mall.

### 📖 Chapter 11: [Finding the Stores: Intercoms and Delivery Bays](story/ch11-finding-the-stores.md)
Connecting shops and drivers via **ClusterIP** and **NodePort** services.

**⚡ Study Guide:** [Networking Services](./study-guide/ch11-services.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Internal Intercom (ClusterIP)](../visual-learning/comics/ch11-services/01-internal-intercom/README.md)
- 🖼️ [Comic: The NodePort Traffic Adventure](../visual-learning/comics/ch11-services/02-cross-namespace/README.md)
- 🧪 [Lab: ClusterIP & Internal Communication](../practice/labs/ch11-services/lab01-clusterip-internal-traffic/README.md)
- 🧪 [Lab: NodePort & Cross-Namespace Access](../practice/labs/ch11-services/lab02-nodeport-cross-namespace/README.md)
- 📄 [Doc: Service IP Trackers](../reference/md-resources/service-ip-tracker-evolution.md)

---

### 📖 Chapter 12: [Ingress & Gateway API: The Grand Entrance](story/ch12-ingress-and-gateway-api.md)
Routing customers through the main doors and specialized directories (**Ingress & Gateway API**).

**⚡ Study Guide:** [Ingress & Gateway API](./study-guide/ch12-ingress.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: Virtual Host Gateway Show](../visual-learning/comics/ch12-ingress/01-virtual-host/README.md)
- 🧪 [Lab: Ingress & Virtual Host Routing](../practice/labs/ch12-ingress/lab03-ingress-virtual-host/README.md)
- 🖼️ [Comic: The Lost Gateway](../visual-learning/comics/ch12-ingress/01-the-lost-gateway/README.md)
- 🧪 [Lab: Canary Deployments with Gateway API](../practice/labs/ch12-ingress/lab05-canary-deployment-gateway-api/README.md)
- 📄 [Doc: Ingress vs Gateway API](../reference/md-resources/ingress-vs-gateway.md)

---

### 📖 Chapter 13: [Network Policies: Locked Corridors](story/ch13-network-policies.md)
Restricting movement between departments to protect the mall's security.

**⚡ Study Guide:** [Network Policies](./study-guide/ch13-networking.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Locked Corridor](../visual-learning/comics/ch13-networking/01-locked-corridors/README.md)
- 🧪 [Lab: Network Policies & Locked Corridors](../practice/labs/ch13-networking/lab06-network-policies/README.md)
- 📄 [Doc: Network Isolation Concept](../reference/md-resources/troubleshooting-kubernetes.md#section-8-3)

---

## 🩺 Part 5: Observability and Maintenance `[ 15% ]`
> **Focus:** Health inspections, incident investigations, and the mall control room.

### 📖 Chapter 14: [Probes & Health Checks: The Health Inspector](story/ch14-probes-and-health-checks.md)
Ensuring shops are alive and ready to serve customers (**Liveness & Readiness Probes**).

**⚡ Study Guide:** [Health Checks & Probes](./study-guide/ch14-probes.md)

**🧰 Study Toolbox:**
- 📄 [Doc: Worker Safety and Probes](../reference/md-resources/troubleshooting-kubernetes.md#section-2)
- 🖼️ [Comic: The Health Inspector - Liveness vs Readiness](../visual-learning/comics/ch14-probes/01-the-health-inspector/README.md)
- 🖼️ [Comic: The Health Inspector - Readiness](../visual-learning/comics/ch14-probes/02-readiness-probes/README.md)
- 🧪 [Lab: Liveness Probes: The Health Inspector](../practice/labs/ch14-probes/lab01-liveness-probes-health-inspector/README.md)
- 🧪 [Lab: Readiness Probes](../practice/labs/ch14-probes/lab02-readiness-probes/README.md)

---

### 📖 Chapter 15: [Debugging & Logs: CCTV and Incident Reports](story/ch15-debugging-and-logs.md)
Investigating "incidents" using logs and real-time inspections (**Logs, Describe & Exec**).

**⚡ Study Guide:** [Debugging & Logs](./study-guide/ch15-debugging.md)

**🧰 Study Toolbox:**
- 📄 [Doc: Troubleshooting Guide](../reference/md-resources/troubleshooting-kubernetes.md)
- 📄 [Doc: Diagnostic Cheat Sheet](../reference/md-resources/diagnostic-cheat-sheet.md)
- 🖼️ [Comic: The Broken Shop](../visual-learning/comics/ch15-debugging/03-the-broken-shop/README.md)
- 🧪 [Lab: Fixing the Broken Shop](../practice/labs/ch15-debugging/lab15-fixing-the-broken-shop/README.md)

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