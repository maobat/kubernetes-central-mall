# 🧪 LAB 06: The Castlemock Boutique (Installation Ritual)

## Logistics Tools – Grand Opening and Post-Install Setup

---

## 🎯 Lab Goal

Learn how to manage the complete lifecycle of a complex application deployment using **Helm**, including pre-requisite secrets, post-installation jobs, and configuration upgrades.

---

## 🛍️ Mall Analogy

In the **Central Mall**, opening a specialized boutique like **Castlemock** is a managed ritual. You don't just dump boxes on the floor; you must secure the vaults (Secrets) first, unpack the manager's kit (Helm Chart), and wait for the "Grand Opening Assistant" (a post-install Job) to set up the staff accounts before the doors can swing open. Finally, as popularity grows, you might upgrade from a simple door to a grand entrance (NodePort).

---

## 🛠️ Lab Setup

Ensure you have a clean namespace for this boutique.

```bash
# 1. Create the dedicated mall sector
kubectl create ns castlemock

# 2. Navigate to your chart directory (assuming you have the castlemock-helm repo)
# cd ~/projects/castlemock-helm/castlemock
```

---

## 📋 Requirements

The Management Office has ordered the opening of the **Castlemock** boutique.

1.  **Security Prep:** Create the `castlemock-tes-credentials` and `castlemock-default-credentials` vaults.
2.  **Unpack the Manager:** Install the `castlemock` Helm release using the local chart.
3.  **Monitor the Assistant:** Ensure the `castlemock-job` completes its setup ritual (creating users and cleaning defaults).
4.  **Upgrade Entrance:** Switch the shop entrance from `ClusterIP` to `NodePort`.

---

## 🛠️ Step-by-Step Solution

### 1. Prepare Security Vaults
Apps often need "keys" (secrets) to be ready *before* they are installed.
```bash
kubectl create secret generic castlemock-tes-credentials \
  --from-literal=tes-password=tes_password \
  -n castlemock

kubectl create secret generic castlemock-default-credentials \
  --from-literal=admin-password=admin \
  -n castlemock
```

### 2. Install the Shop Manager
Unpack the Helm chart into the `castlemock` sector.
```bash
helm install castlemock ./ --namespace castlemock
```

### 3. Monitoring the Ritual
A temporary "Setup Assistant" (Job) will stand by until the shop is ready.
```bash
# Check the Assistant's progress
kubectl logs -f job.batch/castlemock-job -n castlemock
```

### 4. Renovation (Upgrade)
Once the shop is running, upgrade the door type for better accessibility.
```bash
helm upgrade castlemock . \
  --namespace castlemock \
  --set service.type=NodePort
```

---

## 🔎 Verification

1.  **Check All Resources:**
    ```bash
    kubectl get all -n castlemock
    ```
2.  **Verify Setup Completion:** Check that the `castlemock-job` is in `Completed` status.
3.  **Confirm Entry Type:**
    ```bash
    kubectl get svc castlemock-svc -n castlemock
    # Type should be 'NodePort'
    ```

---

## 🧠 Key Takeaways

- **Pre-requisite Secrets:** Many charts expect specific secrets to exist; creating them first is a common "Day 0" task.
- **Post-Install Hooks:** Jobs can automate complex setup logic (like DB migrations or user creation) that happens after the pods start.
- **Declarative Upgrades:** Using `--set` with `helm upgrade` allows for targeted configuration changes without re-installing.

---

## 🔗 References
- **Comic** → [The Castlemock Grand Opening](../../../../visual-learning/comics/ch10-logistics/03-the-castlemock-grand-opening/README.md)
- **Docs** → [Helm Install/Upgrade](https://helm.sh/docs/intro/using_helm/)
- **Study Guide** → [Chapter 10: Logistics & API Management](../../../../sources/study-guide/ch10-management.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
