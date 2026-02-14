# LAB 01 – Creating a Custom Backup Service (CRD)

## 🎯 Objective
Learn how Kubernetes can be extended using **Custom Resource Definitions (CRDs)**  
by introducing a new resource type: **BackUp**.

## 🛍️ Mall Analogy
By default, Mall Management only understands:
- Stores → Deployments
- Pick-up Points → Services
- Licenses → Pods

We introduce a **new permit type**:  
👉 **Nightly Backup Service**

---

## 📁 Lab Files

This lab uses the following manifests:

- `00-crd-backup.yaml`
  - Defines the **Custom Resource Definition**
  - Extends the Kubernetes API with a new resource: `BackUp`

- `01-backup-instance.yaml`
  - Defines a **Custom Resource instance**
  - Represents a concrete Nightly Backup request

- `02-simulated-controller-job.yaml`
  - Simulates the Controller creating the actual Job/Pod

---

## 🧩 Step 1 – Register the New Permit Type (CRD)

Register a new resource type in the Kubernetes API.

```bash
kubectl apply -f 00-crd-backup.yaml
kubectl api-resources | grep backup
```
✔️ The Mall Rulebook now includes **BackUp permits**
✔️ The API server now recognizes `kind: BackUp`

---
## 🧾 Step 2 – Request a Backup Service (Custom Resource)
```bash
kubectl apply -f 01-backup-instance.yaml
kubectl get bks
```
At this stage:
- ✅ The request exists in etcd
- ❌ No Pod / Job is created

**Why?**

👉 A CR only describes desired state
👉 No Controller is managing BackUp resources yet

This is expected behavior.

---
## 🤖 Step 3 – Simulating the Controller Action

In a real-world Operator:

- A Controller watches BackUp resources
- It reconciles desired state with actual state
- It creates Jobs / Pods accordingly

For **CKAD purposes**, we simulate this behavior manually:
```bash
kubectl apply -f 02-simulated-controller-job.yaml
kubectl get jobs
kubectl logs job-nightly-backup
```
This Job represents what a Controller **would** create after observing the CR.

---

## 🧠 Key Takeaways
- CRDs extend the Kubernetes API
- Custom Resources store **desired state**
- Controllers perform the reconciliation loop
- Without a Controller, a CR is pure configuration
- CKAD focuses on **using CRDs**, not writing Operators

---

## ✅ Exam Tips (CKAD)

You may be asked to:

- Inspect existing CRDs (`kubectl get crd`)
- Create Custom Resource instances (`kubectl apply -f ...`)
- Understand who is responsible for acting on them

You will **NOT** be asked to:
- Write Go controllers
- Build full Operators