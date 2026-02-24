# 📖 Chapter 2: Multi-container Design Patterns
*The Clerk and the Specialized Helper*

In a standard shop, one clerk does everything. But in a complex **Central Mall** outlet, the main clerk might need a specialized assistant who handles specific tasks like logging, syncing files, or preparing the shop before it opens.

---

## 🎭 2.1 The Team Dynamics (Design Patterns)

In Kubernetes, we can put multiple workers (containers) inside the same shop (**Pod**). They share the same address (IP) and the same storage (Volumes).

| Pattern | Mall Analogy | The "Why" |
| :--- | :--- | :--- |
| **Sidecar** | **The Security Guard** | Sits next to the clerk. While the clerk sells, the guard logs everyone who enters/exits. |
| **Init Container** | **The Setup Crew** | Arrives before the shop opens. They set up the shelves and then leave. The shop won`t open until they finish. |
| **Adapter** | **The Translator** | Takes the clerk`s messy notes and converts them into a standardized format for the Mall Management. |
| **Ambassador** | **The Delivery Courier** | Handles all outgoing requests. The clerk just hands them a package, and the courier finds the way to the customer. |



---

## 🛠️ 2.2 The Sidecar: The Logging Assistant

Imagine your main worker (`nginx`) is busy serving customers. You need to collect logs, but you don`t want to modify the main worker`s code. You add a **Sidecar**.

### 🧪 Lab Concept: Log Streaming
The main worker writes to a local file. The Sidecar reads that file and streams it to the console.

---

## 🛠️ 2.3 The Init Container: The Prep Team

Before a store opens, a crew must download the latest price list from the Central Office. If they fail to download it, the store **cannot** open.



```yaml
apiVersion: v1
kind: Pod
metadata:
  name: shop-with-prep-team
spec:
  # The Setup Crew (Init Containers)
  initContainers:
  - name: download-prices
    image: busybox
    command: [`sh`, `-c`, `echo "Downloading prices..."; sleep 5;`]
  
  # The Main Clerk (App Container)
  containers:
  - name: main-clerk
    image: nginx
```

---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. Adding a Sidecar via YAML
Since you can`t add a sidecar via a simple `kubectl` command, you generate the template and edit:

```bash
kubectl run sidecar-pod --image=nginx --dry-run=client -o yaml > pod.yaml
```

*Then, manually add the second container under the `containers:` list.*

### 2. Monitoring the Multi-container Pod

```bash
# Check status (You will see READY 2/2)
kubectl get pods

# View logs of a specific container in the team
kubectl logs <pod-name> -c <container-name>

# Execute a command in a specific container
kubectl exec -it <pod-name> -c <container-name> -- sh
```

---

### 🧰 Study Toolbox

- 🖼️ [**Comic: Sidecar Pattern - The Assistant at Work**](./../../comics/pod-design/01-sidecar/README.md)
- 🧪 [**Lab: labs/pod-design/lab01-sidecar-pattern**](./../../labs/pod-design/lab01-sidecar-pattern/README.md)
- 📄 [**Doc: Understanding Multi-container Pod Patterns**](./../../docs/md-resources/decoupling-pods.md)

---
[<< Previous: Workloads](ch01-workloads.md) | [Back to Story Index](../story.md) | [Next: Pod Design >>](ch03-pod-design.md)

---
