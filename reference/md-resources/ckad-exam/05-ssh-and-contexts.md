# 🔑 Mall Logistics: SSH and Contexts
*Navigating the Central Mall Infrastructure*

In the Central Mall, you aren't always working at the main desk. Sometimes you need to take the service elevator to a specific floor (**SSH**) or switch between different Management Ledgers (**Contexts**).

---

## 🚪 The Service Elevator (SSH Basics)
> **Rule of the Mall:** During the exam, some tasks must be performed directly on a specific Floor (**Node**). You will be given the command to connect.

### Task: Create a file on a different host
- **Goal:** Move from the `controlplane` to `node01`, leave a note, and come back.

```shell
# Step 1: Take the elevator to node01
root@controlplane:~$ ssh node01

# Step 2: You are now on node01. Create the floor log.
root@node01:~$ touch /root/node01

# Step 3: Return to the Management Office (CRITICAL!)
root@node01:~$ exit
logout
Connection to node01 closed.

# Step 4: Verify you are back home
root@controlplane:~$ touch /root/controlplane
```



---

## 📖 The Management Ledgers (Kubectl Contexts)
The Mall might have different "Wings" (Clusters) or different administrative views. A **Context** tells your tools which wing you are currently managing.

### Task: List and Export Contexts
- **Goal:** Identify all available ledgers and save the list for the Auditor.

> **Architect's Tip:** Use `k config -h` if you forget the sub-commands!

```shell
# List all available contexts
k config get-contexts

# Save the output to a specific file
k config get-contexts > /root/contexts
```

---

## 🧭 Navigating the Wing Map
In your environment, you might see these specialized contexts:

| CONTEXT | DESTINATION | DEFAULT NAMESPACE |
| :--- | :--- | :--- |
| `kubernetes-admin@kubernetes` | Main Mall | `default` |
| `purple` | Purple Wing | `purple` |
| `yellow` | Yellow Wing | `yellow` |

### ⚠️ Pro-Tip for the Exam
Always **check** your current context before starting a question. If you build a shop in the `Yellow` wing when the ticket asked for the `Purple` wing, the Manager won't find it!

```shell
# Switch to the Purple wing
k config use-context purple
```



---

[Back to Documentation](../../README.md)
---
[Mall Directory ✨](../../../GLOSSARY.md)
