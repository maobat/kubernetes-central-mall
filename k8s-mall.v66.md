    # Kubernetes Decoupling & Application Configuration

## Key Component Analysis: Storage, Configuration, RBAC Security, and API Interaction
> **[Kubernetes Mall Analogy: The Full Directory (Advanced Configuration Edition)]**
>
> This document provides a comprehensive analysis that uses the popular Mall Analogy to explain in detail the fundamental components of Kubernetes, including storage decoupling (PV/PVC), configuration management (ConfigMaps/Secrets), and the security model (RBAC).
---

<h2 id="section-1-0">1.0 Document Overview / Table of Contents</h2>

| Section | Title | Summary |
| :--- | :--- | :--- |
| **2.0** | **[The Core Idea: Storage Decoupling](#20-the-core-idea-storage-decoupling)** | A concise overview of the Kubernetes Storage Decoupling Principle (PV, PVC, Binding). |
| **3.0** | **[The Cast of Characters](#30-the-cast-of-characters-internal--external-components)** | Analogies for Pods, Deployments, Services, Ingress. |
| **3.1** | **[Understanding the Traffic Flow](#31-understanding-the-traffic-flow-the-customer-journey)** | The "Customer Journey". |
| **3.2** | **[Diagnostic Cheat Sheet](#32-diagnostic-cheat-sheet-for-the-cast)** | If the mall isn't working. |
| **4.0** | **[Service IP Tracker Evolution](#40-the-evolution-of-the-service-ip-tracker)** | Endpoints vs EndpointSlice. |
| **4.1** | **[Configuration Decoupling](#41-configuration-decoupling)** | ConfigMaps, Secrets, Tokens. |
| **4.1.1** | **[Core Concepts](#411-core-concepts-configmaps-secrets-and-security)** | Intro to ConfigMaps & Secrets. |
| **4.1.2** | **[ServiceAccount Secrets](#412-key-concept-serviceaccount-secrets-for-api-access-the-trust-mechanism)** | Pod → API auth. |
| **4.1.3** | **[Secrets Use Cases](#413-secrets-use-cases-and-application-integration)** | DB, API keys. |
| **4.1.4** | **[ConfigMaps Injection](#414-configmaps-variables-vs-configuration-files)** | Env vs files. |
| **4.1.5** | **[Lab: Full Config](#415-lab-comprehensive-configuration-integration)** | Full setup lab. |
| **4.1.6** | **[Imperative Workflow](#416-lab-imperative-configuration-workflow)** | kubectl → YAML. |
| **4.2** | **[API Access](#42-api-interaction-and-access)** | API Server & proxy. |
| **4.2.1** | **[Understanding the Kubernetes API Core](#section-4-2-1)** | The role of the API server as the single source of truth.|
| **4.2.2** | **[Direct API Access and \`kube-proxy\`](#422-direct-api-access-and-kube-proxy)** | How to expose and access the API securely. |
| **4.2.3** | **[Connecting to the API via Proxy Tunnel](#section-4-2-3)** | Steps for using a local proxy to reach the API. |
| **4.2.4** | **[Using \`curl\` to Work with API Objects](#section-4-2-4)** | Examples of querying the API using command line tools. |
| **4.3** | **[API Deprecations and Stability](#43-api-deprecations-and-stability)** | Handling removed APIs and ensuring manifest file currency. |
| **4.4** | **[Authentication and Authorization (The Security Team)](#44-authentication-and-authorization-the-security-team)** | Explaining AuthN, AuthZ, and the RBAC model. |
| **4.4.1** | **[Authentication (AuthN)](#section-4-4-1)** | Proving who you are (Certificates, Tokens). |
| **4.4.2** | **[Authorization (AuthZ)](#section-4-4-2)** | Determining what you can do (RBAC, Node, ABAC). |
| **4.4.3** | **[Understanding Role-Based Access Control (RBAC)](#section-4-4-3)** | Detailed breakdown of Roles, ClusterRoles, and Bindings. |
| **4.5** | **[Understanding ServiceAccounts (The Shop's Internal Badge)](#section-4-5-0)** | Explaining default access, token mounting, and the need for custom SAs. |
| **4.6** | **[Implementing RBAC with Roles and Bindings (The HR Process)](#section-4-6-0)** | Full lab demo showing forbidden access (default SA) vs. granted access (custom SA). |
| **4.6.1** | **[Defining the Custom Components](#section-4-6-1)** | Creating the ServiceAccount, Role (Job Description), and RoleBinding (HR Assignment). |
| **4.6.2** | **[Lab: Imperative Pod and ServiceAccount Inspection](#section-4-6-2)** | Step-by-step commands to create a Pod via imperative dry-run and inspect its generated YAML configuration, specifically regarding the default ServiceAccount setting. |
| **5.0** | **[Storage and Logistics (Persistent & Local Data)](#section-5-0)** | Deep dive into PVs, PVCs, StorageClasses, and Pod volumes. |
| **5.0.1** | **[Static vs. Dynamic Provisioning](#section-5-0-1)** | Explains the 3-file vs. 1-file difference in storage setup. |
| **5.1** | **[Creating a PersistentVolume](#section-5-1)** | YAML for a `hostPath` PV and how to verify its creation on the Node. |
| **5.2** | **[PVC Definition & Binding](#section-5-2)** | Breakdown of the `PVC` request form and the PV/PVC matchmaking process. |
| **5.3** | **[The Role of StorageClass](#section-5-3)** | Explains Dynamic Provisioning and Static Selection using StorageClass. |
| **5.3.1** | **[The Spectrum of Storage Class Names](#534-the-spectrum-of-storage-class-names)** | Clarifies that the name can be anything and details the three main categories (Empty, Default, Custom). |
| **5.4** | **[Access Modes: RWO vs. RWM](#section-5-4)** | Explaining the different access capabilities of storage. |
| **5.5** | **[Lab Analysis: Shared Volume Setup](#section-5-5)** | Comprehensive analysis of the shared volume lab exercise. |
| **5.6** | **[Decoupling Pods](#section-5-6)** | The architecture principle behind separating application needs from storage specifics. |
| **5.7** | **[Connecting the Worker](#section-5-7)** | Concrete files for PV/PVC/Pod binding and usage. |
| **5.8** | **[Storage Recap for Dummies](#section-5-8-0)** | A simple three-line table comparing PV, PVC, and Pod Volume lifecycles. |
| **5.8.1** | **[Dynamic Binding (1-File Approach)](#section-5-8-1)** | Breakdown of the Dynamic Provisioning (1-File) binding process. |
| **5.8.2** | **[Static Binding (Manual Matching)](#section-5-8-2)** | Breakdown of the Static Provisioning (Manual Matching) binding process. |
| **6.0** | **[Deploying Applications the DevOps Way (Helm, Kustomize, CD)](#60-deploying-applications-the-devops-way)** | Advanced deployment strategies packaging, and lifecycle management. |
| **6.1** | **[Using the Helm Package Manager](#61-using-the-helm-package-manager)** | Overview of Helm as the package manager. |
| **6.2** | **[Working with Helm Charts](#section-6-2-0)** | Installing and customizing charts. |
| **6.3** | **[Core Deployment Topics](#63-core-deployment-topics)** | Kustomize, Blue/Green, Canary, CRDs, Operators, and StatefulSets. |
| **6.3.1** | **[Using Kustomize](#631-using-kustomize)** | Customizing YAML manifests declaratively using overlays for different environments. |
| **6.3.2** | **[Implementing Blue/Green Deployments](#632-implementing-bluegreen-deployments)** | Zero-downtime, low-risk deployment via simultaneous stable and new environments. |
| **6.3.2.1** | **[Lab Demo Recap: Traffic Transition with Kubernetes Service](#6321-lab-deployment-steps-full-traffic-transition-demo)** | Actions executed in the terminal to demonstrate switching traffic. | 
| **6.3.3** | **[Implementing Canary Deployments](#633-implementing-canary-deployments)** | Progressive rollout strategy releasing the new version to a small subset of users. |
| **6.3.3.1** | **[Demo Recap: Progressive Traffic Demo](#section-6-3-3-1)** | Gradual scaling of Stable and Canary deployments using kubectl scale to achieve controlled traffic distribution. |
| **6.3.4** | **[Related Deployment Strategies Comparison](#634-related-deployment-strategies-comparison)** | Comparison: Blue/Green vs. Canary Deployments |
| **6.3.5** | **[Understanding Custom Resource Definitions (CRDs)](#section-6-3-5)** | Extending the Kubernetes API with new, custom resource types. |
| **6.3.5.1** | **[Phase 1: Defining the New Permit Type (The CRD)](#section-6-3-5-1)** | Defines the structure and requirements for the "Nightly Backup Service" (BackUp) permit, establishing the official ruleset that extends the Central Mall Management's capabilities. |
| **6.4** | **[Extending K8s: CRDs & Operators](#section-6-4-0)** | Automation of complex operational tasks (backup, scaling) using CRDs and Controllers. |
| **6.4.3** | **[CRD Demo (Creating a Custom Service)](#section-6-4-3)** | A step-by-step guide on defining a Custom Resource Definition (CRD) and creating a simple Controller/Operator to manage the custom resource. |
| **6.4.4** | **[Using StatefulSets](#section-6-4-4)** | Specialized workload for managing stateful applications (stable identity and storage). |
| **6.4.5** | **[Case Study: The Vault Recovery (The "Hard Way")](#645-lab-case-study-the-vault-recovery)** | A real-world troubleshooting flow covering StatefulSet persistence, CNI network failures, and Readiness Probe unsealing. |
| **6.5** | **[Service Mesh and Security](#section-6-5-0)** | Advanced networking and security patterns for inter-service communication. |
| **6.7** | **[Lab: Canary Deployments (The "New Recipe" Test)](#section-6-6-0)** | Advanced networking and security patterns for inter-service communication. |
| **7.0** | **[The Chronicles of the Central Mall: The Full Narrative](#70-the-chronicles-of-the-central-mall-the-full-narrative)** | The definitive epic of the Central Mall |
| **8.0** | **[Troubleshooting Kubernetes](#section-8-0)** | A hands-on example of using shared volumes between two containers in a single Pod. |
| **9.0** | **[Sample Exam](#90-sample-ckad-exam-flow)** | Final practice simulation, time management, and triage. |
| **10.0**| **[The Final Simulation](#100-the-final-simulation)** | **The Final Simulation: 15 Tasks including Sidecars, Probes, NetworkPolicy, and Canaries.** |
---

<!-- <a id="section-2-0"></a><h2>2.0 The Core Idea: Storage Decoupling</h2> -->
## 2.0 The Core Idea: Storage Decoupling

The Kubernetes storage model is built on **decoupling**. Applications (Pods) should only declare their **need** for storage, not **where** that storage comes comes from.

| Kubernetes Concept | Mall Analogy | Description |
| :--- | :--- | :--- |
| **PersistentVolume (PV)** | **The Storage Room** | The physical storage resource, set up by the Cluster Administrator. |
| **PersistentVolumeClaim (PVC)** | **The Request Form** | The application's request for a specific size and access mode (e.g., 1Gi, ReadWriteOnce). |
| **Binding** | **The Matchmaking** | The Kubernetes Control Plane (Mall Manager) matches a PVC Request Form to an available PV Storage Room. |
| **Decoupling** | **Worker Freedom** | The Worker (Pod) only references the PVC Request Form, allowing it to move across the cluster without needing to know the physical storage path (PV hostPath, cloud disk, etc.). |

---

<!-- <a id="section-3-0"></a><h2>3.0 The Cast of Characters</h2> -->
## 3.0 The Cast of Characters (Internal & External Components)

| CONCEPT | RESOURCE | MALL ANALOGY | ROLE IN KUBERNETES |
| :--- | :--- | :--- | :--- |
|**The Management Office**|	**kube-apiserver**|	Central Management|	The single source of truth. Every request to change the mall must go through this office.|
|**The Front Desk**|	**Kubernetes API**|	The Mall Ledger|	The official record of every shop, worker, and rule. If it isn’t in the Ledger, it doesn’t exist.|
|**The Security Badge**|	**kubeconfig** (~/.kube/config)|	The Owner's ID Badge|	The digital certificate that proves who you are and what parts of the Management Office you can access. This is your Master Key. You use it to tell the Management Office to build the mall.|
|**The Translator**|	**kubectl proxy**|	The Proxy/Phone Line|	A secure "tunnel" that lets standard tools (like curl) talk to Management without needing a complex badge.|
| **The Stable Counter** | **Service (ClusterIP)** | The Permanent Storefront Sign | A stable, internal "extension number" or counter location. Even if the workers change, the counter stays put. |
| **The Worker** | **Pod** | The Individual Employee | The running containerized application that does the actual work (temporary/scalable). |
| **The Manager** | **Deployment**| The Store Manager | Ensures the correct number of Pods (workers) are always running. |
| **The Main Gate** | **Ingress Controller**| The Guard at the Main Entrance | The program that reads the Ingress Rules and directs external traffic. |
| **The Rulebook** | **Ingress Resource**| The Guard's Rule Sheet (YAML) | **(Legacy)** A single file that lists every store. If the Boutique changes its hours, the Guard has to update the entire list for the whole mall. |
| **The Guest List** |	**EndpointSlice**| The Digital Staff List |	The real-time list of which workers are currently at their desks.|
| **The Side Door**	|**Service (NodePort)**	|Side Entrance with Keypad|	A high-port entry (30000+) on every building for external testing.|
|**The Architect**|	**GatewayClass**	| The Mall Construction Plan |	**(Modern)** Defines the type of technology used (Nginx, Istio, Cloud). Set once by the Cloud/Infrastructure provider.|
|**The Entrance**|	**Gateway**|	The Physical Transit Hub |	**(Modern)** The actual entrance with an IP address. Managed by **Admins** who decide which domains (like `myapp.info`) are allowed in.|
|**The Signage** |	**HTTPRoute** |	Store-Specific Directions |	**(Modern)** Individual rules created by **App Developers**. They control their own traffic (like 90/10 Canary splits) without touching the main Gate.|
|**The Auto-Builder**| **GitOps Operator**|	The Robotic Architect|	**(Modern)** Watches the blueprints in the vault (Git) and automatically builds the mall to match them.|
|**The Shop's Internal Badge**|**ServiceAccount (SA)**|The Automated Employee ID|The identity used by Pods to authenticate with the Management Office. Every worker (Pod) wears one.|
|**The Job Description**|**Role**|The Local Shop Permit|A list of "Can-Do" rules (verbs) restricted to a **single shop (Namespace)**. Example: "Can read the Jewelry Ledger."|
|**The HR Assignment Letter**|**RoleBinding**|The Local HR Appointment|The document that pins a **Local Permit (Role)** to a specific **Employee ID (ServiceAccount)** within one shop.|
|**The Executive Permit**|**ClusterRole**|The Mall-Wide Authority|A list of rules that apply to the **entire Mall (Cluster)**. Used for resources like Nodes or for tasks across all Namespaces.|
|**The Executive Promotion**|**ClusterRoleBinding**|The Mall-Wide Appointment|The high-level document that grants an **Executive Permit (ClusterRole)** to an ID, giving them power across the **entire mall**.|
---

### 3.1 Understanding the Traffic Flow (The "Customer Journey")

To see how these characters interact, follow the path of a request during `Section 10.2 - Task 7`:

**1. The GPS (`/etc/hosts`):** The customer looks up the address of the Mall.

**2. The Front Door (Ingress):** The customer arrives at the Mall Entrance and asks for `myapp.info`.

**3. The Security Guard (Ingress Controller):** Checks the **Rulebook (Ingress Resource)** and identifies that the request belongs to the `updates` department.

**4. The Storefront (Service):** The guard uses the **Internal Intercom (ClusterIP)** to reach the `task7svc` storefront.

**5. The Staff List (EndpointSlice):** The Service checks the **Guest List** to see which workers (Pods) are currently available.

**6. The Staff (Pod):** The request is handed to an available worker who serves the "Nginx Welcome Page."

---
### 3.2 Diagnostic Cheat Sheet for "The Cast"
If the mall isn't working, use these commands to find the "Character" at fault:

- **Is the Manager working?** `kubectl get deploy`

- **Are the Workers healthy?** `kubectl get pods`

- **Is the Intercom connected to the Staff?** `kubectl get endpointslices`

- **Is the Security Guard following the rules?** `kubectl describe ingress myapp`
---

### 3.3 Gateway API: The "Smart Transit Hub" 
As Ingress enters "Feature Freeze," the **Gateway API** takes over. It is a role-oriented, modular system that ensures the Mall Architect, the Security Guard, and the Shop Owner don't step on each other's toes.
**The Gateway Cast of Characters**
|Concept|Resource|Mall Analogy|Role in Kubernetes|
|-|-|-|-|
|**The Blueprint**|GatewayClass|**The Mall Architect**|Defines the entry system style (e.g., Nginx Fabric).|
|**The Entrance**|Gateway|**The Security Guard**|The physical hub point where traffic arrives.|
|**The Signage**|HTTPRoute|**The Shop Signage**|Directions: "Boutique this way, Café that way."|

**Infrastructure Setup**
Gateway API requires **Custom Resource Definitions (CRDs)** and a **Controller** (like Nginx Gateway Fabric) to function.

1. **The Gateway API Hierarchy**
- **GatewayClass:** The template (**The Architect**).
- **Gateway:** The entrance point (**The Security Guard**).
- **HTTPRoute:** The routing rules (**The Signage**).

**Implementation Flow (The Nginx Fabric Way)**

Before we build the entrance, we must establish the mall's rulebook (CRDs) and hire the security staff (Controller).

  1. **Install the Rulebooks (CRDs):**
```Bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.0.0/standard-install.yaml
```
  2. **Hire the Guards (Controller):**
```Bash
helm install my-gateway-controller oci://ghcr.io/nginxinc/charts/nginx-gateway-fabric ...
```
  3. **Build the Entrance (Gateway):** Allocates the Mall's external IP address.
  4. **Hang the Signs (HTTPRoute):** Connects the Gateway to your shop services (like `task7svc`).
---

### 3.4 Mall Analogy: Ingress vs. Gateway API
  - **Ingress (The Old Way):** One giant, messy manual. If the "Boutique" owner wanted to change a rule, they had to edit the same file as the "Café" owner. It was crowded and risky.
  - **Gateway API (The New Way):**
    - The Mall Owner creates the GatewayClass (sets the standard).
    - The Security Manager sets up the Gateway (opens the door).
    - The Shop Owner creates their own HTTPRoute (directs their own customers).

|Feature|Ingress (The Old Way)|Gateway API (The New Way)|
|-|-|-|
|**Philosophy**|"One-size-fits-all" (Single file)|"Divide and Conquer" (Modular)|
|**Control**|Developers fight over one file|Admin controls the Door, Dev the Route|
|**Customization**|Relies on complex "Annotations"|Built-in features (headers, weights)|
|**Exam Status**|Current CKAD Standard|Emerging (Crucial for 2026+)|

---
### 3.5 Lab 6.3.3.2: Advanced Traffic Splitting
Why upgrade to Gateway API for Canary testing? Because **"Weighting"** (e.g., a 90/10 split) is a native feature of the signage, not a "hack" or a special instruction.

**The "Shop Owner" defines the 90/10 split in the** `HTTPRoute`:
```YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: canary-route
spec:
  parentRefs: [{ name: oklahoma-entrance }]
  rules:
  - backendRefs:
    - { name: stable-nginx, weight: 90 }  # 90% to Old Reliable
    - { name: canary-nginx, weight: 10 }  # 10% to the New Canary
```
**Verification:**
```Bash
# Get the Smart Hub IP
kubectl get gtw
# Test the split (The Host Header trick remains king!)
curl -H "Host: myapp.info" <GATEWAY_IP>
```
Since we have the oklahoma wing of the mall ready with our securepod (`Task 15`), let's apply this new **Gateway API** logic to it. This will transition us from a simple internal pod to a professionally routed "Storefront."

---
### 3.6 Lab Exercise: Routing to the Oklahoma Wing 

<img src="image11.png" alt="Canary Deployment Schema in Kubernetes" height="35%" width="35%" />

We are transforming the `oklahoma` wing from an isolated pod into a professional storefront accessible via the **Gateway API**.

---
**Step 1: Create the Shop Counter (Service)**
The Gateway needs a stable "Counter" to send shoppers to.
```Bash
mk -- expose pod securepod -n oklahoma --port=80 --name=secure-service
```
---
**Step 2: Install the "Rulebooks" (CRDs)**
To use the modern Gateway API, we must add the building codes to the cluster-wide library.

> **Note:** We use the **experimental** version because modern controllers like Nginx Gateway Fabric expect the full rulebook (including GRPCRoutes) to even start.
```Bash
mk -- apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/experimental-install.yaml
```
---
**Step 3: Hire the Guard (Install Controller)**
We use Helm to bring in the **NGINX Gateway Fabric**, which acts as the security team managing the doors.
```Bash
helm install my-nginx oci://ghcr.io/nginxinc/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway
```
---
**Step 4: Verify the Architect (GatewayClass)**
Wait for the Pod in `nginx-gateway` to be `2/2 Running`. Then, confirm the Architect is ready:
```Bash
mk -- get gatewayclass
# Result: NAME: nginx, ACCEPTED: True
```
---
**Step 5: Build the Physical Entrance (Gateway)**
Create `oklahoma-gateway.yaml`. This is the physical door where traffic enters the `oklahoma` wing.
```YAML
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: oklahoma-entrance
  namespace: oklahoma
spec:
  gatewayClassName: nginx 
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    allowedRoutes:
      namespaces:
        from: Same
```
**Apply it:** `mk -- apply -f oklahoma-gateway.yaml -n oklahoma`

---
**Step 6: Hang the Signage (HTTPRoute)**
Create `oklahoma-route.yaml`. 
This sign tells shoppers: "If you want the Boutique, go to the secure-service counter."
```YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: oklahoma-sign
  namespace: oklahoma
spec:
  parentRefs:
  - name: oklahoma-entrance 
  rules:
  - matches:
    - path: { type: PathPrefix, value: /boutique }
    filters:                      # <--- THE FIX: URL Rewrite
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplacePrefixMatch
          replacePrefixMatch: /   # Strips /boutique and sends / to the pod
    backendRefs:
    - name: secure-service
      port: 80
```
**Apply it:** `mk -- apply -f oklahoma-route.yaml -n oklahoma`

---

### 3.7 The "Traffic Flow" Verification
Now we verify that the "Sign" has successfully "snapped" onto the "Door.

---
**1. "Check the Infrastructure:** `get all` won't show the signs! Use specific commands:
```Bash
mk -- get gateway,httproute -n oklahoma
```
---
Ensure **PROGRAMMED** is `True` for the Gateway.

**2. Describe the Route:** Verify the sign is officially accepted by the security guard:
```Bash
mk -- describe httproute oklahoma-sign -n oklahoma
```
<i>Look for `Accepted: True` and `ResolvedRefs: True` in the Status section.</i>

---
**3. The Final Test (Street Access):** If on Minikube, open a new terminal and run **minikube tunnel**. Then:
```Bash
curl -i <GATEWAY_IP>/boutique
```
**Summary of the Oklahoma Setup**
|Component|Resource|Mall Analogy|
|-|-|-|
|**Namespace**|`oklahoma`|The Oklahoma Wing|
|**Identity**|`ServiceAccount: secure`|Employee Badge|
|**Worker**|`Pod: securepod`|The Shop Assistant|
|**Counter**|`Service: secure-service`|The Cashier Desk|
|**Entrance**|`Gateway: oklahoma-entrance`|The VIP Glass Doors|
|**Signage**|`HTTPRoute: oklahoma-sign`|The "Boutique This Way" Sign|

---
<!-- <a id="section-4-0"></a><h2>4.0 Service IP Tracker</h2> -->
## 4.0 The Evolution of the Service IP Tracker


Both <b>Endpoints</b> and <b>EndpointSlices</b> represent the "Guest List" (the people currently inside), but they represent how that list is physically written and managed.

| CONCEPT | RESOURCE | MALL ANALOGY | FUNCTION & SCALABILITY |
| :--- | :--- | :--- | :--- |
| Legacy IP List | `Endpoints` | The Original, Single, HUGE Map | One long piece of paper listing every single employee. If one person joins, you have to rewrite the entire scroll. |
| Modern IPs | `EndpointSlice` | The Modern Digital Directory | The list is broken into small pages (Slices). If a person joins, you only update one small page, not the whole directory. |

In the mall, the **Service** is the "Front Door." It never moves. The **EndpointSlice** is the "Guest List" of who is currently working inside.

### Service vs. EndpointSlice Names
* **The Service (`canary-svc`):** Has a **fixed name** and a **static ClusterIP**. This is what users and other apps connect to.
* **The EndpointSlice (`canary-svc-abc12`):** Has a **generated name**. It is a dynamic helper object that stores the real-time IP addresses of your Pods. Kubernetes uses a label to link it to the Service.

**Diagnostic Commands:**
```bash
# Get the stable "Front Door"
kubectl get svc canary-svc

# Get the dynamic "Guest List" using a label filter
kubectl get endpointslice -l kubernetes.io/service-name=canary-svc
```
---
<!-- <a id="section-4-1"></a><h2>4.1 Configuration Decoupling</h2> -->
## 4.1 Configuration Decoupling


The key principle is decoupling application code from site-specific configuration. The application image should be generic, while deployment specifics are externalized.

Configuration decoupling ensures that application settings (`ConfigMaps`), sensitive data (`Secrets`), and API access credentials (`ServiceAccounts`) are managed externally to the Pod definition. This promotes portability and security.

<!-- <a id="section-4-1-1"></a><h2>4.1.1 Core Concepts</h2> -->
## 4.1.1 Core Concepts: ConfigMaps, Secrets, and Security

ConfigMaps and Secrets are essential for separating application code (portable) from deployment configuration (environment-specific).

| Concept | Kubernetes Resource | Use Case | Analogy |
| :--- | :--- | :--- | :--- |
| **Configuration** | `ConfigMap` | Non-sensitive data like URLs, usernames, log levels, or configuration files. | A public instruction manual or settings document. |
| **Secrets** | `Secret` | Sensitive data like passwords, API keys, or security certificates. | A secured vault or safe deposit box. |

#### Security Principle for Secrets

Secrets are specialized Kubernetes resources designed for storing sensitive data. They are **Base64 encoded**, not encrypted by default, and must be protected by **RBAC** (Role-Based Access Control) and **etcd** (Every Thing Consistently Distributed) encryption. Secrets are vital for allowing Pods to connect securely to other cluster resources or external services.

<!-- <a id="section-4-1-2"></a><h2>4.1.2 ServiceAccount Secrets</h2> -->
## 4.1.2 Key Concept: ServiceAccount, Secrets for API Access
All resources within Kubernetes that need to interact with the Kubernetes API require proper authentication and authorization.

* **ServiceAccounts (SA):** Every Pod runs under a ServiceAccount (either default or specified), granting it an identity.
* **TLS Keys:** The necessary Transport Layer Security (TLS) keys (certificate authority, token, and namespace) are required for API authentication.
* **Automatic Mounting (Older Versions):** In older Kubernetes versions (pre-1.24), a dedicated Secret object containing the ServiceAccount token was automatically created and mounted into the Pod at `/var/run/secrets/kubernetes.io/serviceaccount`.

#### Kubernetes Version Difference & Manual Token Patching

Modern Kubernetes (v1.24+) relies on **Projected Volume Tokens** for short-lived, secure access, meaning the dedicated, long-lived Secret is no longer automatically created. This change can break legacy components (like CoreDNS) expecting the Secret to exist.

To fix this, we must manually create and link a token Secret to the ServiceAccount.

**Step 1: Define the Base64 Encoded Data**

To manually create a ServiceAccount Token Secret, you need the following Base64-encoded data (JWT token, CA certificate, and namespace):

| Field Name | Description Placeholder | Value (Base64) |
| :--- | :--- | :--- |
| `token` | The JWT used for API authentication. | `c2VydmljZWFjY291bnQtdG9rZW4=` |
| `ca.crt` | The CA certificate for API server TLS verification. | `Y2xpZW50LWNhLWNlcnRpZmljYXRl` |
| `namespace` | The namespace of the Secret. | `a3ViZS1zeXN0ZW0=` |

**Step 2: Create the Secret Manifest (coredns-secret.yaml)**

This manifest uses the `kubernetes.io/service-account-token` type and links to the `coredns` ServiceAccount:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: coredns-manual-token # CRITICAL: Must match the name linked in the SA
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: coredns
type: kubernetes.io/service-account-token # CRITICAL: Specifies the token Secret structure
data:
  # Base64 encoded values for token, ca.crt, and namespace:
  token: c2VydmljZWFjY291bnQtdG9rZW4=
  ca.crt: Y2xpZW50LWNhLWNlcnRpZmljYXRl
  namespace: a3ViZS1zeXN0ZW0=
```

**Step 3: Apply the Manifest (The Fix)**

```bash
kubectl apply -f coredns-secret.yaml
# Patch the ServiceAccount to reference the new token Secret (required for legacy compatibility)
kubectl patch sa coredns -n kube-system -p '{"secrets": [{"name": "coredns-manual-token"}]}'
```

<!-- <a id="section-4-1-3"></a><h2>4.1.3 Secrets Use Cases</h2> -->
## 4.1.3 Secrets: Use Cases and Application Integration
Secrets are used to hold sensitive data. Since a Secret is essentially a Base64-encoded ConfigMap, it can be mounted or injected into a Pod in similar ways.

#### A. Secret Creation Use Cases

Different types of secrets are created based on the kind of data they hold:

| Use Case | Command Example | Secret Type |
| :--- | :--- | :--- |
| **TLS Certificates/Keys** | `kubectl create secret tls my-tls-keys --cert=tls/my.crt --key=tls/my.key` | `kubernetes.io/tls` |
| **Generic Passwords** | `kubectl create secret generic my-secret-pw --from-literal=password=verysecret` | `Opaque` |
| **SSH Private Key** | `kubectl create secret generic my-ssh-key --from-file=ssh-private-key=.ssh/id_rsa` | `Opaque` |
| **Sensitive File** | `kubectl create secret generic my-secret-file --from-file=/my/secretfile` | `Opaque` |
| **Container Registry Auth** | `kubectl create secret docker-registry my-docker-credentials --docker-username=... ` | `kubernetes.io/docker-registry` |

##### Registry Authentication Decoupling

To pull images from private container registries (like Docker Hub or a private corporate registry), additional authentication is required.

* On a stand-alone container node, these credentials would be stored in a local config file.
* In a cloud-native environment, the authentication information should be decoupled from the nodes and stored centrally using a Secret.
* Use the `docker-registry` Secret type to store the authentication credentials in a Secret.

#### B. Walkthrough: Authenticating Image Pulls (`docker-registry` Secret)

These commands demonstrate the creation and inspection of a `docker-registry` Secret in Kubernetes. This type of Secret is specifically used to store credentials required for Pods to pull images from a private container registry.

**🚀 1. Creating the Secret**

```bash
kubectl create secret docker-registry my-docker-credentials \
    --docker-username=unclebob \
    --docker-password=secretpw \
    --docker-email=uncle@bob.org \
    --docker-server=myregistry:5000
```

**Explanation:**
* **`kubectl create secret docker-registry`:** Tells Kubernetes to create a Secret specifically of the type `kubernetes.io/dockerconfigjson`.
* **`my-docker-credentials`:** This is the name of the Secret being created.
* **`--docker-server=myregistry:5000`:** The URL of the private container registry.
* **`--docker-username=... / --docker-password=...`:** The credentials used for authentication against that registry.
* **Result:** Kubernetes automatically creates a Base64-encoded JSON object that mimics the standard Docker configuration file (`~/.docker/config.json`) and stores it as data in the Secret.

**🔎 2. Basic Inspection**

```bash
k get secrets my-docker-credentials
```

| Column | Value | Notes |
| :--- | :--- | :--- |
| **NAME** | `my-docker-credentials` | The name you assigned. |
| **TYPE** | `kubernetes.io/dockerconfigjson` | Confirms the type is for private registry access. |
| **DATA** | `1` | Indicates there is one primary data field in the Secret (the `.dockerconfigjson` entry). |

**📝 3. Detailed Inspection**

```bash
k describe secret my-docker-credentials
```

> **Output Notes:**
The `describe` command provides a human-readable summary of the Secret.
* **Type:** `kubernetes.io/dockerconfigjson`
* **Data:** `.dockerconfigjson: XXX bytes` (Shows the size of the encoded credential data, but not the contents).

**🔑 4. Viewing Raw Encoded Content**

```bash
k get secrets my-docker-credentials -o yaml
```

> **Output Notes:**
* Using `-o yaml` retrieves the Secret's full YAML definition, including the Base64-encoded credential data.
* The key field is `.dockerconfigjson`, which holds the Base64 representation of the JSON data structure containing the registry credentials.
* **Crucial Note:** This output is not the plain text password. You must Base64-decode this string to view the raw credentials.

**Next Steps: Linking the Secret to a Pod**

Once this Secret is created, the final step is to reference it so that Kubernetes knows to use these credentials when pulling the image. You add the Secret name to the `imagePullSecrets` field of the ServiceAccount used by the Pod:

```yaml
# Example snippet for a ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-app-sa
imagePullSecrets:
- name: my-docker-credentials
```

#### C. Consuming Secrets in Applications

There are two primary ways applications consume Secrets:

1.  **Environment Variables:** Best for single, simple values (like passwords).
    * Use the `kubectl set env` command (often used with Deployments).

2.  **Volume Mounts:** Best for files, certificates, or when fine-grained file permissions are needed.
    * Mount the Secret as a volume in the Pod specification.



---

### Security and Maintenance of Mounted Secrets

#### 1. Permission Control with `defaultMode`

When you mount a Secret as a volume, you are placing its key-value pairs as individual files inside the container's filesystem. The `defaultMode` setting allows you to control the Unix file permissions applied to these created files.

**Why It's Important**
By default, files created from Secrets and ConfigMaps are usually readable by everyone in the container (often `0644`). For highly sensitive data, this is often too permissive. Using `defaultMode` lets you restrict who can read the secret files, often limiting access to just the process owner (the user running the application).

**Example Usage:**
* **`defaultMode: 0400`:** This sets the files to be read-only by the owner (`r--------`). This is a common secure setting for sensitive files like private keys.
* **`defaultMode: 0640`:** Read/write for the owner, read-only for the group (`rw-r-----`).

**Implementation Snippet**
You define `defaultMode` within the volume definition section of your Deployment/Pod specification.

```yaml
# ... inside spec.template.spec
volumes:
- name: secret-volume
  secret:
    secretName: my-tls-secret
    defaultMode: 0400  # Sets permissions on the mounted files
# ...
containers:
- name: my-app
  volumeMounts:
  - name: secret-volume
    mountPath: "/etc/secrets"
```

#### 2. Automatic Updating of Mounted Secrets

One of the most powerful features of mounted Secrets is that they are not static. If you update the contents of the underlying Secret object in Kubernetes, the files mounted inside your running Pod will automatically update themselves.

**How It Works**
* Kubernetes periodically checks for changes to Secret and ConfigMap objects.
* When a change is detected, the **kubelet** on the node updates the file content in the mounted directory.
* This update is **eventual consistency**, it typically takes a few seconds (e.g., 10-60 seconds) to propagate, but it **does not require the Pod or container to be restarted**.

**Why It's Useful**
* **Zero Downtime Credential Rotation:** You can update a database password or API key in the Secret without taking down the application Pods that rely on that credential, assuming the application is built to detect file changes.

**Caveat (Application Awareness)**
While the file is updated on the filesystem, the application itself must be configured to re-read the file from the disk. Most applications only read configuration files once at startup. If your application caches the credential in memory, it won't pick up the change until it's restarted. **Applications using environment variables (instead of mounted files) will generally require a Pod restart to pick up the updated value.**

---
#### D. Demo: Using a Secret to Provide Database Passwords

This walkthrough demonstrates creating a generic password Secret and injecting it into a MariaDB Deployment as an environment variable.

1.  **Create the Secret:**
    ```bash
    kubectl create secret generic dbpw --from-literal=ROOT_PASSWORD=password
    ```

2.  **Inspect the Secret's Details (Base64 encoded):**
    ```bash
    kubectl describe secret dbpw
    kubectl get secret dbpw -o yaml
    ```

3.  **Create the Database Deployment:**
    ```bash
    kubectl create deployment mynewdb --image=mariadb
    ```

4.  **Inject the Secret's Content as Environment Variables:**
    *The prefix `MYSQL_` is needed for the MariaDB image to recognize the variable as a configuration setting.*
    ```bash
    kubectl set env deployment mynewdb --from=secret/dbpw --prefix=MYSQL_
    ```

**Result:** The MariaDB Pod will now run with an environment variable named `MYSQL_ROOT_PASSWORD` set to the value stored in the `dbpw` Secret.

<!-- <a id="section-4-1-4"></a><h2>4.1.4 ConfigMaps Injection</h2> -->
## 4.1.4 ConfigMaps: Variables vs. Configuration Files
The method you use to expose a ConfigMap depends entirely on what it holds:

| Type | Data Format in ConfigMap | How it's Used in Pod |
| :--- | :--- | :--- |
| **Variables** | Key-Value pairs (e.g., `MYSQL_USER=anna`) | Injected as Environment Variables into the container's shell. |
| **Config Files** | Full file content (e.g., the content of index.html) | Mounted as Files into the container's filesystem. |

#### ⚙️ Using ConfigMaps for Environment Variables (Variables)

This method is best for simple, application-level settings.

**A. Creating the ConfigMap**

You have two main imperative ways to create ConfigMaps containing key-value pairs:

**From Literal Values:**
```bash
kubectl create cm mycm --from-literal=MYSQL_USER=anna --from-literal=MYSQL_DATABASE=appdb
```

**From an Environment File (recommended):**
```bash
# varsfile content:
# MYSQL_ROOT_PASSWORD=password
# MYSQL_USER=anna
kubectl create cm mydbvars --from-env-file=varsfile
```

**B. Consuming the ConfigMap (Deployment Injection)**

The key to using variables from a ConfigMap is the `kubectl set env` command, which is an imperative way to modify a Deployment:

```bash
kubectl set env deploy mydb --from=configmap/mydbvars
```

This command modifies the Deployment to pull all key-value pairs from the `mydbvars` ConfigMap and inject them as environment variables into the Pods.

#### 📄 Using ConfigMaps for Configuration Files (Files)

This method is necessary when an application needs its configuration in the form of a file (like `nginx.conf` or an `index.html` file).

**A. Creating the ConfigMap**

You create the ConfigMap from the actual file(s) you want to store:

**From a Single File:**
```bash
# Stores the content of index.html under the key 'index.html'
kubectl create cm myindex --from-file=index.html
```

**B. Consuming the ConfigMap (Volume Mounting)**

When mounting configuration files, you must use the declarative YAML approach. The process involves two steps in the Pod/Deployment manifest:

1.  **Define a Volume:** Inside `spec.template.spec.volumes`, you define a volume of `configMap` type and point it to the ConfigMap name.

2.  **Mount the Volume:** Inside `spec.template.spec.containers.volumeMounts`, you specify where that volume should appear in the container's filesystem.

```yaml
# Example Pod Snippet for Volume Mounting
volumes:
- name: cmvol
  configMap:
    name: myindex # Refers to the ConfigMap created above
containers:
- name: nginx-container
  image: nginx
  volumeMounts:
  - mountPath: /usr/share/nginx/html # Nginx's default document root
    name: cmvol
```
When the Pod runs, the key (`index.html`) inside the ConfigMap appears as a file named `index.html` at the specified `mountPath`.

<!-- <a id="section-4-1-5"></a><h2>4.1.5 Lab Full Config</h2> -->
## 4.1.5 Lab: Comprehensive Configuration Integration

This lab demonstrates the simultaneous use of a ConfigMap to mount a custom file and a Secret to inject an environment variable into a single Deployment.

**Goal:** Start an Nginx server using a custom "hello world" page from a ConfigMap and a secret password from a Secret.

**Step 1: Create the Source File**
Create a simple file named `index.html` that will serve as the content.
```bash
echo "hello world from ConfigMap" > index.html
```

**Step 2: Create the ConfigMap (for File Content)**
Store the `index.html` file content in a ConfigMap named `nginx-page-cm`.
```bash
kubectl create configmap nginx-page-cm --from-file=index.html
```

**Step 3: Create the Secret (for Environment Variable)**
Store the secret password as a literal value in a Secret named `app-secrets`.
```bash
kubectl create secret generic app-secrets --from-literal=MYPASSWORD=verysecret
```

**Step 4: Create the Deployment Manifest (deployment.yaml)**
This manifest integrates both resources:
* The ConfigMap (`nginx-page-cm`) is mounted as a volume at `/usr/share/nginx/html`.
* The Secret (`app-secrets`) injects the `MYPASSWORD` value as an environment variable.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: config-integrated-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-config-lab
  template:
    metadata:
      labels:
        app: nginx-config-lab
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest
        ports:
        - containerPort: 80
        env:
        - name: MY_SECRET_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secrets # Reference the Secret
              key: MYPASSWORD   # Reference the key inside the Secret
        volumeMounts:
        - name: config-volume
          mountPath: /usr/share/nginx/html # Nginx document root
      volumes:
      - name: config-volume
        configMap:
          name: nginx-page-cm # Reference the ConfigMap
          # Note: Since the ConfigMap was created with --from-file=index.html,
          # its contents will appear as a file named 'index.html' in the volume mount.
```

**Step 5: Apply and Verify**

1.  Apply the Deployment: `kubectl apply -f deployment.yaml`
2.  Verify the environment variable inside the Pod:
    ```bash
    # Get the Pod name first
    POD_NAME=$(kubectl get pod -l app=nginx-config-lab -o jsonpath='{.items[0].metadata.name}')
    kubectl exec $POD_NAME -- printenv | grep MY_SECRET_PASSWORD
    # Expected output: MY_SECRET_PASSWORD=verysecret
    ```
3.  Verify the mounted file content:
    ```bash
    # Use the same POD_NAME variable
    kubectl exec $POD_NAME -- cat /usr/share/nginx/html/index.html
    # Expected output: hello world from ConfigMap
    ```

<!-- <a id="section-4-1-6"></a><h2>4.1.6 Imperative Workflow</h2> -->
## 4.1.6 Lab: Imperative Configuration Workflow

This lab demonstrates the process of using rapid, imperative commands to configure a Deployment, extracting the resulting configuration into a clean YAML file, and then redeploying using the declarative approach. This is useful for building a working configuration quickly before committing it to source control.

**Goal:** Configure an Nginx Deployment imperatively, extract its final state into a clean `.yaml` file, and then use that file for declarative deployment.

#### Phase 1: Create and Configure Imperatively

1.  **Create the Secret:**
    ```bash
    kubectl create secret generic lab11secret --from-literal=MYPASSWORD=verysecret
    ```

2.  **Create the Base Deployment:**
    ```bash
    kubectl create deployment lab11deploy --image=nginx
    ```

3.  **Inject the Secret as an Environment Variable:**
    ```bash
    kubectl set env deployment lab11deploy --from=secret/lab11secret
    ```
    > Note: This command imperatively patches the Deployment to pull all data from the Secret and expose it as environment variables.*

4.  **Optional: Verify the Change**
    *You can use `kubectl edit` to see the resulting YAML manifest, which now includes the `envFrom` section referencing the Secret.*
    ```bash
    kubectl edit deployments.apps lab11deploy
    ```

#### Phase 2: Export and Clean the YAML

5.  **Export the Current State:**
    *Get the full live definition of the object and save it to a file.*
    ```bash
    kubectl get deploy lab11deploy -o yaml > lab11deploy.yaml
    ```

6.  **Delete the Live Object:**
    *Remove the imperatively created Deployment so you can recreate it declaratively.*
    ```bash
    kubectl delete deployments.apps lab11deploy
    ```

7.  **Clean the YAML File:**
    *Using a text editor (`vim`, `nano`, etc.), open `lab11deploy.yaml` and remove all fields that are automatically generated by the cluster. These fields are managed by Kubernetes and should not be present in a clean manifest file used for creation.*
    ```bash
    vim lab11deploy.yaml
    ```
    **Fields to Remove:**
    * `metadata.annotations` (some, not all)
    * `metadata.creationTimestamp`
    * `metadata.generation`
    * `metadata.resourceVersion`
    * `metadata.uid`
    * `status` (and everything underneath it)

8.  **Example of Cleaned YAML Snippet:**

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: lab11deploy
      labels:
        app: nginx
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: nginx
      template:
        metadata:
          labels:
            app: nginx
        spec:
          containers:
          - image: nginx
            name: nginx
            envFrom:
            - secretRef:
                name: lab11secret
            resources: {}
            terminationMessagePath: /dev/termination-log
            terminationMessagePolicy: File
          dnsPolicy: ClusterFirst
          restartPolicy: Always
          schedulerName: default-scheduler
          securityContext: {}
          terminationGracePeriodSeconds: 30
    ```

#### Phase 3: Declarative Creation and Verification

9.  **Create from the Clean YAML:**
    ```bash
    kubectl create -f lab11deploy.yaml
    ```

10. **Verify Environment Variable Injection:**
    *Get the Pod name first, then exec into it to check the environment.*
    ```bash
    POD_NAME=$(kubectl get pod -l app=lab11deploy -o jsonpath='{.items[0].metadata.name}')
    kubectl exec $POD_NAME -- env | grep MYPASSWORD
    # Expected Output: MYPASSWORD=verysecret
    ```

11. **Verify File Content (Expected Failure):**
    *This step confirms that the ConfigMap file content is **NOT** present, as we only injected the Secret variable and did not mount a ConfigMap volume.*
    ```bash
    kubectl exec $POD_NAME -- cat /usr/share/nginx/html/index.html
    # Expected Result: This will show the default Nginx index.html content, NOT an error, because the default page exists.
    # To confirm the *Secret* was injected and the *ConfigMap* was NOT, check the environment variable in the previous step.
---

<!-- <a id="section-4-2"></a><h2>4.2 API Access</h2> -->
## 4.2 API Interaction and Access
<img src="image-17.png" alt="4.2 API Interaction and Access" height="35%" width="35%" />

The core functionality of Kubernetes is exposed through its API, which is a critical component for all interactions, including those initiated by \`kubectl\`.

<h2 id="section-4-2-1">4.2.1 Understanding the Kubernetes API Core</h2>

The Kubernetes API defines which resources exist (Pods, Deployments, Services, etc.) and how to interact with them.

* **Core API and Groups:** Kubernetes uses a highly extensible core API, allowing additional functionality to be organized into separate **API Groups**.
    * This flexibility is used in **Custom Resource Definition (CRD)** to add resources to Kubernetes, often when installing **Operators**.
    * Each API Group can have its own independent version number (e.g., \`apps/v1\`, \`batch/v1\`).
* **Inspecting Resources:** Use the following commands for an overview:
    * \`kubectl api-resources\`: Shows all API resources defined in specific APIs.
    * \`kubectl api-versions\`: Provides a list of all resource and version information currently available in the cluster.

### 4.2.2 Direct API Access and \`kube-proxy\`
<img src="image-16.png" alt="4.2.2 Direct API Access and \`kube-proxy\" height="35%" width="35%" />

The Kubernetes APIs are **RESTful**, meaning they can be accessed directly using standard HTTP requests. This is useful when \`kubectl\` might not be available or for scripting purposes.

* **Under the Hood:** \`kubectl\` itself makes secured RESTful API requests. You can inspect the underlying request that \`kubectl\` makes by increasing the verbosity:
    * \`kubectl --v=10 get pods\` (or any other command) will show the actual HTTP request URL, headers, and response.
* **Security Requirement:** The \`kube-apiserver\` is the core Kubernetes process exposing functionality. It is typically started as a systemd process and only allows **TLS certificate-based access** for security.
* **The Role of \`kube-proxy\`:** To provide a secure and simple interface for direct API access from a local workstation without having to manage certificates explicitly, you use \`kube-proxy\`. It establishes a secure tunnel to the API server.

<h2 id="section-4-2-3">4.2.3 Connecting to the API via Proxy Tunnel</h2>

To safely access the API using local tools like \`curl\`, you start the Kubernetes proxy on your local workstation.

1.  **Start the Proxy:**
    ```bash
    kubectl proxy --port=8001 &
    ```
    *This command runs in the background, forwarding local requests on port 8001 securely to the API server.*

2.  **Access the API Root:**
    ```bash
    curl http://localhost:8001
    ```
    *This request, now proxied securely, will return a JSON object listing all available API paths and groups, providing access to all exposed Kubernetes functions.*

<h2 id="section-4-2-4">4.2.4 Using `curl` to Work with API Objects</h2>

Once the `kubectl proxy` is running, you can use standard RESTful commands via `curl` to interact directly with the API server, bypassing the `kubectl` CLI utility.

**Demo: Using `curl` to Access API Resources**

1.  **Start the Proxy (if not already running):**
    This establishes the secure, authenticated tunnel from your local machine (port 8001) to the API server.
    ```bash
    kubectl proxy --port=8001 &
    ```

2.  **Create Test Deployment:**
    We need resources to query and delete.
    ```bash
    kubectl create deploy curl-test --image=nginx --replicas=3
    ```

3.  **Check API Server Version:**
    A basic `GET` request to the root path `/version`.
    ```bash
    curl http://localhost:8001/version
    ```

4.  **List Pods in the `default` Namespace (GET):**
    This shows the API path structure: `/api/v1/namespaces/{namespace}/pods`.
    ```bash
    curl http://localhost:8001/api/v1/namespaces/default/pods
    ```

5.  **View a Specific Pod (GET):**
    To target a specific object, you must append the resource name. *Note: You need the full Pod name, not the Deployment name.*
    ```bash
    # Step 5a: Get a full Pod name first (e.g., curl-test-77c98f8674-w2rtj)
    POD_NAME=$(kubectl get pods -l app=curl-test -o jsonpath='{.items[0].metadata.name}')
    # Step 5b: Access the specific Pod's definition
    curl http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME
    ```

6.  **Delete a Specific Pod (DELETE):**
    Using the HTTP `DELETE` method on the resource endpoint removes the object. The Deployment will automatically recreate it.
    ```bash
    # Using the Pod name obtained above
    curl -XDELETE http://localhost:8001/api/v1/namespaces/default/pods/$POD_NAME
    ```

7.  **Review Authentication Configuration:**
    The security context for all `kubectl` and proxied requests is defined in the configuration file on the user's workstation.
    ```bash
    cat ~/.kube/config
    ```
### 4.3 API Deprecations and Stability
<img src="image-15.png" alt="4.3 API Deprecations and Stability" height="35%" width="35%" />

Kubernetes maintains a strict policy regarding API stability. With new Kubernetes releases, older API versions may get deprecated.

**Deprecation Policy:**
If an old version is marked for deprecation, it will be supported for a **minimum of two more Kubernetes releases**. This ensures that users have enough time to migrate their configurations.

**Action Required:**
When you see a deprecation message, or when updating your cluster to a new major version, make sure to take action and change your YAML manifest files to use the newer, stable API version!

### Demo: Dealing with Removed API (apps/v1beta1 Example)

This demonstration shows the error encountered when trying to use an API version (`apps/v1beta1`) that has been completely removed from the current Kubernetes cluster.

1. **Attempt to Create Resource with Removed API:**
   (Assuming `redis-deploy.yaml` uses `apiVersion: apps/v1beta1`)
   ```bash
   kubectl create -f redis-deploy.yaml
   ```

   **Expected Error:**
   ```
   error: unable to recognize "redis-deploy.yaml": no matches for kind "Deployment" in version “apps/v1beta1"
   ```

2. **Check Available API Versions:**
   Use this command to see what API groups and versions the current cluster supports:
   ```bash
   kubectl api-versions
   ```

3. **Examine the Correct/Stable API Structure:**
   You can use `kubectl explain` to find the current structure of the resource (which will default to the stable `apps/v1` version for `Deployment`):
   ```bash
   kubectl explain --recursive deploy
   ```

### Demo: Using the Stable API (apps/v1)

Once you correct your `redis-deploy.yaml` file to use the stable `apiVersion: apps/v1`, the resource creation will succeed.

1. **Create Resource with Stable API:**
   (Assuming `redis-deploy.yaml` now uses `apiVersion: apps/v1`)
   ```bash
   kubectl create -f redis-deploy.yaml
   ```
### 4.4 Authentication and Authorization (The Security Team)
<img src="image-14.png" alt="4.4 Authentication and Authorization (The Security Team)" height="35%" width="35%" />

Access to the Kubernetes API is governed by two distinct processes: **Authentication** (AuthN) and **Authorization** (AuthZ).

<h2 id="section-4-4-1">4.4.1 Authentication (AuthN)</h2>

**Authentication is about proving *who* you are.** It is the process of verifying a user's or system's identity.

| Kubernetes Concept | Mall Analogy | Description |
| :--- | :--- | :--- |
| **Authentication** | **Employee ID Badge Check-in** | Proving identity at the security desk (e.g., username/password, token, or certificate). |
| **Default User** | **Local Admin Account** | By default, local Kubernetes setups often use a trusted admin account where authentication is implicitly handled by certificates. |
| **\`kubeconfig\` File** | **The Security Credential Card** | The local file (\`~/.kube/config\`) that specifies which cluster to authenticate to, and what credentials (user, certificate, or token) to use. |

In more advanced setups (e.g., cloud providers), you can create your own user accounts that leverage external identity providers (covered in depth in CKA).

**Demo: Viewing Current Authentication Settings**

The `kubectl config` command manages the local configuration file.
```bash
kubectl config view
# Shows current settings, including the cluster, user, and context being used.
```
The configuration is read from:
```bash
less ~/.kube/config
# Displays the content of the configuration file.
```

<h2 id="section-4-4-2">4.4.2 Authorization (AuthZ)</h2>

Authorization is about determining **what you can do** once authenticated. Behind authorization, Kubernetes uses **Role-Based Access Control (RBAC)** to manage permissions.
**Demo: Checking User Capabilities**

You can use the `kubectl auth can-i` command to check if a user (or the current user) is authorized to perform a specific action (verb) on a specific resource.

```bash
# Check what the current user can do (e.g., the kubeconfig user)
kubectl auth can-i get pods

# Check what a hypothetical external user ('bob') can do
kubectl auth can-i get pods --as bob@example.com
# If Bob is not bound to a role, this will likely return 'no'.
```

<h2 id="section-4-4-3">4.4.3 Understanding Role-Based Access Control (RBAC)</h2>

RBAC is the mechanism that connects the "Who" to the "What."

| RBAC Element | Mall Analogy | Description |
| :--- | :--- | :--- |
| **Role** | **The Job Description** | Defines access permissions (verbs like get, create, delete) to specific resources (Pods, Deployments, ConfigMaps) within a **namespace**. |
| **ClusterRole** | **The Executive Job Description** | Defines access permissions that span **the entire cluster** (non-namespaced resources like Nodes or PersistentVolumes). |
| **User/ServiceAccount** | **The Employee/System ID Badge** | The entity (human user or application system) in Kubernetes that works with the API and needs permissions. |
| **RoleBinding** | **The HR Assignment Letter** | Connects a **User** or **ServiceAccount** to a specific **Role** within a **namespace**. |
| **ClusterRoleBinding** | **The Executive Appointment** | Connects a **User** or **ServiceAccount** to a **ClusterRole** across the entire cluster. |


---
<h2 id="section-4-5-0">4.5 Understanding ServiceAccounts (The Shop's Internal Badge)</h2>

### Managing ServiceAccounts

Every Namespace has a default ServiceAccount called `default`. This SA has minimal permissions, generally allowing a Pod to view its own status, but it **cannot** list other resources like Pods or Services.

Additional ServiceAccounts can be created to provide specific, tailored access to resources. After creating a custom ServiceAccount, it *must* be granted permissions through RBAC (Roles and RoleBindings).

**Creating Additional Service Accounts**
ServiceAccounts are easily created using the imperative way:

```bash
kubectl create serviceaccount mysa
# Output: serviceaccount/mysa created
```

When a ServiceAccount is created, a Secret or token is automatically projected into Pods that use it, allowing the Pod to connect to the API. This token is mounted into Pods using the ServiceAccount and used as an access token.

### Demo 1: Using the Default ServiceAccount (mypod.yaml) (Limited Access)

This demo proves that the default ServiceAccount token cannot list resources other than its own status.

**Pod Definition (using implicit 'default' SA)**

```
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  # serviceAccountName is implicitly 'default' if not specified
  containers:
  - name: alpine
    image: alpine/curl
    command:
    - "sleep"
    - "3600"

```

**CLI Steps (Forbidden Access):**

1. Apply the Pod:
   ```bash
   kubectl apply -f my-pod.yaml
   # Output: mypod created
   ```
2. Access the Pod and try to list Pods via the API:
   ```bash
   kubectl exec -it mypod -- sh
   / # apk add --update curl
   
   # Get the token provided by the default ServiceAccount
   / # TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)
   
   # Attempt to list Pods in the default namespace
   / # curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure
   
   # Output showing failure:
   "reason": "Forbidden",
   "message": "pods is forbidden: User \"system:serviceaccount:default:default\" cannot list resource \"pods\" in API group \"\" in the namespace \"default\"",
   "code": 403
   ```
The attempt is forbidden because the `default` ServiceAccount is not bound to any Role granting `list` permission for `pods`.

---

<h2 id="section-4-6-0">4.6 Implementing RBAC with Roles and Bindings (The HR Process)</h2>

To grant the necessary permission (e.g., to list Pods), we need to connect a **custom ServiceAccount** to a **Role** via a **RoleBinding**.

<h2 id="section-4-6-1">4.6.1 Defining the Custom Components</h2>

**A. Custom ServiceAccount (`mysa.yaml`):**
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: mysa
  namespace: default
```

**B. Role Definition (`list-pods.yaml`): The Job Description**

This Role grants only the ability to **list** Pods in the `default` namespace.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: list-pods
  namespace: default
rules:
  - apiGroups:
    - ''          # '' represents the core API group (v1 resources: Pods, Services, etc.)
    resources:
    - pods        # The resource this Role applies to
    verbs:
    - list        # Actions allowed

```

**C. RoleBinding Definition (`list-pods-mysa-binding.yaml`): The HR Assignment Letter**

This object connects the `mysa` ServiceAccount to the `list-pods` Role.

```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: list-pods-mysa-binding
  namespace: default
roleRef:
  kind: Role
  name: list-pods
  apiGroup: rbac.authorization.k8s.io
subjects:
  - kind: ServiceAccount
    name: mysa
    namespace: default
```

### Demo 2: Using Custom SA for Access (Gaining Permission)

**1. Create the RBAC resources:**
```bash
kubectl apply -f mysapod.yaml
kubectl apply -f list-pods.yaml
kubectl apply -f list-pods-mysa-binding.yaml
```

**2. Pod Definition using Custom SA (`pod-custom-sa.yaml`):**

```
apiVersion: v1
kind: Pod
metadata:
  name: mysapod
spec:
  serviceAccountName: mysa # Explicitly use the custom SA 'mysa'
  containers:
  - name: alpine
    image: alpine:3.9
    command: ["sleep", "3600"]
```

**3. Run the Pod and verify successful access:**
```bash
kubectl apply -f pod-custom-sa.yaml
# Output: pod/mysapod created

kubectl exec -it mysapod -- sh
/ # apk add --update curl

# Get the token provided by the 'mysa' ServiceAccount
/ # TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)

# Attempt to list Pods - THIS SHOULD NOW SUCCEED
/ # curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure

# Expected Successful Output:
{
  "kind": "PodList",
  "apiVersion": "v1",
  "metadata": { ... },
  "items": [
    # ... pod definitions will be listed here, confirming success
  ]
}
```
The access is granted because the Pod is using the `mysa` ServiceAccount, which is **bound** to the `list-pods` Role, granting the required permission.

<h2 id="section-4-6-2">4.6.2 Lab: Imperative Pod and ServiceAccount Inspection</h2>

This quick lab demonstrates how to use the imperative approach (`kubectl run`) to generate the YAML manifest for a Pod and inspect the automatic inclusion of the default ServiceAccount setting, which is the baseline configuration being overridden by the custom RBAC setup above.

```bash
# 1. Review available options for kubectl run
kubectl run --help | less

# 2. Generate a YAML manifest (dry-run) for a busybox Pod named 'bysysa'
# The result is redirected to a local file, 'bysysa.yaml'
kubectl run bysysa --image=busybox -o yaml --dry-run=client -- sleep 3600 > bysysa.yaml

# 3. Edit the file (or simply view it) to check the Pod specification.
# Note: The 'serviceAccountName: default' is often implicit but implied in the spec.
vim bysysa.yaml

# 4. Create the Pod from the generated file
kubectl create -f bysysa.yaml

# 5. Inspect the live Pod's final YAML to confirm the ServiceAccount is set.
kubectl get pods bysysa -o yaml | less
```
---
### 4.6.3 One More Example of Implementing RBAC (The HR Process)
To grant a Pod permission to see other Pods, we follow the HR workflow:

1. **Create the Badge:** `kubectl create sa viewer -n bellevue`
2. **Write the Job Description:** `kubectl create role viewer --verb=get,list --resource=pods -n bellevue`
3. **Issue the Assignment:** `kubectl create rolebinding viewer --serviceaccount=bellevue:viewer --role=viewer -n bellevue`
4. **Give the Badge to the Worker:** `kubectl set serviceaccount deployment viewginx viewer -n bellevue`
---
### 4.7 SecurityContext (Worker Safety & Conduct)
A **SecurityContext** defines the specific "behavioral rules" for a worker (Pod/Container).
|Setting|Mall Analogy|Role in Kubernetes|
|--|--|--|
|**runAsUser**|Specific Employee ID|Runs the container as a specific UID (e.g., user 1000).|
|**runAsNonRoot**|No "Master Key"|Prevents the worker from having "Root/Admin" access to the building.|
|**readOnlyFilesystem**|No Writing on Walls|Prevents the container from changing its own internal files.|
|**allowPrivilegeEscalation**|No Promotions|Prevents a worker from gaining higher clearance than assigned.|
---
### 4.8 Resource Requests, Limits, and Quotas (The Resource Budget)
To keep the Mall from running out of electricity (CPU) or physical floor space (RAM), Management sets strict budgets.

---
### 4.8.1 Requests vs. Limits
Before a worker (Pod) can be hired, they must declare their resource needs.
  - **Resource Requests (The Minimum):** "I need at least 1 desk and 250mW of power to even start working." The **Scheduler** uses this to find a building (Node) with enough room.
  - **Resource Limits (The Maximum):** "You can use more power if the mall has extra, but you are strictly cut off at 500mW."

### 4.8.2 Resource Quotas (The Department Budget)
A **Quota** is a total limit applied to a **Namespace**.
  - **Mall Analogy:** "The Food Court department is only allowed a total of 10 employees and 5000W of power."
  - **The Crucial Rule:** If a Quota is set on a department, **every worker** hired must have a defined budget (Requests/Limits) or Management will reject the application immediately.
---
### 4.8.3 Lab: Managing Resource Constraints
In this lab, we simulate a worker who asks for too little "space" and gets "evicted" (OOMKilled), and how to fix the budget.

**Step 1: Defining the Initial Budget (**`frontend-resources.yaml`**)** 
We start with a Pod containing two containers: a database (**db**) and a website (**wp**). Notice the small memory request of **64Mi**.
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: frontend
spec:
  containers:
  - name: db
    image: mysql
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: "password"
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
  - name: wp
    image: wordpress
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
```
**Step 2: Observing the Crisis (OOMKilled)**
After applying the manifest, we check the status.
```Bash
kubectl apply -f frontend-resources.yaml
kubectl get pods
```
**The Result:** The Pod shows `STATUS: CrashLoopBackOff` or `Terminated`.
**Mall Analogy:** The worker tried to cram a massive MySQL filing cabinet into a tiny 64Mi locker. The locker burst, and the worker was kicked out.
**Step 3: Diagnostic - Inspecting the "Eviction"**
To see exactly why the worker failed, we check the Management Ledger:
```Bash
kubectl describe pod frontend
```
Look for the **Reason**: `OOMKilled` (Out Of Memory Killed) and **Exit Code**: `137`. This proves the container exceeded its allocated limit.
**Step 4: Fixing the Budget**
We update the YAML to provide a realistic budget. In this case, we increase the memory to **64Mi** (Request) and **128Mi** (Limit) but ensure the container doesn't try to use **Gi** (Gigabytes) by mistake, which would prevent it from ever finding an empty building.
**Corrected Spec Snippet:**
```YAML
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "256Mi" # Increased limit to prevent OOM
        cpu: "500m"
```        
**Step 5: Final Verification**
```Bash
kubectl delete -f frontend-resources.yaml
kubectl apply -f frontend-resources.yaml
kubectl get pods
```
**Output:** `frontend  2/2  Running`. The worker now has enough "desk space" to perform their tasks.
**Resource Diagnostic Cheat Sheet**
|Command|Mall Analogy|Purpose|
|--|--|--|
|`kubectl describe node`|Check the Building Capacity|See how much total CPU/RAM is left in the node.|
|`kubectl top pod`|Spot the "Resource Hog"|See real-time usage of CPU and Memory.|
|`kubectl set resources`|Change the Budget on the Fly|Update limits for a Deployment without deleting it.|
|`kubectl create quota`|Set Department Spending|Restrict a Namespace's total footprint.|
---
### 4.9 Lab: Managing Security Settings
This lab demonstrates the "HR Process" of assigning a specific identity to a department’s workforce.

---
### 4.9.1 Lab Objectives
  - Create a high-security department (**Namespace**: `secure`).
  - Issue a specialized identity badge (**ServiceAccount**: `secure`).
  - Deploy a managed store (**Deployment**: `securedeploy`) that uses this specific badge instead of the generic one.

---   
### 4.9.2 Mall Analogy: The "High-Value Vault" Setup
In this scenario, we aren't just opening a standard stall. We are creating a restricted area where every worker must wear a specific "Secure" badge to be identified by the Management Office.
|Kubernetes Step|Mall Analogy|Command|
|--|--|--|
|**Create Namespace**|**Build the Restricted Wing**|`kubectl create ns secure`|
|**Create ServiceAccount**|**Print the Specialized Badges**|`kubectl create sa secure -n secure`|
|**Create Deployment**|**Hire the Security Team**|`kubectl create deploy securedeploy -n secure --image=nginx`|
|**Set ServiceAccount**|**Distribute the Badges**|`kubectl set serviceaccount -n secure deploy securedeploy secure`|

---
### 4.9.3 Lab Solution & Verification
After assigning the badge, we verify that the workers (Pods) are actually wearing them.

**1. Update the Store Manager's requirements:**
```Bash
kubectl set serviceaccount -n secure deploy securedeploy secure
```
<i>Logic</i>: This tells the Store Manager (Deployment) that every new worker (Pod) hired from now on must arrive at the office with the "secure" ID badge already pinned to their uniform.

**2. Verify the Worker's ID:**
We inspect one of the active workers to ensure the `Service Account` field has changed from `default` to `secure`.
```Bash
# Find the specific worker name first
kubectl get pods -n secure

# Inspect the worker
kubectl describe pod <pod-name> -n secure | grep "Service Account"
```
**Expected Output:**
`Service Account: secure`

> The ServiceAccount: This is the Restricted Key given to the Worker (Pod). If a worker needs to look at the Mall Ledger (API) to see if a shipment arrived, they use their ServiceAccount badge.
>
>we created the secure ServiceAccount is because:
>By default, workers are given a Guest Badge (default SA) that can't do anything but work.
>If a specific store (like the securedeploy) needs to perform special tasks (like reporting back to Management), we have to issue them a Specialized Badge (custom SA).

**3. Inspecting the Token Mount:**
If you look closer at the `describe` output, you will see a "Mount" point:
`Mounts: /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-xxxx (ro)`
  - **Mall Analogy:** This is the physical "Badge Holder" clipped to the worker's belt. It contains the digital key (token) that the worker uses to "swipe" into the Management Office (API Server).

**Security Summary Checklist**
  - **AuthN:** Did the worker show their Badge? (`~/.kube/config`)
  - **AuthZ:** Does the Job Description (**Role**) allow them to open this door?
  - **SA:** Is the worker using a specialized Badge (**ServiceAccount**) or just the guest one?
  - **SecurityContext:** Is the worker allowed to have a Master Key (**Root**) or are they restricted?
  - **Resources:** Is the worker staying within their allocated Desk Space (**Memory/CPU**)?
---

<h2 id="section-5-0">5.0 Storage and Logistics (Persistent & Local Data)</h2>

How workers (Pods) handle their data: temporary files, shared lockers, persistent storage.

| CONCEPT | RESOURCE | MALL ANALYGY | DATA LIFECYCLE / CONFIGURATION |
| :--- | :--- | :--- | :--- |
| **Temporary Files** | Container Filesystem | The Worker's Notepad | Lives only as long as the container is running. |
| **Local Storage** | Pod Volume | The Worker's Temporary Locker | Survives container restarts; deleted when the Pod is deleted. |
| **Locker Blueprint** | \`pod.spec.volumes\` | The Locker Attribute Definition | Defines the name and type of the volume (where the data comes from). |
| **Locker Access** | \`volumeMounts\` | The Worker's Key | Grants the container access to the volume at a specific path. |
| **New Locker Type** | \`emptyDir\` | A Brand New, Empty Locker | Shared, temporary storage for the entire Pod. |
| **Shared Resource** | \`hostPath\` | The Mall Utility Closet | Maps to a directory on the Node (physical machine). |
| **External Storage** | PersistentVolume | Warehouse Slot (The Room) | A block of durable, external storage. **Independent resource.** |
| **Storage Request** | PVC | Storage Request Form | The application requests specific storage criteria. |
| **Storage Automation** | StorageClass | The Logistics Officer / Contract Type | The administrative blueprint defining how storage is provisioned (Dynamic) or which pre-existing storage (Static) can be claimed. |
---

<h3 id="section-5-0-1">5.0.1 Provisioning Strategies: Static vs. Dynamic</h3>

The two core strategies for managing PersistentVolumes (PVs) highlight a critical difference in Kubernetes administration. This distinction is often simplified by the number of resource files required to set up the storage system:

1.  **Dynamic Provisioning (The 1 or 2-File Strategy):** Only requires the Cluster Administrator to define a StorageClass. The user then simply creates the PersistentVolumeClaim (PVC). The control plane automatically creates the matching PV based on the StorageClass, eliminating the need for manual PV creation. This requires the user to submit only two files (PVC and Pod), or effectively one main resource (the PVC) that triggers the PV creation.

    **Process:**
    * The cluster has a `StorageClass` configured (a "blueprint" for creating new storage).
    * The developer only defines the `PersistentVolumeClaim` (PVC) in their YAML.
    * When the PVC is created, the Kubernetes control plane sees the request and automatically uses the `StorageClass` to provision the necessary storage in the backend (e.g., creating a new disk in the cloud) and simultaneously creates the matching `PersistentVolume` (PV) for you.

    **When to use this:**
    * In most real-world, cloud-native scenarios, as it simplifies workflow and scales easily.
    * When using cloud storage types (like GCP Persistent Disks or AWS EBS) or other solutions that integrate with a `StorageClass`.
2.  **Static Provisioning (The 3-File Approach):** Requires the Cluster Administrator to manually pre-create the PersistentVolume (PV). The user then creates the PersistentVolumeClaim (PVC) to claim it, and finally, the Pod uses the PVC. This requires three distinct YAML definitions: PV, PVC, and Pod.
* **`pv-rwo.yaml` (PersistentVolume):** Defines the actual physical or network storage resource available in the cluster.
* **`pvc-rwo.yaml` (PersistentVolumeClaim):** Defines the *request* for storage by a user.
* **`pod-rwo.yaml` (Pod):** Defines the application that consumes the storage request.

    **Process:** You manually define the supply (PV) and the demand (PVC). The Kubernetes control plane then binds the specific PV to the PVC, and the Pod uses that bound PVC.

    **When to use this:**
    * When demonstrating the fundamental connection between PV, PVC, and Pod.
    * When using storage that must be manually set up and managed (e.g., specialized network shares or legacy systems).
    * If the lab explicitly requires you to define a PersistentVolume.

***

#### Conclusion: Matching Strategy to the Lab's Goal

The key takeaway is that the file count is a symptom of the provisioning method:

| Scenario | Strategy | Files Needed | Purpose |
| :--- | :--- | :--- | :--- |
| **Section 5.5** | **Dynamic** | **1 or 2** (PVC + Pod) | Request storage, allowing Kubernetes to automatically create the necessary backend volume. |
| **Section 5.7.1** | **Static** | **3** (PV, PVC, Pod) | Explicitly define and manually bind a pre-existing storage resource. |


---

<h3 id="section-5-1">5.1 Creating a PersistentVolume via hostPath</h3>

In Kubernetes Mall terms: You are building a permanent warehouse slot *within* the Mall building (Node).

#### 5.1.1 The Warehouse Slot (PersistentVolume)

Here is the YAML defining the warehouse:

```yaml
kind: PersistentVolume
apiVersion: v1
metadata:
  name: pv-volume
  labels:
    type: local
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mydata"
```

| CONCEPT | RESOURCE | ANALOGY | DESCRIPTION |
| :--- | :--- | :--- | :--- |
| Warehouse Slot | `PersistentVolume` | A permanent storage room | Fixed storage area created by the administrator. |
| Storage Location | `hostPath` | Physical closet door | Maps the storage to a real folder on the Node. |

#### 5.1.2 Creating the Warehouse

Apply the YAML: `kubectl apply -f pv.yaml`
Check the PV: `kubectl get pv`

#### 5.1.3 Checking the Physical Warehouse Location (Node Filesystem)

`hostPath` volumes exist on the node, not inside Kubernetes.

Connect to the minikube node: `minikube ssh`
List the root directory: `ls /`
  - You will **NOT** see `/mydata` yet, this is normal.

**Why?** Because Kubernetes does not create the `hostPath` directories unless you specify: `type: DirectoryOrCreate`.

**How to Fix This**

Modify the PV:

```yaml
  path: "/mydata"
  type: DirectoryOrCreate
```

Apply: `kubectl apply -f pv.yaml --force`
Check on the node (only **after** a Pod uses it): `minikube ssh`, then `ls /mydata`

#### 5.1.4 Summary Table — hostPath Behavior

| hostPath Type | Behavior |
| :--- | :--- |
| `Directory` | Path must already exist |
| `DirectoryOrCreate` | **Creates the directory if missing** |
| `FileOrCreate` | Creates an empty file if missing |
| (no type) | Kubernetes does not create the path (Strict Check) |

---

<h3 id="section-5-2">5.2 PVC Definition and Binding: The Request Form Breakdown</h3>

The YAML you are asking about, in the context of the Mall Analogy, represents the Storage Request Form (`PVC`).

#### 5.2.1 The Storage Request Form (PVC)

The YAML manifest below defines the Request Form (PVC) that a Worker (Pod) would use to ask the Mall Manager (Kubernetes Control Plane) for persistent storage.

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pv-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

| YAML Field | Kubernetes Resource | Mall Analogy | Explanation |
| :--- | :--- | :--- | :--- |
| `kind: PersistentVolumeClaim` | PVC | Storage Request Form | This declares the resource as the formal request for storage. |
| `metadata: name: pv-claim` | PVC Name | Request Form Name | The name of the request, used by the Worker (Pod) to reference it. |
| `accessModes: ReadWriteOnce` | Access Mode | Keys/Access Type | Requests an exclusive key: only one Node (the physical host) can mount the storage read/write at a time. |
| `resources: requests: storage: 1Gi` | Capacity | Requested Room Size | Requests a storage space of 1 Gigabyte or more. |

#### 5.2.2 The Binding Process Analogy

* **Request Submission (PVC Creation):** A Worker (Pod) needs durable storage, so its Manager (Deployment) submits the Storage Request Form (`pv-claim`) to the Mall Manager (Kubernetes Control Plane).
* **Matchmaking (PV/PVC Binding):** The Mall Manager checks the available Warehouse Slots (PVs). It looks for a PV that:
    * Has at least 1Gi of space.
    * Supports the `ReadWriteOnce` access mode.
    * (Crucially) Matches the `StorageClass` (Contract Type).
* **Slot Reservation (Bound Status):** Upon finding a match, the Mall Manager reserves that specific Warehouse Slot (PV) and marks the Request Form (PVC) status as **`Bound`**. The two are now exclusively paired. **A PVC bind is exclusive: after binding, the PV cannot be used by any other PVC.**

---
<h3 id="section-5-3">5.3 The Role of StorageClass: Logistics and Selection</h3>

The `StorageClass` (The Logistics Officer / Contract Type) determines the binding method and enables automation. The core matching criteria remain **size, access modes, and `storageClassName`**.

#### 5.3.1 Dynamic Provisioning (Automatic Storage Creation)

* **Concept:** StorageClass allows for automatic creation of a PersistentVolume (PV) when a PVC requests storage.
* **Mechanism:** The StorageClass must be backed by a **storage provisioner** (a dedicated controller) that takes care of the volume configuration (e.g., creating an AWS EBS disk). Kubernetes includes some internal provisioners, but external ones are often installed.
* **Analogy:** The Logistics Officer automatically builds a new, perfect room, backed by a building crew (the provisioner).
> **Note on Labs:** While typical lab environments might not have a provisioner, environments like Minikube often include a default provisioner to simulate this functionality.

#### 5.3.2 Static Binding: Using StorageClass as a Selector

* **Concept:** A second use of StorageClass is as an **exclusive selector label**.
* **Mechanism:** When both the PV and PVC specify the same `storageClassName`, the PVC will *only* bind to a PV that perfectly matches this setting, along with size and access modes.
* **Analogy:** Both the pre-built Warehouse Slot (PV) and the Request Form (PVC) must be labeled with the same custom contract type (e.g., `manual`).
* **Result:** If no PV with the matching StorageClass and requirements is available, the PVC will remain in a **`Pending`** status.

#### 5.3.3 The Special Case: The Empty String (`storageClassName: ""`)

The most critical detail for traditional static binding is the empty string:

* If a PV is created with `storageClassName: ""` (labeled "**No Contract**").
* A PVC must **explicitly** request `storageClassName: ""` to bind to it.
* If the PVC omits the field entirely, it defaults to the system's default StorageClass (usually `standard`), which will fail the match and likely trigger Dynamic Provisioning instead of binding to your custom PV.

---
#### 5.3.4 The Spectrum of Storage Class Names

The `storageClassName` value is the unique identifier for the StorageClass resource, which dictates whether storage is manually selected or automatically created. The name itself can be anything, but falls into three behavioral categories:

| Category Name | Example Value(s) | Behavior / Mall Analogy | Provisioning Type |
| :--- | :--- | :--- | :--- |
| **Hard Static Match** | `storageClassName: ""` | **No Logistics Officer Involved:** PVC demands a PV that also explicitly rejects Dynamic Provisioning. | Static Binding only (manual) |
| **Default Dynamic** | `storageClassName: standard` (or `default`) | **Standard Contract:** If a matching PV is not found, the Logistics Officer (StorageClass) automatically creates a standard-quality PV for the PVC. | Dynamic Provisioning (default) |
| **Custom Contract** | `storageClassName: gold-fast`, `manual`, `nfs-archive` | **Specialized Contract:** This name refers to a custom blueprint created by the Admin, defining specific characteristics like disk speed (e.g., SSD vs. HDD) or replication. | Dynamic or Static Selection |

---

<h3 id="section-5-4">5.4 Access Modes: RWO vs. RWM (The Key Type)</h3>

Access Modes define how the storage volume can be mounted and used. This is a critical factor in the PV/PVC binding match.

| Mode | Name | Mall Analogy | Implication |
| :--- | :--- | :--- | :--- |
| **RWO** | ReadWriteOnce | **Private Office Key** | Volume can be mounted by **one Node** (Worker's physical host) for read/write access. Prevents simultaneous writes from different hosts. |
| **ROX** | ReadOnlyMany | **Public Library Card** | Volume can be mounted by **many Nodes** for read-only access. |
| **RWM** | ReadWriteMany | **Shared Warehouse Floor Access** | Volume can be mounted by **many Nodes** for read/write access simultaneously. Used for shared filesystems (like NFS). |

The choice of Access Mode is the key difference between single-Pod storage (like the previous RWO examples) and shared storage setups.

---

<h3 id="section-5-5">5.5 Lab Analysis: Shared Volume Setup (`lab10.yaml`)</h3>

This manifest demonstrates a successful Static Binding setup using the **ReadWriteMany (RWM)** access mode to allow shared storage access for a web server.

```yaml
# 1. PersistentVolume (The Shared Warehouse Slot)
apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteMany # CRITICAL: Allows multiple Nodes (Pods) access
  hostPath:
    path: "/mnt/data" # Physical location on the Node
    type: DirectoryOrCreate
---
# 2. PersistentVolumeClaim (The Shared Storage Request)
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual # CRITICAL: Selector to match the PV above
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 3Gi
---
# 3. Pod (The Worker using the Shared Storage)
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
    - name: task-pv-container
      image: httpd:alpine
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/local/apache2/htdocs" # Mounts over the HTTPD document root
          name: task-pv-storage
```

| Component | Key Configuration | Analysis |
| :--- | :--- | :--- |
| **PV** | `RWM` + `storageClassName: manual` | Creates a 10Gi shared storage room with a "Manual" contract. |
| **PVC** | `RWM` + `storageClassName: manual` | Requests a shared room with a "Manual" contract (3Gi). **The match succeeds.** |
| **Pod** | Mounts to `/usr/local/apache2/htdocs` | The Pod mounts the bound PV directly into the web server's public folder, making the contents of `/mnt/data` on the Node accessible via the web server. |

---

<h3 id="section-5-6">5.6 Decoupling Pods from Site-Specific Storage</h3>

* The purpose of configuring a Pod with PVC storage is to decouple site-specific information (like the specific cloud disk or host path) from a generic Pod specification.
* The `pod.volume.spec` is set to `PersistentVolumeClaim`, shifting the responsibility to the PVC to find available PV storage that meets its requirements.
* When a Pod specification is distributed with a PVC specification, it will always bind to available site-specific storage, without the Pod knowing or caring about the underlying storage details (e.g., whether it's an AWS EBS volume or a local host path).

---

<h3 id="section-5-7">5.7 Connecting the Worker to the Storage: Concrete Example</h3>

The final step in the storage process is to connect the Worker (Pod) to the reserved Warehouse Slot (PV) using the Storage Request Form (PVC). This demonstrates the full decoupling.

---
#### 5.7.1 The Three Required Files (Static Binding Demo)

For this example, we use **Static Binding** by assigning a matching `storageClassName: manual` to both the PV and PVC.

**File 1: The Warehouse Slot (PV)**: `pv-rwo.yaml`
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-rwo
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi # The available size
  accessModes:
    - ReadWriteOnce # RWO access mode
  hostPath:
    path: "/mnt/storage-rwo" # Actual location on the Node
    type: DirectoryOrCreate
```

**File 2: The Storage Request Form (PVC)**: `pvc-rwo.yaml`
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-rwo-claim
spec:
  storageClassName: manual # Must match PV for static binding
  accessModes:
    - ReadWriteOnce # Must match PV
  resources:
    requests:
      storage: 1Gi # Requested size (must be <= PV capacity)
```

**File 3: The Worker Definition (Pod)**: `pod-rwo.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-rwo-worker
spec:
  volumes:
    - name: app-storage
      persistentVolumeClaim:
        claimName: pvc-rwo-claim # References the PVC by name
  containers:
    - name: nginx-container
      image: nginx:alpine
      volumeMounts:
        - name: app-storage # Must match the volume name above
          mountPath: /usr/share/nginx/html/data # Mounts the PV inside the container
```
---
#### 5.7.2 The Storage Lifecycle in Action (Demo Static Binding Steps)

This sequence mirrors the steps often executed in a lab environment to confirm the binding and usage:

| Action | Kubernetes Command | Result in Analogy |
| :--- | :--- | :--- |
| **1. Admin Prepares** | `kubectl apply -f pv-rwo.yaml` | The Cluster Admin builds the physical Warehouse Slot (PV). |
| **2. App Requests** | `kubectl apply -f pvc-rwo.yaml` | The App Manager submits the Request Form (PVC). **Status goes to `Bound`.** |
| **3. Binding Status Check** | `kubectl get pv,pvc` | Confirms the PV and PVC are bound, linking their names. |
| **4. Hiring the Worker** | `kubectl apply -f pod-rwo.yaml` | The Worker (Pod) is hired and references the now-bound Request Form. |
| **5. Writing Data** | `kubectl exec app-rwo-worker -- touch /usr/share/nginx/html/data/hello.txt` | The Worker places a file inside their Locker via the mounted path. |
| **6. Checking the Source** | `minikube ssh` then `ls /mnt/storage-rwo` | The Mall Administrator checks the physical Utility Closet on the Node and sees the file (`hello.txt`). **Persistence is achieved.** |

--- 
#### 5.7.3 The 1-File/Demo Dynamic Binding Steps
**Step 1: The Request Form (PVC):** `pvc-dynamic.yaml`
Notice we no longer use `manual`. We use a "Contract Name" provided by the mall (like `standard` or `gp2`).
```YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-dynamic-claim
spec:
  storageClassName: standard  # The "Contract" that triggers automation
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
**Step 2: The Worker (Pod):** `pod-dynamic.yaml`
The Pod stays almost exactly the same, just pointing to the new claim name.
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: dynamic-worker
spec:
  volumes:
    - name: data-storage
      persistentVolumeClaim:
        claimName: pvc-dynamic-claim
  containers:
    - name: nginx
      image: nginx:alpine
      volumeMounts:
        - name: data-storage
          mountPath: /data
```
---
#### 5.7.3.5 The Dynamic Lifecycle
Because this is automated, the sequence is shorter and the "Magic" happens at step 2.
|Action|Kubernetes Command|Result in Analogy|
|--|--|--|
|**1. Admin Sets Rule**|`kubectl get sc`|Admin ensures a Logistics Officer (StorageClass) is on duty.|
|**2. App Requests**|`kubectl apply -f pvc-dynamic.yaml`|The Request is submitted. The Officer sees it and instantly builds a new PV.|
|**3. Verify Magic**|`kubectl get pv,pvc`|You will see a PV with a long, random name. The Mall built it just for you!|
|**4. Hiring**|`kubectl apply -f pod-dynamic.yaml`|The Worker starts and immediately has a key to the new room.|
---
#### 5.7.4 The The Worker's Temporary Locker `emptyDir` 
When two workers in the same shop need to pass files back and forth (e.g., one worker writes a log, another worker processes it).

```File: lab574-emptydir.yaml```
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: helper-worker-pod
spec:
  volumes:
    - name: shared-bench  # The "Blueprint" for the emptyDir
      emptyDir: {}        # No extra config needed!
  containers:
    - name: writer-worker
      image: alpine
      command: ["/bin/sh", "-c", "echo 'Work in progress' > /data/task.txt; sleep 3600"]
      volumeMounts:
        - name: shared-bench
          mountPath: /data # Access point for the first worker
    - name: reader-worker
      image: alpine
      command: ["/bin/sh", "-c", "cat /data/task.txt; sleep 3600"]
      volumeMounts:
        - name: shared-bench
          mountPath: /data # Access point for the second worker
```
---
#### 5.7.4.5 The emptyDir Lifecycle in Action
|Action|Result in Analogy|
|--|--|
|**1. Pod Starts**|The Mall Manager sets up a clean, empty workbench inside the shop.|
|**2. Writer Worker acts**|The first worker scribbles a note on the workbench at `/data/task.txt`.|
|**3. Reader Worker acts**|The second worker looks at the same workbench and reads the note.|
|**4. Container Crashes**|If one worker faints and is replaced, the **workbench stays put**. The data survives.|
|**5. Pod is Deleted**|The shop is closed. The Mall Janitor comes by and **throws the whole workbench in the trash**. The data is gone forever.|
---
<h2 id="section-5-8-0">5.8 Storage Recap for Dummies (The Mall Summary)</h2>

If you're finding the difference between volumes, PVs, and PVCs tricky, here is the simplest possible breakdown using our Mall Analogy.

### Core Storage Concepts in Three Lines:

| Resource | Mall Analogy | Lifecycle (When is it deleted?) |
| :--- | :--- | :--- |
| **Pod Volume (`emptyDir`)** | **The Worker's Temporary Locker** | Deleted when the **Pod** is deleted. |
| **Persistent Volume (PV)** | **The Warehouse Slot (Storage Room)** | Deleted only when the **Cluster Administrator** (human) deletes it. |
| **Persistent Volume Claim (PVC)** | **The Storage Request Form** | Deleted when the **Application Manager** (human) deletes it. |

### The Two Ways to Get a Storage Room (Binding)

The entire PV/PVC process is about decoupling the application's *need* from the *physical location* of the storage.

<h2 id="section-5-8-1">5.8.1 Dynamic Binding (Automatic Provisioning)</h2>

This is the process where Kubernetes creates the storage for you, making manual PV files redundant.
  - **PVC Request:** The Request Form asks for a specific **Contract Type** (e.g., `storageClassName: standard`).
  - **PV Action:** The Mall Manager attempts a static match, but finding no perfect pre-built room, the **Logistics Officer** (`StorageClass`) is called. The Logistics Officer **automatically provisions a brand-new, perfect Warehouse Slot (PV)** to exactly match the request's size and access modes.
  - **Why PV YAML is Redundant:** Since the **Logistics Officer** creates the PV resource automatically, you only need to define the **StorageClass** (the rulebook) and the **PVC** (the request). **This is why manually defining PV files makes no sense in this scenario.**
  - **When to use:** When you need a new, dedicated storage resource (like a cloud disk) created just for this PVC. This is the preferred method in modern clusters.

<h2 id="section-5-8-2">5.8.2 Static Binding (Manual Matching)</h2>
    
  - **Prerequisite:** The Cluster Admin has manually built a custom Warehouse Slot (PV) that is waiting.
  - **PVC Request:** The Request Form must explicitly ask for the same **Contract Type** (often `storageClassName: ""`) as the PV.
  - **PV Action:** The Mall Manager must find an existing, manually-built PV that **also** has the exact same contract label and meets the size/access needs. If the labels don't match, the PVC remains `Pending`.
  - **When to use:** When you need to connect your application to a *specific, pre-existing* storage resource (like a local host path or an existing NFS share).

---
### 6.0 Deploying Applications the DevOps Way
This chapter covers the essential tools and practices for modern application deployment in Kubernetes, focusing on repeatable, customizable, and safe release mechanisms.

---
### 6.0.5 DevOps and GitOps (The Mall Management Policy)
Managing a mall manually is impossible. DevOps and GitOps are the modern methodologies we use to ensure the mall stays open 24/7, even when we are making major changes.

  - **Configuration as Code (The Blueprint):** Every store setup is a YAML file..
  - **Zero-Downtime Updates:** The mall never closes during renovations.
  - **GitOps (The Automated Architect):** We store blueprints in a **Git Vault**. A "Robot Manager" (Operator) watches the vault and automatically builds the mall to match the blueprints.

---
**Comparison: Manual vs. GitOps Management**
|FEATURE|MANUAL MANAGEMENT|GITOPS MANAGEMENT|
|--|--|--|
|**Blueprint Storage**|Scraps of paper or the manager's memory.|A secure **Git Vault** (Version Control).|
|**Making a Change**|Shouting orders at workers (`kubectl apply`).|Updating the blueprint in the Vault.|
|**Mistakes**|Hard to fix; no record of who did what.|**Easy Rollback:** Just revert to the previous blueprint version.|
|**Analogy**|**The Busy Manager:** Manually checking every store every hour.|**The Smart Mall:** The mall automatically builds or tears down walls to match the master plan.|

>**Why this matters for the CKAD**
In the exam, you act as the **DevOps Engineer**. You are responsible for the **YAML files** (Configuration as Code). While you might use `kubectl` to apply changes, in a real "GitOps" environment, you would simply "Push" your code to Git and let the cluster update itself.
---

### 6.1 Using the Helm Package Manager
If manual YAML is "DIY construction," **Helm** is the **Prefabricated Store Catalog**. It allows you to buy a "Store-in-a-Box" (Chart) and deploy it in seconds.
  - **Helm Tool:** Your order catalog.
  - **Helm Chart:** The flat-pack box containing all blueprints (Deployments, Services, etc.).
  - **Release:** A specific instance of a store in your mall (e.g., "my-mysql-database").

---

### 6.2 Working with Helm Charts
---
### 6.2.1 Installing the "Store-in-a-Box"
1. Open a Wholesale Account (Add Repo):
```Bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update  # Get the latest catalog prices/versions
```
2. Basic Installation:
```Bash
# Deploys a MySQL store and auto-generates a name (e.g., mysql-1612)
helm install bitnami/mysql --generate-name
```
---
### 6.2.1.1 Troubleshooting Log: The "Broken Store Kit" Case
Sometimes the prefabricated kit arrives with missing parts or wrong instructions. Here is how we fixed a "Broken MySQL" installation.
|STEP|SYMPTOM|ROOT CAUSE|THE FIX (MALL ANALOGY)|
|--|--|--|--|
|**1. Image Error**|`ImagePullBackOff`|Outdated image path in the blueprint.|**Wrong Supplier**: Tell the workers to get the "Legacy" version of the recipe.|
|**2. Rate Limit**|`ImagePullBackOff`|Docker Hub blocked anonymous requests.|**ID Required**: Give the worker a "Secret Key" to prove they are a registered member.|
|**3. Permissions**|`CrashLoopBackOff`|Container couldn't write to the storage.|**Locked Cabinet**: Use `fsGroup: 1001` to give the worker the keys to the storage warehouse.|

**The "Master Fix" Command:**To fix all these at once, we **Upgrade** the release:
```Bash
helm upgrade <RELEASE_NAME> bitnami/mysql \
  --set image.repository=bitnamilegacy/mysql \
  --set primary.podSecurityContext.fsGroup=1001 \
  --reuse-values
```
---
### 6.2.1.2 The Great Customization Debate: Helm vs. Kustomize
In the mall, you have two ways to build a customized store:
|FEATURE|6.2.2 HELM (The Factory Order)|6.3.1 KUSTOMIZE (The Blueprint Overlay)|
|--|--|--|
|**Philosophy**|**Templating:** The blueprint has "blanks" like `{{ color }}`. You fill them in at the factory.|**Patching:** The blueprint is a solid "Base." You lay a transparent sheet over it and draw changes.|
|**Logic**|You change variables in a `values.yaml` file.|You apply "Overlays" (Dev, Prod) in a `kustomization.yaml`.|
|**Analogy**|**Buying a Prefab Kit:** You order a store and tell the factory "I want 5 windows instead of 2.|**"The Architect's Trace Paper:** You take the standard "Base" plan and draw a red "X" over the parts you want to change.|
---
### 6.2.2 Customizing Before Installing
A Helm Chart uses templates to which specific values are applied. These values are primarily stored in the \`values.yaml\` file within the Chart.

**View Default Values:**
To see the default configuration values of a specific Chart, without downloading it:
```bash
helm show values bitnami/nginx
```

**Download and Edit the Chart:**
1. Use \`helm pull\` to fetch a local copy of the Chart (as a \`.tgz\` file):
```bash
helm pull bitnami/nginx
```
2. Extract and edit the \`values.yaml\` file:
```bash
tar xvf nginx-xxxx.tgz
vim nginx/values.yaml # Edit the desired values
```

**Installation with Custom Values:**
Install the local Chart, specifying the modified \`values.yaml\` file using the \`-f\` option:
```bash
helm install -f nginx/values.yaml my-nginx ./nginx/

# (Optional: helm template --debug nginx renders the final YAML output without actually installing it.)
```
---
**Useful "Mall Inspection" Commands**
  - `helm list`: See all open "Prefab" stores in the mall.
  - `helm status [NAME]`: Read the "Manual" for a specific store (shows passwords/URLs).
  - `helm show chart bitnami/mysql`: Displays only the basic metadata of the Chart (Chart.yaml).
  - `helm show all bitnami/mysql`: See the entire blueprint before buying.
  - `helm template --debug`: **"The X-Ray"**, shows the generated YAML without actually building anything.

---
### 6.3 Core Deployment Topics
These advanced concepts are critical for application developers and platform engineers working with Kubernetes deployment pipelines.

---
### 6.3.1 Using Kustomize (The "Transparent Sheet" Method)
Kustomize is a native Kubernetes tool that tweaks YAMLs without templates.

**The "Flat" Approach (Quick Fixes):** you can put a `kustomization.yaml` in the same folder as your manifests to quickly add a `test-` prefix. This is great for a one-time test.

**The "Professional" Approach (Base & Overlays):** For real DevOps, we use the **Base/Overlay** pattern. This prevents "test" settings from ever accidentally reaching "production" by separating the core blueprints from environment-specific tweaks.

---

### 6.3.1.1 The Directory "Brain"
  - **Base:** The "Pure" blueprint (No prefixes, No namespaces).
  - **Overlays:** The environment-specific "filters" (Dev, Prod, Staging).

---
### 6.3.1 Lab Understanding Kustomize

Kustomize uses a file with the name `kustomization.yaml` to apply changes to a set of resources.

* **Convenience:** This is particularly convenient for applying non-destructive changes to input files (e.g., community charts or third-party manifests) that the user does not control and whose contents may change because of new versions appearing in Git.
* **Application Command:** Use `kubectl apply -k ./` in the directory with the `kustomization.yaml` and the files it refers to to apply changes.
* **Deletion Command:** Use `kubectl delete -k ./` in the same directory to delete all resources created by the Kustomization.

---
### Understanding a Sample `kustomization.yaml`

**The `base` directory** contains only the manifests (Deployment, Service) without environment prefixes or labels. Each overlay (dev, prod, staging) consumes this base and individually applies the appropriate prefix and label. This eliminates the unintended creation of default "testing" resources.

#### 1. Directory Structure

The structure remains the same, but the function of the `base` directory has changed.

```text
.
├── base
│   ├── deployment.yaml
│   ├── kustomization.yaml
│   └── service.yaml
└── overlays
    ├── dev
    │   └── kustomization.yaml
    ├── prod
    │   └── kustomization.yaml
    └── staging
        └── kustomization.yaml
```
---
#### 2. Base Configuration Files (PURE)

The base defines the default configuration that the overlays will extend. **We no apply environment-specific prefixes or labels here.**

---
#### `base/deployment.yaml`

Defines the core Nginx deployment with 3 replicas and default resource limits.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-friday20
  name: nginx-friday20
spec:
  replicas: 3 # This is the base value, modified by the overlays
  selector:
    matchLabels:
      app: nginx-friday20
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: nginx-friday20
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx-friday20-container
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        securityContext:
          privileged: false
      terminationGracePeriodSeconds: 30
```

#### `base/service.yaml`

Defines the LoadBalancer service for the application.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-friday20-service
  labels:
    app: nginx-friday20
spec:
  type: LoadBalancer 
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: nginx-friday20
```

#### `base/kustomization.yaml` (Pure Resource Base)

Contains only the resources, without modifiers like `namePrefix` or `commonLabels`.

```yaml
resources:
  - deployment.yaml
  - service.yaml
```

### 3. Overlay Configurations

Each overlay now specifies both the prefix and the label, ensuring no unintended "testing" resources are created.

#### `overlays/dev/kustomization.yaml` (Development)

Sets the name prefix to `dev-`, updates the label to `dev`, and patches the deployment to use 1 replica.

```yaml
resources:
  - ../../base
namespace: development # <--- Add this for completeness
# Apply the specific environment prefix
namePrefix: dev-

commonLabels:
  environment: dev

# Reduce replicas for development
patches:
- target:
    kind: Deployment
    name: nginx-friday20
  patch: |-
    - op: replace
      path: /spec/replicas
      value: 1
```

#### `overlays/prod/kustomization.yaml` (Production)

Sets the name prefix to `prod-`, updates the label to `prod`, and patches the deployment to use 5 replicas and increases the CPU limit to `1000m`.

```yaml
resources:
  - ../../base

# Apply the specific environment prefix
namePrefix: prod-

commonLabels:
  environment: prod

# Increase replicas and resources for production
patches:
- target:
    kind: Deployment
    name: nginx-friday20
  patch: |-
    - op: replace
      path: /spec/replicas
      value: 5
    - op: replace
      path: /spec/template/spec/containers/0/resources/limits/cpu
      value: "1000m"
```

#### `overlays/staging/kustomization.yaml` (Staging)

Sets the name prefix to `staging-`, updates the label to `staging`, and patches the deployment to use 2 replicas.

```yaml
resources:
  - ../../base

# Apply the specific environment prefix
namePrefix: staging-

commonLabels:
  environment: staging

# Set replicas to 2 for staging (intermediate between dev and prod)
patches:
- target:
    kind: Deployment
    name: nginx-friday20
  patch: |-
    - op: replace
      path: /spec/replicas
      value: 2
```

### 4. Deployment Demonstration and Status (Overlays Only)

We now apply only the overlays, as the base is not intended for direct application.

### Deployment 1: Dev Environment

Applying the development overlay configuration:

```bash
kubectl apply -k overlays/dev
# service/dev-nginx-friday20-service created
# deployment.apps/dev-nginx-friday20 created
```

Checking resources labeled `environment=dev`:

> (Note: The prefix is now just `dev-`)

```bash
kubectl get all --selector environment=dev
NAME                                  READY   STATUS    RESTARTS   AGE
pod/dev-nginx-friday20-78b85c9fff-wf8zw       1/1     Running   0          33s

NAME                                     TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
service/dev-nginx-friday20-service         LoadBalancer    10.103.3.231    <pending>     80:30856/TCP      33s

NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/dev-nginx-friday20         1/1     1            1           33s

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/dev-nginx-friday20-78b85c9fff               1         1         1       33s
```

*Result:* Resources are prefixed with **`dev-`** and running 1 replica. 

#### Deployment 2: Prod Environment

Applying the production overlay configuration:

```bash
kubectl apply -k overlays/prod
# service/prod-nginx-friday20-service created
# deployment.apps/prod-nginx-friday20 created
```

Checking resources labeled `environment=prod`:

> (Note: The prefix is now just `prod-`)

```bash
kubectl get all --selector environment=prod
NAME                                  READY   STATUS    RESTARTS   AGE
pod/prod-nginx-friday20-58d8c8f884-4dfpg       1/1     Running   0          11m
# ... (4 more Pods)

NAME                                      TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
service/prod-nginx-friday20-service         LoadBalancer    10.102.92.25    <pending>     80:32081/TCP      11m

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prod-nginx-friday20         5/5     5            5           11m

NAME                                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/prod-nginx-friday20-58d8c8f884               5         5         5       11m
```
> *Result:* Resources are prefixed with **`prod-`** and running 5 replicas, with increased CPU limits. 

> **No `test-` resources were created.**
---


**Integration Note for CKAD**


**Helm (6.2.2)** is best when you are using **third-party apps** (like MySQL or Grafana) where the developers provided a "Menu" (values.yaml) for you.

**Kustomize (6.3.1)** is best for **your own apps**, where you want to keep your YAMLs simple and "Pure," but need different versions for Dev, Staging, and Prod.

---
### 6.3.2 Implementing Blue/Green Deployments
<img src="image-9.png" alt="alt text" height="35%" width="35%" />

---
**Blue/Green Deployment** is a zero-downtime release strategy that drastically reduces deployment risk. It involves running two identical production environments, named Blue (the stable, currently active version) and Green (the new version ready to be released). Traffic is routed entirely to the Blue environment via a stable Service selector. The crucial benefit is keeping the Blue environment active for immediate, instantaneous rollback.

---
#### 6.3.2.1 Lab Deployment Steps: Full Traffic Transition Demo

This sequence demonstrates the full process, from initial Blue setup to the zero-downtime switch and the instant rollback capability, using simulated endpoint output.

<table border="1" cellspacing="0" cellpadding="6">
  <tr>
    <th>Phase</th>
    <th>Objective</th>
    <th>Command Executed</th>
    <th>Endpoint Status (k get endpoints bgnginx)</th>
    <th>Status After Execution</th>
  </tr>

  <tr>
    <td>0. Initial Setup (Blue)</td>
    <td>Establish the current production environment (Blue) and the persistent service.</td>
    <td>
      kubectl create deploy blue-nginx --image=nginx:1.14 --replicas=3<br>
      kubectl expose deploy blue-nginx --port=80 --name=bgnginx
    </td>
    <td>
      10.42.0.1:80<br>
      10.42.0.2:80<br>
      10.42.0.3:80 (Blue)
    </td>
    <td>Service selector → blue-nginx</td>
  </tr>

  <tr>
    <td>I. Prepare Green<br>II. Test Green Privately</td>
    <td>Create the new version (Green) and verify it without exposing it to public traffic.</td>
    <td>
      <b>Deploy Green:</b><br>
      kubectl get deploy blue-nginx -o yaml | sed 's/blue-nginx/green-nginx/g' | sed 's/nginx:1.14/nginx:1.15/g' | kubectl apply -f -<br><br>
      <b>Test Green:</b><br>
      <i>This command is the technical step that creates the isolation mechanism. It creates a Service (likely an internal ClusterIP type) called green-test-svc that points exclusively to the new Green Pods. This is the act of "isolation."<br>
      </i><br>
      kubectl expose deploy green-nginx --port=80 --name=green-test-svc<br>
      <br>
      <i>The actual execution of the verification that confirms or not the new code works as expected.<br>
      Run the test from a running Pod (like a temporary debug container or your CI/CD runner) inside the cluster)</i><br><br>
      curl green-test-svc:80<br>
      (<b>Result:</b> If `curl green-test-svc:80` returns the expected response from NGINX `1.15`, the environment is healthy and ready for promotion.)
    </td>
    <td>
      10.42.0.1:80<br>
      10.42.0.2:80<br>
      10.42.0.3:80 (Still Blue)
    </td>
    <td>Green running + private test svc</td>
  </tr>

  <tr>
    <td>III. Traffic Switch (To Green)</td>
    <td>Instantly redirect all production traffic to the new Green environment.</td>
    <td>
      kubectl patch service bgnginx -p '{"spec":{"selector":{"app":"green-nginx"}}}'
    </td>
    <td>
      10.42.0.5:80<br>
      10.42.0.6:80<br>
      10.42.0.7:80 (Green)
    </td>
    <td>Traffic routed to Green</td>
  </tr>

  <tr>
    <td>IV. Rollback to Blue</td>
    <td>Instantly revert all production traffic back to the known-good Blue environment.</td>
    <td>
      kubectl patch service bgnginx -p '{"spec":{"selector":{"app":"blue-nginx"}}}'
    </td>
    <td>
      10.42.0.1:80<br>
      10.42.0.2:80<br>
      10.42.0.3:80 (Blue)
    </td>
    <td>Instant rollback</td>
  </tr>

  <tr>
    <td>V. Final Cleanup</td>
    <td>Delete the environment that is no longer needed (Green in this rollback scenario).</td>
    <td>
      kubectl delete deploy green-nginx
    </td>
    <td>N/A</td>
    <td>Green removed</td>
  </tr>
</table>

**Endpoint Visualization Key:**
* Blue Pod IPs (v1.14): e.g., 10.42.0.1, .2, .3
* Green Pod IPs (v1.15): e.g., 10.42.0.5, .6, .7

The Endpoint status clearly shows that only the Service's selector patch (Phase III or IV) is needed to redirect all traffic instantaneously, which is the core benefit of the Blue/Green strategy.

---
### 6.3.3 Implementing Canary Deployments
<img src="image-10.png" alt="Canary Deployment Schema in Kubernetes" height="35%" width="35%" />

<img src="image13.png" alt="The 'Smart Transit Hub'" height="35%" width="35%" />

**Canary Deployment** is a progressive release strategy that minimizes risk by exposing the new version (the "canary") only to a small fraction of traffic. Unlike Blue/Green, which is a binary switch (on/off), Canary is a dimmer, allowing traffic directed to the new version to be gradually increased. The strategy relies on using **a single persistent Service** that selects Pods belonging to **two separate Deployments** (Stable and Canary). Traffic control is managed by modifying the replica counts (`replicas`) for each Deployment.

---
### 6.3.3.1 Deployment Steps: Progressive Traffic Demo
---
#### Canary Deployment Implementation Plan (Kubernetes CLI)

This plan outlines the steps for setting up a robust Canary deployment strategy using standard Kubernetes CLI commands. The strategy relies on defining a **shared label** for both stable and canary deployments, which the Service targets. Traffic management is then controlled by scaling the replicas of the respective deployments.

Canary Deployment Implementation Plan (With Food Court Analogy)
We will deploy the new application version (V2) by treating the Service as the **Food Court Entrance** and the Pods as individual **Food Stalls**. Traffic (customers) is routed based on the number of open stalls for each version.

---
##### Analogy Key
* **Service (`canary-svc`):** The Food Court Entrance/Main Sign.
* **Deployment:** The blueprints/staffing plan for a stall type (V1 or V2).
* **Pods (Replicas):** The actual, running Food Stalls (serving customers).
* **Shared Label (`traffic-group`):** The common category ("Food Stalls") that the Entrance directs customers toward.
* **Traffic:** Customers entering the food court.

---
#### 6.3.3.1.1. Deploy Stable Version (V1)
---
##### 6.3.3.1.1.1. Create the Deployment

**Action:** Deploy the Stable Version (V1.14) - This is the existing 10 stalls of the successful V1 restaurant.

```bash
kubectl create deployment stable-nginx --image=nginx:1.14 --replicas=10
```
---
##### 6.3.3.1.1.2. Apply Shared Labels to Pod Template (Tag the Stalls)
We apply the common label (`traffic-group=nginx-canary`) to the Pod Template. This is like putting up the "Food Stalls" sign on the existing V1 restaurants so the Entrance knows where to send customers.

**Action:** Patch the Deployment's Pod Template metadata.

```bash
kubectl patch deployment stable-nginx -p '{"spec": {"template": {"metadata": {"labels": {"app": "stable-nginx", "traffic-group": "nginx-canary"}}}}}'
```
---
#### 6.3.3.1.2. Expose Stable Deployment with a Service (Open the Entrance)
The Service is configured to use the **shared label**. The Entrance is opened, directing traffic to any stall with the "Food Stalls" sign. Since only V1 has the sign, it gets 100% of the traffic.

**Action:** Create the Service targeting the common label.
```bash
kubectl expose deployment stable-nginx --port=80 --name=canary-svc --selector="traffic-group=nginx-canary"
```
---
#### 6.3.3.1.3. Deploy Canary Version (V2 Initial Rollout)
---
##### 6.3.3.1.3.1. Create the Canary Deployment (Build the New Stall)
We introduce the new Canary version (`canary-nginx`), but we keep it closed (`--replicas=0`). The new V2 recipe is ready, but the stall isn't staffed yet.

**Action:** Deploy the Canary Version with 0 replicas initially.

```bash
kubectl create deployment canary-nginx --image=nginx:1.15 --replicas=0
```
---
##### 6.3.3.1.3.2. Apply Shared Labels to Canary Pod Template (Tag the New Stall)
We apply the required labels to the new Canary's Pod Template. The new V2 stall is also given the "Food Stalls" sign, ready for the Entrance to include it when it opens.

**Action:** Patch the Canary Deployment's Pod Template metadata.

```bash
kubectl patch deployment canary-nginx -p '{"spec": {"template": {"metadata": {"labels": {"app": "canary-nginx", "traffic-group": "nginx-canary"}}}}}'
```
---
#### 6.3.3.1.4. Deployment Steps: Progressive Traffic Demo (Staffing the Stalls)
The Entrance (Service) routes customers (traffic) randomly across all open stalls. We control the traffic split by opening V2 stalls and closing V1 stalls using `kubectl scale`.

<table border="1" cellspacing="0" cellpadding="6">
  <tr>
    <th>Phase</th>
    <th>Objective (Mall Analogy)</th>
    <th>Command Executed (Stable / Canary)</th>
    <th>Total Target Replicas</th>
    <th>Status After Execution</th>
  </tr>

  <tr>
    <td>6.3.3.1.4.1. Initial Setup</td>
    <td>10 V1 Stalls Open (100%), V2 Stalls Closed (0%).</td>
    <td>
      kubectl scale deploy stable-nginx --replicas=10 <br>
      kubectl scale deploy canary-nginx --replicas=0
    </td>
    <td>10</td>
    <td>Stable 100% (10/10)</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.2. Canary Test (10% Low Risk)</td>
    <td>Open 1 V2 Stall and close 1 V1 Stall. 10% of customers are now exposed to the new recipe. <b>(Followed by 6.3.3.1.5: Testing)</b></td>
    <td>
      <b>Scale Up Canary:</b><br>
      kubectl scale deploy canary-nginx --replicas=1<br><br>
      <b>Scale Down Stable:</b><br>
      kubectl scale deploy stable-nginx --replicas=9
    </td>
    <td>10</td>
    <td>10% traffic to v1.15 (1/10)</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.3. Progressive Rollout (50% Medium Risk)</td>
    <td>The V2 recipe is popular and safe. Open 4 more V2 Stalls and close 4 V1 Stalls. <b>(Followed by 6.3.3.1.5: Testing)</b></td>
    <td>
      kubectl scale deploy canary-nginx --replicas=5<br>
      kubectl scale deploy stable-nginx --replicas=5
    </td>
    <td>10</td>
    <td>50% traffic to v1.15 (5/10)</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.4. Instant Rollback (Optional)</td>
    <td><i>**Failure Scenario:** Customer feedback is terrible (errors/bugs). Immediately close all V2 stalls and reopen V1 stalls.</i></td>
    <td>
      kubectl scale deploy canary-nginx --replicas=0<br>
      kubectl scale deploy stable-nginx --replicas=10
    </td>
    <td>10</td>
    <td>Rollback completed, 0% traffic to Canary</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.5. Full Promotion (100%)</td>
    <td>The V2 recipe is stable. Close all V1 Stalls and staff all 10 V2 Stalls. The new version is now the standard.</td>
    <td>
      kubectl scale deploy canary-nginx --replicas=10<br>
      kubectl scale deploy stable-nginx --replicas=0
    </td>
    <td>10</td>
    <td>Full Promotion (10/10)</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.6. Final Cleanup</td>
    <td>Remove the blueprints for the old V1 stalls now that V2 is the new standard.</td>
    <td>
      kubectl delete deploy stable-nginx
    </td>
    <td>N/A</td>
    <td>Old Stable removed</td>
  </tr>
</table>


#### 6.3.3.1.5. Testing and Observation Procedures (Between Scaling Steps)
---
After each change in the number of open stalls (traffic increment), a mandatory observation period must occur.

---
##### 6.3.3.1.5.1. Health and Error Monitoring (Food Safety)

| Metric | Description (Analogy) | Command or Tool |
| :--- | :--- | :--- |
| **Pod Health** | Ensure all V2 stalls remain open, staffed, and ready to serve customers. | **Immediate Check:** Get the status of all Canary pods. <pre>kubectl get pods -l app=canary-nginx</pre> |
| **Log Analysis** | Check the V2 kitchen's internal logs for critical failures or system crashes. | **Immediate Check:** Stream logs from one Canary pod (replace `[POD_NAME]` with a live pod name). <pre>kubectl logs -f [POD_NAME] -c nginx</pre> |
| **Error Rate** | Check for "food poisoning reports" (HTTP 5xx responses) specific to the new V2 stalls. | **Monitoring Query (e.g., Prometheus/Grafana):** Compare the rate of 5xx errors between V1 and V2 services. <pre>sum(rate(http_requests_total{app="canary-nginx", status="5xx"}[5m])) / sum(rate(http_requests_total{app="canary-nginx"}[5m]))</pre> |

---
##### 6.3.3.1.5.2. Performance Metrics (Service Speed)

| Metric | Description (Analogy) | Command or Tool |
| :--- | :--- | :--- |
| **Resource Utilization** | Check if the new V2 stall is using excessive resources (CPU/Memory). | **Immediate Check:** Check CPU/Memory for all Canary pods. (Requires Kubernetes Metrics Server). <pre>kubectl top pod -l app=canary-nginx</pre> |
| **Latency/Response Time** | Monitor customer wait times (response latency) at the new V2 stall. | **Monitoring Query (e.g., Prometheus/Grafana):** Compare the 95th percentile (P95) response time. <pre>histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{app="canary-nginx"}[5m]))</pre> |
| **Key Business Metrics (KBMs) & User Feedback** | Track critical business metrics (e.g., conversion rates). The V2 stall should not negatively impact overall sales. | **External APM/Analytics:** Monitored via dedicated Application Performance Monitoring (APM) tools (e.g., New Relic, Datadog) or A/B testing platforms which track user behavior specific to traffic hitting the V2 code path. |

---
**Summary:** By using a common `traffic-group` label, the Food Court Entrance (Service) seamlessly directs customers across all available stalls (Pods). The progressive scaling is only executed after successful completion of the observation and testing steps defined in 6.3.3.1.5, ensuring the new recipe is safe and fast before full promotion.

---
### 6.3.3.2 Lab: The "Smart Transit Hub" (Gateway API Lab)

<img src="image12.png" alt="The 'Smart Transit Hub'" height="35%" width="35%" />

**Why use this instead of Ingress?**

In `Task 7 - Ingress, Exposing Applications`, we used Ingress for simple routing. For DevOps/Canary (Section 6.0), we use the **Gateway API** because "Weighting" (90/10 split) is a native feature, not a hack.

While **Section 6.3.3.1** used the "Manual Scaling" method (hiring more workers), this section uses the **Gateway API** to manage traffic at the entrance using **Weights**.

**1. Hiring the Management Team (Infrastructure)**
Before the mall can open the new hub, we need to install the rules and hire the security firm.
  **- Mall Analogy:** You can't have a "Smart Gate" if the Mall Manager doesn't recognize the new permit types.
```Bash
# 1. Install the "Global Mall Regulations" (CRDs)
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml

# 2. Hire the Security Firm (Nginx Gateway Fabric)
helm install ngf oci://ghcr.io/nginxinc/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway

# 3. Verify the "Office" is open
kubectl get pods,svc -n nginx-gateway

# 4. Check the Blueprint (GatewayClass)
# You should see a class named "nginx"
kubectl get gc
```
**2. Opening the Physical Entrance (The NodePort Trick)**
**- Mall Analogy:** Since we are in a local lab (Minikube), we don't have a "Main Highway" (Cloud LoadBalancer), so we tell the guard to let people in through the **Side Door** (NodePort).
```Bash
# Edit the Service to change type from LoadBalancer to NodePort
kubectl edit -n nginx-gateway svc ngf-nginx-gateway-fabric
# (Change 'type: LoadBalancer' to 'type: NodePort')
```
**3. Building the Store & Smart Signage**
**- Mall Analogy:** We build the "Nginx Boutique" and put up the **Digital Signage** (`HTTPRoute`) to direct customers.
```Bash
# 1. Build the Store and the Intercom
kubectl create deployment nginxgw --image=nginx --replicas=3 -n nginx-gateway
kubectl expose deploy nginxgw -n nginx-gateway --port=80

# 2. Apply the Smart Signage (The 'http-routing.yaml')
kubectl apply -f http-routing.yaml -n nginx-gateway
```
**4. Verification (The GPS Update)**
**- Mall Analogy:** We update the customer's GPS (`/etc/hosts`) to point `whatever.com` to the Mall's address.
```Bash
# 1. Get Mall Address and Side Door Number
minikube ip
kubectl get svc -n nginx-gateway # Note the NodePort, e.g., 31702
# 2. Add to hosts file (Assuming IP is 192.168.49.2)
sudo vi /etc/hosts
# Add line: 192.168.49.2  whatever.com
# 3. Final Test
curl whatever.com:<NODEPORT>
```
---
**Comparison** 
|Feature|6.3.3.1 (Manual Canary)|6.3.3.2 (Gateway API)|
|--|--|--|
|**Control**|Scale replicas (9:1)|Set weight: 10 in YAML|
|**Logic**|Probability based on worker count|Precise traffic percentage|
|**Resource**|Service + Deployment|Gateway + HTTPRoute|

---

### 6.3.4 Related Deployment Strategies Comparison

Here is a direct comparison between the Blue/Green and Canary deployment strategies, highlighting their goals, advantages, and ideal use cases in a Kubernetes context.

### Comparison: Blue/Green vs. Canary Deployments

| Feature | Blue/Green Deployment | Canary Deployment |
| :--- | :--- | :--- |
| **Primary Goal** | Zero downtime and rapid, total rollback capability. | Testing stability and performance on a subset of real users. |
| **Release (Rollout)** | Instantaneous (all or nothing). Once the Green environment is validated, the switch is 100% at once. | Progressive and gradual (e.g., 1% -> 5% -> 25% -> 100%). |
| **Required Environments** | Two complete and identical production environments (Blue and Green). | One main environment, with a small group of Pods running the new version (the Canary). |
| **Error Risk** | Low. Testing is performed on 100% of the Green environment before the final release. | Very Low. Failure only affects the small percentage of users in the Canary group. |
| **Implementation Complexity** | Requires provisioning and maintaining double the resources (can be costly). | More complex to configure in terms of traffic routing and metric monitoring (often requires service mesh/Ingress rules). |
| **Rollback** | Instantaneous and simple. Just redirect traffic back to the previous Blue environment. | Fast only for the small portion of traffic hitting the Canary; requires terminating the Canary Pods. |
| **Ideal Scenarios** | Releases of major patches or upgrades where immediate data consistency is crucial. | Releases of new features with a high potential for regression or performance impact. |
---
### Summary

**Choose Blue/Green** if your main concern is ensuring zero downtime and having the option for an immediate, large-scale rollback, and you can afford to double your infrastructure for a short period.

**Choose Canary** if your main concern is minimizing exposure to risk for end-users and you need to gather real-time metrics on a sample of live traffic before committing to a full rollout.

---

### 6.3.5 Understanding Custom Resource Definitions (CRDs)

**CRDs** extend the Kubernetes API by introducing new resource types (e.g., \`Database\`, \`MonitoringAlert\`, or application-specific types like \`MyAppBackup\`). They allow users to define and manage custom objects using the same declarative \`kubectl\` commands as native Kubernetes resources.

**Mall Analogy:**
By default, Mall Management can only issue permits for Stores (Deployments), Pick-up Points (Services), or Standard Licenses (Pods). We want to add a new service: the "Nightly Backup Service" (BackUp), which is not part of the Mall's standard ruleset.

#### 6.3.5.1. Phase 1: Defining the New Permit Type (The CRD)

This step extends the Official Mall Rulebook (Kubernetes API) to recognize the new `BackUp` resource.

| Kubernetes Step (Command) | Action in the Shopping Mall (Mall Analogy) | Logic |
| :--- | :--- | :--- |
| **6.3.5.1.1. Define the CRD Manifesto** (`vim crd-object.yaml`) | **Write the Rulebook Chapter:** Define exactly what a "Nightly Backup Service" (`kind: BackUp`) is. | Establishes the rules: the module name, the required fields (`backupType`, `replicas`, `image`), and where it will be filed. |
| **6.3.5.1.2. Create the CRD** (`kubectl create -f crd-object.yaml`) | **Formalize the Regulation:** Submit the new Chapter (the CRD) to Central Management. | Central Management updates its system: they now know what a `BackUp` request means and are ready to accept forms for it. |
| **6.3.5.1.3. Verify Extension** (`kubectl api-resources \| grep backup`) | **Check the Forms Database:** Verify that the new "Nightly Backup Services" form is officially listed. | Confirms the new resource type is known to the API server. |

#### crd-object.yaml (The Regulation)

```yaml
# A simplified CRD definition
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.stable.example.com
spec:
  group: stable.example.com
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                backupType: { type: string }
                image: { type: string }
                replicas: { type: integer }
  scope: Namespaced
  names:
    plural: backups
    singular: backup
    shortNames:
      - bks
    kind: BackUp # <-- The new permit type (Nightly Backup Service)
```

#### 6.3.5.2. Phase 2: Creating a Custom Service Instance

This step is the act of requesting the new service.

| Kubernetes Step (Command) | Action in the Shopping Mall (Mall Analogy) | Logic |
| :--- | :--- | :--- |
| **6.3.5.2.1. Define the Instance** (`vim crd-backup.yaml`) | **Fill out the Form:** Request a specific instance of the "Nightly Backup Service." | Defines the desired state for the custom resource. |

#### 📄 crd-backup.yaml (The Form Instance)

```yaml
apiVersion: [stable.example.com/v1](https://stable.example.com/v1)
kind: BackUp
metadata:
  name: mybackup
spec:
  backupType: full
  image: backup-script:v2.0
  replicas: 1
```

| Kubernetes Step (Command) | Action in the Shopping Mall (Mall Analogy) | Logic |
| :--- | :--- | :--- |
| **6.3.5.2.2. Create the Custom Resource (CR)** (`kubectl create -f crd-backup.yaml`) | **Submit the Form:** Send the specific request to Central Management. | The API server stores this configuration in etcd. The resource now exists but is currently *unmanaged*. |
| **6.3.5.2.3. Verify the New Resource** (`kubectl get bks`) | **Check the Request Status:** List all submitted "Nightly Backup Services" forms. | Confirms the instance is stored in Kubernetes. The resource is pending action by a Controller/Operator. |

<h2 id="section-6-4-0">6.4 Extending K8s: CRDs & Operators</h2>
This section explores the component responsible for managing the Custom Resources defined in the previous section. A <b>Controller</b> is a control loop that constantly monitors the state of your cluster and attempts to make the current state match the desired state. An <b>Operator</b> is a specialized Controller that uses Custom Resources to automate complex application lifecycle management.

### 6.4.1 Using Operators
Operators are a method for packaging, deploying, and managing a Kubernetes application. Operators use CRDs to automate complex operational tasks, acting like "robots" that manage the application's lifecycle, from installation and scaling to backup and recovery, all based on best practices.

### 6.4.2 Calico CNI Operator Demo (Production CR Example)
A practical demonstration of consuming a large, industry-standard Custom Resource (CR) by installing and configuring the Calico CNI Operator. This shows how CRDs are used to manage complex infrastructure components like the Container Network Interface (CNI).

<h3 id="section-6-4-3">6.4.3 CRD Demo (Creating a Custom Service)</h3>

This section details the missing link: the **Controller** that watches for the Custom Resources (`kind: BackUp`) and takes action to match the desired state (the CR) with the current state (a running Pod). This is the foundational component of an Operator.

#### 1. The Controller's Role (The Watcher)
The Controller is a persistent process running inside the Kubernetes cluster. Its core job is to continuously monitor the API server for changes to the Custom Resource type it manages (`BackUp` resources).

| Control Loop Component | Action on `BackUp` Resource |
| :--- | :--- |
| **Watcher** | Listens for creation, update, or deletion events for `BackUp` resources. |
| **Reconciler** | Compares the desired state (defined in the `BackUp` CR's `spec`) with the actual state of the cluster (e.g., is the backup Pod running?). |
| **Actuator** | If states don't match, it takes corrective action (e.g., creates a Deployment, updates a ConfigMap, or starts a Pod). |

#### 2. The Reconcile Function (The Logic)

The heart of every Controller is the `Reconcile` function. When a `BackUp` object is created (like `mybackup` in 6.3.5.2), the Controller sees the event and runs the logic below.

**Conceptual Pseudocode (Operator Logic):**

```python
# Simplified Logic of the BackUp Controller

def Reconcile(backup_cr_name):
    # 1. Fetch the Desired State (The CR)
    backup_cr = api_client.get_custom_resource('BackUp', backup_cr_name)

    if not backup_cr:
        # Resource was deleted (cleanup if needed)
        # Ensure associated Deployment/Job is also deleted
        delete_job(backup_cr_name)
        return

    # 2. Define the Actual State (The Dependent Kubernetes Object)
    job_name = f"job-{backup_cr.metadata.name}"
    existing_job = api_client.get_kubernetes_job(job_name)

    # 3. Check and Act (Reconciliation Loop)
    if not existing_job:
        # Create a new Kubernetes Job/Deployment based on the CR spec
        new_job_spec = create_job_spec(
            image=backup_cr.spec.image,
            replicas=backup_cr.spec.replicas,
            command=f"/run/backup --type={backup_cr.spec.backupType}"
        )
        api_client.create_kubernetes_job(new_job_spec)
        
        # Update the CR's status to 'Creating'
        api_client.update_cr_status(backup_cr_name, 'Status: Creating Job')

    elif existing_job.spec.image != backup_cr.spec.image:
        # Update Case: The image in the CR was changed
        api_client.update_kubernetes_job(job_name, new_image=backup_cr.spec.image)
        
        # Update the CR's status to 'Updating'
        api_client.update_cr_status(backup_cr_name, 'Status: Image Updated')

    # ... other logic for scaling, deletion, or failure handling

    return # Reconciliation complete
```
#### 3. Result: Automated Management
Once the Controller is running, the user never interacts directly with the Kubernetes Deployment or Job resources for the backup. They simply manage the simple `BackUp` CR:

* **To create the backup:** `kubectl apply -f crd-backup.yaml` (The Controller sees this and creates the K8s Job).
* **To change the image:** `kubectl edit bks mybackup` (The Controller sees the update and rolls out the new K8s Job).
* **To delete the backup service:** `kubectl delete bks mybackup` (The Controller sees the deletion and automatically cleans up the underlying K8s Job).

### 6.4.4 Using StatefulSets

**StatefulSets** are a specialized workload object designed for managing stateful applications (which require persistent storage and stable network identity). They provide guarantees for ordered deployment, scaling, and unique, stable network identifiers for each Pod (e.g., `web-0`, `web-1`). They are commonly used for databases and message queues.

## (The Bank Row Analogy)

In the Kubernetes **"Mall,"** a **StatefulSet** is used for applications that aren't just temporary shops, but permanent institutions, like a row of **Numbered Private Banks**.

---

## 🏗️ 1. The Core Concept

The main purpose is to provide a **persistent identity** and **specific storage** to each Pod.

### 🔐 Persistent Identifiers
Each Pod is named with a strict index:

- `web-0`
- `web-1`
- `web-2`

If `web-0` is demolished, it is rebuilt as **`web-0`**, never with a random name.

### 📦 Ordered Deployment
Unlike regular stores, these are built **one-by-one**:

- `web-0` must be **"Open for Business"**
- Only then does construction start on `web-1`

### 🏦 Stable Storage
Every bank branch has its own **Private Underground Vault** (Persistent Volume):

- The vault is permanently tied to the branch number  
- Storage survives Pod restarts and rescheduling  

---

## 📐 2. The Blueprint Integration (`sfs.yaml`)

### Part A: The Private Switchboard (Headless Service)

**YAML**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  clusterIP: None  # <--- The "Headless" magic
```
## 🏦 Analogy:
Instead of a general mall receptionist, this is a Direct-Dial Directory.

## Function:
It allows you to dial a specific branch directly (e.g., web-0.nginx) rather than hitting a load balancer.

### Part B: The Bank Row (StatefulSet)

**YAML**
```yaml


apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: "nginx"
  replicas: 3
  template:
    spec:
      terminationGracePeriodSeconds: 10 # Emergency evacuation time
```
## 🏦 Analogy:
You are ordering 3 numbered branches.
The terminationGracePeriodSeconds gives staff 10 seconds to lock the safe before the building is removed.

### Part C: The Automatic Vault Permit (VolumeClaimTemplates)
**YAML**
```yaml
volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "standard" # The "Digging Machine"
      resources:
        requests:
          storage: 1Gi
```
## 🏦 Analogy

This is a permit that says:

> "For every bank built, automatically dig a 1Gi vault using the standard digging machine."

---

## 💾 Persistence

If the building (`web-0`) is destroyed, the vault (`www-web-0`) is **not deleted**.  
It waits in the ground for the next `web-0`.

---

## 📝 3. Limitations & Rules

### Storage Provisioning
A **StorageClass** (like the standard `hostpath` in Minikube) must be available.

### Manual Cleanup
To ensure data safety, the Mall Manager (Kubernetes) will **never delete the vaults (PVCs)** automatically.  
You must manually *"fill in the holes"* (delete PVCs) if you want the data gone.

### Headless Requirement
A **Headless Service MUST** be created to provide direct-dial access.

### Graceful Removal
To remove the banks, you should **scale the number of Pods down to 0** before deleting the StatefulSet.

---

## Summary Table
While a Deployment creates "Disposable Workers," a StatefulSet creates "Named Institutions."

| Feature   | Deployment (Pop-up Shop) | StatefulSet (Private Bank) |
|-----------|--------------------------|-----------------------------|
| Naming    | Random (web-7fc...)      | Strict Index (web-0, web-1) |
| Startup   | All at once (Parallel)   | One-by-one (Ordered)        |
| Storage   | Shared or Temporary      | Unique Private Vault        |
| Network   | Single Shared Number     | Direct Extension per Pod   |

---

## 🔍 Construction Progress (From Logs)
- `web-0` in `ContainerCreating`  
- Other Pods waiting  

This confirms **Ordered Deployment**.

The PVC `www-web-0` was **Bound** to the digging machine before the Nginx "Bank" could open.

---
### 6.4.5 Lab Case Study: The Vault Recovery
<i>Detailed post-mortem of a HashiCorp Vault deployment. Covers the transition from '0/1 Ready' (Sealed) to '1/1 Ready' (Unsealed), forcing a 'Zombie' Pod deletion, and recovering from a Calico CNI 'Unauthorized' error without losing data.</i>

This lab demonstrates the resilience of **StatefulSets** and the complexities of **CNI (Networking)** and **Readiness Probes**.

**1. Installation via Helm**

We use Helm to deploy a complex "Prefab" store.
```Bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install my-vault hashicorp/vault --version 0.32.0
```
**2. The Discovery (0/1 READY)**

Even though the Pod is `Running`, it is not `Ready`.
  - **The Reason:** Hashicorp Vault starts in a **Sealed** state. It requires manual intervention to open the "Safe."
  - **The Diagnostic:** `kubectl describe pod my-vault-0` showed the Readiness Probe failing because the vault was uninitialized.

**3. Initialization & Key Management**

We initialize the vault to generate the **Master Keys** and the **Root Token**.
```Bash
kubectl exec -it my-vault-0 -- vault operator init
```
> **CKAD Lesson:** Vault uses Shamir’s Secret Sharing. With a **Threshold of 3**, you must provide 3 **different** keys to unseal it. Using the same key 3 times will result in an error.

**4. The "Zombie" Pod Crisis (CNI Failure)**

During the lab, the Pod became stuck in a **Terminating** state due to a **CNI (Calico) Authorization** error. The network "Security Guards" lost their connection to the API server.

**- The Solution:**
  1. **Force Delete:** `kubectl delete pod my-vault-0 --force --grace-period=0`
  2. **Cluster Reset:** `minikube stop` then `minikube start` to refresh CNI tokens and certificates.

**5. Final State: Persistence in Action**

Despite a force deletion and a full cluster restart, the Vault remained **Initialized**.
  - **Why?** Because it is a **StatefulSet** with a **Persistent Volume Claim (PVC)**. The data in `/vault/data` was un-linked from the old Pod and re-linked to the new one.
  - **Final Step:** Run `vault operator unseal` three times with three different keys.
---
### Summary of Final Status

|Resource|Status|Note|
|--|--|--|
|`pod/my-vault-0`|**1/1 Running**|Readiness probe passed after unsealing.|
|`statefulset.apps/my-vault`|**1/1**|Desired state matches current state.|
|`pvc/data-my-vault-0`|**Bound**|The "Locker" survived the restart.|
---

### 6.4.5 Case Study Analogy: The High-Security Jewelry Store (Vault)
This lab is the ultimate proof of how **StatefulSets** protect your business even when the "Mall" (Cluster) faces a total security breakdown.1. 

**1. The Franchise Opening (Helm)**
Instead of building a store from scratch, we buy a **"High-Security Franchise" (Helm Chart)**. It comes with the walls, the staff, and the heavy safe already designed.
  - **The Command:** `helm install my-vault...`
  - **The Mall Result:** The franchise is set up in spot **#0** of the High-Security Wing.

**2. The "Open" Sign is Off (0/1 READY)**
The lights are on, and the staff is inside (`Running`), but the front door is locked.
  - **The Reason:** The store is Sealed. In a high-end jewelry store, the safe is locked by default. The staff can't sell anything if they can't reach the jewels.
  - **The Management Check:** The Mall Manager (Readiness Probe) knocks on the door every 5 seconds. The staff yells, "We’re here, but the safe is locked!" So, the Manager keeps the "Closed" sign on the shop front.

**3. Setting the Combination (Initialization)** 
You, the owner, arrive to set the master combination. You decide to use a **Multi-Manager System (Shamir’s Secret Sharing)**.
  - **The Setup:** You generate 5 unique keys. To open the safe, **3 different managers** must show up with their specific keys.
  - **The Error:** If one manager tries to use the same key 3 times, the safe stays locked. It requires a "Quorum" (3/5) of unique keys.

**4. The "Zombie" Guard Strike (CNI/Calico Failure)**
Suddenly, the Mall’s **Security Radio System (Calico CNI)** glitches. The guards' badges become "Unauthorized." They can't communicate with Central Management.
  - **The Crisis:** You try to fire the staff and restart (`Delete`), but they are stuck in the doorway (**Terminating**) because they can't get the radio signal to confirm they've left.
  - **The Forceful Solution:** You have to physically drag the staff out (`--force`) and reboot the entire Mall's security system (`minikube stop/start`) to give the guards new, authorized badges.

**5. The "Locker" survived! (Persistence)**
The miracle happens here. Even though you "fired" the staff and the Mall shut down, the **Heavy Safe (Persistent Volume)** was bolted to the floor of the shop.
  - **Why?** Because this is a StatefulSet. Unlike a pop-up kiosk (Deployment), the Jewelry Store has a permanent lease on that specific floor space and that specific safe.
  - **The Result:** When the new staff arrives, the safe is still there. It's still **Initialized** with your combination. You just need your 3 managers to walk in, provide their keys (**Unseal**), and the store finally flips to **1/1 READY**.
---
**The "CKAD Student" Takeaway**
|Mall Event|K8s Technical Concept|
|--|--|
|**Franchise Kit**|**Helm:** Pre-packaged complex apps.|
|**Staff inside, door locked**| **Readiness Probe:** App is live but not functional.|
|**The Heavy Safe**|**Persistent Volume:** Data that lives longer than the Pod.|
|**The Radio Glitch**|**CNI (Calico):** The networking layer that assigns Pod IPs.|
|**Permanent Shop #0**|**StatefulSet:** Guaranteed identity and storage mapping.|
---
## 6.5 Service Mesh and Security
<img src="image-12.png" alt="Service Mesh and Security" height="35%" width="35%" />

As clusters grow, managing communication between microservices becomes complex. A Service Mesh is a dedicated infrastructure layer that handles **service-to-service (East-West)** traffic.

---
### 6.5.1 The Core Components
- <b>Data Plane:</b> Lightweight proxies (like Envoy) running as <b>Native Sidecars</b> in your Pods. They intercept all traffic entering or leaving the container.
- <b>Control Plane</b>: The central "brain" (e.g., Istio) that manages policies, security certificates, and telemetry. It tells the proxies how to behave.
---
### 6.5.1.1 The Role of the Native Sidecar (The Modern Assistant)
In the past, Service Mesh proxies were just "regular" containers. If the proxy crashed or started late, the app would fail. **Modern Kubernetes (1.29+)** fixes this by treating the proxy as a native sidecar.
|FEATURE|SERVICE MESH SIDECAR|MALL ANALOGY|
|--|--|--|
|**Identity**|`initContainer` with `restartPolicy: Always`|**The Security Escort:** Arrives before the shop opens and stays at the door all day.|
|**Startup**|Must be healthy before the Main App starts.|"Ensures the ""Encrypted Radio"" (mTLS) is working before any customers arrive."|
|**Termination**|Shuts down only after the Main App is finished.|"Ensures the last ""Customer"" is logged before locking the gates."|
---
### 6.5.2 Key Security & Traffic Features (The 4 Pillars)
|FEATURE|MALL ANALOGY|WHAT IT ACTUALLY DOES|BENEFIT|
|--|--|--|--|
|**mTLS**|**The Scrambled Radio**|Automatically encrypts traffic between pods.|**Zero Trust:** Hackers can't "sniff" data in the hallways.|
|**Zero Trust**|**The ID Badge**|Verifies identity before allowing any conversation.|**Security:** Pods can't talk unless a policy explicitly allows it.|
|**Observability**|**The Logbook**|Records every interaction and "customer" path.|**Insight:** Deep tracing (Kiali/Jaeger) without changing code.|
|**Traffic Shifting**|**The Smart Turnstile**|Directs a specific % of traffic to different versions.|**Canary:** Precision control (e.g., 1%) for new releases.|
---
  - **Resilience (The "Backup Plan")** If a "Store" is slow or busy, the Service Mesh Assistant (Sidecar) can automatically try the door again (**Retries**) or temporarily close the path if the store is broken (**Circuit Breaking**) to prevent a mall-wide crowd jam.
---  
### 6.5.3 Deployment Comparison: Manual Assistant vs. Elite Firm
In the mall, you can hire your own helper manually, or hire a massive firm like **Istio** to handle every shop at once.

---

**1. The "Manual Assistant" (Basic K8s Sidecar)**

This is the manual way you would do it for a single task (like logging). This is a classic CKAD exam scenario.
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: manual-sidecar-pod
spec:
  containers:
  - name: app-worker (The Main Worker)
    image: busybox
    command: ["sh", "-c", "while true; do echo $(date) >> /var/log/app.log; sleep 5; done"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log
  initContainers:
  - name: sidecar-logger (The Manual Assistant)
    image: busybox
    restartPolicy: Always # <--- Native Sidecar logic
    command: ["sh", "-c", "tail -f /var/log/app.log"]
    volumeMounts:
    - name: shared-logs
      mountPath: /var/log
  volumes:
  - name: shared-logs
    emptyDir: {}
```

---

**2. The "Elite Firm" (Istio/Service Mesh)**

Istio is a "Heavyweight" solution. You don't write the proxy YAML yourself; the Istio Operator injects it into your Pod automatically based on your mall rules.
|FEATURE|MANUAL SIDECAR (BASIC K8s)|ISTIO SIDECAR (HEAVYWEIGHT)|
|--|--|--|
|**Who builds it?**|***You (Manual YAML).***|**The Operator** (Auto-injected).|
|**Complexity**|Simple: One job (like logging).|High: mTLS, Retries, and Metrics.|
|**Effort**|Add it to every Deployment.|Label a namespace; it's added everywhere.|
|**Analogy**|**The Personal Helper**|**The Global Security Detail**|

---
### 6.5.4 Popular Solutions
- **Istio:** The "Heavyweight" industry standard. It’s like hiring a massive, global security firm that automates everything but requires a lot of setup.
- **Linkerd:** Focused on simplicity and performance (Rust-based). Ideal if you want the "Security Escorts" without the complex paperwork of Istio.
- **Cilium:** A modern approach using **eBPF**. It’s like having "Invisible Security Cameras" built into the very floors of the mall (the Kernel), often removing the need for sidecars entirely.

---
### 6.6 Observability (The Mall Control Room)

<img src="image-13.png" alt="Observability (The Mall Control Room)" height="35%" width="35%" />

If your mall is running hundreds of shops and thousands of workers, you can't walk to every store to check if things are okay. You need a **Central Control Room** to monitor the state of the mall using external signals.

> **6.5 (Service Mesh):** Generates the data (the "Security Escorts" recording actions).
>
> **6.6 (Observability):** Views the data (the "Control Room").

---
### 6.6.1 What is Observability?
Observability is "Monitoring on Steroids." While basic monitoring tells you if a store is closed, Observability helps you figure out why the coffee machine broke at exactly 2:00 PM when the lights flickered.

**The Three Pillars of the Control Room**
|PILLAR|MALL ANALOGY|K8s DATA TYPE|POPULAR TOOLS|
|--|--|--|--|
|**Metrics**|**The Dashboard:** Shows temperature, customer count, and electricity usage.|**Numerical Data:** CPU/RAM usage, request counts.|**Prometheus & Grafana**|
|**Logs**|**The Incident Reports:** A written record of every time a door opened or a register crashed.|**Text Records:** System events and application "stdout" messages.|**ELK Stack / Loki**|
|**Traces**|**The Follow-the-Customer:** Watching a single customer walk from the Gate to the Food Court.|**End-to-End Path:** Tracking one request through multiple microservices.|**Jaeger & Zipkin**|
---
### 6.6.2 Monitoring vs. Observability
  - **Monitoring (The Security Guard):** Watches for "Known Problems."
    - Analogy: "Is the front door locked?"
    - K8s: `kubectl get pods` (Is it running?)
  - **Observability (The Private Investigator):** Asks "Unknown Questions" about complex patterns.
    - Analogy: "Why do customers leave whenever the elevator makes a squeaking sound?"
    - K8s: "Why does the app slow down only when the database is performing a backup?"
---
### 6.6.3 The "Control Room" Toolset
To run a professional mall, you hire specialized teams for each pillar:

- 1. **Prometheus & Grafana:** The **Metric Gauges**. Prometheus collects the numbers (the "scrapers"), and Grafana puts them on beautiful TV screens in the control room.<img src="image-11.png" alt="Data Warehouse Architecture" height="35%" width="35%" />
- 2. **Loki / ELK Stack:** The **Library**. These tools store every "Log" (incident report) so you can search through them to find out what went wrong.
- 3. **Jaeger:** The **GPS Tracker**. It shows you exactly which "Hallway" (service communication) is causing a delay.
---
**Integration Note**

> **Section Connection:** In **Section 6.5**, we learned that the **Service Mesh** (Istio) acts as the "Security Escort" that creates these Logs, Metrics, and Traces. **Section 6.6** is the "Control Room" where we actually visualize that data.

---
### 6.6.4 The Heartbeat Monitor (Health Endpoints)
In the mall, a store might look open from the outside, but inside, the staff might be incapacitated or the registers broken. To avoid sending customers to a "zombie" store, we use **Health Endpoints**.

If Observability (6.6.1–6.6.3) is the "Control Room" with fancy TV screens, then **Section 6.6.4 (Health Probes)** is the **Heartbeat Monitor** on each store's door.

---
**The "Are You Okay?" Check**
A health endpoint is a specific door (URL path) that only returns a simple "OK" if everything inside is working.

  - **The /healthz Standard:** Most professional shops are programmed to provide a /healthz door. If the manager knocks and hears "OK," the shop is healthy.

  - **The API Server Check:** Even the **Mall Management Office (kube-apiserver)** has these doors to prove it hasn't collapsed.

  **The Three Types of Heartbeats**
  Kubernetes checks the Management Office using three specific signals:
  |ENDPOINT|MALL ANALOGY|WHAT IT TELLS THE MANAGER|
  |--|--|--|
  |`/healthz`|**General Health**|"Is the store generally functioning?"|
  |`/livez`|**The Pulse**|"Is anyone actually inside the building, or should we restart the shift?"|
  |`/readyz`|**The Open Sign**|"Are the shelves stocked and is the register ready to take customers?"|

---
**Lab: Checking the Mall Manager's Pulse**
You can manually check the health of the Kubernetes API server using `curl`. Since the API server uses a secure connection (HTTPS) with a self-signed certificate in Minikube, we use the `-k` (insecure) flag to bypass the certificate check.

```Bash
# 1. Ask the Mall Manager if they are healthy
curl -k https://$(minikube ip):8443/healthz
# Result: ok

# 2. What happens if you knock on a door that doesn't exist?
curl -k https://$(minikube ip):8443/bogus
```
> **Security Note:** If you try to access a "bogus" door, the Manager will stop you. You’ll see a 403 Forbidden error because system:anonymous (a random person off the street) isn't allowed to poke around the Manager's private files.

Applying this to your Apps
Just like the API server, your Nginx or Python apps should have these "Pulse Check" paths.

  - **In Task 5 (Probes)**, we use these endpoints to tell Kubernetes: "<i>If /livez doesn't say OK, fire the staff and restart the Pod (Liveness Probe).</i>"

---
**Final Integration Tip**

-  **Section Connection:** 
  While **Prometheus (6.6.3)** watches the mall's "Blood Pressure" (Metrics), these **Health Endpoints (6.6.4)** are the immediate "Pulse Checks" used by the **Manager (Kubelet)** to decide if a worker needs to be replaced right now.

---
<h2 id="section-6-7-0">🐤 6.7 Lab: Canary Deployments (The "New Recipe" Test)</h2>

In the Kubernetes "Mall," a **Canary Deployment** is like testing a new recipe by opening a small pop-up stand next to your established restaurant. You see if customers like the new flavor before you renovate the whole building.

## Lab: Using Canary Deployments
This lab demonstrates how to use the **Canary** upgrade strategy to replace an old version of an application with a newer version by utilizing shared labels and a single Service.

---

### 1. Lab Objectives
* **Run an Nginx Deployment (v1.14)** with 3 replicas.
* **Use a ConfigMap** to provide a specific `index.html`.
* **Deploy a "Canary" version (latest)** with a different ConfigMap.
* **Verify the traffic split** between versions.
* **Complete the transition** by removing the old version.

---

### 2. Phase 1: Deploying the Old Version

**Step 1: Create the Local Content**
```bash
echo "welcome to the old version" > index.html
```

**Step 2: Create the ConfigMap**
```
kubectl create cm oldversion --from-file=index.html
```
**Step 3: Create the Deployment (old-nginx.yaml)**

Define a deployment with the label `type: canary` and mount the `oldversion` ConfigMap to `/usr/share/nginx/html`.
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: old-nginx
    type: canary
  name: old-nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: old-nginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: old-nginx
        type: canary
    spec:
      containers:
      - image: nginx:1.14
        name: nginx
        resources: {}
        volumeMounts: 
        - name: indexfile
          mountPath: /usr/share/nginx/html
      volumes:
      - name: indexfile
        configMap:
          name: oldversion
status: {}
```
**Apply the deployment:**
```
kubectl apply -f old-nginx.yaml
```
**Step 4: Expose the Service**
```
kubectl expose deployment old-nginx --name=canary-svc --port=80 --target-port=80 --selector=type=canary
```
### 3. Phase 2: Deploying the Canary (New Version)
**Step 1: Create the New Content & ConfigMap**
```
echo "welcome to the new version" > index.html
kubectl create cm newversion --from-file=index.html
```
**Step 2: Create the New Deployment (new-nginx.yaml)**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: new-nginx
    type: canary
  name: new-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: new-nginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: new-nginx
        type: canary
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        resources: {}
        volumeMounts:
        - name: indexfile
          mountPath: /usr/share/nginx/html
      volumes:
      - name: indexfile
        configMap:
          name: newversion
status: {}
```
**Apply the canary deployment:**
```
kubectl apply -f new-nginx.yaml
```
### 4. Phase 3: Traffic Verification
**Step 1: Get the Service IP**
```
kubectl get svc canary-svc
# NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
# canary-svc   ClusterIP   10.111.0.65    <none>        80/TCP    21m
```
**Step 2: SSH and Run Test Loop**
```
minikube ssh
docker@minikube:~$ while true; do curl -s 10.111.0.65; sleep 1; done
```
**Expected Result:** Roughly 75% "old version" and 25% "new version".
### 5. Phase 4: Finalizing the Rollout
**Step 1: Scale the New Version**
```
kubectl scale deployment new-nginx --replicas=3
```
**Step 2: Delete the Old Version**
```
kubectl delete deployment old-nginx
```
**Final Verification:** All traffic returns "welcome to the new version".
### Summary Table
|Resource|Old Component|New Component|
|-|-|-|
|ConfigMap|oldversion|newversion|
|Image|nginx:1.14|nginx:latest|
|Service Label|type: canary|type: canary|
|Count|3 Replicas|3 Replicas|
---

### 7.0 The Chronicles of the Central Mall: The Full Narrative
**Chapter 1: The Architect’s Blueprint (Control Plane & GitOps)**
Our story begins in a digital vault where the **Robotic Architect (GitOps Operator)** sits. It doesn't build with hammers; it builds with **Blueprints (Git)**. When the business owner updates a file in the vault, the Architect instantly wakes up.

It carries the new plans to the **Management Office (kube-apiserver)**. At the **Front Desk (The API)**, the request is validated. "Is this permit valid? Is the user authorized?" Once the clerk stamps the document, the details are etched into the **Mall Ledger (etcd)**, the single source of truth. If it isn’t in the Ledger, it doesn't exist in the mall.

---
**Chapter 2: Establishing the Workforce (Deployments & Pods)**
The Ledger now says a "Jewelry Store" must exist with 3 staff members. The **Store Manager (Deployment)** sees this and begins hiring. The Manager doesn't just hire once; they are a **Control Loop**. If a **Worker (Pod)** gets sick and leaves the floor, the Manager detects the vacancy in the Ledger and hires a replacement immediately to maintain the "Desired State."

But these workers are "stateless", they come and go. To give them a stable identity, the Manager uses **Stable Store Signage (Service/ClusterIP)**. Now, even if the individual workers change, other staff members can always find the shop by calling the same internal extension.

---
**Chapter 3: The Security Clearance (RBAC & ServiceAccounts)**
The workers are on the floor, but they are powerless. They try to look at the **Mall Ledger** to see the delivery schedule, but the **Front Desk** turns them away. "You are just wearing a **Guest Badge (Default ServiceAccount)**," the clerk says.

The Owner must go through the **HR Process (RBAC)**.
  1. They define a **Job Description (Role)**: "Authorized to view delivery schedules."
  2. They issue an **HR Assignment Letter (RoleBinding)**.
  3. This letter clips the **Automated Employee ID (Custom ServiceAccount)** to the Job Description.
  
Suddenly, the worker’s badge flashes green. They can now talk to Management. However, the **Security Team** also enforces **Worker Safety & Conduct (SecurityContext)**. One worker tries to use a "Master Key" (**Root access**), but the **Security Guard** blocks them because the permit says: `runAsNonRoot`: true.

**The ServiceAccount** and **SecurityContext** work together like this:
1. **The ServiceAccount: "The Green Light" (Permissions)**
When the worker’s badge "flashes green," it means the **ServiceAccount** (their ID badge) has been recognized by the **Management Office (API Server)** because of an **HR Assignment Letter (RoleBinding)**.
  - **The Logic:** This gives the worker permission to go to the Front Desk and ask questions like, "Can I see the delivery schedule?" or "Who else is working today?"
  - **In K8s:** This allows the Pod to make successful API calls to the Kubernetes API server.

1. **The SecurityContext: "The Conduct Rules" (Behavior)**
Even if a worker has a badge that lets them talk to **Management**, they still have to follow the **Mall Safety Rules**. This is the **SecurityContext**.
  - **The "Master Key" (Root Access):** By default, some workers (containers) try to start their shift with a "Master Key" (running as the `root` user). This gives them the power to change anything inside their own shop, or even try to mess with the mall's structure.
  - **The Enforcement:** The **Security Guard** checks the worker's permit. If the permit says `runAsNonRoot: true`, the guard physically stops the worker at the door if they are holding that Master Key.
  - **The Result:** The worker isn't even allowed to start their shift. In your terminal, you’ll see the Pod stuck in `CreateContainerConfigError` or failing to start.
---
**The Comparison Table**
|Feature|Concept|Mall Analogy|What it controls|
|--|--|--|--|
|**ServiceAccount**|**Authorization**|The Badge Clearance|What the worker can **ask Management to do**.|
|**SecurityContext**|**Security/Safety**|The Code of Conduct|How the worker **behaves inside the building**.|

---
**Chapter 4: Logistics and the Shared Vault (Storage & Config)**
A store needs more than just people; it needs gear and data.
  - **The Shared Locker:** The Owner puts the store's "Daily Specials" in a **Public Bulletin Board (ConfigMap)** and the "Safe Combination" in a **Locked Box (Secret)**. The workers "mount" these onto their desks to read them.
  - **The Permanent Safe:** The workers need to store real diamonds. They fill out a **Locker Request Form (PVC)**. The **Logistics Team (StorageClass)** sees this and automatically builds a **Permanent Safe (PersistentVolume)** in the basement.
 
Even if the building is demolished and rebuilt, the **Safe** remains bolted to the floor, waiting for the next worker to pick up where the last one left off. This is the **StatefulSet**, a high-security wing where every worker has a permanent desk and a permanent safe.

---
**Chapter 5: Opening the Gates (Ingress & Gateway API)**
The mall is running, but the customers are stuck outside.
1. The customer looks at their **GPS** (`/etc/hosts`) to find `jewelry.mall.com`.
2. They arrive at the **Physical Transit Hub (The Gateway)**.
3. The **Main Gate Guard (Ingress Controller)** reads the **Signage (HTTPRoute)**. "Jewelry? That's the `task7svc` storefront."
4. The Guard checks the **Digital Staff List (EndpointSlice)**. "Worker #3 is free. Go to counter 3."

--- 
**Chapter 6: The Modern Upgrade (Canary & Helm)**
The mall is old, so the Owner uses **Helm (The Package Manager)** to install a pre-built "Food Court" kit. They don't want to risk a total shutdown, so they perform a **Canary Test (The New Recipe)**.

They hire a few "Modern Chefs" and update the **Signage (HTTPRoute)** to send 10% of customers to them. When the Ledger shows that customers love the new food, the Owner uses the **Robotic Architect (GitOps)** to update the blueprints. The old chefs are phased out, and the "Modern Food Court" becomes the new standard.

---
**Chapter 7: The Emergency (Troubleshooting)**
Suddenly, the jewelry store goes dark. The Owner rushes to the **Management Office**.
1. They use their **Security Badge** (`kubeconfig`) to enter.
2. They check the **Ledger**: `kubectl get pods` shows `CrashLoopBackOff`.
3. They use the **Translator (kubectl proxy)** to call the store's internal line directly.
4. They find the problem: The worker ran out of **Electricity (CPU/RAM Limits)**. They update the **Resource Budget** and the mall returns to life. 
---
**The Central Mall Legend**
|Stage|Goal|Key Characters|
|--|--|--|
|**Foundation**|Define the mall|Architect (GitOps), Management Office (API)|
|**Staffing**|Run the apps|Manager (Deployment), Worker (Pod)|
|**Security**|Control access|HR (RoleBinding), Badge (ServiceAccount)|
|**Logistics**|Save the data|Safe (PV), Locker Form (PVC)|
|**Traffic**|Connect users|Guard (Ingress), Signage (HTTPRoute)|
---
# 8.0: Troubleshooting Kubernetes
<h3 id="section-8-0">8.0: Troubleshooting Kubernetes</h3>


## 8.1 Determining a Troubleshooting Strategy
Troubleshooting a cluster requires a structured approach to filter out the noise. When an application fails, follow the **Inside-Out** hierarchy:



### The Troubleshooting Hierarchy
1. **Pod Level:** Check the container status. Is it `Running`, `Pending`, or in `CrashLoopBackOff`?
2. **Access Level:** If the Pod is running, check the **Service**. Are the labels matching? Is the `targetPort` correct?
3. **Node Level:** If many Pods fail, check the **Node**. Is it `Ready`? Is there disk or memory pressure?
4. **Control Plane Level:** Check the **API Server** and **Scheduler**. Are resources being created at all?

---

## 8.1.1 Understanding Pod Startup
To find out *where* a Pod is failing, you must know the sequence of events that happen after a `kubectl apply`.



### The Sequence of Events:
1. **API Server & etcd:** The request is validated and stored in **etcd**.
2. **Scheduler:** The Scheduler notices a new Pod with no `nodeName` and assigns it to a healthy Node.
3. **Kubelet:** The Kubelet on the destination node sees the assignment and starts the **CRI (Container Runtime)**.
4. **Image Pull:** The runtime pulls the image from the registry.
5. **Container Start:** The container is created and the `ENTRYPOINT` command is executed.

---

## 8.1.2 Common Pod Errors
| Error Status | Meaning | Common Fix |
| :--- | :--- | :--- |
| **Pending** | Scheduler cannot find a node. | Check `kubectl describe pod` (usually Insufficient CPU/RAM). |
| **ImagePullBackOff** | Kubelet cannot fetch the image. | Check image name, tag, or registry credentials (Secrets). |
| **CrashLoopBackOff** | Container starts but then exits immediately. | Check `kubectl logs --previous` to see the application crash. |
| **OOMKilled** | Container exceeded its memory limit. | Increase the memory `limits` in the YAML. |
| **CreateContainerConfigError** | Missing ConfigMap or Secret. | Ensure the referenced ConfigMap/Secret exists. |


<h2 id="section-8-2-0">8.2.0 Analyzing Failing Applications</h2>

When an application fails, it leaves a trail of clues in its **State** and **Exit Code**.

### 1. Understanding Pod States
In its lifetime, a Pod will go through different states:

* **Pending:** The API accepted the Pod, but it can't be scheduled (e.g., no node has enough RAM).
* **Running:** The Pod is bound to a node and containers are created.
* **Completed:** The container finished its job successfully (Exit Code 0).
* **Failed:** The container finished but something went wrong (Exit Code non-zero).
* **CrashLoopBackOff:** The container is failing repeatedly, and K8s is waiting before trying again.
* **Unknown:** The API server can't talk to the Kubelet on the Pod's node.

---

### 2. The Detective's Toolkit (Investigation Steps)

#### Step 1: Check the Status
```bash
kubectl get pods
```
Look for `RESTARTS` and `STATUS`. A high restart count combined with `CrashLoopBackOff` is a major red flag.

#### Step 2: Investigate with Describe

```bash
kubectl describe pod <pod-name>
```

- <b>Events:</b> Look at the bottom. This tells the "story" of the failure (e.g., `FailedScheduling`, `Back-off restarting failed container`).

- <b>Containers State:</b> Look for the `Last State`.

  - <b>Exit Code 0:</b> The app finished its work and closed (Normal for a Job, Bad for a Web Server).

  - <b>Exit Code 1-255:</b> The app crashed. You must check the logs.

#### Step 3: Inspect the Logs
If the exit code is not 0, the problem is inside the application code or configuration.

```Bash
# Check current logs
kubectl logs <pod-name>

# Check logs from the PREVIOUS (crashed) instance
kubectl logs <pod-name> --previous
```

#### 3. Demo Recap: Failure Case Studies
#### Case A: The "Instant Exit" (Busybox)
<b>Command:</b> `kubectl create deploy failure1 --image=busybox`
- <b>Result:</b> `CrashLoopBackOff`.
- <b>Reason:</b> Busybox's default entrypoint is a shell. Since there is no interactive command, the shell finishes immediately.
- <b>Fix:</b> Give it a long-running task: `kubectl create deploy failure1 --image=busybox -- sleep 3600`.
#### Case B: The "Missing Config" (MariaDB)
<b>Command:</b> `kubectl create deploy failure2 --image=mariadb`
- <b>Result:</b> CrashLoopBackOff.
- <b>Investigation:</b> kubectl logs <pod-name>
- <b>Discovery:</b> The logs show: `[ERROR] You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD or MYSQL_RANDOM_ROOT_PASSWORD`.
- <b>Fix:</b> Add the required environment variables via a ConfigMap or Secret.

#### Summary Troubleshooting Workflow
|Step|Command|Goal|
|-|-|-|
|1|`kubectl get pods`|Find the failing Pod and check Restart count.|
|2|`kubectl describe pod`|Check <b>Events</b> and <b>Exit Codes</b>.
|3|`kubectl logs --previous`|Read the application's "death certificate" (Error messages).|
---

<h2 id="section-8-3">8.3 Analyzing Pod Access Problems</h2>

If your Pod is `Running` and `Ready` but you cannot reach it, the issue lies in the **Network Plumbing**.

### 1. Understanding Services (The Load Balancer)
A Service uses a **Selector** to find Pods. If the Selector doesn't perfectly match the Pod's **Labels**, the Service will have no "Endpoints."

**The Golden Rule of Connectivity:**
For traffic to flow, the string in `service.spec.selector` **must exactly match** the string in `pod.metadata.labels`. Case sensitivity and spelling count!

**Diagnostic Checklist:**
* **Labels:** Run `kubectl get pods --show-labels`. Does it match the service selector?
* **Endpoints:** Run `kubectl get endpoints <svc-name>`. If it says `<none>`, your selector is wrong.
* **Target Port:** Ensure the `targetPort` in the Service matches the `containerPort` of the Pod.

### 2. Understanding Ingress (The External Entry)
Ingress relies on a Service to forward traffic.
* **Ingress Controller:** Must be running (e.g., NGINX Ingress Controller).
* **Path Matching:** Ensure your `path` and `serviceName` in the Ingress YAML are correct.



### 3. Understanding NetworkPolicies (The Firewall)
NetworkPolicies are "Default Allow" unless a policy selects a Pod. Once a Pod is selected, it becomes "Default Deny" for everything not explicitly allowed.

**Key Troubleshooting Tips:**
* **Isolation:** If a policy applies to a Pod, all traffic is blocked unless a rule allows it.
* **Add-on Support:** Not all Network add-ons support NetworkPolicy (e.g., **Flannel** does NOT, **Calico** DOES).
* **Check Existence:** Use `kubectl get netpol -A` to see if a policy is silently blocking your traffic.

---

### 4. Demo: Troubleshooting a Broken Service

Follow this flow to see how changing a label "breaks" access.

**Step 1: Create and Expose a Deployment**
```bash
kubectl create deploy trouble --image=nginx
kubectl expose deploy trouble --port=80 --type=NodePort
```

**Step 2: Verify Initial Access**
```Bash
# Get the endpoints (should show the Pod IP)
kubectl get endpoints trouble

# Get the NodePort
kubectl get svc trouble

# Test access (should work)
curl $(minikube ip):<NODEPORT>
```
**Step 3: Break the Connection**
Edit the Service and change the selector label to something non-existent (e.g., `app: wrong`).
```Bash
kubectl edit svc trouble
```
**Step 4: Verify the Failure**
```Bash
# Endpoints will now be <none>
kubectl get endpoints trouble

# Access will fail/timeout
curl $(minikube ip):<NODEPORT>
```

<h2 id="section-8-4">8.4 The Network Add-on (The Engine)</h2>

The <b>CNI (Container Network Interface)</b> is the engine under the hood.
- <b>Flannel:</b> Simple, but no NetworkPolicy support.
- <b>Calico:</b> High performance, supports NetworkPolicy and Ingress integration. <b>(Recommended for CKAD labs)</b>.
  
#### Summary Troubleshooting Workflow for Access
|Problem|Action|Command|
|-|-|-|
|No Endpoints|Check Selector/Labels|`kubectl get pods --show-labels`|
|Connection Refused|Check Container Port|`kubectl describe pod`|
|Connection Timeout|Check Network Policies|`kubectl get netpol -A`|
|Ingress 404|Check Ingress Rules|`kubectl describe ingress`|

<h2 id="section-8-4">8.4 Monitoring Cluster Event Logs</h2>

If `kubectl logs` shows nothing, you need to check the **Cluster Events**. Events are the "Security Cameras" of the mall, they record every movement, successful or failed, of the Kubernetes components.



1. The Global View
When you aren't sure which resource is failing, check the events for the entire namespace:
```bash
# General overview
kubectl get events #--sort-by='.lastTimestamp'|`.source.component`|`.involvedObject.name`|`.type` 

# Detailed overview (shows nodes and exact times)
kubectl get events -o wide
```

2. Filtering for "Crime Scenes"The event log can be noisy. To find actual problems quickly, filter for Warnings:
```Bash
kubectl get events | grep Warning
```
<b>Common Warning:</b> `Back-off restarting failed container` (This confirms a `CrashLoopBackOff`).
<b>Common Warning:</b> `FailedScheduling` (This confirms the Pod is stuck in `Pending` due to lack of resources).

3. Resource-Specific InvestigationWhile get events is great for a global view, if you already know which "Shop" (Pod/Node) is having trouble, use describe.Checking the Worker (Pod)
```Bash
kubectl describe pod <pod-name>
```

The events at the bottom will tell you exactly when the image was pulled and when the container started or failed.Checking the Foundation (Node)If multiple Pods are failing, the issue might be the Node itself (the "Mall Floor"):
```Bash
kubectl describe nodes minikube
```

Look for Conditions like MemoryPressure, DiskPressure, or PIDPressure. If these are True, the node is unhealthy.

<h2 id="section-8-5">8.5 Troubleshooting Summary: The Detective's Checklist</h2>

|Tool|Analogous To...|Best Used When...|
|-|-|-|
|kubectl logs|Interviewing the Worker|The Pod is running but the app inside is crashing.|
|kubectl get events|Security Camera Footage|You don't know which resource is causing the problem.|
|kubectl describe|Reading the Incident Report|You know the specific Pod/Node that is broken.|
|kubectl get endpoints|Checking the Guest List|The Pod is healthy but the Service can't find it.|

<h2 id="section-8-7">8.7 Troubleshooting Authentication Problems</h2>

If you cannot talk to the cluster at all, or if you get "Permission Denied" errors, the problem lies in your **Credentials** or **Permissions**.



### 1. The Kubeconfig File (The Master Key)
Access to the cluster is managed via the `~/.kube/config` file. 
* This file contains the API Server address, your certificates, and your current "context" (which mall you are visiting).
* In a standard setup, this is a copy of `/etc/kubernetes/admin.conf` from the Control Plane.

**Diagnostic Commands:**
```bash
# View your current keys and active cluster
kubectl config view

# Switch to a different context/user if you have multiple
kubectl config use-context <context-name>
```
### 2. Authorization: "What can I do?"
Once you are inside the mall, <b>RBAC (Role-Based Access Control)</b> determines which shops you can enter. While configuring RBAC isn't on the CKAD, <b>testing</b> your access is.

<b>The "Can-I" Command:</b> Use this to check if your current user has the "keys" to perform a specific action:

```Bash

# Check if you can create pods
kubectl auth can-i create pods

# Check if you can delete services in a specific namespace
kubectl auth can-i delete svc -n production
```
### 3. Demo: Recovering a Lost Key (Minikube)
If your `~/.kube/config` is deleted or corrupted, you can recover it from the Minikube node. Think of this as getting a master key copy from the Mall Manager's office.

Recovery Flow:

1. SSH into the Node: `minikube ssh`

2. Locate the Admin Config: The master copy is at `/etc/kubernetes/admin.conf`.

3. Move to Temporary Space:

```Bash
sudo cp /etc/kubernetes/admin.conf /tmp/admin.conf
sudo chmod 644 /tmp/admin.conf
```
4. Exit and Copy to Local Machine:

```Bash
scp -i $(minikube ssh-key) docker@$(minikube ip):/tmp/admin.conf ~/.kube/config
```
## 8.6 Using Probes (Health Checks)
#### 1. Understanding the Three Probe Types
Probes allow Kubernetes to perform "Self-Healing" by checking if your app is actually working, not just "running.". Probes are defined in pods.spec.containers.

- **Liveness Probe:** "Is the app alive?" If it fails, Kubernetes **restarts** the container.
- **Readiness Probe:** "Is the app ready for traffic?" If it fails, the Pod is **removed from the Service** until it becomes healthy again.
- **Startup Probe:** Used for slow-starting legacy apps. It disables liveness/readiness checks until the app is fully initialized.

#### 2. Probe Mechanisms (The "How")You can perform these checks using three methods:

|Method|Description|Example Use Case|
|-|-|-|
|exec|Runs a command inside the container. Success = exit code 0.|Checking if a specific file exists (like /tmp/ready).|
|httpGet|Performs an HTTP GET request. Success = 200-399.|Checking an /healthz or /readyz API endpoint.|
|tcpSocket|Checks if a TCP port is open.|Checking if a database or Nginx port (80) is listening.|

#### 3. Rebuilding the "Busybox-Ready" Demo
The lesson shows why a Pod might stay in 0/1 READY state even if it is Running.

##### Step A: The Manifest (`busybox-ready.yaml`)
```YAML

apiVersion: v1
kind: Pod
metadata:
  name: busybox-ready
spec:
  containers:
  - name: busybox
    image: busybox
    args: ['sh', '-c', 'sleep 3600']
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/nothing
      initialDelaySeconds: 5
      periodSeconds: 10
```
##### Step B: The Execution Flow
1. <b>Create:</b> `kubectl create -f busybox-ready.yaml`

2. <b>The Problem:</b> Running `kubectl get pods` shows `READY 0/1`.

     - Why? The probe is looking for `/tmp/nothing`, which doesn't exist yet.

3. <b>The Attempted Fix (Edit):</b> Running `kubectl edit pod busybox-ready` to change the path to `/etc/hosts` <b>fails</b>.

     - <i>Note:</i> Most probe parameters cannot be edited on a live Pod; you usually have to delete and recreate it.

4. <b>The Manual Fix:</b>

```Bash

kubectl exec busybox-ready -- touch /tmp/nothing
```
<b>The Result:</b> After a few seconds (defined by `periodSeconds`), `kubectl get pods` will show `1/1 READY`.

#### 4. Applying this to your Lab
In the <b>Nginx Canary transition</b>, you should add a Readiness probe to your Nginx Deployment. This prevents the "Canary" from receiving traffic if the ConfigMap isn't mounted correctly or the index.html is missing.

<b>Try this for your Nginx manifest:</b>

```YAML
readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 2
  periodSeconds: 5
```
---

## 8.6.1 Liveness Probe Lab 
Create a Busybox Pod that runs sleep 3600. Configure a Liveness Probe that checks if the file /etc/hosts exists.

**Step 1: Create the Manifest**
We use /etc/hosts because that file is created automatically by Kubernetes, so the probe should always succeed.

`vim livenessprobe.yaml`
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: busybox-probe-lab
  labels:
    test: liveness
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - /bin/sh
    - -c
    - sleep 3600
    livenessProbe:
      exec:
        command:
        - cat
        - /etc/hosts
      initialDelaySeconds: 5
      periodSeconds: 5
```
#### 1. Understanding the "Exec" Mechanism
When you define an `exec` probe, the Kubelet "reaches into" the container and runs the command you specified.

  - <b>InitialDelaySeconds (5):</b> The Kubelet waits 5 seconds after the container starts before doing the first check.
  
  - <b>PeriodSeconds (5):</b> The Kubelet repeats the check every 5 seconds.
  
  - <b>Success:</b> If `cat /etc/hosts` returns exit code 0, the Pod stays `Running`.
  
  - <b>Failure:</b> If the file were missing, the command would return a non-zero exit code, and the Kubelet would kill and restart the container.

#### 3. Execution & Verification
Follow these commands to verify the lab results:

**1. Apply the manifest:**

```Bash

kubectl apply -f livenessprobe.yaml
```
**2. Check the status:**

```Bash

kubectl get pods busybox-probe-lab
```
You should see `STATUS: Running` and `RESTARTS: 0`.

**3. Describe the Pod to see the Probe activity:**

```Bash

kubectl describe pod busybox-probe-lab
```
<i>Look at the "Events" section at the bottom. You should see no "Unhealthy" warnings.</i>

#### 4. Troubleshooting Scenario
**Let's simulate a failure in the lab:** If you want to see the probe actually work/fail, you can edit your YAML to look for a non-existent file:

```YAML

      exec:
        command:
        - cat
        - /tmp/nonexistent-file
```
After applying this, run `kubectl get pods -w`. You will eventually see the **RESTARTS** count increase because the Liveness probe is failing and forcing a restart.

## Essential Troubleshooting Toolkit
Use these commands in order when a problem arises:

```bash
# 1. Check high-level status
kubectl get pods

# 2. Look at the "History" of the Pod (Events are at the bottom)
kubectl describe pod <pod-name>

# 3. See current application logs
kubectl logs <pod-name>

# 4. See logs from the container that just crashed
kubectl logs <pod-name> --previous

# 5. Check Service-to-Pod connectivity
kubectl get endpoints <service-name>
```
## 9.0 Sample CKAD Exam Flow
The Final Simulation (CKAD Sample Exam)
The Sample Exam is designed to test your "Muscle Memory." In the real CKAD, you won't have time to look up every command. You need to know which tool to grab from your belt immediately.

## 9.1 The Exam Strategy: "Triage"
Just like a busy Mall Manager during a holiday rush, you must prioritize your tasks:
1. **Fast Wins First:** Tackle simple Pod creations and ConfigMaps first.
2. **The 10-Minute Rule:** If a Troubleshooting task (like a broken Service) takes more than 10 minutes, skip it and come back.
3. **Context is King:** Always check which cluster and namespace you are in using `kubectl config set-context --current --namespace=...`.

## 9.2 Core Competency Checklist
Before starting the sample exam, ensure you can perform these "Reflex Actions":
|Domain|Key Action|Command Reflex|
|-|-|-|
|Storage|Mount an `emptyDir` or `PVC`.|`k run ... --dry-run=client -o yaml` then edit volumes.|
|Deployments|Perform a Rolling Update/Undo.|`k rollout undo deployment/<name>`|
|Networking|Create a Service for a Pod.|`k expose pod <name> --port=80 --target-port=8080`|
|Security|Check permissions.|`k auth can-i create secrets --as system:serviceaccount:default:mysa`|
Troubleshooting|Find why a Pod is failing.|`k get events --sort-by='.lastTimestamp'`|

---

## 10.0 The Final Simulation
This section transforms your knowledge into **Muscle Memory**. The exam isn't just about knowing Kubernetes; it's about navigating the mall under a 2-hour time limit.

### 10.1 The Environment Setup
To replicate the exam, you must clear the "Mall Floor":
1. **Reset:** `minikube delete`
2. **CNI Support:** `minikube start --cni=calico` (Essential for Task 8: NetworkPolicy).
3. **Verification:** `minikube status` should show "Running" and "Configured."

### 10.2 Task Themes & "Mall Manager" Focus
The exam covers 15 critical tasks that test your ability to build and fix components quickly:

* **Infrastructure:** Namespaces, Resource Quotas, and ServiceAccounts.
* **Application Design:** Sidecars, Liveness Probes, and multi-container Pods.
* **Networking:** Ingress routing, NetworkPolicy firewalls, and Service exposure.
* **Storage:** HostPath mounts and Persistent Volumes.
* **Advanced Deployment:** Canary 80/20 splits and Rolling Update tuning (`maxSurge`).

|Task|	Topic|	Key Goal|
|-|-|-|
|1	|Namespaces & Secrets|	Create namespace Indiana, Pod inpod, and Secret insecret.|
|2	|Label Filtering	|Write names of Pods with tier=control-plane to /tmp/task2pods.|
|3	|ConfigMaps	|Mount an index.html via ConfigMap to /usr/share/nginx/html/.|
|4	|Sidecars	|Pod sidepod with Nginx + a container running sleep 15.|
|5	|Probes	|Busybox Pod with a Liveness Probe checking the K8s Service.|
|6	|Deployments|	Rolling update (50% surge/available) -> Update -> Rollback.|
|7	|Ingress	|Expose via Service + Ingress for host myapp.info.|
|8	|NetworkPolicy|	Only allow Pods with type=tester to access type=webapp.|
|9	|Storage |(HostPath)	Mount Minikube's /webapp to Pod; expose via NodePort 32032.|
|10|	Helm	|Install bitnami/mysql chart.|
|11|	Resources|	Set Memory Request 64MiB and Limit 128MiB in namespace nebraska.|
|12|	Canary	|80/20 traffic split between oldbird and newbird using labels.|
|13|	SecurityContext|	No privilege escalation + Supplemental GID 2000.|
|14|	Docker/OCI	|Build image myapp:1.0 and export to /tmp/myapp.tar.|
|15|	ServiceAccounts|	Create SA secure and link it to Pod securepod in oklahoma.|
---
### 10.2.1 
This specific task is a classic CKAD challenge because it tests your ability to manage **Namespaces**, **Secrets**, and **Pod Environment Variables** all in one go.

# Task 1 - Namespaces & Secrets
  1. **Create the Namespace**
```Bash
kubectl create ns indiana
```
  2. **Create the Secret**

Create it directly from the command line.
```Bash
kubectl create secret generic insecret --from-literal=COLOR=blue -n indiana
```

  3. **Create the Deployment (Imperative)**
Create the deployment without a YAML file first.

```Bash
kubectl create deploy indeploy --image=nginx:latest -n indiana
```

  4. **Attach the Secret (The "Fast" Way)**
Instead of opening vim and typing out valueFrom and secretKeyRef, use this single command:

```Bash
kubectl set env --from=secret/insecret deployment/indeploy -n indiana
```
**What this does:** It automatically updates the Deployment's template. Kubernetes will trigger a rolling update, and every new Pod will now have the environment variables from that Secret.

**How to Verify (Fast)**
Don't waste time opening a shell (exec) unless the task specifically asks you to. You can verify the configuration has been applied to the deployment directly:

```Bash
kubectl describe deploy indeploy -n indiana | grep -A 5 Environment
```
<i>You should see `COLOR` sourced from `insecret`.</i>

To verify that your Pod is actually using the Secret to define the variable, you need to check **inside** the running container. While kubectl describe shows that the link exists, only exec proves the value is there.

Run this command to print the environment variable directly from the container's shell:

```Bash
kubectl exec -n indiana pod/indeploy-7dd88896fb-hlpdj -- printenv COLOR
```
**Expected Output:** `blue`

---

# Task 2 - Label Filtering
This task tests your ability to filter resources and manipulate text output, which is a frequent requirement in the CKAD exam.

Here the quickest way:
```shell
kubectl get pods -A -l tier=control-plane --no-headers  | awk '{print $2}' > /tmp/task2pods
```
---
# Task 3 - ConfigMaps
This task is a classic CKAD objective: Decoupling configuration from the application.

**Step A: Create the File and CM**
```Bash
echo "welcome to the task 3 webserver" > index.html
kubectl create cm task3cm --from-file=index.html
```
**Step B: Generate the Pod YAML (The "Dry-Run" Trick)**
Don't copy-paste from the web if you can avoid it. Use this:

```Bash
kubectl run oregonpod --image=nginx:latest --dry-run=client -o yaml > task3.yaml
```
**Step C: Quick Edit**
Open `task3.yaml` and add the `volumes` and `volumeMounts`. **Note:** Ensure you mount to the exact directory Nginx uses for its default page.

**2. Refined YAML (The Final Result)**
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: oregonpod
spec:
  containers:
  - name: nginx-container
    image: nginx:latest
    volumeMounts:
    - name: config-volume
      mountPath: /usr/share/nginx/html  # This replaces the default index.html
  volumes:
  - name: config-volume
    configMap:
      name: task3cm
```
**3. The "Gotcha": Directory Overwriting**
In your current YAML, mounting the ConfigMap to `/usr/share/nginx/html` will **hide everything else** in that folder.

  - **Standard Nginx Behavior:** The folder usually contains index.html and 50x.html.

  - **Mount Behavior:** Because you mounted the volume at the **directory** level, the container will only see `index.html` (from your CM). This is fine for this task, but if the exam asks you to "add a file to an existing directory without deleting others," you must use a `subPath`.

**4. Verification (The Last 10% of the Task)**
In the exam, always verify. Since it's a webserver, you can verify from inside the pod:

```Bash
# Verify the file content
kubectl exec oregonpod -- cat /usr/share/nginx/html/index.html

# Verify the webserver is actually serving it
kubectl exec oregonpod -- curl -s localhost
```
---
# Task 4 - 4th Edition of the CKAD: Native Sidecar support
Create a Pod with the name “sidepod”. It should run the nginx:latest image
together with a sidecar container that runs the sleep 15 command.
```shell
kubectl run sidepod --image=nginx:latest --dry-run=client -o yaml > task4.yaml
```
**Pro-Tip for generating this fast:**
Instead of typing it all out, use the `--` flag in `kubectl run`. It separates the image from the command and arguments automatically:

**This command will generate the YAML for you with the correct structure!** It usually puts them all into the `args` field or a single `command` field depending on the K8s version, but it is guaranteed to be valid YAML.
```Bash

kubectl run sidepod --image=nginx:latest --dry-run=client -o yaml -- /bin/sh -c "sleep 15"
```
Edit the yaml and put the sidecar in the initContainers section with restartPolicy: Always, Kubernetes expects it to run forever **(Native Sidecars) **.

Tips: you can copy and fix it from the `kubernetes.io`.
```shell
vim task4.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sidepod
spec:
  containers:
  - image: nginx:latest
    name: sidepod
    resources: {}
  initContainers:
  - name: sidecar
    image: alpine:latest
    restartPolicy: Always
    command: ["/bin/sh", "-c", "sleep 15"]
  restartPolicy: Always
```
After applying, run: `kubectl get pod sidepod -w` (The -w stands for watch).
```shell
k apply -f task4.yaml
```
If you see the Pod stay at `2/2` for 15 seconds and then drop to `1/2`, you have successfully executed the `sleep 15` command as requested.
```
k get pod sidepod -w
```
---
# Task 5 - Probes
Here is exactly how you should build it to satisfy the exam requirements:

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: probepod
  namespace: probes      # Requirement 1: Namespace
spec:
  containers:
  - name: busybox
    image: busybox       # Requirement 2: Image
    args: 
    - /bin/sh
    - -c
    - "sleep infinity"   # Requirement 3: Command
    livenessProbe:       # Requirement 4: Liveness Probe
      httpGet:           # Because the task said "endpoint"
        path: /healthz   # The specific endpoint name
        port: 80         # Standard port for health checks
      initialDelaySeconds: 3
      periodSeconds: 5
```

**1. Create the namespace:**

```Bash
kubectl create ns probes
```
**2. Create the file:** Copy the code above into a file named `task5.yaml`.

**Apply it:**

```Bash
kubectl apply -f task5.yaml
```
**What to expect when you verify:**

If you run `kubectl describe pod probepod -n probes`, you will see that the probe is **failing** (because Busybox isn't a web server).

**Don't worry!** In a CKAD exam, if the instructions say "Configure an HTTP probe for /healthz," you get the points for **configuring it correctly**, even if the application inside the pod isn't actually set up to answer that call. The examiner is testing your **Kubernetes skills**, not your web development skills.

---
# Task 6 - Deployments

**1. Pro-Tip:** The "One-Liner" Creation
**Generate the base:**
```Bash
kubectl create deploy updates --image=nginx:1.17 --replicas=3 
```
**2. Add labels** during creation to save time:
```Bash
# Then add the specific label required:
kubectl label deploy updates type=prod
```
**3. Let's use dry-run to generate the** YAML and then edited it to change image version and add the strategy. This is the safest way. 
```
kubectl create deploy updates --image=nginx:latest --replicas=3 --dry-run=client -o yaml > task6.yaml
```
**4. Edit and adding Strategy**
To add the "Strategy" snippet from the official documentation to your workflow, you can reference the section titled **"Strategy"** under the Deployment concept page.

In the CKAD exam, searching for "Deployment" and then using **Ctrl+F** to find `strategy` is the fastest way to get this exact block.

Copy the right snippet from the **Official Documentation Snippet** on [kubernetes.io](https://www.kubernetes.io/), paste it and apply `task6.yaml`:
```shell
vim task6.yaml
k apply task6.yaml
```
**What about that "Warning"?**
The warning after apply is about the missing annotation happens because you originally created the deployment using kubectl create and are now trying to update it using kubectl apply.

**In the Exam:** You can ignore this warning. It just means Kubernetes is adding a "tracking note" to the deployment so it can manage future changes. It won't stop your deployment from working!

**5. Tracking history**
Before you ran `kubectl rollout undo`, it’s often helpful to see the **Revision History**. If the exam asks you to "rollback to a specific version" (e.g., version 1), you need to know the revision number.

```Bash
kubectl rollout history deploy/updates
```
In the exam you might see `<none>` and wonder if you did something wrong. You didn't! This column only fills up if you use the `--record` flag (which is being deprecated) or if you add an annotation manually.
```bash
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```
**Pro-Tip for the Exam:** If the task asks you to "Record the change," you can add a note like this:
```Bash
kubectl annotate deployment updates kubernetes.io/change-cause="Updating to latest nginx"
```

**6. If you need to go back to a specific revision (like Revision 1):**

```Bash
kubectl rollout undo deploy/updates --to-revision=1
```
**7. Verification Check**
After your rollback, you saw the ReplicaSet hash change back.
  - updates-646bc8d9c9 (The "latest" version) went to 0.
  - updates-5856644c8c (The "1.17" version) went back to 3.

**One Final Verification (The "CKAD Safety Check")**
In the exam, before moving to the next question, always do a quick check to ensure the image is what you expect. Since you rolled back to Revision 1, the image should be **nginx:1.17**.

Run this to be sure:
```Bash
kubectl describe deploy updates | grep Image
```
---
# Task 7 - Ingress, Exposing Applications

## Objectives
- Map a custom domain to the Minikube IP.
- Expose the 'updates' Deployment via a Service.
- Configure Ingress to route external traffic to the Service.

---

## Step 1: Identify the Entry Point (The Mall Address)   
Map the Minikube IP to the domain `myapp.info` so the local machine knows where to send requests.
   
```bash
# Get Minikube IP
minikube ip 

# Add to hosts file (Assuming IP is 192.168.49.2)
sudo vi /etc/hosts
# Add line: 192.168.49.2  myapp.info
```

## Step 2. Create the Storefront (The Service)
Expose the Deployment internally. This creates a stable "Front Door" for the pods.

```Bash
kubectl expose deploy updates --name=task7svc --port=80
```

## Step 3. Prepare the Mall (Enable Ingress)
Minikube requires the Ingress addon to be enabled to process Ingress rules.

```Bash
minikube addons enable ingress
```

## Step 4. Create the Directory Rule (The Ingress)
Create the rule that routes `myapp.info` traffic to the `task7svc` Service.

```Bash
kubectl create ing myapp --rule="myapp.info/=task7svc:80"
```

## Step 5a: Verification
Test the full chain: **User -> Ingress -> Service -> Pod**.

```Bash
curl myapp.info
```
## Step 5b: Verification Strategies (The "No-Hosts-File" Way)
In the exam, you don't have time to edit `/etc/hosts`. Use these methods instead:

**Strategy A: The Host Header (Best for Ingress)**
This tells the Ingress controller which "Store" you want without needing DNS.
```Bash
# curl -H "Host: <Domain>" <Ingress_IP>
curl -H "Host: myapp.info" $(minikube ip)
```
<i>Expected Output: HTML source for the Nginx welcome page.</i>

**Strategy B: Internal Pod Test (Best for Service)**
Check if the "Storefront" is working by calling it from another "Store" (Pod) inside the mall.

```Bash
kubectl run test-pod --image=busybox -it --rm -- restart=Never -- wget -q- task7svc
```
**Strategy C: Endpoint Check (The "Quick Look")**
Verify that the Service has successfully found its Pods. If **ENDPOINTS** is empty, the traffic has nowhere to go.
```Bash
kubectl get ep task7svc
```
### CKAD Exam Tip
If the `curl` command returns a **404**, it usually means the Ingress rule is correct, but the **Host Header** doesn't match what you defined in the YAML. Always double-check that `myapp.info` is spelled exactly the same in your rule and your `curl` command.

---
### 3. Key Takeaways for the CKAD Exam

1.  **Ingress Class:** In your lab, Minikube automatically handles the class. In the exam, you might need to add `--class=nginx` to your `kubectl create ing` command if multiple controllers exist.
2.  **Path Types:** When using `kubectl create ing`, the default path type is usually `Prefix`. If the exam asks for an "Exact" match, you'll need to edit the YAML.
3.  **The "Curl" Test:** If `curl myapp.info` fails but `curl <MINIKUBE_IP>` works, the issue is your `/etc/hosts`. If both fail, check `kubectl get pods` to ensure the workers are actually running!
---

# Task 8: Managing NetworkPolicy (The Mall Bouncer)

### 8.1 The Security Guard at the Door (NetworkPolicy)
|CONCEPT|RESOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The VIP Store**|**Pod (nevaginx)**|The High-End Boutique|The application we are trying to protect.|
|**The Store Sign**|	**Service (ClusterIP)**|	The Boutique Signage	| Allows other pods to find the store by name.|
|**The VIP Badge**|**Label (type=tester)**|The "Security Clearance"| Badge|The specific metadata required to pass the security check.|
|**The Bouncer**|**NetworkPolicy**|The Bouncer at the Store Door|The rule that says: "No badge, no entry."|

### 8.2 The "Bouncer" Workflow (Task 8 Walkthrough)
**1. Open the Boutique (Create the Pod)** You started by opening the store and giving it a name.
- **Command:** `kubectl run nevaginx --image=nginx:latest --labels="type=webapp"`
- **Analogy:** You open the "NevaGinx" boutique and give it a "Web App" category sign.

**2. Hang the Store Sign (Create the Service) — CRITICAL STEP** If you don't do this, other pods will get a `bad address` error.

**Command:** `kubectl expose pod nevaginx --port=80`

**Analogy:** You put "NevaGinx" in the Mall Directory so people can look up the room number.

**3. Building & Hiring the Bouncer (Create the NetworkPolicy)** You create the rulebook (YAML) and hire the guard to stand at the door. 

**The YAML Rule:**
```YAML
spec:
  podSelector:
    matchLabels:
      type: webapp  # Target this store
  ingress:
  - from:
    - podSelector:
          type: tester # Only allow this badge
        matchLabels:
```
When building a NetworkPolicy, think of it in three parts: **Who am I protecting?**, **What type of traffic?**, and **Who is allowed in?**

```YAML

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy  # The name of our "Bouncer"
  namespace: default         # The Mall location
spec:
  # 1. WHO AM I PROTECTING? (The Target)
  podSelector:
    matchLabels:
      type: webapp           # Apply this rule to the 'nevaginx' pod
      
  # 2. WHAT DIRECTION?
  policyTypes:
  - Ingress                  # We are controlling "Incoming" traffic
  
  # 3. WHO IS ALLOWED IN? (The Whitelist)
  ingress:
  - from:
    - podSelector:
        matchLabels:
          type: tester       # Only pods with this badge get through
```

**Command:** `kubectl apply -f task8.yaml`

**Analogy:** The Bouncer stands at the "Web App" door with a clipboard: "Only people wearing a **'Tester'** badge can enter."

**CKAD Exam Tip:** If you forget the syntax, use `kubectl explain networkpolicy.spec` to see the fields, and always run kubectl get pod --show-labels to verify your spelling before applying the YAML.

**4. The Shopper Arrives (Create the Tester Pod)** Now you bring in the second worker, but they don't have a badge yet.

**Command:** `kubectl run nevatest --image=busybox -- sleep infinity`

**Analogy:** A shopper named nevatest walks into the mall without a badge.

**5. The Unauthorized Guest (The Initial Failure)** You tried to enter from the nevatest pod, but it didn't have a badge yet.
- **Command:** `kubectl exec -it nevatest -- wget --spider nevaginx`
- **Result:** `download timed out`
- **Analogy:** Because of the Service (Step 2), the shopper finds the door. But because of the Bouncer (Step 3), they are ignored and eventually give up (Timeout).

**6. Handing out the Badge (Labeling the Pod)** You gave the shopper the correct security clearance.
- **Command:** `kubectl label pod nevatest type=tester`
- **Analogy:** You pin a **"Tester"** badge onto the shopper's lapel.

**7. Successful Entry (The Verification)** Now that the badge matches the Bouncer's clipboard, the connection is allowed.
- **Command:** `kubectl exec -it nevatest -- wget --spider nevaginx`
- **Result:** `remote file exists`
- **Analogy:** The Bouncer sees the "Tester" badge, steps aside, and lets the shopper into the boutique.

### Troubleshooting Cheat Sheet
|IF YOU SEE...|IT MEANS...|ANALOGY|
|-|-|-|
|bad address|**Missing Service**. The name doesn't exist.|The store isn't in the Mall Directory.|
|download timed out|**NetworkPolicy is blocking.** The packet was dropped.|The Bouncer is ignoring you.
|connection refused|**Pod is down or wrong port.**|You found the door, but the store is closed.|

---
# Task 9: Using Storage (The Basement Locker)

In our Mall analogy, this is like renting a storage locker in the basement of the mall building and connecting it directly to your store shelf.

## 9.1 The Storage & Side Door Characters
|CONCEPT|RESOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The Basement Locker**|**HostPath**|A storage unit in the building's basement.|Storage located on the actual physical node (host).|
|**The Shelf**|**VolumeMount**|The shelf inside your boutique.|Where the storage is "attached" inside the container.|
|**The Side Door**|**NodePort**|A specific side entrance for the public.|Exposes the service on a specific port (30000-32767) of the Node IP.|

## 9.2 The "Storage" Workflow (Task 9 Walkthrough)
1. **Stocking the Basement (Minikube SSH)** 

    Before the store opens, you put the inventory in the building's basement.

    **- Commands:** 
 
      `minikube ssh`

      `sudo mkdir /webapp`
     
      `sudo sh -c "echo welcome to the store > /webapp/index.html"`
     
      `exit` 
    
    **- Analogy:** You go into the mall's basement, build a crate (`/webapp`), and put a "Welcome" sign inside it.

2. **Building the Store with a Chute (The Pod YAML)** You build your store (`storepod`) and create a "delivery chute" (Volume) that connects your shelf directly to that basement crate.
**How to build this quickly (Exam Strategy):** Search the Kubernetes Documentation for `hostPath` to find a template. Ensure `volumes` and `containers` are siblings under `spec`.

  - **The YAML Build** (`task9.yaml`):

```YAML

apiVersion: v1
kind: Pod
metadata:
  name: storepod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    volumeMounts:
    - name: store-volume
      mountPath: /usr/share/nginx/html # The Shelf
  volumes:
  - name: store-volume
    hostPath:
      path: /webapp # The Basement Locker
```

**Analogy:** You tell the construction crew: "Mount the shelf in the display window (`/usr/share/nginx/html`) so it pulls whatever is in the basement crate (`/webapp`)."

3. **Labeling and Hanging the Side Door (Service & NodePort)** You need a specific entrance so customers can visit using a special port number.

  - **Commands:**
    - ```kubectl apply -f task9.yaml```
    - ```kubectl label pod storepod type=storage``` **(The Badge)**
    - ```kubectl expose pod storepod --port=80``` **(The Sign)**
    - ```kubectl edit svc storepod``` (Changing to ` nodePort: 32032`)

  - **Analogy:** You assign the store a "Storage" category, hang the sign, and then tell the Mall Manager: "I want a special side entrance at Door #32032."

## 9.3 The "Service Edit" Hack
While `kubectl edit` works, generating a file is often safer for complex tasks. Use the **Dry Run** command to create a template instantly:

  - **The Command:**
    ```Bash
    kubectl expose pod storepod --port=80 --type=NodePort --dry-run=client -o yaml > svc.yaml
    ```
    **The Edit:** Open `svc.yaml` and simply add the `nodePort` line:

    ```YAML
    spec:
      ports:
      - port: 80
        protocol: TCP
        targetPort: 80
        nodePort: 32032  # Add this line specifically!
    ```

## 9.4 Pro-Tips for the CKAD Exam
  - **Indentation Check:** YAML is very sensitive. A common mistake is putting the `volumes:` block inside the `containers:` list.
      
      **Remember:** `containers` and `volumes` are **siblings**, they both live directly under the `spec:` key.

  - **Empty Directory / 403 Forbidden:** If you see the default Nginx page or an error, check your `mountPath`. Mounting a volume to `/usr/share/nginx/html` hides the original Nginx files. If your host directory is empty, your store shelf will be empty!

  - **Verification:** Always test your work with `curl $(minikube ip):32032` to ensure the "Welcome" sign is visible from the outside.

---

# Task 10: Using Helm (The Franchise Package)
In our Mall analogy, Helm is the "**Store-in-a-Box**" service. Instead of hiring every contractor yourself to build walls, floors, and wiring, you just call a provider and say, "Send me a fully furnished Pizza Hut," and they deliver the whole thing ready to go.

## 10.1 The Helm Characters
|CONCEPTRE|SOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The Catalog**|**Helm Repo**|A Franchise Directory|A repository containing various pre-configured apps.|
|**The Blueprint**|**Helm Chart**|The Franchise Manual|A bundle of YAML files that define how an app is built.|
|**The Franchise**|**Helm Release**|A specific store location|A specific instance of a chart running in your cluster.|

## 10.2 The "Franchise" Workflow (Task 10 Walkthrough)
1. **Finding the Franchise Provider (Helm Repo Add)** Before you can install a specific store, you have to add the provider to your directory.

  - **Command:** `helm repo add bitnami https://charts.bitnami.com/bitnami`
  - **Analogy:** You add "Bitnami Franchises" to your mall's approved vendor list.
2. **Ordering the Store-in-a-Box (Helm Install)** You order a MySQL "store" and tell the system to give it a name automatically.
**Command:** `helm install bitnami/mysql --generate-name`
**Analogy:** You call Bitnami and say, "Deliver one MySQL store and just give it whatever tracking number (name) is available."
3. **The Grand Opening (Verification)** Because Helm is a "package deal," it doesn't just create a Pod. It creates the Manager (Deployment), the Workers (Pods), and the Signage (Services) all at once.
Command: `kubectl get all`
Result: You see `pod/mysql-xxxxx` and `service/mysql-xxxxx` appearing instantly.
Analogy: You look at the mall map and notice that a fully staffed store with a sign and workers has appeared out of nowhere!

## 10.3 Pro-Tips for Helm in the CKAD Exam
1. **Search First:** If the exam asks for a package but you aren't sure of the name, use `helm search repo mysql`. It's like checking the table of contents in the franchise directory.
2. **Naming:** If the exam asks for a specific name (e.g., "mydb"), the command is `helm install mydb bitnami/mysql`. Only use `--generate-name` if explicitly told to.
3. **The "Init" Status:** In your lab results, you saw `STATUS: Init:0/1`.
  - Analogy: The workers are inside the store setting up the kitchen equipment before they can open for business. Just wait a minute, and it will change to **Running**.

## 10.4 Diagnostic Cheat Sheet for Helm
|COMMAND|ANALOGY|PURPOSE|
|-|-|-|
|`helm list`|"Show all franchises"|See which Helm apps are currently running.|
|`helm uninstall [name]`|"Close the franchise"|Removes every resource (Pods, Services, etc.) created by that chart.|
|`helm status [name]`|"Check store health"|Shows the instructions and connection info for that specific app.|

---

# Task 11: Resource Restrictions (The Lease Agreement)
In our Mall analogy, this is the "**Lease Agreement.**" The Mall Manager (Kubernetes) needs to know how much physical space (Memory/CPU) your store will take up so the building doesn't run out of electricity or floor space.

### 11.1 The Resource Characters
|CONCEPT|RESOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The New Wing**|**Namespace**|A new section of the Mall|A logical partition to group related resources.|
|**The Minimum Rent**|**Requests**|The guaranteed floor space|The minimum amount of resources K8s guarantees to the Pod.|
|**The Maximum SpaceLimits**|**The maximum shop size**|The hard ceiling. If the shop tries to expand past this, it gets shut down.|

### 11.2 The "Resource" Workflow (Task 11 Walkthrough)
1. **Building the New Wing (Create Namespace)** Before opening the store, you define which part of the mall it belongs to.
  - **Command:** `kubectl create ns nebraska`
  - **Analogy:** You open a new wing of the mall called "Nebraska."

2. **Hiring the Manager (Create Deployment)** You hire a manager to run the "Snow" shop in the Nebraska wing.
  - **Command:** `kubectl create deploy snowdeploy -n nebraska --image=nginx`
  - **Analogy:** You hire a manager (`Deployment`) to set up a boutique (`Pod`) in the Nebraska wing.

3. **The "Help" Strategy (Finding the Template)** Instead of typing the command from memory, you used the built-in manual to find a working example.
  - **Action:** `kubectl set resources -h | less`
  - **Analogy:** You check the Mall’s "Standard Lease Terms" book to find the correct phrasing for a space restriction.
  ```
    # Set the resource request and limits for all containers in nginx
    kubectl set resources deployment nginx --limits=cpu=200m,memory=512Mi --requests=cpu=100m,memory=256Mi
  ```

4. **Signing the Lease (Set Resources)** You define exactly how much "power and space" the shop is allowed to use.
  - **Command:** ```kubectl set resources -n nebraska deploy snowdeploy --limits=memory=128Mi --requests=memory=64Mi```
  - **Analogy:** You tell the manager: "You are guaranteed 64sqm of space (`Request`), but under no circumstances can you occupy more than 128sqm (`Limit`)."

### 11.3 Pro-Tips for the CKAD Exam
1. **Don't Type It, Generate It:** Use `kubectl set resources` as you did in the lab. It is much faster and less error-prone than manually editing YAML.
2. **Verify with Describe:** Always check your work with `kubectl describe deploy snowdeploy -n nebraska`. Look for the **Pod Template** section to see if the Limits and Requests were applied correctly.
3. ***The "OOMKilled" Ghost:* * Analogy:** If your store tries to pack in more inventory than the 128Mi limit allows, the Mall Security will suddenly close the shop.
   -  **Kubernetes**: The Pod will crash with an **OOMKilled** (Out Of Memory) error.

### 11.4 Diagnostic Cheat Sheet
|COMMAND|PURPOSE|
|-|-|
|`kubectl top pod -n nebraska`|See how much "electricity" (RAM/CPU) the shop is actually using right now.|
|`kubectl describe node`|See how much total space is left in the entire Mall.|

---
# Task 12: Creating Canary Deployments (The Taste Test)
**The Canary Deployment.** In our Mall analogy, this is the "**Taste Test.**" You aren't ready to change the whole menu yet, so you keep 4 chefs cooking the old recipe and bring in 1 chef cooking the new one. The customers walk up to the same counter and get whichever chef is free.

### 12.1 The Canary Characters
|CONCEPT|RESOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The Aviary**|**Namespace (birds)**|A themed wing of the mall|Isolates the bird shop resources.|
|**The Veteran Staff**|**Deployment (oldbird)**|4 Chefs using the old recipe|The stable, existing version (v1.17).|
|**The New Recruit**|**Deployment (newbird)**|1 Chef using the new recipe|The "Canary" version (latest).|
|**The Shared Counter**|**Service (allbirds)**|One unified ordering desk|Routes traffic to any chef with the `type=allbirds` badge.|

### 12.2 The "Canary" Workflow (Task 12 Walkthrough)
1. **Building the Aviary (Create Namespace)**
  - **Command:** `kubectl create ns birds`
2. **Drafting the Blueprints (Dry Run to YAML)** Instead of typing from scratch, you generate the base files to edit them.
  - **Command:** 
    - `kubectl -n birds create deploy oldbird --image=nginx:1.17 --dry-run=client -o yaml > oldbird.yaml`
    - `kubectl -n birds create deploy newbird --image=nginx:latest --dry-run=client -o yaml > newbird.yaml`
3. **YAML Surgery (The "Shared Badge" Labeling)** To make the Canary work, you must manually add the `type: allbirds` label to the **Pod Template** in both files. This allows one Service to find both Deployments.
  - Editing **oldbird.yaml**:
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: oldbird
    namespace: birds
    labels:
      app: oldbird
      type: allbirds  # Add this!
  spec:
    template:
      metadata:
        labels:
          app: oldbird
          type: allbirds  # AND Add this!
      spec:
        containers:
        - image: nginx:1.17
          name: nginx
  ```
   - **Editing** `newbird.yaml`: (Repeat the same process, ensuring `type: allbirds` is added to the metadata and template labels, while keeping the image as `nginx:latest`).
  4. **Hiring the Staff (Apply the Files)**
  - **Command:** 
    ```
      kubectl apply -f oldbird.yaml -n birds
      kubectl apply -f newbird.yaml -n birds
    ```
   5. **Setting up the Shared Counter (The Service)** You create a Service that ignores the "app" name and only looks for the "type" badge.
   - **Command:** `kubectl -n birds expose deploy oldbird --name=allbirds --selector type=allbirds --type=NodePort --port=80`
   - **The Edit:** Use `kubectl edit svc allbirds -n birds` to set `nodePort: 32323`.
   6. **The 80/20 Split (Scaling)**
  - **Command:** `kubectl scale -n birds deploy oldbird --replicas=4`
  - **Analogy:** With 4 `oldbird` pods and 1 `newbird` pod all sharing the `type: allbirds` label, the service naturally sends 80% of traffic to the old version.
  
### 12.3 Pro-Tip: The "Metadata vs. Template" Trap
In the CKAD exam, remember that the Service looks at the labels on the **Pod**, not the Deployment.
  - **Deployment Labels:** These are for the Mall Manager's filing cabinet.
  - **Template Labels:** These are the actual "Badges" pinned to the workers. **Crucial:** Ensure type: allbirds is inside the spec.template.metadata.labels section!

### 12.4 Diagnostic Tip: Is the Split Working?
If you want to see the **80/20 split in action**, run a loop from your `pod/newbird-7bf6b8f57f-84whm` pod:`for i in {1..20}; do curl -sI allbirds | grep -i "Server"; done | sort | uniq -c`. 
You should see: 
```
  17 Server: nginx/1.17.10
  3 Server: nginx/1.29.4
```
---
# Task 13: securityContext
**The Mall Analogy:** The "High-Security Boutique" 
In our mall, most shops have general rules. But for the **"SecuredPod" Boutique**, the Mall Manager has issued very specific security mandates for the staff (containers) working there.

### 1. The Supplemental Group (The "Staff ID Badge")
  - **The Rule:** `supplementalGroups: [2000]`
  - **The Analogy:** Every staff member in this shop belongs to a specific "Security Guild" (Group ID 2000). This badge gives them extra access to shared mall resources (like the loading dock or a shared safe) that other shops can't touch.
  - **Where it lives:** This is a **Pod-level** rule. It applies to everyone inside the shop.
### 1. No Privilege Escalation (The "No Master Key" Rule)
  - **The Rule:** `allowPrivilegeEscalation: false`
  - **The Analogy:** Even if a staff member finds a way to open a locked drawer, they are strictly forbidden from becoming "Mall Security" (root). They cannot gain more power than they were given on their first day.
  - **Where it lives:** This is a **Container-level** rule. It applies specifically to the individual worker at the counter.

### The "Blueprint" (YAML Construction)
Here is how we translate the Mall Manager's mandates into a valid Kubernetes YAML:

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: securedpod
spec:
  # POD LEVEL SECURITY (The Shop Rules)
  securityContext:
    supplementalGroups: [2000]
  containers:
  - name: nginx
    image: nginx:latest
    # CONTAINER LEVEL SECURITY (The Worker Rules)
    securityContext:
      allowPrivilegeEscalation: false
```

### Step-by-Step Lab Execution
Follow these commands to build and verify your secured shop:

**Step 1: Generate the base blueprint**
```Bash
mk -- -n securitycontext run securedpod --image=nginx --dry-run=client -o yaml > task13.yaml
```
**Step 2: Edit the security settings**
Open `task13.yaml` and ensure it looks like the block above. Notice the distinction:
  - `spec.securityContext`: For the `supplementalGroups`.
  - `spec.containers[].securityContext`: For `allowPrivilegeEscalation`.

**Step 3: Open the shop**
```Bash
mk -- create ns securitycontext
mk -- apply -f task13.yaml -n securitycontext
```
**Step 4: Inspect the "Security Clearance"**
Once the pod is running, verify the group ID is active by "talking" to the worker:
```Bash
mk -- exec securedpod -- id
```
The Goal: You should see `groups=... 2000` in the output!
---
# Task 14: Docker/OCI
This task shifts us from the **Mall Manager** (Kubernetes) to the **Factory Floor** (Docker).

## The Mall Analogy: The "Custom Vending Machine" 
Imagine you want to set up a very specific vending machine in the mall. You can't just buy a standard one; you need to **build** it yourself according to a secret recipe and then **package** it so it can be shipped to other malls.

### 1. The Secret Recipe (The Dockerfile)
  - **The Concept:** You find the manual (`Dockerfile`) in the back office (`Git repository`). It tells you exactly what goes into the machine: a base frame (`FROM alpine`), a workspace (`WORKDIR /mydata`), and a specialized timer (`COPY countdown`).
  - **The Action:** docker build -t myapp:1.0 .
  - **Analogy:** You follow the manual to assemble the vending machine and name the model **"myapp:1.0"**.
### 1. The Shipping Crate (The Tar File)
  - **The Concept:** Now that the machine is built, you need to put it in a wooden crate (`.tar`) so the delivery truck can move it.
  - **The Action:** `docker save myapp:1.0 > /tmp/myapp.tar`
  - **Analogy:** You "freeze" the machine's state and slide it into a crate labeled `/tmp/myapp.tar`.

### Step-by-Step Lab Execution
**Step 1: Find Secret Recipe**

``` Dockerfile ```
```
# 1. The Base Frame (Lightweight Linux)
FROM alpine

# 2. The Designer Label (Metadata)
LABEL Sander=<mail@sandervanvugt.nl>

# 3. The Storage Bin (Persistent mount point)
VOLUME /mydata

# 4. The Workspace (Changing directory)
WORKDIR /mydata

# 5. Adding the Tool (Copying the script from your laptop to the machine)
COPY countdown .

# 6. The Core Mission (The command that CANNOT be easily changed)
ENTRYPOINT ["./countdown"]

# 7. The Default Setting (The number of seconds, which CAN be changed)
CMD ["1000"]
```
**Step 2: Build the Machine (The Image)**
You want to make sure the mall's factory knows about this image.

```Bash
docker build -t myapp:1.0 .
```
**CKAD Tip:** If the exam asks you to make the image available to the cluster without a registry, you might need to use minikube image load myapp:1.0 or point your shell to the minikube docker-env.

**Step 3: Package for Shipping (The OCI Tar)**
The requirement says it must be **OCI compliant**. Modern `docker save` does this by default, but to be safe and clear, we use the redirection or the `-o` (output) flag.

```Bash
docker save myapp:1.0 -o /tmp/myapp.tar
```
**Step 4: Verify the Crate**
Just like you did in your terminal, check that the file exists and is a valid archive:
```Bash
file /tmp/myapp.tar
# Result should be: POSIX tar archive
```
---
# Task 15 The Mall Analogy: The "Security Badge": Service Account 💳🏢
In our mall, most workers are "temporary" and don't have access to the Mall Manager's office. However, some shops need to talk to the office to check inventory or mall schedules.

### 1. The Membership (The ServiceAccount)
  - **The Concept:** You create a special "Security Badge" named `secure` in the `oklahoma` wing of the mall.
  - **The Action:** `kubectl create sa secure -n oklahoma`
  - **Analogy:** You register a new identity in the mall's database. This badge doesn't do anything yet, but it’s ready to be worn.
### 1. The Worker Wearing the Badge (The Pod)
  - **The Concept:** You tell the `securepod` worker that they must wear the `secure` badge while they are on the clock.
  - **The Action:** `serviceAccountName: secure` (inside the Pod spec).
  - **Analogy:** When the worker shows up for their shift, the Mall Manager sees their badge and knows exactly who they are and what they are allowed to touch.

**Step-by-Step Lab Execution**
### Step 1: Prepare the "Mall Wing" (Namespace)
```Bash
mk -- create ns oklahoma
```
### Step 2: Create the "Badge" (ServiceAccount)
```Bash
mk -- create sa secure -n oklahoma
```
### Step 3: Create the "Blueprint" (YAML)
Generate the base Pod file:
```Bash
mk -- run securepod --image=nginx --dry-run=client -o yaml -n oklahoma > task15.yaml
```
### Step 4: Link the Badge to the Worker (Editing the YAML)
You saw a "strict decoding error" in your logs. This usually happens if `serviceAccountName` is placed in the wrong spot. It belongs inside the `spec`, but not inside the `containers` list.

Correct `task15.yaml` structure:

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: securepod
  namespace: oklahoma
spec:
  serviceAccountName: secure  # <--- MUST BE HERE (at the Pod level)
  containers:
  - name: securepod
    image: nginx
```
### Step 5: Open the Shop
```Bash
mk -- apply -f task15.yaml -n oklahoma
```
### Verification: Checking the "ID Card"
To ensure the pod is actually wearing the badge, inspect the running pod:
```Bash
mk -- get pod securepod -n oklahoma -o yaml | grep serviceAccountName
```
**Goal Result:** `serviceAccountName: secure`
---
### 10.3 The "Triage" Rule
In Section 10.0, remember the Mall Manager's priority:
1.  **Context Check:** Always `kubectl config set-context --current --namespace=<task-ns>`.
2.  **Dry-Runs:** Use `k run ... --dry-run=client -o yaml > task.yaml`. 
3.  **Validate:** Always test with `curl` or `kubectl get endpoints` before moving to the next task.

---

### 10.4 Grading the Exam
```bash 
student@ckad:~/ckad$ . /exam-grade.sh
```

---
### LABS
---
<img src="image-19.png" alt="labV1 - Services and Networking - Managing Services" height="35%" width="35%" />

### labV1
- Create a namespace with the name **“remote”**.
- In the remote Namespace, run an Nginx Pod with the name **“remoteweb”** and expose it such that it can be reached on the Minikube host port 31999.
- In the default Namespace, run the Pod testpod, based on the Busybox image and using the sleep infinity command as its default command.
- From the testpod Pod, use `wget --spider --timeout=1` to verify you can access the default webpage of the remoteweb Pod.
- Also verify that this web page is accessible on Minikube host port 31999.
---
> #### Solution
We are opening a boutique in a new, separate wing of the mall called **"remote"**. 
We need to make sure our staff in the **"default"** wing can call them, and that customers can walk in directly from the street via a specific gate number.
|Kubernetes Concept|Mall Analogy|
|--|--|
|**Namespace: remote**|A new, separate wing of the mall.|
|**Pod: remoteweb**|The Nginx boutique store.|
|**Service: NodePort**|A stable shop sign with a special street-level entrance.|
|**NodePort: 31999**|The specific "Gate Number" on the outside of the building.|
|**testpod (Busybox)**|A worker in the main wing testing the phone lines.|
---
**1. Build the Remote Wing and the Store**
```Bash
# Create the new mall wing
kubectl create ns remote
# Hire the worker (Nginx) in that wing
kubectl -n remote run remoteweb --image=nginx
```
**2. Install the Side Entrance (NodePort)**
We need to specifically request **Gate 31999** so external customers can find us. We generate the blueprint first, then edit it.

```Bash
# Generate the service blueprint
kubectl -n remote expose pod remoteweb --port=80 --type=NodePort --dry-run=client -o yaml > svc.yaml
```
**Edit `svc.yaml` to fix the port:**
```YAML
apiVersion: v1
kind: Service
metadata:
  name: remoteweb
  namespace: remote
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 31999 # The specific street-level gate
  selector:
    run: remoteweb
```
```Bash
# Apply the blueprint
kubectl apply -f svc.yaml
```
**3. Test from the Main Mall Wing (Inter-Namespace)**
We hire a temporary worker (`testpod`) in the **default** wing to see if they can call the boutique.
```Bash
# Hire a tester in the default wing
kubectl run testpod --image=busybox -- sleep infinity

# Use the internal phone system (DNS)
# Format: <service-name>.<namespace>
kubectl exec testpod -- wget --spider --timeout=1 remoteweb.remote.svc.cluster.local
```
***Verification Results***

**Internal Check (The "Mall Phone Call")**
  - **The Command:** `wget --spider --timeout=1 remoteweb.remote.svc.cluster.local`
  - **The Analogy:** The worker in the main wing dials "remoteweb" in the "remote" wing.
  - **Result:** `remote file exists`. The connection is successful!

**External Check (The "Street Entrance")**
  - **The Command:** `curl $(minikube ip):31999`
  - **The Analogy:** A customer walks up to the outside of the mall building and enters through Gate 31999.
  - **Result:** `Welcome to nginx!`. The boutique is open for business from the street!
---
**Expert Summary**
  - **Port 80:** The boutique's internal front door.
  - **remoteweb.remote:** The "Mall Extension Number" used to call across wings.
  - **NodePort 31999:** The special side entrance built into the mall's exterior wall.

>**Tip:** 
Since you are going across namespaces, you only need remoteweb.remote. Kubernetes is smart enough to fill in the rest!

---
<img src="image-18.png" alt="labV2 - Services and Networking - Managing Incoming Traffic" height="35%" width="35%" />

### labV2
- Create a Deployment with the name “lab11web”, based on the nginx container image and running 3 Pod instances.
- Make this Deployment accessible at the virtual hostname `lab11web.example.com`.
---
> #### Solution
`minikube addons enable ingress`

`kubectl create deploy lab11web --image=nginx --replicas=3`

`kubectl expose deployment lab11web --port=80`

---
**Pro-Tip for the CKAD**

In the exam, you usually won't have to edit `/etc/hosts` on your local machine. Instead, they will ask you to verify connectivity from inside the cluster.
Here is how you do it step-by-step:

**1. Spin up a temporary "Tester" Pod**

We will use a one-off pod (`busybox` or `curlimages/curl`) to run the test.

`kubectl run dns-test --image=curlimages/curl --rm -it --restart=Never -- sh`

**2. Run the Curl Test**

Once you are inside the pod shell, try to hit your virtual hostname:

```Bash
curl -v http://lab11web.example.com
```
**3. Why this might "Fail" (and how to fix it)**

If you just set up the Ingress, the `curl` might return a **404** or **Could not resolve host**. This is because the internal Kubernetes DNS (CoreDNS) doesn't automatically know about `example.com`, it only knows about internal `.cluster.local` addresses.

**The Fix:** You can "spoof" the host header to test the Ingress routing without needing DNS:

```Bash
# Get the ClusterIP of your Ingress Controller Service
INGRESS_IP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.clusterIP}')
echo ${INGRESS_IP}
10.98.79.1
```

**The Command Breakdown**

  - `-n ingress-nginx `You are looking in the specific **namespace** where Minikube installs the Ingress Controller.
  - `ingress-nginx-controller`: This is the specific name of the Service that handles all incoming web traffic.
  - `-o jsonpath='{.spec.clusterIP}'`: This is the "surgical" part. Instead of getting a whole table of information, you are telling Kubernetes: "Go into the YAML, find the `spec` section, then find the `clusterIP` field, and just show me that value."

**4. Execute the "Internal" Verification**
Since you have seen the `INGRESS_IP` with `echo{INGRESS_IP}`, let's copy that.

**Run this command:**
```Bash
kubectl run dns-test --image=curlimages/curl --rm -it --restart=Never -- \
  curl -v -H "Host: lab11web.example.com" http://10.98.79.1
```

**Understanding the Traffic Flow**
Internal testing helps you visualize the hops the data takes:

1. **Your Test Pod** sends a request.
2. **Ingress Controller** receives it.
3. **Ingress Rules** look at the "Host" header.
4. **Service/Pods** receive the traffic from the Ingress.
---

![alt text](image.png)
![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)
![alt text](image-4.png)
![alt text](image-5.png)
![alt text](image-6.png)
