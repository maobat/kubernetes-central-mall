# 🧪 LAB 01: Worker Safety (SecurityContext & Conduct)

## 🎯 Lab Goal
Learn how to "harden" a Pod by setting strict **SecurityContext** rules. You will ensure that a worker cannot run as the "Owner" (root), has a restricted ID badge, and cannot write to the shop's walls (Read-Only Filesystem).

## 🛍️ Mall Analogy
In the **Central Mall**, every clerk must follow the **Mall Safety Gear & Conduct Policy**. 
- **The ID Badge (`runAsUser`):** Every clerk must wear their specific ID badge (User 1000).
- **No Master Keys (`runAsNonRoot`):** No clerk is allowed to have the "Master Keys" (Root access) to the mall's infrastructure.
- **Museum Rules (`readOnlyRootFilesystem`):** The clerk can use the tools provided, but they are strictly forbidden from painting the walls or modifying the shop's structural files.
- **Specialized Permit (`capabilities`):** To perform certain networking tasks (like "sniffing" for interference), a clerk needs a specialized `NET_RAW` permit.

---

## 📋 Requirements

1.  **Deploy the Secure Shop**: Create a Pod named `worker-safety-pod` with a single container using `busybox:1.36`.
2.  **Apply Safety Gear (SecurityContext)**:
    - Set the Pod-wide user ID to `1000`.
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

Apply the blueprint:
```bash
kubectl apply -f safety-pod.yaml
```

### 2. Inspect the Worker's Conduct
Check the ID badge:
```bash
kubectl exec worker-safety-pod -- id
```
*Output should show `uid=1000 gid=3000`.*

Test the "Museum Rules" (Read-Only FS):
```bash
kubectl exec worker-safety-pod -- touch /test-file
```
*Output should say: `touch: /test-file: Read-only file system`.*

---

## 🔎 Verification
1.  Check the security settings in the live Pod:
    ```bash
    kubectl get pod worker-safety-pod -o jsonpath='{.spec.containers[0].securityContext}'
    ```

## 🧠 Key Takeaways
- **Least Privilege:** Start with the most restrictive settings and only add what is needed.
- **Multi-Level Security:** You can set defaults at the Pod level and override or add specifics (like capabilities) at the Container level.
- **CKAD Tip:** Always remember that `readOnlyRootFilesystem` is one of the most effective ways to harden a container against "drift" or malicious changes.

---
## 🔗 References
- **Study Guide** → [Chapter 6: Security & Safety](../../../../sources/study-guide/ch06-security.md)
- **Docs** → [Configure a Security Context](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)
