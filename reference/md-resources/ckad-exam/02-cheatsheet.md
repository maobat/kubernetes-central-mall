
---

# 📘 `02-cheatsheet.md`

# ⚡ CKAD Cheatsheet

Short, fast, no thinking.

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
[Mall Directory ✨](../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
