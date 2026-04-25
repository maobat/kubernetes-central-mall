# 🧪 LAB 04: Entry Permit Office Configuration (Advanced)

## 🎯 Lab Goal
Learn how to manage the **Admission Control** plugins at the administrative level. You will audit enabled plugins, enable a new one, and witness the effects of disabling a critical safety plugin.

> [!WARNING]
> This lab involves modifying the `kube-apiserver` manifest. In a real mall (production cluster), this causes a temporary shutdown of the Management Office. Always make backups!

## 🛍️ Mall Analogy
The **Entry Permit Office** (Admission Control) follows a strict manual of plugins (checklists). As a Mall Administrator, you need to know which checklists are active, how to add a new inspection step, and how to remove one (though removing safety checks is rarely advised!).

---

## 📋 Requirements

1.  **Audit the Checklist**: List all admission controller plugins currently enabled in the `kube-apiserver` and save them to `/root/admission-plugins`.
2.  **Enable Auto-Safety**: Enable the `MutatingAdmissionWebhook` plugin to allow for automated policy enforcement.
3.  **Disable Floor Protection**: Temporarily disable the `NamespaceLifecycle` plugin to see why it's normally protected.

---

## 🛠️ Step-by-Step Solution

### 1. Audit the Checklist
We need to check the "blueprint" of the Management Office.

```bash
# Filter the api-server manifest for admission plugins
cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep admission-plugins
```

**Task**: Create the file `/root/admission-plugins` with the list of enabled plugins found (e.g., `NodeRestriction`, `LimitRanger`, `Priority`).

### 2. Enabling the Auto-Safety Vest (Mutating Admission)
We need to add `MutatingAdmissionWebhook` to the enabled list.

```bash
# 1. ALWAYS make a backup!
cp /etc/kubernetes/manifests/kube-apiserver.yaml ~/kube-apiserver.yaml.bak

# 2. Edit the manifest
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

**Change**: Update the `--enable-admission-plugins` line:
`--enable-admission-plugins=NodeRestriction,LimitRanger,Priority,MutatingAdmissionWebhook`

**Wait**: Use `watch crictl ps` to monitor the API server restarting.

### 3. Disabling Floor Protection (DANGEROUS!)
The `NamespaceLifecycle` plugin prevents you from deleting "Essential Floors" like `default`. Let's see what happens if we turn it off.

```bash
# 1. Try to delete the default floor (should fail)
kubectl delete ns default
```

**Task**: Disable `NamespaceLifecycle` by adding it to `--disable-admission-plugins` or removing it from the enable list if it was there implicitly.

```bash
# Edit manifest again
vim /etc/kubernetes/manifests/kube-apiserver.yaml
```

**Add/Update**: `--disable-admission-plugins=NamespaceLifecycle`

**Observation**: After the API server restarts, attempt to delete the `default` namespace. It will now be allowed (though it will likely be recreated immediately by the mall's heart).

---

## 🔎 Verification
1.  Check the API server process: `ps aux | grep kube-apiserver`
2.  Verify the plugins are active in the manifest.

## 🧠 Key Takeaways
- **Plugins:** Admission control is modular. You can enable/disable specific checks.
- **Static Pods:** The API server is often a static pod; editing its manifest triggers an automatic restart.
- **Safety First:** Disabling plugins like `NamespaceLifecycle` can lead to accidental deletion of critical infrastructure.

---
## 🔗 References
- **Study Guide** → [Chapter 7: Identity & RBAC](../../../../sources/study-guide/ch07-identity.md)
- **Docs** → [Admission Controllers Reference](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
