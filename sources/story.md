# 🏙️ The Central Mall: A CKAD Adventure
> A narrative guide to mastering Certified Kubernetes Application Developer concepts through the lens of a bustling urban mall.

---

## 🏗️ Part 1: Application Design and Build `[ 20% ]`
> **Focus:** Understanding the core blueprints of the mall, how we hire staff, organize departments, and deploy our "mannequin" images.

### 📖 Chapter 1: [Choosing the Right Workload](./story/ch01-choosing-the-right-workload.md) 
When to use a Shop Clerk (**Pod**), a Manager (**Deployment**), a Night-Shift Worker (**Job**), or a Recurring Maintenance Crew (**CronJob**).

**⚡ Study Guide:** [Workloads & Contracts](./study-guide/ch01-workloads.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: Jobs & CronJobs](./../comics/pod-design/02-jobs-cronjobs/README.md)
- 🧪 [Lab: Jobs & CronJobs](./../labs/pod-design/lab02-jobs-cronjobs/README.md)
- 🖼️ [Comic: The Fixed Boutique (StatefulSets)](./../comics/storage/02-statefulsets/README.md)
- 🧪 [Lab: The Fixed Boutique (StatefulSets)](./../labs/storage/lab02-statefulsets/README.md)
- 📄 [Doc: Using StatefulSets](./../docs/md-resources/using-statefulsets.md)

---

### 📖 Chapter 2: [Multi-container Design Patterns](./story/ch02-multi-container-design-patterns.md)
The Clerk and their Helper (**Sidecar** and **Init Containers**).

**⚡ Study Guide:** [Sidecars & Helpers](./study-guide/ch02-multi-container.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: Sidecar Pattern](./../comics/pod-design/01-sidecar/README.md)
- 🧪 [Lab: Sidecar Pattern](./../labs/pod-design/lab01-sidecar-pattern/README.md)
- 📄 [Doc: Decoupling Pods](./../docs/md-resources/decoupling-pods.md)

---

### 📖 Chapter 3: [Images & Modifications: The Perfect "Mannequin"](story/ch03-images-and-modifications.md)
Mastering the art of building and updating your store's display models (**Docker/OCI Images**).

**⚡ Study Guide:** [Pod Design & Images](./study-guide/ch03-pod-design.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Perfect Mannequin](./../comics/pod-design/03-image-updates/README.md)
- 🧪 [Lab: Image Updates & Rollouts](./../labs/pod-design/lab03-image-updates/README.md)
- 📄 [Doc: Managing Images & Rollouts](./../docs/md-resources/managing-container-images-and-rollouts.md)

---

### 📖 Chapter 4: [Extending the Mall: Special Permits](story/ch04-extending-the-mall.md)
Hiring external contractors and obtaining special building permits (**CRDs & Operators**).

**⚡ Study Guide:** [Extending K8s](./study-guide/ch04-extending-k8s.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Nightly Backup Permit](./../comics/crd/01-the-nightly-backup-permit/README.md)
- 🧪 [Lab: Custom Backup Service (CRD)](./../labs/extending-k8s/lab01-crd-custom-backup-service/README.md)
- 🧪 [Lab: CRDs & Operators](./../labs/architecture/lab04-crds-operators/README.md)
- 📄 [Doc: Extending K8s with CRDs](./../docs/md-resources/extending-k8s-crds-operators.md)

---

## 🔐 Part 2: Environment, Configuration and Security `[ 25% ]`
> **Focus:** Managing the mall's vault, setting employee conduct rules, and balancing the utility budget.

### 📖 Chapter 5: [ConfigMaps & Secrets: The Price List and the Vault](story/ch05-configmaps-and-secrets.md)
Managing shop data and keeping the combinations safe (**ConfigMaps & Secrets**).

**⚡ Study Guide:** [Configuration](./study-guide/ch05-configuration.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Rulebook & The Uniform](./../comics/configuration/01-configmap/README.md)
- 🧪 [Lab: Configuration: ConfigMaps](./../labs/configuration/lab01-configmaps/README.md)
- 🖼️ [Comic: The Secret of the High-Security Vault](./../comics/secrets/01-secrets-injection/README.md)
- 🧪 [Lab: Secrets & Env Injection](./../labs/security/lab03-secrets-env-injection/README.md)
- 📄 [Doc: Configuration Decoupling](./../docs/md-resources/configuration-decoupling.md)

---

### 📖 Chapter 6: [Worker Safety: Safety Gear and Conduct](story/ch06-worker-safety-and-conduct.md)
Setting strict rules for how employees handle equipment (**SecurityContexts & Capabilities**).

**⚡ Study Guide:** [Security & Safety](./study-guide/ch06-security.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: Worker Safety & SecurityContext](./../comics/security/02-worker-safety/README.md)
- 📄 [Doc: Worker Safety and Conduct](./../docs/md-resources/securitycontext-worker-safety-and-conduct.md)
- 🧪 [Lab: Managing Security Settings (SecurityContext)](./../labs/security/lab01-serviceaccount-identity/README.md)

---

### 📖 Chapter 7: [Identity & Access (RBAC): The Magnetic ID Badge](story/ch07-identity-and-access.md)
Assigning roles and permissions to ensure only authorized staff access the backrooms (**Roles & ServiceAccounts**).

**⚡ Study Guide:** [Identity & RBAC](./study-guide/ch07-identity.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Secure Badge](./../comics/security/01-the-secure-badge/README.md)
- 🧪 [Lab: Identity & Access (RBAC)](./../labs/security/lab02-rbac-identity/README.md)
- 📄 [Doc: Understanding RBAC](./../docs/md-resources/understanding-role-based-access-control-rbac.md)

---

### 📖 Chapter 8: [Resource Budgets: Water and Electricity](story/ch08-resource-budgets.md)
Preventing "Resource Hogs" from causing mall-wide blackouts (**Requests, Limits & Quotas**).

**⚡ Study Guide:** [Resources & Quotas](./study-guide/ch08-resources.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Resource Hog](./../comics/resources/01-the-resource-hog/README.md)
- 🧪 [Lab: Managing Resource Constraints](./../labs/resources/lab01-managing-resource-constraints/README.md)
- 📄 [Doc: The Resource Budget](./../docs/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)

---

## 🚀 Part 3: Application Deployment `[ 20% ]`
> **Focus:** Grand openings, logistics pipelines, and managing change without disappointing customers.

### 📖 Chapter 9: [Launch Strategies: The Sign Swap and the Taste Test](story/ch09-launch-strategies.md)
Mastering **Blue/Green** and **Canary** deployments to ensure zero downtime.

**⚡ Study Guide:** [Deployment Strategies](./study-guide/ch09-deployments.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: Canary Traffic at the Side Entrance](./../comics/nodeport/01-canary-nodeport/README.md)
- 📄 [Doc: Implementing Canary Deployments](./../docs/md-resources/implementing-canary-deployments.md)
- 🧪 [Lab: Canary Deployments with NodePort](./../labs/services-and-networking/lab04-canary-nodeport/README.md)

---

### 📖 Chapter 10: [Logistics Tools: Shipping Containers](story/ch10-logistics-tools.md)
Using standardized tools like **Helm** and **Kustomize** to manage mall layout templates.

**⚡ Study Guide:** [Management Tools](./study-guide/ch10-management.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Logistics Chain](./../comics/deploying/02-the-logistics-chain/README.md)
- 🧪 [Lab: Logistics Tools (Helm & Kustomize)](./../labs/deploying/lab06-helm-packages/README.md)
- 📄 [Doc: Using Helm](./../docs/md-resources/using-the-helm-package-manager.md)
- 📄 [Doc: Using Kustomize](./../docs/md-resources/using-kustomize.md)

---

## 🌐 Part 4: Services and Networking `[ 20% ]`
> **Focus:** Intercoms, signage, and managing the grand entrances of the mall.

### 📖 Chapter 11: [Finding the Stores: Intercoms and Delivery Bays](story/ch11-finding-the-stores.md)
Connecting shops and drivers via **ClusterIP** and **NodePort** services.

**⚡ Study Guide:** [Networking Services](./study-guide/ch11-services.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The NodePort Traffic Adventure](./../comics/nodeport/02-cross-namespace/README.md)
- 🧪 [Lab: ClusterIP & Internal Communication](./../labs/services-and-networking/lab01-clusterip-internal-traffic/README.md)
- 🧪 [Lab: NodePort & Cross-Namespace Access](./../labs/services-and-networking/lab02-nodeport-cross-namespace/README.md)
- 📄 [Doc: Service IP Trackers](./../docs/md-resources/service-ip-tracker-evolution.md)

---

### 📖 Chapter 12: [Ingress & Gateway API: The Grand Entrance](story/ch12-ingress-and-gateway-api.md)
Routing customers through the main doors and specialized directories (**Ingress & Gateway API**).

**⚡ Study Guide:** [Ingress & Gateway API](./study-guide/ch12-ingress.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: Virtual Host Gateway Show](./../comics/ingress/01-virtual-host/README.md)
- 🧪 [Lab: Ingress & Virtual Host Routing](./../labs/services-and-networking/lab03-ingress-virtual-host/README.md)
- 🖼️ [Comic: The Lost Gateway](./../comics/gateway-api/01-the-lost-gateway/README.md)
- 🧪 [Lab: Canary Deployments with Gateway API](./../labs/deploying/lab05-canary-deployment-gateway-api/README.md)
- 📄 [Doc: Ingress vs Gateway API](./../docs/md-resources/ingress-vs-gateway.md)

---

### 📖 Chapter 13: [Network Policies: Locked Corridors](story/ch13-network-policies.md)
Restricting movement between departments to protect the mall's security.

**⚡ Study Guide:** [Network Policies](./study-guide/ch13-networking.md)

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Locked Corridor - Whitelisting Traffic](./../comics/network-policies/01-locked-corridors/README.md)
- 🧪 [Lab: Network Policies & Locked Corridors](./../labs/services-and-networking/lab06-network-policies/README.md)
- 📄 [Doc: Network Isolation Concept](./../docs/md-resources/troubleshooting-kubernetes.md#section-8-3)

---

## 🩺 Part 5: Observability and Maintenance `[ 15% ]`
> **Focus:** Health inspections, incident investigations, and the mall control room.

### 📖 Chapter 14: [Probes & Health Checks: The Health Inspector](story/ch14-probes-and-health-checks.md)
Ensuring shops are alive and ready to serve customers (**Liveness & Readiness Probes**).

**⚡ Study Guide:** [Health Checks & Probes](./study-guide/ch14-probes.md)

**🧰 Study Toolbox:**
- 📄 [Doc: Worker Safety and Probes](./../docs/md-resources/troubleshooting-kubernetes.md#section-2)
- 🖼️ [Comic: The Health Inspector - Liveness vs Readiness](./../comics/observability/01-the-health-inspector/README.md)
- 🖼️ [Comic: The Health Inspector - Readiness](./../comics/observability/02-readiness-probes/README.md)
- 🧪 [Lab: Liveness Probes: The Health Inspector](./../labs/observability/lab01-liveness-probes-health-inspector/README.md)

---

### 📖 Chapter 15: [Debugging & Logs: CCTV and Incident Reports](story/ch15-debugging-and-logs.md)
Investigating "incidents" using logs and real-time inspections (**Logs, Describe & Exec**).

**⚡ Study Guide:** [Debugging & Logs](./study-guide/ch15-debugging.md)

**🧰 Study Toolbox:**
- 📄 [Doc: Troubleshooting Guide](./../docs/md-resources/troubleshooting-kubernetes.md)
- 📄 [Doc: Diagnostic Cheat Sheet](./../docs/md-resources/diagnostic-cheat-sheet.md)
- 🖼️ [Comic: The Broken Shop](./../comics/observability/03-the-broken-shop/README.md)
- 🧪 [Lab: Fixing the Broken Shop](./../labs/observability/lab15-fixing-the-broken-shop/README.md)

---