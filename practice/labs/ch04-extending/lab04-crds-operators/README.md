# Lab 04 – Architecture: CRDs & Operators

## Working with Special Permits

---

## 🎯 Lab Goal

This lab introduces you to **Custom Resource Definitions (CRDs)** and **Operators**. While you won't write an Operator from scratch in the CKAD exam, you **must** know how to:

- Identify custom resources in a cluster.
- Interact with specialized objects (CRs).
- Understand how Helm simplifies the deployment of complex systems.

---

## 📖 Related Comic
👉 [visual-learning/comics/ch04-extending/04-operators/README.md](../../../../visual-learning/comics/ch04-extending/04-operators/README.md)

It explains the relationship between Permits (CRDs) and Managers (Operators).

---

## 📘 Reference Docs

- Custom Resources → [Understanding CRDs](../../../../reference/md-resources/understanding-custom-resource-definitions-crds.md)
- Operator Pattern → [Kubernetes: Operator pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)

---

## 📋 Requirements

1. **List** all Custom Resource Definitions currently active in the "Mall".
2. **Find** all instances of a specific custom resource (e.g., `prometheuses`).
3. **Inspect** a custom resource to see its specialized fields.
4. **Learn** how to install a suite of tools (like a "Store-in-a-Box") using Helm.

---

## 🏬 Mall Analogy

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| **CRD** | **The Permit Type** (Defining what a 'Solar Panel' shop is). |
| **Custom Resource** | **The Specific Permit** (The permit for 'Joe's Solar Shop'). |
| **Operator** | **The Specialized Manager** (Someone who knows how to fix solar panels). |
| **Helm Chart** | **The Store-in-a-Box Kit** (All the permits and furniture in one box). |

---

## 🛠️ Solution

### 1️⃣ Checking for Special Permits

How do we see what "non-standard" things this cluster understands?

```bash
kubectl get crd
```

*Look for names like `prometheuses.monitoring.coreos.com` or `backups.example.com`.*

### 2️⃣ Listing Specific Resources

Once you know a CRD exists, you can list its instances just like Pods:

```bash
# Example: If a 'Backup' CRD exists
kubectl get backups
```

### 3️⃣ Inspecting the Permit (The Spec)

Custom resources have their own fields defined in the CRD. Check a specific one:

```bash
kubectl describe <resource-type> <resource-name>
```

*Notice the `Spec:` section—these fields are specific to that application!*

### 4️⃣ The "Store-in-a-Box" (Helm)

Sometimes, instead of one permit, you need a whole kit. Helm handles this.

```bash
# Search for a package
helm search repo bitnami

# Install a package (The Store-in-a-Box)
helm install my-release bitnami/nginx
```

✅ **You now know how to extend the Mall's capabilities!**

---

## 📖 Related Chapter
👉 [sources/study-guide/ch04-extending-k8s.md](../../../../sources/study-guide/ch04-extending-k8s.md)
