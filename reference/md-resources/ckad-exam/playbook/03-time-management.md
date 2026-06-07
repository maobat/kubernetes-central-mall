# ⏱️ Time Strategy: The Mall Manager's Triage

In a busy shopping mall, a manager cannot solve every issue simultaneously. If a lightbulb is out in a boutique (2% value) but the main entrance doors are jammed (8% value), you focus on the entrance.

The CKAD exam is a game of **Return on Investment (ROI)**. You have **120 minutes** to solve **15–20 tasks** to reach the passing score of **66%**.

---

## 📊 The Task Triage Matrix

Every question displays a percentage weight (value) in the top corner. Prioritize your work like a business owner:

| Task Category | Exam Weight | Effort Level | Priority | Mall Analogy |
| :--- | :--- | :--- | :--- | :--- |
| **Quick Sales** <br>(Pods, ConfigMaps, Secrets, Namespaces) | 2% – 4% | Very Low (1-3 mins) | **1. High** | *Unboxing inventory.* Solve immediately using fast imperative commands. |
| **Grand Openings** <br>(Deployments, Services, Scaling) | 5% – 8% | Medium (3-5 mins) | **2. High** | *Opening new departments.* High points return, easy to generate templates. |
| **Store Logistics** <br>(PV, PVC, StorageClasses, Probes) | 4% – 7% | Medium-High (5-7 mins) | **3. Medium** | *Warehouse storage setup.* Requires precise name matches and mount paths. |
| **Security Vaults** <br>(NetworkPolicies, ServiceAccounts/RBAC) | 6% – 9% | High (7-10 mins) | **4. Low (Save for last)** | *Alarms and lock policies.* High value, but easy to make tiny syntax errors. |

---

## 🚫 Avoid the "Loss Leaders" (The 2-Minute Skip Rule)

A **Loss Leader** is a task that eats all your time for very little return. 
* **The Rule:** If you are debugging a container crash or a network policy connection block and make no progress for **2 minutes**, flag the question and **move on**.
* **Why?** Debugging a 2% task for 15 minutes is a failing strategy. You could use those 15 minutes to secure three 6% deployment tasks.

---

## ⚡ Fast Execution: Imperative over YAML

Do not write YAML manifests from scratch. Use the **Cash Register Shortcuts** (imperative generators):

* **To deploy a Pod:**
  ```bash
  kubectl run my-pod --image=nginx:alpine --dry-run=client -o yaml > pod.yaml
  ```
* **To create a Service:**
  ```bash
  kubectl expose pod my-pod --port=80 --target-port=8080 --name=my-service
  ```
* **To create a Deployment with replicas:**
  ```bash
  kubectl create deploy my-dep --image=nginx --replicas=3
  ```

Only open `vi` or `nano` to make minor adjustments (like adding environment variables, volume mounts, or security contexts).

---

## 🏁 The Last 20 Minutes (Final Inspection)

When the clock hits the **20-minute mark**, stop solving new complex tasks. Walk the store floor to verify:
1. **Name Matching:** Did you save files exactly where requested? (e.g., `/opt/course/1/namespaces`).
2. **Context Checks:** Did you verify that your objects exist in the correct namespace?
3. **Restarts:** Are your newly deployed pods in `Running` state, or are they stuck in `CrashLoopBackOff`?

---

👉 Continue with:

- [Final Checklist](./04-final-checklist.md)

---

> **Disclaimer:** *Kubernetes®, CKAD, and CNCF are registered trademarks of The Linux Foundation. This project is an independent educational resource and is not affiliated with, sponsored by, or officially endorsed by The Linux Foundation or the Cloud Native Computing Foundation (CNCF).*
