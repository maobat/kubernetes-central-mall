<img src="lab01-crd-nightly-backup_II.png" alt="The Nightly Backup Permit" width="40%" />

# 🗂️ The Nightly Backup Permit

This comic explains:

- what a **Custom Resource Definition (CRD)** really is
- why creating a **Custom Resource (CR)** does nothing by itself
- who turns intent into action (**Controllers / Operators**)
- how the **Reconciliation Loop** works

Read this if:
- you are working on [LAB 01](../../../../practice/labs/ch04-extending/lab01-crd-custom-backup-service/README.md)
- you want to understand CRDs and Operators.
- you are preparing for the CKAD exam.

## 🔗 References
- Docs → [Extending K8s: CRDs & Operators](../../../../sources/study-guide/ch04-extending-k8s.md)
- Lab → [LAB 01 – Creating a Custom Backup Service (CRD)](../../../../practice/labs/ch04-extending/lab01-crd-custom-backup-service/README.md)

---

### 📖 Comic Script: The Secret of Custom Resources (4 Panels)

---

#### **Panel 1: The Limit**
**Mall Manager (Kubernetes):**
> <i>“I only understand Deployments and Services.”</i>

**Narrator:**
Backups are not a native Kubernetes concept.

**❌ No CRD → No Backup**



---

#### **Panel 2: The New Word (CRD)**
**Engineer:**
> <i>“I’ll teach you a new resource: `Backup`.”</i>

```yaml
# kubectl apply -f backup-crd.yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.mall.com
```
---

**Narrator**:
Kubernetes now recognizes Backup objects, but still does nothing.

⚠️ **CRD = definition only**

**Panel 3: The Request**
**Shop Owner:**

> <i>I want a nightly backup.</i>

```yaml
# kubectl apply -f backup.yaml
apiVersion: [mall.com/v1](https://mall.com/v1)
kind: Backup
metadata:
  name: nightly-inventory
spec:
  schedule: "0 0 * * *"
```

**Mall Manager:**
> "Request received and stored in the Ledger."

**Narrator:**
The resource is now in etcd, but nothing happens.

📄 **Intent recorded, no execution**

---
**Panel 4: The Controller**

**Backup Controller:**

> <i>I see a Backup request!</i>

**Controller:**

> <i>I’ll create a Job → Pod to run it.</i>

**Narrator:**
This loop runs forever.

✅ CRD + Controller = Real behavior

🔁 **Reconciliation Loop**

---
## 🧠 Key Takeaways

- CRDs extend the Kubernetes API
- CRs only store **desired state**
- Controllers reconcile desired vs actual state
- Without a Controller, nothing happens

---

## 🔗 References
- Chapter → [Chapter 4: Extending K8s](../../../../sources/study-guide/ch04-extending-k8s.md)
