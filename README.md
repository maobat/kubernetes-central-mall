# Kubernetes Central Mall 🛍️

![License: MIT](https://img.shields.io/badge/License-MIT-green)
![Status: WIP](https://img.shields.io/badge/status-WIP-orange)

**Kubernetes Central Mall** is a **CKAD-focused learning project** that explains Kubernetes concepts using a **consistent shopping mall analogy**, reinforced by **hands-on labs** and **educational comic strips**.

The goal is simple:  
👉 *Understand Kubernetes fast, remember it longer, pass the exam with confidence.*

---

## 🎓 CKAD Curriculum Alignment (CNCF)

This project is structured to align with the **official CKAD (Certified Kubernetes Application Developer) curriculum** defined by the **Cloud Native Computing Foundation (CNCF)**.

By browsing the official CNCF curriculum, you can review the **exam domains and their weightings**:

🔗 https://github.com/cncf/curriculum/blob/master/ckad/README.md

According to the latest available version of the curriculum (**CKAD Curriculum v1.34**), the exam domains are:

| Domain | Weight |
|------|--------|
| Application Design and Build | 20% |
| Application Deployment | 20% |
| Application Observability and Maintenance | 15% |
| Application Environment, Configuration and Security | 25% |
| Services and Networking | 20% |

📄 Reference document: `CKAD_Curriculum_v1.34.pdf`

### 🧭 How This Repository Maps to the CKAD Domains

Chapters, labs, and comics in this repository are designed to collectively cover **all CKAD exam domains**, with a strong focus on:

- conceptual understanding (storytelling)
- exam-oriented clarity (study guides)
- hands-on execution (labs)

The goal is **not** to duplicate the CNCF curriculum, but to **make it tangible, memorable, and executable**.

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

## 🧭 How to ACTUALLY Use This (The Real Workflow)

### 1️⃣ First Pass (Comprehension)
- Read the narrative chapter in `sources/story/`
- Look at the related **Comic**
- **DO NOT** touch `kubectl`

### 2️⃣ Second Pass (Structuring)
- Read the technical summary in `sources/study-guide/`
- Memorize patterns and differences
- Note down exam traps

### 3️⃣ Third Pass (Muscle Memory)
- Do the **Lab**
- Redo the lab without looking
- Explain it out loud (even to the wall)

> **💡 Ultra-Honest TL;DR:** By strictly separating the Story, Study Guide, and Labs, you get less confusion, zero useless repetitions, and a killer CKAD learning path.

---

## 🎓 CKAD Exam Day Playbook

When exam day arrives, stop studying concepts and switch to execution mode. We have a dedicated playbook just for the exam environment:

- 💻 **[Linux Setup (The first 5 minutes)](docs/md-resources/ckad-exam/01-linux-setup.md)**
- 🚀 **[CKAD Cheatsheet (Commands to memorize)](docs/md-resources/ckad-exam/02-cheatsheet.md)**
- ⏱️ **[Time Management Strategy](docs/md-resources/ckad-exam/03-time-management.md)**
- ✅ **[Final Checklist](docs/md-resources/ckad-exam/04-final-checklist.md)**

👉 *[Go to the Exam Playbook Index](docs/md-resources/ckad-exam/README.md)*

---

## 📚 Repository Structure

    ├── comics/ # Visual explanations (comic strips)
    ├── docs/ # Modular concept documentation
    ├── labs/ # CKAD-style hands-on labs
    ├── sources/ # The core curriculum
    │   ├── story/ # Narrative expansions of the mall analogy
    │   └── study-guide/ # Concise CKAD technical summaries
    ├── antigravity/ # Experimental / advanced material
    └── README.md

### 📖 `docs/`
Conceptual explanations, deep dives, and reference material.

**⭐ Must-Read Core Concepts:**
- 🎭 **[The Cast of Characters](docs/md-resources/cast-of-characters.md):** A complete mapping of Kubernetes resources to the Mall analogy.
- 🛤️ **[The Traffic Flow (Customer Journey)](docs/md-resources/traffic-flow.md):** How a request travels from the outside world to a Pod.
- 🧯 **[Troubleshooting Kubernetes](docs/md-resources/troubleshooting-kubernetes.md):** The ultimate guide to debugging broken shops.
- 🚑 **[Diagnostic Cheat Sheet](docs/md-resources/diagnostic-cheat-sheet.md):** Quick `kubectl` triage commands.

*Also covers deep-dives into:*
- Traffic, Storage, and Security
- Deployments & rollout strategies
- API & control plane interaction

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
