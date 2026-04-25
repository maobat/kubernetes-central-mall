# 🧪 LAB 03: Renovating the Blueprints (API Versions & Deprecations)

## 🎯 Lab Goal
Learn how to identify and upgrade Kubernetes API versions. In a long-running mall, blueprints (YAML manifests) eventually become outdated as the Management Office ([API Server](../../../../GLOSSARY.md#api-server)) adopts newer, more efficient standards.

## 🛍️ Mall Analogy
The **Management Office** ([API Server](../../../../GLOSSARY.md#api-server)) frequently updates its filing system. A blueprint for a "Warehouse" (**[CronJob](../../../../GLOSSARY.md#cronjob)**) that worked perfectly two years ago might use an "Old Style" form (**v1beta1**). As a Mall Architect, you must audit the current system version and ensure all blueprints are updated to the "Current Style" (**v1**) before the old ones are no longer accepted.

---

## 📋 Requirements

1.  **Audit the Management Version**: Identify the K8s server version (Major, Minor, Patch) and save them to `/root/versions`.
2.  **Identify the Department**: Determine the **API Group** for `Deployments` and save it to `/root/group`.
3.  **Renovate the Warehouse Blueprint**: Update a deprecated `CronJob` manifest to the current stable version.
4.  **Upgrade Specialized Permits**: Update a deprecated `FlowSchema` manifest to the non-deprecated version.

---

## 🛠️ Step-by-Step Solution

### 1. Audit the Management Version
We need to see exactly which version of the Mall Management software is running.

```bash
# Check the version
kubectl version
```
**Task**: Create `/root/versions` with three lines:
- Line 1: Major version
- Line 2: Minor version
- Line 3: Patch version

### 2. Identify the Department (API Group)
Each resource belongs to a specific department (Group).

```bash
# Use explain to find the version and group
kubectl explain deploy
```
**Observation**: You will see `VERSION: apps/v1`. The group is `apps`.
**Task**: Save the group name to `/root/group`.

### 3. Renovating the Warehouse Blueprint ([CronJob](../../../../GLOSSARY.md#cronjob))
A `CronJob` file exists at `/apps/cronjob.yaml` but uses an old version.

**Task**: Update the `apiVersion` in `/apps/cronjob.yaml` to the current stable version (`batch/v1`).

```yaml
# OLD: apiVersion: batch/v1beta1
# NEW:
apiVersion: batch/v1
kind: CronJob
...
```

### 4. Upgrade Specialized Permits (FlowSchema)
A `FlowSchema` file exists at `/apps/flowschema.yaml` with a deprecated version.

**Task**: Update the `apiVersion` to the non-deprecated version (e.g., `flowcontrol.apiserver.k8s.io/v1`).

---

## 🔎 Verification
1.  Check `/root/versions` and `/root/group`.
2.  Try applying the renovated manifests: `kubectl apply -f /apps/cronjob.yaml --dry-run=client`.

## 🧠 Key Takeaways
- **Evolution:** API versions move from `v1alpha1` -> `v1beta1` -> `v1`.
- **Deprecation:** Once a version is deprecated, it will eventually be removed.
- **Conversion:** You must stay ahead of removals by updating your blueprints.

---
## 🔗 References
- **Study Guide** → [Chapter 10: Management](../../../../sources/study-guide/ch10-management.md)
- **Docs** → [API Deprecations and Stability](../../../../reference/md-resources/api-deprecations-and-stability.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
