# Kubernetes Central Mall 🛍️
# 🏬 Kubernetes Central Mall: The Ultimate CKAD Visual Study Guide

[![CKAD Simulator](https://img.shields.io/badge/Premium-Exam_Simulator_Packet-gold?style=for-the-badge&logo=kubernetes)](PREMIUM.md)
![License: MIT](https://img.shields.io/badge/License-MIT-green)
![Status: WIP](https://img.shields.io/badge/status-WIP-orange)

**Kubernetes Central Mall** is a **CKAD-focused learning project** that explains Kubernetes concepts using a **consistent shopping mall analogy**, reinforced by **hands-on labs** and **educational comic strips**.

The goal is simple:  
👉 *Understand Kubernetes fast, remember it longer, pass the exam with confidence.*

---

## 🗺️ The Learning Map: Choose Your Path

In this repository, you can learn Kubernetes through four different lenses. We suggest starting with the **Story** to build your mental model.

---

### 1. 📖 [The Story: Welcome to Central Mall](./sources/story.md)
*The Big Picture*
Read the narrative of how a chaotic marketplace transforms into a managed Kubernetes cluster. 
- **Goal:** Understand "The Why" behind namespaces, pods, and services.
- **Vibe:** Metaphorical, fun, and non-technical.

---

### 2. 🎨 [The Comics: Visual Insights](./visual-learning/comics/README.md)
*The Mental Hooks*
Visual breakdowns of specific problems (like "The Lost Gateway" or "Locked Corridors") organized by chapter.
- **Goal:** Create fast mental recall for the CKAD exam.
- **Link:** [Browse the Comics Collection](./visual-learning/comics/README.md)

---

### 3. 🧪 [The Labs: Engineering Office](./practice/labs/README.md)
*Hands-on Practice*
The technical blueprints where you actually build the mall using `kubectl` across 15 structured chapters.
- **Goal:** Mastery of YAML and imperative commands.
- **Link:** [Go to the Labs Index](./practice/labs/README.md)

---

---

### 🗺️ [The Mall Directory: Search & Glossary](./GLOSSARY.md)
*The Information Desk*
A central repository to quickly find terms, analogies, and all related documentation, labs, and official Kubernetes references.
- **Goal:** Fast lookup and cross-referencing across all project sections.
- **Link:** [Open the Mall Directory](./GLOSSARY.md)

---

### 4. 📚 [Reference: Technical Library](./reference/README.md)
*Deep Dives*
Compact study guides and modular documentation covering all CKAD domains.
- **Goal:** Technical precision and exam-ready theory.
- **Link:** [Search the Reference Library](./reference/README.md)

---

### 5. 🏬 [CKAD Mock Simulator: Central Mall Practice](./reference/md-resources/ckad-exam/simulator/06-ckad-practice-simulator.md)
*Real Exam Drill*
Practice the exam-level mock simulator suite on your local cluster using mapped mall analogies.
- **Goal:** Get comfortable with exam-level pressure, multi-context switches, and debugging under time constraints.
- **Trial Pack:** Download the free [ckad-mall-simulator-trial.zip](./ckad-mall-simulator-trial.zip) to practice Questions 1 & 2 instantly.
- **Links:** [Go to the Simulator Guide](./reference/md-resources/ckad-exam/simulator/06-ckad-practice-simulator.md) | [Real Simulator (Questions Only)](./reference/md-resources/ckad-exam/simulator/06-ckad-real-simulator.md) | [Setup Instructions](./reference/md-resources/ckad-exam/simulator/06-ckad-simulator-prep.md) | [Unlock Full 22 Questions](PREMIUM.md)

---

## 🚀 Recommended Workflow

If you are new to a concept, follow this "Central Mall" sequence:
1. **Read the Story Chapter** (e.g., [Chapter 12: Ingress](./sources/story/ch12-ingress-and-gateway-api.md)).
2. **Scan the Matching Comic** (e.g., [Virtual Host Gateway Show](./visual-learning/comics/ch12-ingress/01-virtual-host/README.md)).
3. **Execute the Lab** (e.g., [lab03-advanced-ingress](./practice/labs/ch12-ingress/lab03-advanced-ingress/README.md)).
4. **Consult the Study Guide** (e.g., [ch12-ingress](./sources/study-guide/ch12-ingress.md)) for exam traps and technical details.

---

## 🎓 CKAD Curriculum Alignment (CNCF)

This project is structured to align with the **official CKAD (Certified Kubernetes Application Developer) curriculum** defined by the **Cloud Native Computing Foundation (CNCF)**.

| Domain | Weight | Chapters |
|------|--------|----------|
| **Application Design and Build** | 20% | 1, 2, 3, 4 |
| **Application Environment, Configuration and Security** | 25% | 5, 6, 7, 8 |
| **Application Deployment** | 20% | 9, 10 |
| **Services and Networking** | 20% | 11, 12, 13 |
| **Application Observability and Maintenance** | 15% | 14, 15 |

---

## 🧠 The Mall Analogy

The mall is your Kubernetes cluster:

- **Shops** → Pods & Containers  
- **Corridors & Entrances** → Services, Ingress, Gateway API  
- **Storage Rooms** → Volumes & PersistentVolumes (The Warehouse)
- **Security Office** → RBAC, Secrets, ServiceAccounts  
- **Mall Expansion** → Deployments, Scaling, Rollouts  

---

## 🧭 How to Navigate
The **Central Mall** is designed for non-linear exploration. Use these tips to move through the project:
*   **The Mall Directory (Glossary):** Use the [GLOSSARY.md](./GLOSSARY.md) at any time to look up a technical term and see its Mall Analogy.
*   **The Learning Matrix:** Every technical concept in the Glossary links back to its corresponding Story, Study Guide, and Lab.
*   **Hoppping Back:** Since Markdown is static, use your **Browser's Back Button** or **IDE Navigation arrows** to return to a specific chapter after looking up a term in the Glossary.
*   **Footers:** Every page has a footer with links back to the Chapter Index and the Global Directory.

---

## 🏗️ Project Structure

```text
.
├── practice/lab/              # Hands-on labs organized by chapter
├── visual-learning/comics/    # Educational comics strips
├── sources/
│   ├── story/                 # Narrative expansions of the mall analogy
│   └── study-guide/           # Concise CKAD technical summaries
├── reference/                 # Deep-dives, cheatsheets, and concept docs
└── antigravity/               # Advanced or experimental material
```

---

🛍️ *Ready to start? Head over to [Chapter 1: Choosing the Right Workload](./sources/story/ch01-choosing-the-right-workload.md) and hire your first worker!*

---

> **Disclaimer:** *Kubernetes®, CKAD, and CNCF are registered trademarks of The Linux Foundation. This project is an independent educational resource and is not affiliated with, sponsored by, or officially endorsed by The Linux Foundation or the Cloud Native Computing Foundation (CNCF).*
