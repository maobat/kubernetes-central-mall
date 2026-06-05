# 🚀 1. The Right Tool: Killer.sh or Local Clusters
*Where to practice building the Mall*

Before you take the CKAD exam, you need a place to practice. Here are the best environments to hone your skills:

## 🏆 [The "Bible": Killer.sh](https://killer.sh/)
For the CKAD, the absolute gold standard simulator is **Killer.sh**. 
- **The Perk:** You receive **two free simulator sessions** when you purchase the official exam.
- **Why it's great:** It perfectly mimics the real exam environment, timing, and interface. The difficulty is generally slightly *harder* than the real exam, meaning if you can pass Killer.sh, you are ready for the real thing.

## 🏠 Free At-Home Options

If you want to train for free before burning your Killer.sh sessions:

### 1. Minikube or Kind
- **Best for:** Having a real, fully-functional "Mall" running directly on your own PC.
- **Why use it:** Great for the practice labs in this repository, messing around with configurations, and testing deployments without needing an internet connection.

#### ⚠️ The Local Kind/Minikube Situation (Constraints & Caveats)

When practicing on a local single-node cluster (like **Kind** or **Minikube**) instead of the official multi-node exam environment, keep the following differences in mind:

* **Kubernetes Version Differences (e.g. Sidecars):**
  * *The Real Exam:* Runs on Kubernetes $\ge$ 1.28, which supports **Native Sidecar Containers** (`initContainers` with `restartPolicy: Always`).
  * *Your Local Cluster:* If your local cluster is running a legacy version $\le$ 1.27 (e.g., `v1.27.3`), defining `restartPolicy: Always` inside `initContainers` will cause a schema validation error.
  * *Workaround:* For local practice on older versions, place the sidecar in the main `spec.containers` array. The grading script automatically checks both locations and will score it correctly.
* **Accessing Services via NodePorts:**
  * *The Real Exam:* NodePorts are directly reachable on the node VM IPs from the host.
  * *Your Local Cluster:* Because Kind runs nodes inside Docker containers, the node is isolated. To access a NodePort directly, you must retrieve the internal Docker IP of the node (using `kubectl get nodes -o wide` to find the `INTERNAL-IP`) rather than `127.0.0.1` or `localhost`.
* **Local Registry Proxies (Image Building):**
  * *The Real Exam:* Provides a pre-configured `registry.killer.sh:5000` registry.
  * *Your Local Cluster:* To practice building and pushing images locally, you must run a registry proxy container mapped to the Kind network and redirect host traffic by adding `127.0.0.1 registry.killer.sh` to `/etc/hosts`.

### [2. Killercoda](https://killercoda.com/)
- **Best for:** Quick, targeted practice without any local setup.
- **Why use it:** It offers free, browser-based scenarios where the terminal immediately tells you "FAIL" or "PASS". It's excellent for drilling specific tasks (like creating NetworkPolicies or fixing broken Deployments) repeatedly until they are muscle memory.

---
[Mall Directory ✨](../../../../GLOSSARY.md)
