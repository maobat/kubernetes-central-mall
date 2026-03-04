# 🧪 LAB 04: The Specialized Managers (Operators & Helm)

## Architecture – Working with Special Permits & Kits

---

## 🎯 Lab Goal

This lab introduces you to **Custom Resource Definitions (CRDs)**, **Operators**, and **Helm**. While you won't write an Operator code in the exam, you must know how to interact with specialized objects and use Package Managers.

> **CKAD Importance:** Medium. You should be comfortable listing CRDs and using Helm to install or uninstall charts.

---

## 🛍️ Mall Analogy

In the **Central Mall**, some projects are too complex for the general manager.

- **The Specialized Manager (Operator)** → A consultant who knows *exactly* how to manage complex equipment (like Solar Panels or Databases). They watch for specific permits (CRs) and take care of the technical details.
- **The Permit Type (CRD)** → The application form for a specialized service.
- **The Store-in-a-Box Kit (Helm Chart)** → Instead of buying bricks, glass, and wood separately, you buy a pre-packaged kit. One command (`helm install`) and the whole shop is built immediately with all the right parts.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **CRD** | The definition of a non-standard permit. |
| **Operator** | The smart manager watching the CRD. |
| **Helm** | The toolkit for "Store-in-a-Box" deployments. |

---

## 📋 Requirements

1. **Investigate Permits**: List all Custom Resource Definitions in the cluster.
2. **Find Instances**: Search for specialized resources (e.g., Monitoring).
3. **Inspect a Kit**: Use Helm to see what packages are available in the Mall's warehouse.
4. **Deploy a Kit**: Practice basic Helm commands.

---

## 🛠️ Step-by-Step Solution

### 1. Identify Special Permits (CRDs)
Check what non-standard objects the Mall understands.
```bash
k get crd
# Look for prometheuses.monitoring.coreos.com or similar.
```

### 2. Find the Instances
Once you know the name, list the actual permits:
```bash
# Get the short name or the full name from step 1
k get <crd-name-here>
```

### 3. The Package Manager (Helm)
Helm lets you install multi-resource applications with one command.
```bash
# Search for the Nginx kit
helm search repo bitnami/nginx

# Install the kit
helm install my-shop bitnami/nginx
```

---

## 🔎 Verification

1. **Check Install History:**
   ```bash
   helm list
   # Verify your 'my-shop' kit is 'deployed'.
   ```

2. **Describe a CR:**
   ```bash
   k describe <type> <name>
   # Look at the 'Spec' section—these fields are specific to that application!
   ```

---

## 🧠 Key Takeaways

- **CRDs vs CRs:** CRD is the "class" (template); CR is the "object" (instance).
- **Automation:** Operators automate operational tasks like backups and scaling.
- **Package Management:** Helm is the "App Store" for Kubernetes. It groups multiple YAMLs into one "Chart."
- **CKAD Tip:** If you see a resource you don't recognize in the exam (e.g. `CertRequest`), it is likely a Custom Resource. Use `k describe` to understand it.

---

## 🔗 References
- **Comic** → [Operators](../../../../visual-learning/comics/ch04-extending/04-operators/README.md)
- **Docs** → [Custom Resources](../../../../reference/md-resources/understanding-custom-resource-definitions-crds.md) | [Operator Pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)
- **Study Guide** → [Chapter 4: Extending K8s](../../../../sources/study-guide/ch04-extending-k8s.md)
