# 🧪 LAB 01: The Mall Catalog Audit ([Helm](../../../../GLOSSARY.md#helm) Management)

## Logistics Tools – Inventory & Decommissioning

---

## 🎯 Lab Goal

Learn how to audit and manage installed application packages in the Mall. You will practice listing all current "Prefab Kits" ([Helm](../../../../GLOSSARY.md#helm) releases), exporting the inventory, and uninstalling defunct managers.

---

## 🛍️ Mall Analogy

In the **Central Mall**, some services are provided by external partners.

- **The Shop Catalog ([Helm](../../../../GLOSSARY.md#helm) Repo)** → The master list of all available "Shop-in-a-Box" kits.
- **The Active Manager ([Helm](../../../../GLOSSARY.md#helm) Release)** → When a kit is installed, it becomes an "Active Manager" for that shop.
- **The Ledger Audit ([Helm](../../../../GLOSSARY.md#helm) List)** → A manager checking all wings of the mall to see which specialized kits are currently being used.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[Helm](../../../../GLOSSARY.md#helm) Release** | An installed instance of a prefab kit. |
| **[Helm](../../../../GLOSSARY.md#helm) List -A** | A mall-wide audit of all specialized managers. |
| **[Helm](../../../../GLOSSARY.md#helm) Uninstall** | Formally decommissioning a specialized shop manager. |

---

## 📋 Requirements

The Mall Logistics department needs to audit existing kits and install new safety equipment.

1. **Install Safety Kit:** Install the `falcosecurity/falco` chart into the `team-yellow` [namespace](../../../../GLOSSARY.md#namespace). Name the release `dev`.
2. **Audit & Check:** Verify that the new kit is running and export the list of all Mall releases to `releases`.
3. **Decommission a Store:** Remove the [Helm](../../../../GLOSSARY.md#helm) release named `dev` to clean up the wing.

---

## 🛠️ Step-by-Step Solution

### 1. Install the New Safety Kit
```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update
helm -n team-yellow install dev falcosecurity/falco
```

### 2. Audit and Check
```bash
helm -n team-yellow list
helm ls -A > releases
```

### 3. Decommission the Kit
```bash
helm -n team-yellow uninstall dev
```

---

## 🔎 Verification

1. **Check the Ledger:**
   ```bash
   cat releases
   # Should list 'dev'
   ```

2. **Verify Decommissioning:**
   ```bash
   helm ls -A | grep dev
   # Should return nothing.
   ```

---

## 🧠 Key Takeaways

- **Global Scope:** Always use `-A` when auditing to see all namespaces.
- **Cleanup:** Uninstalling via [Helm](../../../../GLOSSARY.md#helm) removes all associated k8s objects.

---

## 🔗 References
- **Comic** → [The Logistics Chain](../../../../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
- **Docs** → [Helm CLI](https://helm.sh/docs/helm/helm/)
- **Study Guide** → [Chapter 10: Management](../../../../sources/study-guide/ch10-management.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
