# 🎨 Kubernetes Central Mall – Comics

This directory contains **educational comic strips** designed to visually explain key Kubernetes concepts using the **Central Mall analogy**.

Each comic is tightly coupled with:
- a **specific lab**
- a **precise CKAD topic**
- a **single conceptual takeaway**

Comics are **not decorative** — they are a learning tool.

---

## 🎯 Why Comics?

Kubernetes concepts often fail not because they are hard, but because they are **invisible**.

Comics help by:
- Turning abstract control-plane behavior into stories
- Explaining *why* something happens, not just *what*
- Creating fast mental recall during the CKAD exam
- Reducing cognitive load under stress

> 📌 **Rule of thumb**  

> If you can remember the comic, you can reconstruct the YAML.

---

## 🗂️ Structure & Conventions

    comics/
    ├── <topic>/
    │   └── <order>-<story-name>/
    │       ├── <lab>-<story>.png
    │       └── README.md

### Naming rules
- `<topic>` matches a Kubernetes domain (`nodeport`, `ingress`, `secrets`, `crd`, `gateway-api`, …)
- `<order>` keeps stories progressive
- Each story focuses on **one problem / one insight**
- Every comic **must** reference:
  - the related lab
  - the related docs

---

## 📚 Available Comics

### 🧩 Custom Resources (CRD)

    crd/
    └── 01-the-nightly-backup-permit/
        ├── lab01-crd-nightly-backup.png
        └── README.md

**Story:** *The Nightly Backup Permit*  
**Quick links:**
- 🧪 **Lab:** [`lab01-crd-custom-backup-service`](../labs/extending-k8s/lab01-crd-custom-backup-service/README.md)
- 📖 **Docs:** [`docs/md-resources/understanding-custom-resource-definitions-crds.md`](../docs/md-resources/understanding-custom-resource-definitions-crds.md)

Explains:
- How Kubernetes can be extended with new resource types
- Why Custom Resources do nothing without Controllers
- The role of the reconciliation loop
- What CKAD expects you to understand about CRDs

---

---

### 📞 Services (Internal)

    clusterip/
    └── 01-internal-intercom/
        ├── internal-intercom.png
        └── README.md

**Story:** *The Internal Intercom*  
**Quick links:**
- 🧪 **Lab:** [`lab01-clusterip-internal-traffic`](../labs/services-and-networking/lab01-clusterip-internal-traffic/README.md)
- 📖 **Docs:** [`docs/md-resources/service-ip-tracker-evolution.md`](../docs/md-resources/service-ip-tracker-evolution.md)

Explains:
- how **ClusterIP** balances requests
- why Pods don’t need to know each other’s IPs
- the role of the Service as a stable entry point

---

### 🚪 Services (External)

    nodeport/
    ├── 01-canary-nodeport/
    │   ├── lab04-canary-nodeport.png
    │   └── README.md
    └── 02-cross-namespace/
        ├── lab01-nodeport-cross-namespace.png
        └── README.md

**Story:** *The Canary Side Entrance*  
**Quick links:**
- 🧪 **Lab:** [`lab04-canary-nodeport`](../labs/services-and-networking/lab04-canary-nodeport/README.md)
- 🧪 **Lab:** [`lab02-nodeport-cross-namespace`](../labs/services-and-networking/lab02-nodeport-cross-namespace/README.md)

---

### 🎛️ Ingress

    ingress/
    └── 01-virtual-host/
        ├── lab02-ingress-virtual-host.png
        └── README.md

**Quick links:**
- 🧪 **Lab:** [`lab03-ingress-virtual-host`](../labs/services-and-networking/lab03-ingress-virtual-host/README.md)
- 📖 **Docs:** [`docs/md-resources/ingress-vs-gateway.md`](../docs/md-resources/ingress-vs-gateway.md)

Explains:
- Host-based routing
- Why Ingress needs a controller
- How virtual hosts map to services

---

### 🤫 Secrets

    secrets/
    └── 01-secrets-injection/
        ├── lab03-secrets-injection.png
        └── README.md

**Quick links:**
- 🧪 **Lab:** [`lab03-secrets-env-injection`](../labs/security/lab03-secrets-env-injection/README.md)
- 📖 **Docs:** [`docs/md-resources/secrets-use-cases-and-application-integration.md`](../docs/md-resources/secrets-use-cases-and-application-integration.md)

Explains:
- Why secrets should never be hardcoded
- How env injection works
- How applications receive sensitive data safely

---
### 🛡️ Service Accounts

    security/
    └── 02-the-secure-badge/
        ├── lab01-the-secure-badge.png
        └── README.md

**Quick links:**
- 🧪 **Lab:** [`lab01-serviceaccount-identity`](../labs/security/lab01-serviceaccount-identity/README.md)
- 📖 **Docs:** [`docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md`](../docs/md-resources/understanding-serviceaccounts-the-shops-internal-badge.md)

Explains:
- Why **every Pod runs with an identity**
- What the **default ServiceAccount** really is
- How **Pods inherit identity from Deployments**
- Why **assigning a ServiceAccount is a security boundary**
- The CKAD mental model: 
> *"Pods don't choose permissions — they wear the badge you give them."*

---

### 🛡️ Network Policies

    network-policies/
    └── 01-locked-corridors/
        ├── locked-corridors.png
        └── README.md

**Story:** *The Locked Corridor*  
**Quick links:**
- 🧪 **Lab:** [`lab06-network-policies`](../labs/services-and-networking/lab06-network-policies/README.md)
- 📖 **Docs:** [`docs/md-resources/troubleshooting-kubernetes.md#section-8-3`](../docs/md-resources/troubleshooting-kubernetes.md#section-8-3)

Explains:
- Default deny strategy
- Why whitelisting is the safest approach
- How labels act as keycards
- The critical role of DNS whitelisting

---

 
 ### 📦 Package Management & Logistics (Helm & Kustomize)
 
     deploying/
     └── 02-the-logistics-chain/
         ├── the-logistics-chain.png
         └── README.md
 
 **Story:** The Logistics Chain  
 **Quick links:**
 - 📖 **Docs:** [`docs/md-resources/using-the-helm-package-manager.md`](../docs/md-resources/using-the-helm-package-manager.md)
 - 📖 **Docs:** [`docs/md-resources/using-kustomize.md`](../docs/md-resources/using-kustomize.md)
 
 Explains:
 - **Helm**: Prefabricated "Store-in-a-Box".
 - **Kustomize**: Blueprint overlays (Base vs. Overlays).
 - Why we use different tools for different scaling needs.
 
 ---

### 📡 Gateway API

    gateway-api/
    └── 01-the-lost-gateway/
        ├── lab05-il-giallo-del-gateway-perduto.png
        └── README.md

**Quick links:**
- 🧪 **Lab:** [`lab05-canary-deployment-gateway-api`](../labs/deploying/lab05-canary-deployment-gateway-api/README.md)
- 📖 **Docs:** [`docs/md-resources/gateway-api.md`](../docs/md-resources/gateway-api.md)

Explains:
- Why a Gateway may show `Programmed: False`
- What `GatewayConflict` really means
- Why the Gateway often has **no IP**
- Who actually controls traffic (GatewayClass & Controller)
---

### 🧱 Pod Design (InitContainers & Sidecars)

    pod-design/
    └── 01-the-helping-hands/
        ├── lab01-pod-design-sidecar-init.png
        └── README.md

**Story:** The Helping Hands
**Quick links:**

- 🧪 **Lab:** [`lab01-sidecar-initcontainers`](../labs/pod-design/lab01-sidecar-pattern/README.md)
- 📖 **Docs:** [`TASK 4`-`docs/md-resources/the-final-simulation.md`](../docs/md-resources/the-final-simulation.md)


Explains:

- Why one container shouldn’t do everything
- InitContainers as setup crew
- Sidecars as permanent assistants
- Shared volumes as communication channels

> **CKAD takeaway:**
> 
> “InitContainers prepare the shop. Sidecars keep it running.”

---

### 🗄️ Storage (Persistent Volumes & Claims)
    storage/
    └── 01-the-warehouse/
        ├── lab01-the-warehouse.png
        └── README.md

**Story:** The Warehouse
**Quick links:**

- 🧪 **Lab:** [`lab01-pv-pvc`](../labs/storage/lab01-persistent-volume/README.md)
- 📖 **Docs:** [`docs/md-resources/storage-recap-for-dummies.md`](../docs/md-resources/storage-recap-for-dummies.md)

Explains:

- Why Pod storage is ephemeral
- PV as physical storage
- PVC as a rental contract
- Why Pods are replaceable but data isn’t

> **CKAD mental hook:**
> 
> “Pods are temporary workers. Data lives in the warehouse.”

---

### 🧰 Configuration (ConfigMaps & Secrets)
    configuration/
    └── 01-configuration-injection/
        ├── labXX-configuration-injection.png
        └── README.md

**Story:** ConfigMaps & Secrets
**Quick links:**

- 🧪 **Lab:** [`lab01-configmaps`](../labs/configuration/lab01-configmaps/README.md)
- 📖 **Docs:** [`docs/md-resources/configmaps-variables-vs-configuration-files.md`](../docs/md-resources/configmaps-variables-vs-configuration-files.md)
- 📖 **Docs:** [`docs/md-resources/configuration-deoupling.md`](../docs/md-resources/configuration-deoupling.md  )


**Will explain:**

- ConfigMaps vs Secrets
- Env vars vs volumes
- Why config is injected, not baked into images

---

### 👁️ Observability (Liveness Probes)

    observability/
    └── 01-the-health-inspector/
        ├── lab01-observability-health-inspector.png
        └── README.md

**Quick links:**
- 🧪 **Lab:** [`lab01-liveness-probes-health-inspector`](../labs/observability/lab01-liveness-probes-health-inspector/README.md)

Explains:
- The difference between **Liveness** (restart) and **Readiness** (traffic)
- How Kubernetes acts as a strict Health Inspector
- Why `initialDelaySeconds` is critical for avoiding restart loops

---

## 🔁 How to Use Comics Effectively

**Recommended learning flow:**

1. Read the **lab README**
2. Run the lab
3. Open the **comic**
4. Re-read the lab summary

**Before the CKAD exam:**
- Skim comics only
- Rebuild concepts mentally
- Recall YAML patterns

---

## 🧠 Design Principles

- One comic = one core idea
- No YAML inside comics
- Visual first, technical second
- Always CKAD-relevant

---

## 🎨 Visual Style

- Simple, clean line art
- Consistent characters
- Minimalist backgrounds
- Focus on **control-plane behavior**
- No clutter

---

## 🔗 Workflow

1. **Lab first** → understand the YAML  
2. **Comic second** → understand the *why*  
3. **Docs third** → deep dive if needed  

---

🛍️ *Welcome to the Kubernetes Central Mall — where even control-plane logic has a personality.*
