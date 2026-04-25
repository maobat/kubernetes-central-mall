<img src="hr-manual.png" alt="The HR Manual - Role" width="40%" />

# 🖼️ Comic: The HR Manual
## Chapter 07: Identity – RBAC Role

In the **Central Mall**, security isn't just a badge; it's a **Permit**. The **HR Manual** contains the standard job descriptions that define exactly what an employee is allowed to do in a specific shop.

---

## 🛍️ Mall Analogy

- **The Shop floor (Namespace)** → Where the work happens.
- **The Job Description (Role)** → A specific entry in the HR Manual that lists allowed activities.
- **The Detailed Actions (Verbs)** → What the worker can actually do:
  - **Get/List** → Look at the shop ledgers.
  - **Create** → Stock new items on the shelves.
  - **Update** → Change the price tags.
- **The Scope** → A standard **Role** only applies to a single shop (Namespace). For mall-wide authority, you need a **ClusterRole**.

> 📖 *You can't sell jewelry if your manual only says you're a florist.*

---

## 🧠 Key Takeaways

- **Least Privilege:** Roles allow you to grant only the specific permissions a Pod needs to do its job.
- **Namespaced:** A `Role` is always bound to a specific namespace.
- **Verbs and Resources:** Kubernetes permissions are built on a "Verb + Resource" model (e.g., `get pods`, `list secrets`).
- **CKAD Tip:** If the exam asks you to grant permissions across the *entire cluster*, use a `ClusterRole`. If it's just for one namespace, use a regular `Role`.

---

## 🔗 References
- **Study Guide** → [Chapter 7: Identity & Access](../../../../sources/study-guide/ch07-identity.md)
- **Lab** → [Lab 02 - RBAC & Identity](../../../../practice/labs/ch07-identity/lab02-rbac-identity/README.md)
- **Docs** → [Understanding RBAC](../../../../reference/md-resources/understanding-role-based-access-control-rbac.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
