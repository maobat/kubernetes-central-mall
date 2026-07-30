# Troubleshooting Challenge — Overnight Contractors

The mall passed its final inspection, but several contractors made unauthorised changes overnight. At **09:00**, the Inspector returns.

This challenge turns the completed Capstone into a live troubleshooting environment. The scripts modify the running cluster; they do not merely describe hypothetical failures.

## Files

```text
challenge/
├── overnight-contractors.sh  # introduces six faults
├── challenge-reset.sh        # restores the approved solution state
└── README.md
```

## Prerequisites

Complete all four Capstone phases first. The cluster must contain these resources:

- `cashier`, `shop-manager`, and `cashier-shop-manager` in `mall-shops`;
- `warehouse-pv` and `warehouse-pvc`;
- StatefulSet `shoes-boutique`;
- Service `shoes-boutique-svc`;
- NetworkPolicy `secure-shops`;
- DaemonSet `security-camera` in `mall-security`.

The reset script expects the approved manifests in:

```text
solutions/
├── phase1-foundation.yaml
├── phase2-workloads.yaml
├── phase3-networking.yaml
└── phase4-maintenance.yaml
```

## Start the incident

From `practice/labs/ch17-capstone`:

```bash
chmod +x challenge/*.sh
./challenge/overnight-contractors.sh
```

The script introduces six real faults:

1. the `cashier` identity can no longer read Pods;
2. `warehouse-pvc` remains `Pending` while still requesting `500Mi`;
3. nginx loses the welcome page because the shared-volume path is wrong;
4. the headless Service selector no longer matches the StatefulSet Pods;
5. the NetworkPolicy allows approved traffic on the wrong port;
6. the DaemonSet is no longer restricted to `mall-zone=secure` nodes.

## Operating rules

Do not apply the complete solution manifests while solving the challenge. Work like a Kubernetes operator:

```text
Observe → Inspect → Identify → Repair → Verify
```

You may edit or patch the affected resources. Do not delete and recreate the entire architecture. The warehouse claim must continue requesting `500Mi`.

## Suggested first inspection

```bash
k get ns | grep mall
k get pods -n mall-shops
k get events -n mall-shops --sort-by=.lastTimestamp
k auth can-i get pods \
  --as=system:serviceaccount:mall-shops:cashier \
  -n mall-shops
k get pv,pvc -n mall-shops
k get svc,endpoints,endpointslice -n mall-shops
k get networkpolicy -n mall-shops
k get ds -n mall-security
```

The script deliberately does not print the repair commands.

## Reset the lab

To restore the known-good state:

```bash
./challenge/challenge-reset.sh
```

The reset script scales down the StatefulSet, recreates the two storage objects, reapplies the four approved phase manifests, and waits for the StatefulSet and DaemonSet rollouts.

> **Warning:** Run these scripts only against the dedicated Central Mall practice cluster. They intentionally modify and delete the named Capstone resources.

---

## 🔗 References
- **Capstone** → [The Grand Opening — Lab 17.01](../README.md)
- **Docs** → [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) | [PersistentVolumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) | [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) | [NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/) | [DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
- **Study Guide** → [Chapter 07: Identity & RBAC](../../../../sources/study-guide/ch07-identity.md) | [Chapter 13: Networking](../../../../sources/study-guide/ch13-networking.md) | [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Glossary** → [RBAC](../../../../GLOSSARY.md#rbac) | [NetworkPolicy](../../../../GLOSSARY.md#networkpolicy) | [PersistentVolume](../../../../GLOSSARY.md#persistentvolume) | [StatefulSet](../../../../GLOSSARY.md#statefulset) | [DaemonSet](../../../../GLOSSARY.md#daemonset)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
