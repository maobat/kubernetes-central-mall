# 🧪 LAB 06: The Departmental Pass (Namespaced [RBAC](../../../../GLOSSARY.md#rbac))

## Identity & Access – Restricting Scope

---

## 🎯 Lab Goal

This lab focuses on **Namespaced [RBAC](../../../../GLOSSARY.md#rbac)**. You will learn how to:
- Create a **[ServiceAccount](../../../../GLOSSARY.md#serviceaccount)** for a specific department.
- Define a **[Role](../../../../GLOSSARY.md#role)** that is restricted to a single **[Namespace](../../../../GLOSSARY.md#namespace)**.
- Verify that permissions are enforced within the [namespace](../../../../GLOSSARY.md#namespace) and rejected everywhere else.

> **CKAD Importance:** High. The exam frequently asks you to restrict access to a specific [namespace](../../../../GLOSSARY.md#namespace) for security and multi-tenancy.

---

## 🛍️ Mall Analogy

In the **Central Mall**, not all badges work in all hallways.

- **The Department Badge ([ServiceAccount](../../../../GLOSSARY.md#serviceaccount))** → Identifies a worker as part of `dev-team-1`.
- **The Office Rules ([Role](../../../../GLOSSARY.md#role))** → A rulebook that says: "You can read the files in the `dev-team-1` office, but nowhere else."
- **The Office Door (RoleBinding)** → Attaching the badge to the internal office rules.
- **The Department Wall ([Namespace](../../../../GLOSSARY.md#namespace))** → A physical barrier. Even if you have the rules, they mean nothing once you step outside your department's wall.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[Namespace](../../../../GLOSSARY.md#namespace)** | A self-contained department or office. |
| **[ServiceAccount](../../../../GLOSSARY.md#serviceaccount)** | A worker's departmental identity. |
| **[Role](../../../../GLOSSARY.md#role)** | Rules valid only inside a specific department. |
| **RoleBinding** | Linking the identity to the departmental rules. |

---

## 📋 Requirements

1. **[Namespace](../../../../GLOSSARY.md#namespace)**: Use `dev-team-1` (assume it already exists).
2. **[ServiceAccount](../../../../GLOSSARY.md#serviceaccount)**: Create `pod-viewer-sa` in `dev-team-1`.
3. **[Role](../../../../GLOSSARY.md#role)**: Create `pod-reader-role` in `dev-team-1` with `get, list, watch` on `pods`.
4. **RoleBinding**: Create `pod-viewer-binding` in `dev-team-1` to link the SA and [Role](../../../../GLOSSARY.md#role).
5. **Validation**: Prove that the SA can list pods in `dev-team-1` but NOT in `default`.

---

## 🛠️ Step-by-Step Solution

### 1. Print the Department Badge (SA)
```bash
kubectl create sa pod-viewer-sa -n dev-team-1
```

### 2. Write the Office Rules ([Role](../../../../GLOSSARY.md#role))
```bash
kubectl create role pod-reader-role \
  --resource=pods \
  --verb=get,list,watch \
  -n dev-team-1
```

### 3. Clip the Rules to the Badge (Binding)
```bash
kubectl create rolebinding pod-viewer-binding \
  --role=pod-reader-role \
  --serviceaccount=dev-team-1:pod-viewer-sa \
  -n dev-team-1
```

---

## 🔎 Verification

### 1. The Department Drill (Success)
Verify the worker can read files in their own office:
```bash
kubectl auth can-i list pods \
  --as=system:serviceaccount:dev-team-1:pod-viewer-sa \
  -n dev-team-1
# Expected Output: yes
```

### 2. The Intruder Drill (Failure)
Verify the worker is blocked from other departments:
```bash
kubectl auth can-i list pods \
  --as=system:serviceaccount:dev-team-1:pod-viewer-sa \
  -n default
# Expected Output: no
```

---

## 🧠 Key Takeaways

- **Scope:** Unlike ClusterRoles, standard **Roles** are locked to a [namespace](../../../../GLOSSARY.md#namespace). If you don't specify a [namespace](../../../../GLOSSARY.md#namespace) in the Binding, it defaults to `default`.
- **Isolation:** [RBAC](../../../../GLOSSARY.md#rbac) in one [namespace](../../../../GLOSSARY.md#namespace) has zero impact on another, unless you use ClusterRoles.
- **CKAD Tip:** When using `--as` for a [ServiceAccount](../../../../GLOSSARY.md#serviceaccount), the prefix `system:serviceaccount:<namespace>:<name>` is mandatory.

---

## 🔗 References
- **Comic** → [The Secure Badge](../../../../visual-learning/comics/ch07-identity/01-the-secure-badge/README.md)
- **Study Guide** → [Chapter 7: Identity & Access](../../../../sources/study-guide/ch07-identity.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
