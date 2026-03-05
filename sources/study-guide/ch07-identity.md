# 📖 Chapter 7: Identity & Access (RBAC)
*The Magnetic ID Badge*

In the **Central Mall**, security isn't just about locks; it's about **Permissions**. A "ServiceAccount" is the ID badge for a worker, a "Role" is the list of doors that badge can open, and a "Binding" is the act of handing that badge to a specific person.

---

## 🎭 7.1 The Security Trio

To give a worker access to the "Backroom" (The API), you need three things:

| Component | Mall Analogy | K8s Concept |
| :--- | :--- | :--- |
| **ServiceAccount** | **The Badge** | The identity of the Pod. |
| **Role** | **The Keycard Access List** | Defines *what* can be done (get, list, watch). |
| **RoleBinding** | **The Hand-off** | Connects the Badge to the Access List. |



---

## 🛠️ 7.2 The Blueprint: Creating Access

In the CKAD, you often need to give a Pod permission to "list" other Pods in its neighborhood.

### 1. Create the Badge (ServiceAccount)
```bash
kubectl create serviceaccount mall-clerk
```

### 2. Create the Access List (Role)
This list says: "You can look at Pods, but you cannot delete them."
```bash
kubectl create role pod-viewer --verb=get,list,watch --resource=pods
```

### 3. Bind the Badge to the List (RoleBinding)
```bash
kubectl create rolebinding clerk-view-access --role=pod-viewer --serviceaccount=default:mall-clerk
```

---

## 🛠️ 7.3 Using the Badge in a Shop

By default, every shop gets a "Standard" badge that can't do much. If your clerk needs the specialized `mall-clerk` badge, you must specify it in the blueprint.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: api-aware-shop
spec:
  serviceAccountName: mall-clerk # Using the Magnetic ID Badge
  containers:
  - name: clerk
    image: nginx
```



---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. The "Can I?" Check
This is the most important command in the exam. It lets you test permissions without actually running a Pod.
```bash
# Can the mall-clerk list pods?
kubectl auth can-i list pods --as=system:serviceaccount:default:mall-clerk
```

### 2. Cluster-Wide Access
If a worker needs to see shops in **every** floor of the mall (all Namespaces), use a **ClusterRole** instead of a Role.

---

## ⚠️ Common Exam Traps
- **Forgetting the Binding:** Creating a `ServiceAccount` and a `Role` does absolutely nothing until you create a `RoleBinding` to connect them. If your Pod gets "Forbidden" errors, check the binding first!
- **Cross-Namespace Bindings:** A `RoleBinding` in `namespace-a` can reference a `Role` in `namespace-a` and bind it to a `ServiceAccount` in `namespace-b`. Pay close attention to the `--serviceaccount=<namespace>:<name>` syntax in the exam.

---

### 🧰 Study Toolbox

* 🖼️ **Comic:** [The Secure Badge - Pod Identity](../../visual-learning/comics/ch07-identity/01-the-secure-badge/README.md)
* 🖼️ **Comic:** [The HR Manual (Role)](../../visual-learning/comics/ch07-identity/02-the-hr-manual/README.md)
* 🖼️ **Comic:** [The Entry Permit Office (Admission Control)](../../visual-learning/comics/ch07-identity/03-admission-control/README.md)
* 🧪 **Lab:** [Implementing RBAC (The HR Process)](../../practice/labs/ch07-identity/lab02-rbac-identity/README.md)
* 🧪 **Lab:** [Entry Permit Office (Admission Control)](../../practice/labs/ch07-identity/lab03-admission-control-entry-permit/README.md)
* 📄 **Doc:** [Understanding Role-Based Access Control (RBAC)](../../reference/md-resources/understanding-role-based-access-control-rbac.md)

---
[<< Previous: Security](ch06-security.md) | [Back to Story Index](../story.md) | [Next: Resources & Quotas >>](ch08-resources.md)
