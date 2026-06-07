
---

# ⚡ CKAD Cheatsheet

Short, fast, no thinking.

> [!WARNING]
> **Custom Variables (`$do` / `$now`) Warning:**
> In this cheatsheet, we use the shortcuts `$do` and `$now` which are defined as:
> ```bash
> export do="--dry-run=client -o yaml"
> export now="--grace-period=0 --force"
> ```
> * **Local practice environment:** These are highly recommended to save time.
> * **Exam Day:** **Do not rely on them!** During the exam, you will frequently hop between different contexts and nodes (via `ssh` or context switches). Environment variables do not transfer automatically to other nodes/sessions. If you type `k run nginx $do` in a new shell where `$do` is not defined, it will evaluate to an empty string and run the Pod *live* in the cluster instead of generating the YAML template, costing you time and points.

---

## 📦 Pods

```bash
k run nginx --image=nginx
k run nginx --image=nginx $do > pod.yaml
```
Delete immediately:
```
k delete pod nginx $now
```
YAML:
```
k create job hello --image=busybox -- echo hello $do > job.yaml
```
## ⏰ CronJobs
```bash
k create cronjob hello \
--image=busybox \
--schedule="*/1 * * * *" \
-- echo hello
```
## 🌐 Services
```
k expose pod nginx --port=80 --type=ClusterIP
```
## 📂 ConfigMaps
```bash
k create cm app-config --from-literal=env=prod
```
## 🔐 Secrets
```bash
k create secret generic db \
--from-literal=user=admin \
--from-literal=pass=1234
```

## 💾 Volumes (PVC)
```bash
k get pv
k get pvc
```

Always check:

- accessModes
- capacity
- bound status

## 🔍 Debug
- k describe pod `<name>`
- k logs `<pod>`
- k logs `<pod>` -c `<container>`

## 🧹 Cleanup
- k delete pod `<name>` $now
- k delete deploy `<name>`
- k delete job `<name>`

---

👉 Continue with:

- [Time Strategy](./03-time-management.md)
- [Final Checklist](./04-final-checklist.md)
---
[Mall Directory ✨](../../../../GLOSSARY.md)
