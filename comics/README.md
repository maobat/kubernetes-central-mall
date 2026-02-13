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
    │ └── <order>-<story-name>/
    │ ├── <lab>-<story>.png
    │ └── README.md
    
### Naming rules
- `<topic>` matches a Kubernetes domain (`nodeport`, `ingress`, `secrets`, `gateway-api`, …)
- `<order>` keeps stories progressive
- Each story focuses on **one problem / one insight**
- Every comic **must** reference:
  - the related lab
  - the related docs

---

## 📚 Available Comics

### 🚪 NodePort

    nodeport/
    └── 01-cross-namespace/
    ├── lab01-nodeport-cross-namespace.png
    └── README.md

**Story:** *Crossing the Mall Corridors*  
**Lab:** `lab01-nodeport-cross-namespace`

Explains:
- How NodePort exposes services
- Why namespaces don’t isolate traffic paths
- Why NodePort works even when pods live elsewhere

---

### 🎛️ Ingress

    ingress/
    └── 02-virtual-host/
    ├── lab02-ingress-virtual-host.png
    └── README.md

**Story:** *The Virtual Host Directory*  
**Lab:** `lab02-ingress-virtual-host`

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

**Story:** *The Locked Vault*  
**Lab:** `lab03-secrets-injection`

Explains:
- Why secrets should never be hardcoded
- How env injection works
- How applications receive sensitive data safely

---

### 🐤 Canary Deployments (NodePort)

    canary-nodeport/
    └── 01-canary-replica-weighting/
    ├── lab04-canary-nodeport.png
    └── README.md
    
**Story:** *The Two Shops Experiment*  
**Lab:** `lab04-canary-nodeport`

Explains:
- Replica-based canary behavior
- Why NodePort can’t do true traffic splitting
- How Kubernetes “fakes” percentages using replicas

---

### 📡 Gateway API

    gateway-api/
    └── 01-the-lost-gateway/
    ├── lab05-il-giallo-del-gateway-perduto.png
    └── README.md


**Story:** *The Lost Gateway*  
**Lab:** `lab05-canary-deployment-gateway-api`

Explains:
- Why a Gateway may show `Programmed: False`
- What `GatewayConflict` really means
- Why the Gateway often has **no IP**
- Who actually controls traffic (GatewayClass & Controller)



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

## 🤝 Contributing

Contributions are welcome:
- New comics for missing topics
- Improvements to existing comics
- Better YAML-to-story mappings

---

🛍️ *Welcome to the Kubernetes Central Mall — where even control-plane logic has a personality.*
