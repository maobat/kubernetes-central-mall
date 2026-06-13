# 📋 The Mall Directory: Global Glossary & Index

Welcome to **The Information Desk** of the Kubernetes Central Mall. 🛍️  
Use this directory to quickly look up terms, understand their mall analogies, and find every related chapter, lab, or comic in the project.

> [!TIP]
> **Pro Tip:** Use `Ctrl + F` to search for any keyword. Once you've found what you need, use your **Browser/IDE back button** to return to your previous chapter!

## 🧭 Navigating the Official Building Codes
When you follow links to `kubernetes.io`, you will encounter different types of documentation. Use this map to find the level of detail you need:

- **CONCEPTS (/docs/concepts)**: **The "Why" and "What".** Best for building mental models (like our *Story* & *Study Guides*).
- **TASKS (/docs/tasks)**: **The "How-To".** Step-by-step guides for specific configurations (like our *Labs*).
- **REFERENCE (/docs/reference)**: **The "Official Specs".** Command-line flags, API details, and the technical fine print.
- **TUTORIALS (/docs/tutorials)**: **The "Walkthroughs".** Longer, scenario-based learning paths.

---

## 🏗️ The Global Link Matrix
Find where each concept is discussed across different study paths.

| Topic | Story (Narrative) | Study Guide (Theory) | Hands-on Lab | Visual Comic | Official Docs |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **00. Introduction** | [Welcome](./sources/story.md) | [Reference Library](./reference/README.md) | - | [Show Comic](./visual-learning/comics/ch00-introduction/01-the-cast-of-characters/README.m[...]
| **01. Workloads** | [Story Ch1](./sources/story/ch01-choosing-the-right-workload.md) | [Guide Ch1](./sources/study-guide/ch01-workloads.md) | [Lab Index](./practice/labs/ch01-workloads/README.md[...]
| **02. Multi-Container** | [Story Ch2](./sources/story/ch02-multi-container-design-patterns.md) | [Guide Ch2](./sources/study-guide/ch02-multi-container.md) | [Lab Index](./practice/labs/ch02-mul[...]
| **03. Images & Design** | [Story Ch3](./sources/story/ch03-images-and-modifications.md) | [Guide Ch3](./sources/study-guide/ch03-pod-design.md) | [Lab Index](./practice/labs/ch03-images/README.m[...]
| **04. Extending K8s** | [Story Ch4](./sources/story/ch04-extending-the-mall.md) | [Guide Ch4](./sources/study-guide/ch04-extending-k8s.md) | [Lab Index](./practice/labs/ch04-extending/README.md)[...]
| **05. Configuration** | [Story Ch5](./sources/story/ch05-configmaps-and-secrets.md) | [Guide Ch5](./sources/study-guide/ch05-configuration.md) | [Lab Index](./practice/labs/ch05-config-secrets/R[...]
| **06. Worker Safety** | [Story Ch6](./sources/story/ch06-worker-safety-and-conduct.md) | [Guide Ch6](./sources/study-guide/ch06-security.md) | [Lab Index](./practice/labs/ch06-safety/README.md) [...]
| **07. Identity & RBAC** | [Story Ch7](./sources/story/ch07-identity-and-access.md) | [Guide Ch7](./sources/study-guide/ch07-identity.md) | [Lab Index](./practice/labs/ch07-identity/README.md) | [...]
| **08. Resource Budgets** | [Story Ch8](./sources/story/ch08-resource-budgets.md) | [Guide Ch8](./sources/study-guide/ch08-resources.md) | [Lab Index](./practice/labs/ch08-resources/README.md) | [...]
| **09. Launch (Deploy)** | [Story Ch9](./sources/story/ch09-launch-strategies.md) | [Guide Ch9](./sources/study-guide/ch09-deployments.md) | [Lab Index](./practice/labs/ch09-launch/README.md) | [[...]
| **10. Logistics (Helm)** | [Story Ch10](./sources/story/ch10-logistics-tools.md) | [Guide Ch10](./sources/study-guide/ch10-management.md) | [Lab Index](./practice/labs/ch10-logistics/README.md) [...]
| **11. Services** | [Story Ch11](./sources/story/ch11-finding-the-stores.md) | [Guide Ch11](./sources/study-guide/ch11-services.md) | [Lab Index](./practice/labs/ch11-services/README.md) | [Show [...]
| **12. Ingress & GW API**| [Story Ch12](./sources/story/ch12-ingress-and-gateway-api.md) | [Guide Ch12](./sources/study-guide/ch12-ingress.md) | [Lab Index](./practice/labs/ch12-ingress/README.md[...]
| **13. Network Policies**| [Story Ch13](./sources/story/ch13-network-policies.md) | [Guide Ch13](./sources/study-guide/ch13-networking.md) | [Lab Index](./practice/labs/ch13-networking/README.md)[...]
| **14. Health Checks** | [Story Ch14](./sources/story/ch14-probes-and-health-checks.md) | [Guide Ch14](./sources/study-guide/ch14-probes.md) | [Lab Index](./practice/labs/ch14-probes/README.md) |[...]
| **15. Debugging** | [Story Ch15](./sources/story/ch15-debugging-and-logs.md) | [Guide Ch15](./sources/study-guide/ch15-debugging.md) | [Lab Index](./practice/labs/ch15-debugging/README.md) | [Sh[...]
| **CKAD Playbook** | - | [Exam Strategy](./reference/md-resources/ckad-exam/playbook/03-time-management.md) | [Final Lab](./practice/labs/ch16-ckad-exam/README.md) | [Show Comic](./visual-learnin[...]

---

## 📖 Alphabetical Glossary

| CONCEPT | MALL ANALOGY | DEFINITION | STUDY PATH | OFFICIAL DOCS |
| :--- | :--- | :--- | :--- | :--- |
| <a id="api-server"></a>**API Server** | The Management Office | The single source of truth. Every request to change the mall must go through this office. | [Ch 00](#🏗️-the-global-link-matri[...]
| <a id="besteffort"></a>**BestEffort** | The Basic Worker | No guaranteed utility budget. Used only if there's spare capacity left in the mall. | [Story Ch 08](./sources/story/ch08-resource-budge[...]
| <a id="bluegreen-deployment"></a>**Blue/Green Deployment** | The Sign Swap | A zero-downtime strategy where you build a new shop version and swap the sign (Service) in one go. | [Story Ch 09](./[...]
| <a id="burstable"></a>**Burstable** | The Flexible Worker | A worker with some guaranteed capacity, but allowed to request extra if the mall allows it. | [Story Ch 08](./sources/story/ch08-resou[...]
| <a id="canary-deployment"></a>**Canary Deployment** | The Taste Test | Releasing a new version to a small subset of customers initially to verify safety. | [Story Ch 09](./sources/story/ch09-lau[...]
| <a id="clusterrole"></a>**ClusterRole** | The Mall-Wide Authority | Rules that apply to the **entire Mall (Cluster)**, like access to building blueprints (Nodes). | [Story Ch 07](./sources/story[...]
| <a id="configmap"></a>**ConfigMap** | The Shop Manual | A set of non-sensitive configuration rules for a shop (e.g., color scheme, open hours). | [Story Ch 05](./sources/story/ch05-configmaps-an[...]
| <a id="crd"></a>**CRD** | Special Building Permit | Custom Resource Definition: Extending the mall with new, custom rules (like "Nightly Backup Permit"). | [Story Ch 04](./sources/story/ch04-ext[...]
| <a id="cronjob"></a>**CronJob** | Scheduled Maintenance | Repeating tasks (e.g., cleaning the floors every night at 2 AM). | [Story Ch 01](./sources/story/ch01-choosing-the-right-workload.md) \|[...]
| <a id="daemonset"></a>**DaemonSet** | Floor Security | Ensures exactly one worker (Pod) remains on every single building (Node) at all times. | [Story Ch 01](./sources/story/ch01-choosing-the-ri[...]
| <a id="deployment"></a>**Deployment** | The Store Manager | Ensures that the correct number of workers (Pods) are always on duty. | [Story Ch 09](./sources/story/ch09-launch-strategies.md) \| [L[...]
| <a id="emptydir"></a>**emptyDir** | The Day-Use Locker | Temporary storage shared between workers in the same shop (Pod). Wiped when the shop closes. | [Story Ch 02](./sources/story/ch02-multi-c[...]
| <a id="endpointslice"></a>**EndpointSlice** | The Digital Staff List | The real-time list of which workers are currently at their desks and ready to help. | [Story Ch 11](./sources/story/ch11-fi[...]
| <a id="gateway-api"></a>**Gateway API** | The Smart Transit Hub | **(Modern)** A modular way to manage traffic using roles (Architect, Admin, Developer). | [Story Ch 12](./sources/story/ch12-ing[...]
| <a id="guaranteed"></a>**Guaranteed** | The VIP Worker | A worker whose minimum guaranteed utilities are exactly equal to their maximum allowed limits. | [Story Ch 08](./sources/story/ch08-resou[...]
| <a id="helm"></a>**Helm** | Mall Catalog Template | A tool for packaging and managing complex Mall blueprints as a single "chart." | [Story Ch 10](./sources/story/ch10-logistics-tools.md) \| [La[...]
| <a id="ingress"></a>**Ingress** | The Main Gate Guard | **(Legacy)** A rulebook that tells the entrance guard where to send customers based on their request. | [Story Ch 12](./sources/story/ch12[...]
| <a id="init-container"></a>**Init Container** | The Prep Crew | A special container that finishes its task before the main worker (Pod) starts (e.g., setting up the cash register). | [Story Ch 0[...]
| <a id="job"></a>**Job** | Temporary Contractor | A task that runs until it is finished (e.g., a one-time inventory count). | [Story Ch 01](./sources/story/ch01-choosing-the-right-workload.md) \|[...]
| <a id="kubeconfig"></a>**kubeconfig** | The Owner's ID Badge | The digital certificate that proves who you are and grants access to the Management Office. | [Exam Guide](./reference/md-resources[...]
| <a id="kubectl"></a>**kubectl** | The Management Terminal | The tool used to send commands to the Management Office. | [Speed-run Guide](./reference/md-resources/ckad-exam/playbook/02-cheatsheet[...]
| <a id="limit"></a>**Limit** | The Utility Cap | The maximum amount of resource (water/electricity) a shop can use before being cut off. | [Story Ch 08](./sources/story/ch08-resource-budgets.md) [...]
| <a id="liveness-probe"></a>**Liveness Probe** | The Health Inspector | Periodic check to see if a worker is still "alive" (not frozen). If they fail, they are replaced. | [Story Ch 14](./sources[...]
| <a id="namespace"></a>**Namespace** | The Individual Shop Space | A logical boundary that keeps one shop's resources separate from another. | [Story Ch 01](./sources/story/ch01-choosing-the-righ[...]
| <a id="networkpolicy"></a>**NetworkPolicy** | Internal Shop Security | Rules that define which shops (Pods) can talk to each other. | [Story Ch 13](./sources/story/ch13-network-policies.md) \| [[...]
| <a id="node"></a>**Node** | The Mall Building | A physical or virtual machine where the shops (Pods) are actually located. | [Story Ch 01](./sources/story/ch01-choosing-the-right-workload.md) | [...]
| <a id="oomkilled"></a>**OOMKilled** | Memory Eviction | The Guards evicting a shop immediately because it used more temporary inventory space (RAM) than allowed. | [Story Ch 15](./sources/story/[...]
| <a id="operator"></a>**Operator** | Robotic Shop Manager | A specialized manager that knows how to run complex applications automatically using a manual. | [Story Ch 04](./sources/story/ch04-ext[...]
| <a id="persistentvolume"></a>**PersistentVolume** | The Warehouse Vault | A permanent storage unit in the basement that stays even if the shop is replaced. | [Story Ch 02](./sources/story/ch02-m[...]
| <a id="pod"></a>**Pod** | The Individual Employee | The smallest unit in Kubernetes; a worker that runs your application. | [Story Ch 01](./sources/story/ch01-choosing-the-right-workload.md) \| [...]
| <a id="rbac"></a>**RBAC** | The HR Policy | Rule-Based Access Control: deciding who can do what (Read, Write, Delete) in the mall. | [Story Ch 07](./sources/story/ch07-identity-and-access.md) \|[...]
| <a id="readiness-probe"></a>**Readiness Probe** | The Velvet Rope | Periodic check to see if a worker is "open for business" and ready to receive customers. | [Story Ch 14](./sources/story/ch14-[...]
| <a id="replicaset"></a>**ReplicaSet** | The Shift Scheduler | Low-level controller that ensures a specified number of identical worker copies (Pods) are running. Usually managed by a Deployment. | [Story Ch 09](./sources/story/ch09-launch-strategies.md) \| [Guide Ch 09](./sources/study-guide/ch09-deployments.md) \| [Lab Ch 09](./practice/labs/ch09-launch/README.md) |
| <a id="request"></a>**Request** | The Utility Budget | The minimum amount of resource (water/electricity) a shop is guaranteed to have. | [Story Ch 08](./sources/story/ch08-resource-budgets.md) [...]
| <a id="resourcequota"></a>**ResourceQuota** | The Department Budget | Limits the total amount of resources all shops in a specific department (Namespace) can use. | [Story Ch 08](./sources/story[...]
| <a id="role"></a>**Role** | The Local Shop Permit | A list of "Can-Do" rules restricted to a single shop (Namespace). | [Story Ch 07](./sources/story/ch07-identity-and-access.md) \| [Labs Ch 07][...]
| <a id="rolling-update"></a>**Rolling Update** | Sequential Renovation | Updating a shop by building the new version one clerk at a time while removing the old ones. | [Story Ch 09](./sources/sto[...]
| <a id="secret"></a>**Secret** | The Manager's Safe | Storage for sensitive information like passwords or API keys. | [Story Ch 05](./sources/story/ch05-configmaps-and-secrets.md) \| [Labs Ch 05][...]
| <a id="securitycontext"></a>**SecurityContext** | Worker Safety Gear | Rules defining the permissions and safety constraints for a worker (e.g., "Must wear non-slip shoes"). | [Story Ch 06](./so[...]
| <a id="service"></a>**Service** | The Storefront Sign | A stable entry point or "phone extension" that stays the same even if workers move. | [Story Ch 11](./sources/story/ch11-finding-the-store[...]
| <a id="serviceaccount"></a>**ServiceAccount** | An Employee ID Badge | The identity used by a worker (Pod) to talk to the Management Office. | [Story Ch 07](./sources/story/ch07-identity-and-acc[...]
| <a id="sidecar-container"></a>**Sidecar Container** | The Helper | An additional worker in the same shop (Pod) that helps the main worker with tasks like logging or cleaning. | [Story Ch 02](./s[...]
| <a id="statefulset"></a>**StatefulSet** | Specialized Boutique | For apps that need stable "identities" and persistent storage (like a database). | [Story Ch 01](./sources/story/ch01-choosing-th[...]
| <a id="storageclass"></a>**StorageClass** | Type of Digging Machine | Defines different types of storage available (e.g., "Silver" for HDD, "Gold" for SSD). | [Story Ch 02](./sources/story/ch02-[...]
| <a id="throttling"></a>**Throttling** | Dimming the Lights | The Guards slowing down a shop's operations because it exceeded its electricity (CPU) limits. | [Story Ch 08](./sources/story/ch08-re[...]


---

 \| [Back to Main README](./README.md)
