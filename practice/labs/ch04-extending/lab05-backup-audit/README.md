# 🧪 LAB 05: The Architect's Ledger (Backup Audit)
*Focus: API Extension Discovery & Resource Auditing (v1.35)*

In the **Central Mall**, a **CRD (Custom Resource Definition)** is like adding a new type of shop to the mall's legal charter (e.g., "Virtual Reality Lounge") that wasn't in the original blueprints. Once the charter is updated, you can start tracking the actual "VR Lounge" instances (Custom Objects).

---

## 📋 The Scenario
The Mall has been extended with custom database backup services. As the Architect, you need to audit these new extensions and list all active backup instances for the Management Office.

- **Task 1:** Export the list of all "Blueprints" (CRDs) installed in the Mall.
- **Task 2:** Export the list of all "Active Backup Units" (DbBackup objects) across all Wings (Namespaces).

---

## 🛠️ Lab Setup

If you are practicing in a fresh cluster, you must first register the custom "Charter" and create the sample "Backup Units" used in this audit.

```bash
# 1. Register the DbBackup CRD
kubectl apply -f 00-crd-db-backup.yaml

# 2. Create the sample instances in Finance and Logistics wings
kubectl apply -f 01-db-backup-instances.yaml
```

---

## 🛠️ Step 1: Auditing the Charter (CRDs)
Before looking for objects, we need to see what new "Kinds" of resources the Mall now understands.

```bash
# List all Custom Resource Definitions and save to the ledger
kubectl get crd > /root/crds
```

---

## 🏗️ Step 2: Tracking Custom Instances (Custom Objects)
Now that we know `DbBackup` is a valid resource, we need to find every instance of it. 
**Crucial:** Custom resources are often Namespaced. If you don't use `-A`, you might miss the backups running in the "Finance" or "Logistics" wings.

```bash
# List all DbBackup objects from all Namespaces
kubectl get db-backups -A > /root/db-backups
```



---

## 💡 Why this works?
1. **API Evolution:** By defining a `CRD`, you are teaching the `kube-apiserver` a new vocabulary. The Mall Manager (kubectl) now understands what a `DbBackup` is.
2. **Global Visibility:** Custom objects live inside Namespaces just like Pods. The `-A` (or `--all-namespaces`) flag is the only way to get the full "Mall-wide" inventory.
3. **Storage:** These lists are vital for disaster recovery. Knowing which CRDs exist allows you to recreate the Mall's custom logic in a new Cluster.

---

## 📝 CKAD Pro-Tips
- **Shortnames:** Many CRDs define shortnames (like `deploy` for `deployments`). Try `kubectl api-resources` to see if `db-backups` has a shorter alias like `dbb`.
- **The "Kind" vs "Object":** - `kubectl get crd`: Shows the *Definition* (The Template).
    - `kubectl get <name-of-crd>`: Shows the *Instance* (The actual running service).
- **v1.35 Update:** In the latest exam versions, you might encounter **Operators**. An Operator is just a Controller that watches these Custom Objects and performs actions (like actually running the backup).

---