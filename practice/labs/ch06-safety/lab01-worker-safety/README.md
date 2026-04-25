# 🧪 LAB 01: Worker Safety ([SecurityContext](../../../../GLOSSARY.md#securitycontext) & Conduct)

## 🎯 Lab Goal
Learn how to "harden" a [Pod](../../../../GLOSSARY.md#pod) by setting strict **[SecurityContext](../../../../GLOSSARY.md#securitycontext)** rules. You will ensure that a worker cannot run as the "Owner" (root), has a restricted ID badge, and cannot write to the shop's walls (Read-Only Filesystem).

## 🛍️ Mall Analogy
In the **Central Mall**, every clerk must follow the **Mall Safety Gear & Conduct Policy**. 
- **The ID Badge (`runAsUser`):** Every clerk must wear their specific ID badge (User 1000).
- **No Master Keys (`runAsNonRoot`):** No clerk is allowed to have the "Master Keys" (Root access) to the mall's infrastructure.
- **Museum Rules (`readOnlyRootFilesystem`):** The clerk can use the tools provided, but they are strictly forbidden from painting the walls or modifying the shop's structural files.
- **Specialized Permit (`capabilities`):** To perform certain networking tasks (like "sniffing" for interference), a clerk needs a specialized `NET_RAW` permit.

---

## 📋 Requirements

1.  **Deploy the Secure Shop**: Create a [Pod](../../../../GLOSSARY.md#pod) named `worker-safety-pod` with a single container using `busybox:1.36`.
2.  **Apply Safety Gear ([SecurityContext](../../../../GLOSSARY.md#securitycontext))**:
    - Set the [Pod](../../../../GLOSSARY.md#pod)-wide user ID to `1000`.
    - Ensure the container **cannot** run as root.
    - Set the container's root filesystem to **Read-Only**.
    - Add the **`NET_RAW`** capability to the container.
3.  **Verify Conduct**: Verify that the files cannot be written to and the user ID is correct.

---

## 🛠️ Step-by-Step Solution

### 1. Create the Safety Blueprint
Create a file named `safety-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: worker-safety-pod
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
  containers:
  - name: secure-clerk
    image: busybox:1.36
    command: ["sh", "-c", "sleep 3600"]
    securityContext:
      runAsNonRoot: true
      readOnlyRootFilesystem: true
      capabilities:
        add: ["NET_RAW"]
```

```bash
# Or imperatively
kubectl run worker-safety --image=busybox:1.36 --dry-run=client -o yaml -- /bin/sh -c "sleep 3600" > safety-pod.yaml
```
```yaml
  #***************************
  # Pod-level securityContext
  #***************************
  securityContext:         # <-- Add this block for Pod-level
    runAsUser: 1000        # runAsUser is the user id of the pod
    runAsGroup: 3000       # runAsGroup is the group id of the pod
    fsGroup: 2000          # fsGroup is the group id of the volume
  #***************************
  # Pod-level securityContext
  #***************************
  containers:
  - name: worker-safety
    image: busybox:1.36
    args:
    # args is the arguments to the command or entrypoint otherwise you can use command and args together 
    - /bin/sh
    - -c
    - sleep 3600
    # or more readable
    # command: ["/bin/sh", "-c", "sleep 3600"]
    #***************************
    # Container-level securityContext
    #***************************
    securityContext:       # <-- Add this block for Container-level
      runAsNonRoot: true   # runAsNonRoot is a boolean that specifies whether the container should run as a non-root user
      readOnlyRootFilesystem: true # readOnlyRootFilesystem is a boolean that specifies whether the container's root filesystem should be read-only
      capabilities:
        add: ["NET_RAW"] # capabilities is a list of capabilities to add to the container
    #***************************
    # Container-level securityContext
    #***************************
```

Apply the blueprint:
```bash
kubectl apply -f safety-pod.yaml
```

### 2. Inspect the Worker's Conduct
Check the ID badge:
```bash
kubectl exec worker-safety -- id
```
*Output should show `uid=1000 gid=3000 groups=2000,3000`.*

Test the "Museum Rules" (Read-Only FS):
```bash
kubectl exec worker-safety -- touch /test-file
```
*Output should say: `touch: /test-file: Read-only file system`.*

---

## 🔎 Verification
1.  Check the security settings in the live [Pod](../../../../GLOSSARY.md#pod):
    ```bash
    kubectl get pod worker-safety -o jsonpath='{.spec.containers[0].securityContext}'
    ```

## 🧠 Key Takeaways
- **Least Privilege:** Start with the most restrictive settings and only add what is needed.
- **Multi-Level Security:** You can set defaults at the [Pod](../../../../GLOSSARY.md#pod) level and override or add specifics (like capabilities) at the Container level.
- **CKAD Tip:** Always remember that `readOnlyRootFilesystem` is one of the most effective ways to harden a container against "drift" or malicious changes.

---
## 🔗 References
- **Study Guide** → [Chapter 6: Security & Safety](../../../../sources/study-guide/ch06-security.md)
- **Docs** → [Configure a Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
