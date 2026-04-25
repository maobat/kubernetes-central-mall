# 🧪 LAB 02: The Nightly Backup Permit (Custom Resources)

## Architecture – Extending Kubernetes with CRDs

---

## 🎯 Lab Goal

Learn how Kubernetes can be extended using **Custom Resource Definitions (CRDs)**. You will introduce a new resource type, **BackUp**, to the cluster's "Rulebook" and see how it differs from a standard resource.

> **CKAD Importance:** Medium. You should know how to identify and create custom resources, even if you don't write the Controller logic.

---

## 🛍️ Mall Analogy

By default, Mall Management only understands standard stores (Deployments) and permits (Pods). But what if you want a **Nightly Backup [Service](../../../../GLOSSARY.md#service)** for all shops?

- **The Rulebook Extension ([CRD](../../../../GLOSSARY.md#crd))** → Adding a new type of permit to the Mall's computer system. Now the manager can recognize the word "BackUp."
- **The Backup [Request](../../../../GLOSSARY.md#request) (Custom Resource)** → A specific shop owner filling out the new "BackUp Permit" form. "Please back up my vault at 2:00 AM."
- **The Specialized Manager (Controller/[Operator](../../../../GLOSSARY.md#operator))** → A dedicated staff member whose *only* [job](../../../../GLOSSARY.md#job) is to watch for "BackUp Permits" and hire workers to do the actual work.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[CRD](../../../../GLOSSARY.md#crd)** | The definition of a new permit type (BackUp). |
| **Custom Resource (CR)** | A specific instance of that permit (Joe's-Backup). |
| **Controller** | The staff member who reconciles the permit into action. |

---

## 📋 Requirements

1. **Register the [CRD](../../../../GLOSSARY.md#crd)**: Add the `BackUp` resource type to your cluster.
2. **Submit a [Request](../../../../GLOSSARY.md#request)**: Create an instance of a `BackUp` resource.
3. **Simulate the Action**: Understand why a CR needs a Controller to actually *do* something.

---

## 🛠️ Step-by-Step Solution

### 1. Register the Rule ([CRD](../../../../GLOSSARY.md#crd))
Apply the definition so Kubernetes learns what a "BackUp" is.
```bash
k apply -f 00-crd-backup.yaml
k api-resources | grep backup
# You should see 'backups' or 'bks' in the list now!
```

### 2. File the [Request](../../../../GLOSSARY.md#request) (CR Instance)
Submit a desired state. "I want a backup of my MariaDB vault."
```bash
k apply -f 01-backup-instance.yaml
k get bks
# The request is accepted and stored in the database (etcd).
```

### 3. Simulating the Controller
Notice that `k get pods` shows nothing new. This is because we haven't hired the "Specialized Manager" ([Operator](../../../../GLOSSARY.md#operator)) yet. In this lab, we simulate the manager by manually running the [job](../../../../GLOSSARY.md#job) they would have created:
```bash
k apply -f 02-simulated-controller-job.yaml
```

---

## 🔎 Verification

1. **Check API Knowledge:**
   ```bash
   k explain backups
   # If this works, the cluster successfully learned the new permit!
   ```

2. **Check the Jobs:**
   ```bash
   k get jobs
   k logs job/nightly-backup
   ```

---

## 🧠 Key Takeaways

- **Custom API:** CRDs allow you to create your own "verbs" and "nouns" in Kubernetes.
- **Desired State:** Like a [Pod](../../../../GLOSSARY.md#pod), a CR only describes what you *want*. You need a **Controller** to make it happen (Actual State).
- **CKAD Tip:** If an exam question asks you to "List all resources of type X" and standard `k get` doesn't work, first check `k api-resources` to see if it's a Custom Resource.

---

## 🔗 References
- **Comic** → [The Nightly Backup Permit](../../../../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- **Docs** → [Understanding CRDs](../../../../reference/md-resources/understanding-custom-resource-definitions-crds.md)
- **Study Guide** → [Chapter 4: Extending K8s](../../../../sources/study-guide/ch04-extending-k8s.md)
---
[Mall Directory ✨](../../../../GLOSSARY.md)
