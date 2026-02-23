# 🏙️ The Central Mall: A CKAD Adventure
> A narrative guide to mastering Certified Kubernetes Application Developer concepts through the lens of a bustling urban mall.

---

## 🏗️ Part 1: Application Design and Build `[ 20% ]`
> **Focus:** Understanding the core blueprints of the mall, how we hire staff, organize departments, and deploy our "mannequin" images.

### 📖 Chapter 1: [Choosing the Right Workload](./story/ch1.md) 
When to use a Shop Clerk (**Pod**), a Manager (**Deployment**), a Night-Shift Worker (**Job**), or a Recurring Maintenance Crew (**CronJob**).

**🧰 Study Toolbox:**
- 🖼️ [Comic: Jobs & CronJobs](./../comics/pod-design/02-jobs-cronjobs/README.md)
- 📄 [Doc: Using StatefulSets](./../docs/md-resources/using-statefulsets.md)

---

### 📖 Chapter 2: [Multi-container Design Patterns](./story/ch2.md)
The Clerk and their Helper (**Sidecar** and **Init Containers**).

**🧰 Study Toolbox:**
- 🖼️ [Comic: Sidecar Pattern](./../comics/pod-design/01-sidecar/README.md)
- 🧪 [Lab: Sidecar Pattern](./../labs/pod-design/lab01-sidecar-pattern/README.md)

---

### 📖 Chapter 3: [Images & Modifications: The Perfect "Mannequin"](story/ch3.md)
Mastering the art of building and updating your store's display models (**Docker/OCI Images**).

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Perfect Mannequin](./../comics/pod-design/03-image-updates/README.md)
- 🧪 [Lab: Image Updates & Rollouts](./../labs/pod-design/lab03-image-updates/README.md)

---

### 📖 Chapter 4: [Extending the Mall: Special Permits](story/ch4.md)
Hiring external contractors and obtaining special building permits (**CRDs & Operators**).

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Nightly Backup Permit](./../comics/crd/01-the-nightly-backup-permit/README.md)
- 📄 [Doc: Extending K8s with CRDs](./../docs/md-resources/extending-k8s-crds-operators.md)

---

## 🔐 Part 2: Environment, Configuration and Security `[ 25% ]`
> **Focus:** Managing the mall's vault, setting employee conduct rules, and balancing the utility budget.

### 📖 Chapter 5: [ConfigMaps & Secrets: The Price List and the Vault](story/ch5.md)
Managing shop data and keeping the combinations safe (**ConfigMaps & Secrets**).

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Rulebook & The Uniform](./../comics/configuration/01-configmap/README.md)
- 🧪 [Lab: Configuration: ConfigMaps](./../labs/configuration/lab01-configmaps/README.md)
- 🖼️ [Comic: The Secret of the High-Security Vault](./../comics/secrets/01-secrets-injection/README.md)
- 🧪 [Lab: Secrets & Env Injection](./../labs/security/lab03-secrets-env-injection/README.md)

---

### 📖 Chapter 6: [Worker Safety: Safety Gear and Conduct](story/ch6.md)
Setting strict rules for how employees handle equipment (**SecurityContexts & Capabilities**).

**🧰 Study Toolbox:**
- 📄 [Doc: Worker Safety and Conduct](./../docs/md-resources/securitycontext-worker-safety-and-conduct.md)
- 🧪 [Lab: Managing Security Settings (SecurityContext)](./../labs/security/lab01-serviceaccount-identity/README.md)

---

### 📖 Chapter 7: [Identity & Access (RBAC): The Magnetic ID Badge](story/ch7.md)
Assigning roles and permissions to ensure only authorized staff access the backrooms (**Roles & ServiceAccounts**).

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Secure Badge](./../comics/security/01-the-secure-badge/README.md)
- 📄 [Doc: Understanding RBAC](./../docs/md-resources/understanding-role-based-access-control-rbac.md)

---

### 📖 Chapter 8: [Resource Budgets: Water and Electricity](story/ch8.md)
Preventing "Resource Hogs" from causing mall-wide blackouts (**Requests, Limits & Quotas**).

**🧰 Study Toolbox:**
- 📄 [Doc: The Resource Budget](./../docs/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)

---

## 🚀 Part 3: Application Deployment `[ 20% ]`
> **Focus:** Grand openings, logistics pipelines, and managing change without disappointing customers.

### 📖 Chapter 9: [Launch Strategies: The Sign Swap and the Taste Test](story/ch9.md)
Mastering **Blue/Green** and **Canary** deployments to ensure zero downtime.

**🧰 Study Toolbox:**
- 🖼️ [Comic: Canary Traffic at the Side Entrance](./../comics/nodeport/01-canary-nodeport/README.md)
- 📄 [Doc: Implementing Canary Deployments](./../docs/md-resources/implementing-canary-deployments.md)
- 🧪 [Lab: Canary Deployments with NodePort](./../labs/services-and-networking/lab04-canary-nodeport/README.md)

---

### 📖 Chapter 10: [Logistics Tools: Shipping Containers](story/ch10.md)
Using standardized tools like **Helm** and **Kustomize** to manage mall layout templates.

**🧰 Study Toolbox:**
- 📄 [Doc: Using Helm](./../docs/md-resources/using-the-helm-package-manager.md)
- 📄 [Doc: Using Kustomize](./../docs/md-resources/using-kustomize.md)

---

## 🌐 Part 4: Services and Networking `[ 20% ]`
> **Focus:** Intercoms, signage, and managing the grand entrances of the mall.

### 📖 Chapter 11: [Finding the Stores: Intercoms and Delivery Bays](story/ch11.md)
Connecting shops and drivers via **ClusterIP** and **NodePort** services.

**🧰 Study Toolbox:**
- 🖼️ [Comic: The NodePort Traffic Adventure](./../comics/nodeport/02-cross-namespace/README.md)
- 🧪 [Lab: NodePort & Cross-Namespace Access](./../labs/services-and-networking/lab02-nodeport-cross-namespace/README.md)
- 📄 [Doc: Service IP Trackers](./../docs/md-resources/service-ip-tracker-evolution.md)

---

### 📖 Chapter 12: [Ingress & Gateway API: The Grand Entrance](story/ch12.md)
Routing customers through the main doors and specialized directories (**Ingress & Gateway API**).

**🧰 Study Toolbox:**
- 🖼️ [Comic: Virtual Host Gateway Show](./../comics/ingress/01-virtual-host/README.md)
- 🧪 [Lab: Ingress & Virtual Host Routing](./../labs/services-and-networking/lab03-ingress-virtual-host/README.md)
- 🖼️ [Comic: The Lost Gateway](./../comics/gateway-api/01-the-lost-gateway/README.md)
- 🧪 [Lab: Canary Deployments with Gateway API](./../labs/deploying/lab05-canary-deployment-gateway-api/README.md)

---

### 📖 Chapter 13: [Network Policies: Locked Corridors](story/ch13.md)
Restricting movement between departments to protect the mall's security.

**🧰 Study Toolbox:**
- 🖼️ [Comic: The Locked Corridor - Whitelisting Traffic](./../comics/network-policies/01-locked-corridors/README.md)
- 🧪 [Lab: Network Policies & Locked Corridors](./../labs/services-and-networking/lab06-network-policies/README.md)
- 📄 [Doc: Network Isolation Concept](./../docs/md-resources/troubleshooting-kubernetes.md#section-8-3)

---

## 🩺 Part 5: Observability and Maintenance `[ 15% ]`
> **Focus:** Health inspections, incident investigations, and the mall control room.

### 📖 Chapter 14: [Probes & Health Checks: The Health Inspector](ch14.md)
Ensuring shops are alive and ready to serve customers (**Liveness & Readiness Probes**).

**🧰 Study Toolbox:**
- 📄 [Doc: Worker Safety and Probes](./../docs/md-resources/troubleshooting-kubernetes.md#section-2)
- 🖼️ [Comic: The Health Inspector - Liveness vs Readiness](./../comics/observability/01-the-health-inspector/README.md)
- 🖼️ [Comic: The Health Inspector - Readiness](./../comics/observability/02-readiness-probes/README.md)
- 🧪 [Lab: Liveness Probes: The Health Inspector](./../labs/observability/lab01-liveness-probes-health-inspector/README.md)

---

### 📖 Chapter 15: [Debugging & Logs: CCTV and Incident Reports](story/ch15.md)
Investigating "incidents" using logs and real-time inspections (**Logs, Describe & Exec**).

**🧰 Study Toolbox:**
- 📄 [Doc: Troubleshooting Guide](./../docs/md-resources/troubleshooting-kubernetes.md)
- 📄 [Doc: Diagnostic Cheat Sheet](./../docs/md-resources/diagnostic-cheat-sheet.md)
- 🖼️ [Comic: The Broken Shop](./../comics/observability/03-the-broken-shop/README.md)
- 🧪 [Lab: Fixing the Broken Shop](./../labs/observability/lab15-fixing-the-broken-shop/README.md)

---