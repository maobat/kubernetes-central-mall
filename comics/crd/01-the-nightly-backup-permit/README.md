<img src="lab06-crd-nightly-backup.png" alt="The Nightly Backup Permit" width="50%" />

# 🗂️ The Nightly Backup Permit

This comic explains:

- what a **Custom Resource Definition (CRD)** really is  
- why creating a **Custom Resource (CR)** does *nothing* by itself  
- who is responsible for turning intent into action (**Controllers / Operators**)  
- how the **Reconciliation Loop** works behind the scenes  

---

## 🛍️ Mall Analogy

Mall Management normally knows about:

- Stores → Deployments
- Pick-up Points → Services
- Licenses → Pods

We want a **new permit type**:

👉 **Nightly Backup Service**

- Writing a **CRD** = Adding a new chapter to the rulebook  
- Creating a **CR** = Filling out the form requesting that service  
- Controller / Operator = The staff who reads the form and actually runs the backup

---

## 📁 Lab Files

- `00-crd-backup.yaml` – Defines the CRD, adds the BackUp resource type  
- `01-backup-instance.yaml` – Creates a specific BackUp request  
- `02-simulated-controller-job.yaml` – Simulates the controller creating the actual Job/Pod

---

## 🧪 Steps (CKAD-style)

### 1️⃣ Register the new resource type
```bash
kubectl apply -f 00-crd-backup.yaml
kubectl api-resources | grep backup
```
✔️ The API now knows about BackUp objects
### 2️⃣ Create a BackUp request
```bash
kubectl apply -f 01-backup-instance.yaml
kubectl get bks
```
At this stage:
- ✅ The CR exists in etcd
- ❌ Nothing happens yet (no Controller running)

### 3️⃣ Simulate Controller action
```bash
kubectl apply -f 02-simulated-controller-job.yaml
kubectl get jobs
kubectl logs job-nightly-backup
```
This mimics what a real Controller would do: creating Jobs / Pods automatically.

---
### 🤖 Behind the Scenes – Reconciliation Loop

- Watcher – Listens for BackUp CR events
- Reconciler – Compares desired state (CR) vs actual state (Jobs/Pods)
- Actuator – Creates / updates / deletes Jobs to match the CR

💡 Example: CR requests `backup-script:v2.0` → Controller spins up a Job with that image automatically

---
## 🧠 Key Takeaways
- CRDs extend the Kubernetes API with **new resource types**
- Custom Resources only store **desired state**, they do not act by themselves
- Controllers/Operators reconcile the **desired state** with the **actual state**
- Without a Controller, a CR is just **pure configuration**
- CKAD focuses on **using CRDs**, not writing Operators

---
## 🔗 References
- Lab → [LAB 01 – Custom Backup Service (CRD)](../../../labs/extending-k8s/lab01-crd-custom-backup-service/README.md)
---
## ✅ Exam Tips (CKAD)

You may be asked to:

- Inspect existing CRDs (`kubectl get crd`)
- Create Custom Resource instances (`kubectl apply -f ...`)
- Understand who is responsible for acting on them

You will **NOT** be asked to:

- Write Go controllers
- Build full Operators