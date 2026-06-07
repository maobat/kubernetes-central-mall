# 📘 CKAD – Exam Day Playbook & Simulator

This directory contains resources to prepare for and execute your **CKAD Exam Day** and practice labs using the mock simulator.

---

## ⏱️ Exam Facts

- ⏱️ **Duration:** 2 hours
- 💻 **Format:** 100% hands-on tasks
- 🎯 **Scenarios:** ~15–20 tasks
- ✅ **Passing Score:** 66%
- 📅 **Validity:** 2 years
- ☸️ **Environment:** Real Kubernetes clusters (v1.27+)

---

## 🗺️ Study Guide Directory

### 🚀 Part 1: Exam Day Playbook (Strategy & Settings)
- **Environment Setup:** [Study Environments](./playbook/00-study-environments.md) — local setup vs exam terminal.
- **Terminal Config:** [Linux Setup](./playbook/01-linux-setup.md) — alias definitions, vim configs, and auto-completion.
- **Speed Reference:** [CKAD Cheatsheet](./playbook/02-cheatsheet.md) — commands for daily tasks.
- **Time Management:** [Time Strategy](./playbook/03-time-management.md) — score strategies and weighting.
- **Verification List:** [Final Checklist](./playbook/04-final-checklist.md) — what to check before submitting.
- **Context Routing:** [SSH & Contexts](./playbook/05-ssh-and-contexts.md) — moving between clusters and nodes safely.

### 🚀 Part 2: Killer.sh Simulator (CKAD Mall Analogy Practice)
- **Lab Preparation:** [Lab Prep Guide](./simulator/06-killer-sh-simulator-prep.md) — local lab setup guide.
- **Lab Setup Script:** [setup-labs.sh](./scripts/setup-labs.sh) — spins up namespaces, pods, and deployments.
- **Master Study Guide:** [Killer.sh Simulator Guide](./simulator/06-killer-sh-simulator.md) — full 22-question syllabus with blueprints, solutions, and exam tips.
- **Mock Exam Simulator:** [Real Simulator (Questions Only)](./simulator/06-killer-sh-real-simulator.md) — practice questions-only under real exam conditions.
- **Grading Script:** [check-answers-with-score-labs.sh](./scripts/check-answers-with-score-labs.sh) — terminal grading tool to verify your answers.
- **Cleanup Script:** [cleanup-labs.sh](./scripts/cleanup-labs.sh) — tears down all created namespaces and directories.

---

## ⚙️ Prerequisites & Quick Start

Before starting the simulator locally, ensure you meet the following requirements:

1. **Local Kubernetes Cluster:** A running local cluster (such as Minikube, Kind, or a local VM) with `kubectl` configured.
2. **Permissions Setup:** The lab environment writes output files to `/opt/course`. To avoid permission errors when redirects are used, run this command once to grant ownership to your current user:
   ```bash
   sudo chown -R $(whoami) /opt/course
   ```

### ⚡ Quick Start Workflow (Run from repository root):
1. **Initialize the lab:**
   ```bash
   sudo ./reference/md-resources/ckad-exam/scripts/setup-labs.sh
   ```
2. **Take the exam:** Open [Real Simulator](./simulator/06-killer-sh-real-simulator.md) and solve the tasks.
3. **Verify your answers:**
   ```bash
   ./reference/md-resources/ckad-exam/scripts/check-answers-with-score-labs.sh
   ```
4. **Clean up when finished:**
   ```bash
   ./reference/md-resources/ckad-exam/scripts/cleanup-labs.sh
   ```

---

### 📝 Part 3: Extra Practice Exercises
- **Resource Limits:** [Pod Resources Practice](./exercises/pod.md) — practice setting up CPU/Memory limits.

---
[Mall Directory ✨](../../../GLOSSARY.md)
