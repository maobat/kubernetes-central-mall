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

Default editor is `vim`.

## The "Instant Audit" (The Fast Way)
While inside Vim, type these commands to see the currently active values:

1. Check everything at once:

```shell
:set expandtab? tabstop? shiftwidth?
```

> Adding the ? at the end tells Vim to "report" the value instead of setting it.

2. Check if they are "Global" or "Local":
If you suspect a specific filetype (like YAML) is overriding your settings:

```shell
:verbose set expandtab?
```

> This tells you exactly which file (like /etc/vimrc) last changed that setting.

## `Vim` Setup
Persist Vim settings in `.vimrc`

---
### Settings
First create or open (if already exists) file `.vimrc`:
```shell
vim ~/vimrc
```

Now enter (in insert-mode activated with i) the following lines:
```shell
set expandtab
set tabstop=2
set shiftwidth=2
```
Save and close the file by pressing `Esc` followed by `:x` and `Enter`.

### Explanation
Whenever you open Vim now as the current user, these settings will be used.
If you ssh onto a different server, these settings will **not** be transferred.

Settings explained:
```shell
expandtab: use spaces for tab
tabstop: amount of spaces used for tab
shiftwidth: amount of spaces used during indentation
```


Useful commands:

- `i` → insert
- :`set paste`/`nopaste` -> enable/disable mode paste
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
---
[Mall Directory ✨](../../../GLOSSARY.md)
