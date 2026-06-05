# 📘 CKAD Practice Exam Simulator (Solutions Guide)

Welcome to the Master Simulator Guide. This file contains the complete solutions, explanations, and Official Docs references for the simulator questions. Use this file to check your answers and understand the best practices.

Use [06-killer-sh-real-simulator.md](./06-killer-sh-real-simulator.md) to practice in "questions-only" mode.

> [!NOTE]
> **Practice Environment vs. Real Simulator Contexts:**
> * **In the Real Simulator / Exam:** You work in a multi-cluster, multi-node topology. Questions will prompt you to access specific environments (e.g., `ssh ckad5601` or switch context via `kubectl config use-context ...`).
> * **In Your Local Practice Environment:** You are running on a single local cluster (e.g., Kind or Minikube). **Do not run `ssh ckad5601`** (this host does not exist on your machine). Instead, execute all commands directly on your local terminal and save output files to `/opt/course/...` locally.

---

## 🛒 Question 1: Namespaces List
<p class="doc-link-row"><a href="https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces" class="doc-link-copy" target="_blank" rel="noopener noreferrer">Namespaces</a> <a href="https://kubernetes.io/docs/reference/kubectl/quick-reference" class="doc-link-copy" target="_blank" rel="noopener noreferrer">kubectl Quick Reference</a></p>

### Task Description
The DevOps team would like to get the list of all Namespaces in the cluster.
The list can contain other columns like `STATUS` or `AGE`.
Save the list to `/opt/course/1/namespaces` on `ckad5601`.

### Solution & Execution
To get the list of namespaces and save it, run:
```bash
kubectl get namespaces > /opt/course/1/namespaces
```
*(Or the shorthand `kubectl get ns > /opt/course/1/namespaces`)*

### Explanation
- **Namespaces** are virtual clusters backed by the same physical cluster. They allow you to divide cluster resources between multiple users or teams.
- By default, `kubectl get namespaces` outputs columns `NAME`, `STATUS`, and `AGE`, which fulfills all the requirements of the task.

---

## 🛒 Question 2: Pod Management
<p class="doc-link-row"><a href="https://kubernetes.io/docs/concepts/workloads/pods" class="doc-link-copy" target="_blank" rel="noopener noreferrer">Pods</a> <a href="https://kubernetes.io/docs/reference/kubectl/quick-reference" class="doc-link-copy" target="_blank" rel="noopener noreferrer">kubectl Quick Reference</a></p>

### Task Description
Create a single Pod of image `nginx:1.14` in Namespace `default`.
The Pod should be named `pod1` and the container should be named `pod1-container`.
Your manager would like to run a command manually on occasion to output the status of that exact Pod.
Please write a command that does this into `/opt/course/2/pod1-status-command.sh` on `ckad5601`.
The command should use `kubectl`.

### Solution & Execution
1. Generate the initial pod manifest:
   ```bash
   kubectl run pod1 --image=nginx:1.14 --dry-run=client -o yaml > pod1.yaml
   ```
2. Edit `pod1.yaml` to set the container name to `pod1-container`:
   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: pod1
     namespace: default
   spec:
     containers:
     - name: pod1-container
       image: nginx:1.14
   ```
3. Apply the manifest:
   ```bash
   kubectl apply -f pod1.yaml
   ```
4. Create the status helper script:
   ```bash
   echo "kubectl get pod pod1 -n default -o jsonpath='{.status.phase}'" > /opt/course/2/pod1-status-command.sh
   chmod +x /opt/course/2/pod1-status-command.sh
   ```

### Explanation
- **Pods** are the smallest deployable units of computing that you can create and manage in Kubernetes.
- `kubectl run` creates a pod helper manifest. We must customize the container name within the `containers` array spec block.
- For querying specific resource metadata fields such as the pod phase status, `jsonpath` parsing (`-o jsonpath='{.status.phase}'`) is highly efficient and clean.

---

[Back to Documentation](../../README.md)
---
[Mall Directory ✨](../../../../GLOSSARY.md)
