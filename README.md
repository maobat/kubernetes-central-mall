# Kubernetes Central Mall 🛍️

![License: MIT](https://img.shields.io/badge/License-MIT-green)
![Status: WIP](https://img.shields.io/badge/status-WIP-orange)

**Kubernetes Central Mall** is a **CKAD-focused learning project** that explains Kubernetes concepts using a **consistent shopping mall analogy**, reinforced by **hands-on labs** and **educational comic strips**.

The goal is simple:  
👉 *Understand Kubernetes fast, remember it longer, pass the exam with confidence.*

---

## 🧠 The Mall Analogy

The mall is your Kubernetes cluster:

- **Shops** → Pods & Containers  
- **Corridors & Entrances** → Services, Ingress, Gateway API  
- **Storage Rooms** → Volumes & PersistentVolumes  
- **Security Office** → RBAC, Secrets, ServiceAccounts  
- **Mall Expansion** → Deployments, Scaling, Rollouts  

Each concept is explained **twice**:
1. **Technically** (exam-ready)
2. **Visually** (comic-style storytelling)

---

## 📚 Repository Structure

    ├── comics/ # Visual explanations (comic strips)
    ├── docs/ # Modular concept documentation
    ├── labs/ # CKAD-style hands-on labs
    ├── antigravity/ # Experimental / advanced material
    ├── sources/ # Long-form narrative & backups
    └── README.md

### 📖 `docs/`
Conceptual explanations, deep dives, and reference material:
- Traffic & networking
- Storage
- Security
- Deployments & strategies
- API & control plane concepts

---

### 🧪 `labs/`
CKAD-oriented labs with:
- Clear goals
- Imperative + declarative workflows
- Verification steps
- Exam tips

Examples:
- `lab01-nodeport-cross-namespace`
- `lab02-ingress-virtual-host`
- `lab03-secrets-env-injection`
- `lab04-canary-nodeport`
- `lab05-canary-deployment-gateway-api`

---

### 🎨 `comics/`
Each major lab or topic has a **matching comic strip**.

Purpose of comics:
- Fix concepts in long-term memory
- Explain *why* something works, not just *how*
- Provide fast visual recall during the exam

Structure:

    comics/
        ├── gateway-api/
        │ └── 01-the-lost-gateway/
        ├── secrets/
        │ └── 01-secrets-injection/
        └── README.md


Comics **do not replace labs** — they reinforce them.

---

### 🚀 `antigravity/`
Advanced or experimental material:
- Non-standard flows
- Edge cases
- “What if?” scenarios

Optional, but useful for deeper understanding.

---

## 🎯 Target Audience

- CKAD candidates
- Kubernetes learners who hate abstract explanations
- Engineers who prefer **mental models over memorization**

---

## 🤝 Contributing

Contributions are welcome:

1. Open issues for ideas, corrections, or missing labs
2. Submit PRs for:
   - New labs
   - Improved explanations
   - Additional comics
3. Keep commits and branch names descriptive

---

## ⚠️ Project Status

This project is **Work In Progress (WIP)**.

- Structure may evolve
- Content will grow
- Comics will expand over time

Feedback is highly encouraged.

---

🛍️ *Welcome to the Kubernetes Central Mall — don’t get lost in the corridors.*
