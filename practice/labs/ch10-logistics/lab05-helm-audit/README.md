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

1. **Audit the Catalog (Helm List):** Find all Helm releases in all "Wings" (Namespaces) and save the list to `/root/releases`.
2. **Decommission a Store (Helm Uninstall):** Remove the Helm release named `apiserver` from the `team-yellow` wing.
3. **Install Safety Kit (Helm Install):** Install the `falcosecurity/falco` chart into the `team-yellow` namespace. Name the release `dev`.

---

## 🛠️ Step-by-Step Solution

### 1. Audit the Catalog
Check the global inventory and export it to the ledger.
```bash
# List all releases in all namespaces
helm ls -A > /root/releases
```

### 2. Cleanup Defunct Managers
Remove the specialized manager that is no longer needed.
```bash
# Always check where the release is located first
helm ls -A | grep apiserver

# Uninstall the apiserver release from team-yellow
helm -n team-yellow uninstall apiserver
```

### 3. Install the New Safety Kit
Add the safety equipment provider to the Mall's registry.
```bash
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update

# Install the kit named 'dev' into the yellow wing
helm -n team-yellow install dev falcosecurity/falco
```

---

## 🔎 Verification

1. **Check the Ledger:**
   ```bash
   cat /root/releases
   # Should list all previously installed kits.
   ```

2. **Verify Deletion:**
   ```bash
   helm ls -A | grep apiserver
   # Should return nothing.
   ```

3. **Verify New Install:**
   ```bash
   helm -n team-yellow list
   # Should show 'dev' as 'deployed'.
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
