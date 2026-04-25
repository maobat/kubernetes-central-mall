# 🧪 LAB 05: The Connection Crisis ([Kubeconfig](../../../../GLOSSARY.md#kubeconfig) & VPN)


## 🎯 Lab Goal

> [!NOTE]
> **Local Lab vs. The Real CKAD Exam**
> Because the official CKAD exam environment is pre-configured and runs remotely via a web terminal, **you will actually never need to run `docker inspect` or bypass a VPN on the exam**. 
> However, practicing this locally is essential for your engineering career! The ability to manually repair a broken `kubeconfig` and understand cluster routing is a crucial skill for any Kubernetes Administrator. For exam-specific tricks, skip ahead to the **[CKAD Exam Speed-Run](#️-ckad-exam-speed-run-context-navigation)** section below!


Diagnose and repair the **"Broken Compass"** ([Kubeconfig](../../../../GLOSSARY.md#kubeconfig)) when your laptop and the Cluster (Kind) lose their connection due to VPN interference or "Port Drift."

---

## 🛍️ Mall Analogy

In the **Central Mall**, your [kubeconfig](../../../../GLOSSARY.md#kubeconfig) is the **Store Directory (The Map)**.

- **The Map ([Kubeconfig](../../../../GLOSSARY.md#kubeconfig))** → Tells you the Shop is at Aisle 10 (Port 45145).
- **The Reality (Docker)** → Due to a "Renovation" (Cluster restart), the Shop moved to Aisle 12 (Port 37607).
- **The VPN Jammer** → A Security Gate (FortiClient) has blocked the main hallway, so you have to find the [Service](../../../../GLOSSARY.md#service) Entrance (Internal Docker Bridge IP).

If your map doesn't match reality, you'll be wandering the parking lot forever (**I/O Timeout**).

---

## 🛠️ Step-by-Step Solution

### 1. Verify the "Physical" Address
Find out exactly where the Mall is actually listening on your laptop:
```bash
docker inspect ckad-control-plane --format='{{(index (index .NetworkSettings.Ports "6443/tcp") 0).HostPort}}'
```

### 2. Bypass the VPN "Jammer"
If the local IP is timing out, find the **Internal [Service](../../../../GLOSSARY.md#service) Entrance** (The Docker Bridge IP):
```bash
docker inspect ckad-control-plane -f '{{ .NetworkSettings.Networks.kind.IPAddress }}'
```

### 3. Repair the Compass (Manual Edit)
Update your directory to point to the truth. Open your map:
```bash
nano ~/.kube/config
```
Find the `server:` line and update the IP and Port to match Step 2 (using port `6443` internally if using the Bridge IP).

| Target Address | Use Case | Why? |
| :--- | :--- | :--- |
| `127.0.0.1:PORT` | **Standard** | Fastest, but fails if VPN blocks loopbacks. |
| `172.18.x.x:6443` | **VPN/Tunnel** | Bypasses Host routing. Most stable in enterprise labs. |

---

## 🔎 Verification (The Connectivity Test)

Once you've saved `~/.kube/config`, test the connection to ensure the compass is fixed:
```bash
kubectl get nodes
```
*If this returns the `ckad-control-plane` [node](../../../../GLOSSARY.md#node) in a `Ready` state, your Map is correct and the VPN is bypassed!*

---

## ⏱️ CKAD Exam Speed-Run (Context Navigation)

In the real CKAD exam, you will never fight a local VPN. Instead, your biggest enemy is time and the **multitude of clusters** they provide you. The exam environment has multiple "Malls," and running a perfect command in the wrong Mall will score you zero points.

Master these [Kubeconfig](../../../../GLOSSARY.md#kubeconfig) speed tricks to survive:

### 1. View the Map (Without the Noise)
Running `cat ~/.kube/config` will flood your screen with thousands of lines of cryptographic keys. To see your current contexts and clusters cleanly:
```bash
kubectl config view --minify
```

### 2. The Context Switch (Crucial for Every Question)
Before starting *any* exam question, you must switch your toolset to the correct cluster:
```bash
# See all available Malls
kubectl config get-contexts

# Switch to the required Mall (The exam provides this exact command)
kubectl config use-context <cluster-name>
```

### 3. The [Namespace](../../../../GLOSSARY.md#namespace) Speed Trick
The exam will repeatedly ask you to operate within a specific [namespace](../../../../GLOSSARY.md#namespace). Instead of typing `-n target-namespace` 15 times per question, change your "default" location for the duration of the question:
```bash
# Sets your default namespace for the current context
kubectl config set-context --current --namespace=<target-namespace>

# Now, any command you run automatically happens in that namespace!
kubectl get pods 
```

---

## 📂 Critical File Paths (The "Identity" Locations)

These files are the "ID Cards" for your connection:

| File Path | Purpose | Usage |
| :--- | :--- | :--- |
| `~/.kube/config` | **The Client-side Map** | Stores Contexts, Clusters, and Credentials. |
| `/etc/kubernetes/pki/ca.crt` | **The "Security Badge"** | `kubectl` uses this to verify the [API server](../../../../GLOSSARY.md#api-server) identity. |
| `/etc/kubernetes/admin.conf` | **The "Master Key"** | Copy this to your laptop if your local config is totally corrupted. |

---

## 🧠 CKAD Insights & Exam Traps

> [!CAUTION]
> **Context Check:** Always run `kubectl config get-contexts` first! You might be perfectly connected to the wrong cluster.

- **The "Thinking" [kubectl](../../../../GLOSSARY.md#kubectl):** If `kubectl` hangs (I/O Timeout), it's usually a **Routing/VPN issue**.
- **The "Refused" [kubectl](../../../../GLOSSARY.md#kubectl):** If `kubectl` says "Connection Refused," the **Process ([API Server](../../../../GLOSSARY.md#api-server)) is dead** or the **Port is wrong**.
- **Certificate Verification:** If you change the IP in your config, you might need `--insecure-skip-tls-verify` because the certificate was only signed for `localhost`.

> ⚡ **One-line memory:** "Docker is the Building, [Kubeconfig](../../../../GLOSSARY.md#kubeconfig) is the Map, and the VPN is the locked gate between them."

---

## 🔗 References
- **Comic** → [The Connection Crisis](../../../../visual-learning/comics/ch15-debugging/05-the-connection-crisis/README.md)
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)
---
[Mall Directory ✨](../../../../GLOSSARY.md)
