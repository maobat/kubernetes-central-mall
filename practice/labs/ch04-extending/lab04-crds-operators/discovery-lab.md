# 🧪 LAB 04b: The Architect's Ledger (CRD Discovery)

## Architecture – API Extension Discovery & Resource Auditing

---

## 🎯 Lab Goal

Master the art of **API extension discovery** and **resource auditing**. You will learn how to identify newly registered "Rulebook" extensions (CRDs) and track their instances (Custom Objects) across the entire Mall.

> **CKAD Importance:** Medium. Auditing custom resources using `kubectl get crd` and `kubectl get <resource> -A` is a vital skill for navigating environments with complex Operators.

---

## 🛍️ Mall Analogy

In the **Central Mall**, some projects use non-standard permits.

- **The Shop Registry (CRD)** → Adding a new type of shop to the mall's legal charter (e.g., "Virtual Reality Lounge") that wasn't in the original blueprints. 
- **The Active Ledger (Custom Objects)** → Once the charter is updated, you can start tracking the actual "VR Lounge" instances (Custom Objects) running in different wings of the mall.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **CRD** | The definition of a new shop type in the charter. |
| **Custom Resource (CR)** | A specific instance of that shop in a wing. |
| **Namespaced Discovery** | Checking all wings (-A) for specialized shops. |

---

## 📋 Requirements

The Mall has been extended with custom database backup services. As the Architect, you need to audit these new extensions for the Management Office.

1. **Audit the Charter**: Export the list of all "Blueprints" (CRDs) installed in the Mall to `/root/crds`.
2. **Track the Instances**: Find all "Active Backup Units" (`DbBackup` objects) across all Wings (Namespaces) and export to `/root/db-backups`.

---

## 🛠️ Step-by-Step Solution

### 1. Audit the Charter (CRDs)
Before looking for objects, we need to see what new "Kinds" of resources the Mall now understands.
```bash
# List all Custom Resource Definitions and save to the ledger
kubectl get crd > /root/crds
```

### 2. Tracking Custom Instances (Custom Objects)
Now that we know `DbBackup` is a valid resource, we need to find every instance of it. 
**Crucial:** Custom resources are often Namespaced. If you don't use `-A`, you might miss the backups running in the "Finance" or "Logistics" wings.

```bash
# List all DbBackup objects from all Namespaces
kubectl get db-backups -A > /root/db-backups
```

---

## 🔎 Verification

1. **Check the Ledger:**
   ```bash
   cat /root/crds | grep dbbackups
   # You should see 'dbbackups.stable.example.com'
   ```

2. **Check the Count:**
   ```bash
   cat /root/db-backups | wc -l
   # Ensure you've captured all active units.
   ```

---

## 🧠 Key Takeaways

- **API Evolution:** By defining a `CRD`, you are teaching the `kube-apiserver` a new vocabulary. The Mall Manager (`kubectl`) now understands what a `DbBackup` is.
- **Global Visibility:** Custom objects live inside Namespaces just like Pods. The `-A` (or `--all-namespaces`) flag is the only way to get the full inventory.
- **CKAD Pro-Tip:** Many CRDs define shortnames. Try `kubectl api-resources` to see if `db-backups` has a shorter alias like `dbb`.

---

## 🔗 References
- **Comic** → [Operators](../../../../visual-learning/comics/ch04-extending/04-operators/README.md)
- **Docs** → [Understanding CRDs](../../../../reference/md-resources/understanding-custom-resource-definitions-crds.md)
- **Study Guide** → [Chapter 4: Extending K8s](../../../../sources/study-guide/ch04-extending-k8s.md)
