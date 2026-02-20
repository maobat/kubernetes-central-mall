Book Index: "The Central Mall Guide to CKAD"

Part 1: Application Design and Build (20%)
Store Architecture & Staffing Patterns

Ch. 1: [Choosing the Right Workload](story/ch01-choosing-the-right-workload.md): When to use a Shop Clerk (Pod), a Manager (Deployment), a Night-Shift Worker (Job), or a Recurring Maintenance Crew (CronJob).

Resources: pod-design/02-jobs-cronjobs, using-statefulsets.md.

Ch. 2: [Multi-container Design Patterns](story/ch02-multi-container-design-patterns.md): The Clerk and their Helper (Sidecar, Init Containers).

Resources: pod-design/01-sidecar, lab01-sidecar-pattern.

Ch. 3: [Images & Modifications: Creating the perfect "Mannequin"](story/ch03-images-and-modifications.md) (Docker/OCI images).

Ch. 4: [Extending the Mall: Special Permits and External Contractors](story/ch04-extending-the-mall.md) (CRDs & Operators).

Resources: crd/01-the-nightly-backup-permit, extending-k8s-crds-operators.md.

Part 2: Application Environment, Configuration and Security (25%)
The Mall Vault & Employee Conduct

Ch. 5: [ConfigMaps & Secrets: The Price List and the Vault Combination](story/ch05-configmaps-and-secrets.md) (ConfigMaps & Secrets).

Resources: configuration/01-configmap, secrets/01-secrets-injection, lab-comprehensive-configuration-integration.md.

Ch. 6: [Worker Safety: Safety Gear and Conduct Protocols](story/ch06-worker-safety-and-conduct.md) (SecurityContexts, Capabilities).

Resources: securitycontext-worker-safety-and-conduct.md, lab-managing-security-settings.md.

Ch. 7: [Identity & Access (RBAC): The Magnetic ID Badge and the HR Manual](story/ch07-identity-and-access.md) (Roles, RoleBindings, ServiceAccounts).

Resources: security/01-the-secure-badge, understanding-role-based-access-control-rbac.md.

Ch. 8: [Resource Budgets: Water and Electricity Limits](story/ch08-resource-budgets.md) (Requests, Limits, Quotas).

Resources: resource-requests-limits-and-quotas-the-resource-budget.md.

Part 3: Application Deployment (20%)
Grand Openings & Changing Management

Ch. 9: [Launch Strategies: The Sign Swap and the Taste Test](story/ch09-launch-strategies.md) (Blue/Green, Canary).

Resources: canary-nodeport/01-canary-replica-weighting, implementing-canary-deployments.md.

Ch. 10: [Logistics Tools: Shipping Containers and Layout Templates](story/ch10-logistics-tools.md) (Helm & Kustomize).

Resources: using-the-helm-package-manager.md, using-kustomize.md.

Part 4: Services and Networking (20%)
Intercoms, Signage, and Side Entrances

Ch. 11: [Finding the Stores: The Intercom and the Delivery Bay](story/ch11-finding-the-stores.md) (ClusterIP, NodePort).

Resources: nodeport/01-cross-namespace, service-ip-tracker-evolution.md.

Ch. 12: [Ingress & Gateway API: The Grand Entrance and the Smart Directory](story/ch12-ingress-and-gateway-api.md).

Resources: ingress/02-virtual-host, gateway-api/01-the-lost-gateway.

Ch. 13: [Network Policies: Locked Corridors and Badge Access](story/ch13-network-policies.md).

Resources: troubleshooting-kubernetes.md#section-8-3 (Conceptual), [Lab to be written].

Part 5: Observability and Maintenance (15%)
The Control Room & Health Inspections

Ch. 14: [Probes & Health Checks: The Health Inspector](story/ch14-probes-and-health-checks.md) (Liveness, Readiness).

Resources: observability/01-the-health-inspector, healthz_probe.yaml.

Ch. 15: [Debugging & Logs: CCTV and Incident Reports](story/ch15-debugging-and-logs.md).

Resources: troubleshooting-kubernetes.md, diagnostic-cheat-sheet.md.