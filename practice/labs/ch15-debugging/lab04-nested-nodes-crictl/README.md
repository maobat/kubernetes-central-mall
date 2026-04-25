# 🧪 LAB 04: The Nested Node (Kind & crictl)

## Observability and Maintenance – Node Debugging & CCTV

---

## 🎯 Lab Goal

Understand the "Nested Architecture" of your lab environment (Kind) and use **`crictl`** (the internal CCTV) to troubleshoot pods when the standard `kubectl` intercom is broken.

---

## 🛍️ Mall Analogy

In the **Central Mall**, Kind is like a set of **Delivery Trucks** (Docker containers) parked in the loading dock. 

- **The Street (Laptop):** Runs Docker. Sees the nodes as trucks.
- **The Truck (Kind Node):** Runs Ubuntu/Debian. Contains the Mini-Mall (K8s).
- **The Shop (Pod Container):** Runs your App. Managed by **`crictl`**.

To see the individual shops, you have to climb into the truck and use the **Internal CCTV** (`crictl`).

---

## 🛠️ Step-by-Step Solution

### 1. Enter the Truck (Kind Node)
If your laptop's `kubectl` isn't working, or you need to see "under the hood", enter the node directly:
```bash
docker exec -it kind-control-plane bash
```

### 2. Update the Inventory & Restock Tools
Kind nodes are stripped down. If you need a "blueprints pen" (`vim`), install it:
```bash
apt-get update && apt-get install -y vim
```

### 3. CCTV Operations: Using `crictl`
Once inside the truck, use `crictl` to see the "Ground Truth":

| Command | Action | Why? |
|---------|--------|------|
| `crictl ps` | List containers | See what is actually running on the CPU. |
| `crictl pods` | List Pods | Check the "Sandboxes" (Network/IP) of the shops. |
| `crictl logs <id>`| View Logs | Direct access if the API Server is down. |

---

## 📂 Critical File Paths (The "Safe" Locations)

If you are modifying the cluster "under the hood" using `vim`, these are the only paths that matter:

-   **/etc/kubernetes/manifests/**
    -   **Purpose:** Static Pods.
    -   **Usage:** Drop a YAML here, and the Kubelet will start it without asking the API Server.
    -   **Best for:** API Server, Scheduler, Etcd.
-   **/var/lib/kubelet/config.yaml**
    -   **Purpose:** The "Rules of the Node."
    -   **Usage:** Change the `staticPodPath` or authentication settings here.
-   **/run/containerd/containerd.sock**
    -   **Purpose:** The "Phone Line" between K8s and the hardware.
    -   **Usage:** Point `crictl` here if it can't find the containers.

---

## 🧠 CKAD Insights & Exam Traps

> [!CAUTION]
> **Context Confusion:** Never run `crictl` on your laptop; it only works **inside** the Node via SSH/Docker Exec!

-   **The Pause Container:** If you see a container named `pause`, do not kill it. It’s the "Foundation" of the Pod’s network.
-   **Read-Only Filesystems:** Sometimes Kind nodes are mounted read-only. If `apt-get install` fails with "Read-only file system," you must recreate the cluster with write permissions.

**⚡ One-line memory:** *"Docker manages the Truck (Node), `crictl` manages the Shop (Container)."*

---

## 🔗 References
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Official Docs** → [crictl CLI](https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
