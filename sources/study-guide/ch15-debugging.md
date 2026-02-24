# 📖 Chapter 15: Debugging & Logs
*CCTV and Incident Reports (Troubleshooting)*

In the **Central Mall**, when a shop stops working, you don't just stare at the closed door. You look at the **CCTV tapes** (Logs) to see what the clerk was doing, you check the **Security Logbook** (Describe) to see if the Mall Manager left a note, and sometimes you **walk inside** (Exec) to look around yourself.

---

## 🎭 15.1 The Troubleshooting Toolkit

| Tool | Mall Analogy | The "Why" |
| :--- | :--- | :--- |
| **kubectl logs** | **CCTV Tapes** | See exactly what the clerk said or did right before the "crash." |
| **kubectl describe** | **Security Logbook** | See the Mall Manager's events. Did the worker run out of water (OOM)? Did the door jam (ImagePullBackOff)? |
| **kubectl exec** | **Walking Inside** | Physically enter the shop to check if the files are where they should be. |
| **kubectl get** | **The Directory** | A quick look to see which shops are "Running" and which are "Terminated." |



---

## 🛠️ 15.2 CCTV Analysis: Streaming the Logs

If your shop has multiple workers (Sidecars), you must tell the manager *which* worker's camera you want to see.

///bash
# View the main clerk's activity
kubectl logs <pod-name> -c main-clerk

# Follow the tapes in real-time (Live Feed)
kubectl logs -f <pod-name>

# See the tapes from BEFORE the worker fainted (Previous instance)
kubectl logs <pod-name> --previous
///

---

## 🛠️ 15.3 Incident Reports: The Logbook

If a Pod is stuck in `Pending` or `CrashLoopBackOff`, the `describe` command is your best friend. It reveals the "Events"—the Mall Manager's timestamped notes on why things are failing.

///bash
kubectl describe pod <pod-name>
///

**Common "Incident Report" Findings:**
* **FailedScheduling:** "No room in the mall for this shop" (Resource shortage).
* **Back-off restarting failed container:** "The clerk keeps fainting" (App error or bad Liveness Probe).
* **Failed to pull image:** "The warehouse doesn't have that mannequin" (Typo in image name).



---

## 🛠️ The Blueprint (CKAD Speed-Run)

In the exam, you'll be given a "Broken Shop" and told to fix it. Use this **3-Step Investigation**:

1. **Check Status:** `kubectl get pods` (Is it a restart loop or a failure to start?)
2. **Read Events:** `kubectl describe pod <name>` (Check the 'Events' section for Manager errors).
3. **Watch CCTV:** `kubectl logs <name>` (Check for application-level crashes).

///bash
# Fast way to see all "Events" for the whole mall floor
kubectl get events --sort-by='.lastTimestamp'
///

---

## ⚠️ Common Exam Traps
- **Multi-Container Logs:** If a Pod has more than one container, `kubectl logs <pod>` will fail, demanding you specify a container with `-c`. Get used to looking at the Pod description `Containers:` section first.
- **Ignoring Events:** If a Pod is stuck in `Pending` or `ImagePullBackOff`, the logs will be totally empty! The container hasn't started yet. You MUST use `kubectl describe pod <pod>` and read the `Events` section at the very bottom to find out why.

---

## 🧰 Study Toolbox

* 📄 **Doc:** [Troubleshooting Kubernetes (The Master Guide)](../../docs/md-resources/troubleshooting-kubernetes.md)
* 📄 **Doc:** [Diagnostic Cheat Sheet (Commands to Memorize)](../../docs/md-resources/diagnostic-cheat-sheet.md)
* 🖼️ **Comic:** [The Health Inspector - The Broken Shop](../../comics/observability/03-the-broken-shop/README.md)
* 🧪 **Lab:** [LAB 15 – Fixing the Broken Shop](../../labs/observability/lab15-fixing-the-broken-shop/README.md)

---
[<< Previous: Health Checks](ch14-probes.md) | [Back to Story Index](../story.md)
