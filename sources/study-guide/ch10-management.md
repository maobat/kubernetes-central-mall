# 📖 Chapter 10: Logistics Tools
*Shipping Containers (Helm & Kustomize)*

In the **Central Mall**, if a corporation like "Nginx-Corp" wants to open a store, they don`t send a construction crew with raw bricks. They send a **Shipping Container** (Helm Chart) that includes the walls, the staff, the manual, and the keys—all ready to be unpacked in one go.

---

## 🎭 10.1 Helm: The Package Manager

**Helm** is like a "Store-in-a-Box." It allows you to package all your Kubernetes YAML files into a single bundle called a **Chart**.

| Term | Mall Analogy | K8s Concept |
| :--- | :--- | :--- |
| **Chart** | The Box containing all store blueprints. | A collection of YAML templates. |
| **Values** | The "Order Form" (Change the color, name, or size). | The `values.yaml` file that customizes the chart. |
| **Release** | The actual store instance built from the box. | A running deployment managed by Helm. |



---

## 🎭 10.2 Kustomize: The Layered Template

**Kustomize** is a bit different. It doesn`t use boxes; it uses **Overlays**. Imagine you have a standard blueprint, and you place a transparent sheet over it to change the "Production" store from the "Development" store.

* **Base:** The original, standard blueprint.
* **Overlay:** The changes (e.g., "In Production, use 10 replicas instead of 1").



---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. The Helm Toolkit
You might be asked to search for a package or install one during the exam.
```bash
# Search the warehouse for Nginx
helm search repo nginx

# Install the store with a specific name
helm install my-store bitnami/nginx

# See all your active stores
helm list
```

### 2. The Kustomize Toolkit
Kubernetes has Kustomize built-in! You don`t even need an extra tool.
```bash
# Preview the final blueprint after overlays are applied
kubectl kustomize ./overlays/production

# Deploy the final version
kubectl apply -k ./overlays/production
```

---

## ⚠️ Common Exam Traps
- **Apply `-k` vs `-f`:** When deploying a Kustomization directory, you MUST use `kubectl apply -k <dir>`. If you use `-f`, it will ignore the `kustomization.yaml` and try to apply plain files, which usually fails or results in the wrong configuration.
- **Extracting Values:** When working with Helm, you often need to fetch the default values before customizing them. Use `helm show values <repo/chart> > values.yaml`, modify the file, and then deploy it using `helm install -f values.yaml`.

---

### 🧰 Study Toolbox

### 📦 Helm (The Package Manager)
* 🖼️ **Comic:** [The Logistics Chain - Deploying at Scale](../../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
* 📄 **Doc:** [Using the Helm Package Manager](../../reference/md-resources/using-the-helm-package-manager.md)
* 📄 **Doc:** [Working with Helm Charts](../../reference/md-resources/working-with-helm-charts.md)
* 🧪 **Lab:** [Lab 05: Helm Catalog Audit](../../practice/labs/ch10-logistics/lab05-helm-audit/README.md)
* 🧪 **Lab:** [Lab 06: Prefab Stores & Blueprint Overlays](../../practice/labs/ch10-logistics/lab06-helm-packages/README.md)
* 🧪 **Lab:** [Architecture: CRDs & Operators (Helm Section)](../../practice/labs/ch04-extending/lab04-crds-operators/README.md#4-the-store-in-a-box-helm)

### 🧩 Kustomize (Blueprint Overlays)
* 🖼️ **Comic:** [The Logistics Chain - Deploying at Scale](../../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
* 📄 **Doc:** [Using Kustomize (Transparent Sheet Method)](../../reference/md-resources/using-kustomize.md)

---
[<< Previous: Launch Strategies](ch09-deployments.md) | [Back to Story Index](../story.md) | [Next: Intercoms & Delivery Bays >>](ch11-services.md)
