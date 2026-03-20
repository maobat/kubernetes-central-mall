# 🧪 LAB 05: The Mall Catalog Audit (Helm Management)

## Logistics Tools – Inventory & Decommissioning

---

## 🎯 Lab Goal

Learn how to audit and manage installed application packages in the Mall. You will practice listing all current "Prefab Kits" (Helm releases), exporting the inventory, and uninstalling defunct managers.

> **CKAD Importance:** Medium. Fast retrieval of Helm release information and basic lifecycle management (uninstall/install) are common tasks in the "Application Deployment" section.

---

## 🛍️ Mall Analogy

In the **Central Mall**, some services are provided by external partners.

- **The Shop Catalog (Helm Repo)** → The master list of all available "Shop-in-a-Box" kits.
- **The Active Manager (Helm Release)** → When a kit is installed, it becomes an "Active Manager" for that shop.
- **The Ledger Audit (Helm List)** → A manager checking all wings of the mall to see which specialized kits are currently being used.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Helm Release** | An installed instance of a prefab kit. |
| **Helm List -A** | A mall-wide audit of all specialized managers. |
| **Helm Uninstall** | Formally decommissioning a specialized shop manager. |

---

## 📋 Requirements

The Mall Logistics department needs to audit existing kits and install new safety equipment.

1. **Install Safety Kit (Helm Install):** Install the `falcosecurity/falco` chart into the `team-yellow` namespace. Name the release `dev`.
2. **Audit & Check (Helm List):** Verify that the new kit is running and export the list of all Mall releases to `releases`.
3. **Decommission a Store (Helm Uninstall):** Remove the Helm release named `dev` (the one you just installed) to clean up the wing.

---

## 🛠️ Step-by-Step Solution

### 1. Install the New Safety Kit
Add the safety equipment provider and install the "Falco" health scanner.
```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

# Install the kit named 'dev' into the yellow wing
helm -n team-yellow install dev falcosecurity/falco
```

### 2. Audit and Check
Verify the installation and export the global inventory to the ledger.
```bash
# Verify 'dev' is deployed
helm -n team-yellow list

# List all releases in all namespaces and save to a file
helm ls -A > releases
```

### 3. Decommission the Kit
Remove the specialized manager once the audit is complete.
```bash
# Uninstall the 'dev' release from team-yellow
helm -n team-yellow uninstall dev
```

---

## 🔎 Verification

1. **Check the Ledger:**
   ```bash
   cat releases
   # Should list 'dev' (proving it was installed in Step 1 and audited in Step 2).
   ```

2. **Verify Decommissioning:**
   ```bash
   helm ls -A | grep dev
   # Should return nothing (proving Step 3 worked).
   ```

---

## 🧠 Key Takeaways

- **Global Scope:** Always use `-A` when auditing, or you might miss kits installed in specialized mall wings.
- **Cleanup:** Uninstalling a release via Helm ensures all associated resources (Pods, Services, etc.) are removed cleanly.
- **Naming:** The "Release Name" (like `dev`) is your way of identifying that specific instance of a kit.

---

## 🔗 References
- **Comic** → [Logistics Chain](../../../../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
- **Docs** → [Helm Command Line Reference](https://helm.sh/docs/helm/helm/)
- **Study Guide** → [Chapter 10: Management](../../../../sources/study-guide/ch10-management.md)
