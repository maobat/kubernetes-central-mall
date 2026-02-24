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

### 🧰 Study Toolbox

* 🖼️ **Comic:** [The Secure Badge - Pod Identity](../../comics/security/01-the-secure-badge/README.md)
* 🧪 **Lab:** [Implementing RBAC (The HR Process)](../../docs/md-resources/implementing-rbac-with-roles-and-bindings-the-hr-process.md)
* 📄 **Doc:** [Understanding Role-Based Access Control (RBAC)](../../docs/md-resources/understanding-role-based-access-control-rbac.md)

---
[<< Previous: Security](ch06-security.md) | [Back to Story Index](../story.md) | [Next: Resources & Quotas >>](ch08-resources.md)
