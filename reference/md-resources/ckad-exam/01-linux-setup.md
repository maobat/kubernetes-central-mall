# 🐧 Linux Setup (CKAD)

This setup is for the **exam terminal only**.

Do this immediately after the exam starts.

---

## 🚀 Mandatory Setup (First 3 Minutes)

## 🚀 First 3 Minutes (MANDATORY)

```bash
mkdir ~/ckad-exam
cd ~/ckad-exam

alias k=kubectl
source <(kubectl completion bash)
complete -F __start_kubectl k

export do="--dry-run=client -o yaml"
export now="--force --grace-period=0"
```
## ⚡ Optional but Useful Aliases
```bash
alias kgetp='k get pods --sort-by=.metadata.creationTimestamp -o wide'
alias kgp='k get pods -o wide'
alias kgs='k get svc'
alias kgd='k get deploy'
alias kgn='k get ns'
alias kga='k get all'
```

## 🧠 Editor

Default editor is `vi`.

Useful commands:

- `i` → insert
- `:wq` → save & quit
- `:q!` → quit without saving

---

## ⚠️ Rules Reminder

- No internet
- No copy-paste from browser
- Everything must work via kubectl

If something works **imperatively**, use it.
If YAML is required, generate it with **--dry-run**.

---

👉 Continue with:

- [CKAD Cheatsheet](./02-cheatsheet.md)
- [Time Strategy](./03-time-management.md)
- [Final Checklist](./04-final-checklist.md)