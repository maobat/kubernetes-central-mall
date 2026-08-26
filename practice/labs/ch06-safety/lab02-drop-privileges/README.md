# 🧪 LAB 02: Drop Privileges (Capabilities & Escalation)

## 🎯 Lab Goal
Learn the **"deny by default"** hardening pattern used across most CKAD security tasks: start by stripping a worker of every Linux capability, then add back only the single permit they actually need. You will also close the two most common exam traps — privilege escalation and running in privileged mode.

## 🛍️ Mall Analogy
Lab 01 taught the "Safety Gear" — an ID badge, a Read-Only manual. This lab teaches the **Mall Security Office's actual policy**: every new clerk starts with **zero permits**, not a full set that gets trimmed down.
- **Strip the Master Ring (`capabilities.drop: ["ALL"]`):** A new hire is issued no specialized tools at all.
- **Reissue One Permit (`capabilities.add`):** If the job truly requires it (e.g. a network technician needs to "sniff" cables), only that one permit is reissued.
- **No Self-Promotion (`allowPrivilegeEscalation: false`):** A clerk can never grant themselves a higher badge mid-shift.
- **No Building Manager Impersonation (`privileged: false`):** A clerk is never allowed to act as the building's owner/manager, with full access to every system in the mall.

---

## 📋 Requirements

1. **Deploy the Hardened Shop**: Create a Pod named `hardened-worker` using image `busybox:1.36`, running `sleep 3600`.
2. **Strip and Reissue Capabilities**:
   - Drop **all** Linux capabilities from the container.
   - Add back only `NET_BIND_SERVICE`.
3. **Close the Escalation Path**:
   - Set `allowPrivilegeEscalation` to `false`.
   - Set `privileged` to `false` (explicit, even though it's the default).
4. **Verify Conduct**: Confirm the Pod is `Running` and that the capability set is exactly what was requested.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Blueprint

Create a file named `hardened-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hardened-worker
spec:
  containers:
  - name: clerk
    image: busybox:1.36
    command: ["sh", "-c", "sleep 3600"]
    securityContext:
      allowPrivilegeEscalation: false
      privileged: false
      capabilities:
        drop: ["ALL"]
        add: ["NET_BIND_SERVICE"]
```

```bash
kubectl apply -f hardened-pod.yaml
```

### 2. Inspect the Worker's Conduct

```bash
kubectl get pod hardened-worker -o jsonpath='{.spec.containers[0].securityContext}'
```

*Output should show `"capabilities":{"add":["NET_BIND_SERVICE"],"drop":["ALL"]}` alongside `"allowPrivilegeEscalation":false`.*

---

## 🔎 Verification

1. Confirm the Pod reached `Running`:
   ```bash
   kubectl get pod hardened-worker
   ```
2. Confirm the capability set matches the blueprint exactly (no extra capabilities left over from the base image):
   ```bash
   kubectl get pod hardened-worker -o jsonpath='{.spec.containers[0].securityContext.capabilities}'
   ```

## 🧠 Key Takeaways
- **Drop first, add second:** `capabilities.drop: ["ALL"]` is the CKAD-standard starting point for any "harden this Pod" task — never leave the base image's default capability set intact.
- **Capabilities are Container-only:** Just like Lab 01's study guide notes, `capabilities` cannot be set at the Pod level — only inside a container's `securityContext`.
- **`allowPrivilegeEscalation: false` is not automatic:** Even a non-root, capability-stripped container can still escalate unless this flag is set explicitly.
- **CKAD Tip:** If a task says "prevent this container from gaining more privileges than its parent process," that's `allowPrivilegeEscalation: false` — a very literal keyword match worth memorizing.

---
## 🔗 References
- **Study Guide** → [Chapter 6: Security & Safety](../../../../sources/study-guide/ch06-security.md)
- **Docs** → [Configure a Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
- **Docs** → [Linux Capabilities](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-capabilities-for-a-container)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
