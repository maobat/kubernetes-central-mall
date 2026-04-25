# 🧪 LAB 04: The Inventory Report ([Helm](../../../../GLOSSARY.md#helm) Releases)

## Logistics Tools – Tracking Managed Prefab Kits

---

## 🎯 Lab Goal

Learn how to audit the mall's specialized management services by listing all active **[Helm](../../../../GLOSSARY.md#helm) Releases** across all wings (namespaces).

---

## 🛍️ Mall Analogy

In the **Central Mall**, specialized shops often come with their own "Prefab Managers" ([Helm](../../../../GLOSSARY.md#helm) Releases). To keep an accurate inventory, you need to check every wing to see which managers are currently on duty.

---

## 🛠️ Lab Setup

If your cluster is currently empty, you should first install some "Prefab Managers" to have something to audit.

```bash
# 1. Add the Bitnami warehouse
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# 2. Install dummy managers in different wings (namespaces)
kubectl create ns team-red
kubectl create ns team-blue
helm -n team-red install boutique bitnami/nginx
helm -n team-blue install warehouse bitnami/redis
```

---

## 📋 Requirements

The Mall Logistics department needs a full report of all specialized managers currently active in the cluster.

1. **Inventory Collection:** Write the list of all **[Helm](../../../../GLOSSARY.md#helm) releases** in the cluster into the file `releases`.

---

## 🛠️ Step-by-Step Solution

### 1. Audit All Wings (Namespaces)
Since specialized shops can be anywhere in the mall, you must search across all namespaces.
```bash
# List all Helm releases in all namespaces and save to the report
helm ls -A > releases
```

---

## 🔎 Verification

1. **Check the Report:**
   ```bash
   cat releases
   # Should list all active Helm releases across the cluster.
   ```

---

## 🧠 Key Takeaways

- **Release vs Chart:** A Chart is the blueprint; a Release is the actual manager active in the mall.
- **Global Vision:** The `-A` or `--all-namespaces` flag is essential for a complete mall-wide audit.

---

## 🔗 References
- **Comic** → [The Logistics Chain](../../../../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
- **Docs** → [Helm List](https://helm.sh/docs/helm/helm_list/)
- **Study Guide** → [Chapter 10: Management](../../../../sources/study-guide/ch10-management.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
