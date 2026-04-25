# 🧪 LAB 05: The Connection Crisis (Kubeconfig & VPN)

## Infrastructure & Troubleshooting – The Broken Compass

---

## 🎯 Lab Goal

Diagnose and repair the **"Broken Compass"** (Kubeconfig) when your laptop and the Cluster (Kind) lose their connection due to VPN interference or "Port Drift."

---

## 🛍️ Mall Analogy

In the **Central Mall**, your kubeconfig is the **Store Directory (The Map)**.

- **The Map (Kubeconfig)** → Tells you the Shop is at Aisle 10 (Port 45145).
- **The Reality (Docker)** → Due to a "Renovation" (Cluster restart), the Shop moved to Aisle 12 (Port 37607).
- **The VPN Jammer** → A Security Gate (FortiClient) has blocked the main hallway, so you have to find the Service Entrance (Internal Docker Bridge IP).

If your map doesn't match reality, you'll be wandering the parking lot forever (**I/O Timeout**).

---

## 🛠️ Step-by-Step Solution

### 1. Verify the "Physical" Address
Find out exactly where the Mall is actually listening on your laptop:
```bash
docker inspect ckad-control-plane --format='{{(index (index .NetworkSettings.Ports "6443/tcp") 0).HostPort}}'
```

### 2. Bypass the VPN "Jammer"
If the local IP is timing out, find the **Internal Service Entrance** (The Docker Bridge IP):
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

## 📂 Critical File Paths (The "Identity" Locations)

These files are the "ID Cards" for your connection:

| File Path | Purpose | Usage |
| :--- | :--- | :--- |
| `~/.kube/config` | **The Client-side Map** | Stores Contexts, Clusters, and Credentials. |
| `/etc/kubernetes/pki/ca.crt` | **The "Security Badge"** | `kubectl` uses this to verify the API server identity. |
| `/etc/kubernetes/admin.conf` | **The "Master Key"** | Copy this to your laptop if your local config is totally corrupted. |

---

## 🧠 CKAD Insights & Exam Traps

> [!CAUTION]
> **Context Check:** Always run `kubectl config get-contexts` first! You might be perfectly connected to the wrong cluster.

- **The "Thinking" kubectl:** If `kubectl` hangs (I/O Timeout), it's usually a **Routing/VPN issue**.
- **The "Refused" kubectl:** If `kubectl` says "Connection Refused," the **Process (API Server) is dead** or the **Port is wrong**.
- **Certificate Verification:** If you change the IP in your config, you might need `--insecure-skip-tls-verify` because the certificate was only signed for `localhost`.

> ⚡ **One-line memory:** "Docker is the Building, Kubeconfig is the Map, and the VPN is the locked gate between them."

---

## 🔗 References
- **Comic** → [The Connection Crisis](../../../../visual-learning/comics/ch15-debugging/05-the-connection-crisis/README.md)
- **Study Guide** → [Chapter 15: Debugging](../../../../sources/study-guide/ch15-debugging.md)
- **Central Mall Map** → [Practice Labs Index](../../README.md)