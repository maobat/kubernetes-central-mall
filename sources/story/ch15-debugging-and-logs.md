# 📖 Chapter 15: Debugging & Logs: CCTV and Incident Reports

Even in the best-managed mall, things occasionally go wrong. A lightbulb flickers, a pipe bursts, or a shop clerk goes missing. To fix these problems, the Mall Owner relies on two main tools: the security cameras and the incident logbook.

## Checking the CCTV (Logs)

When a customer complains that they were overcharged at the "Smoothie Stand," the Mall Manager doesn't just guess what happened. They go to the security room and rewind the **CCTV footage**.

Every employee in the mall is required to keep a verbal record of what they're doing. Everything they say is captured by the mall's microphones and stored in a central database. 

In Kubernetes, these are the **Logs**. By running `kubectl logs`, you can listen in on what an application was saying right before it crashed. It's the "First Person" perspective of the problem.

## Reading the Incident Reports (Describe & Events)

Sometimes the CCTV doesn't show the whole picture. Maybe the "Smoothie Stand" is empty not because the worker left, but because the Mall Owner forgot to pay the electricity bill, and the lights are out.

For this, you check the **Incident Reports** in the Manager's office. This book records high-level events:
- "10:00 AM: Smoothie Stand requested 500 Watts of power."
- "10:01 AM: Power request denied (Quota exceeded)."
- "10:05 AM: Security Guard shut down the stand due to lack of resources."

In Kubernetes, this is `kubectl describe`. It shows the "Third Person" perspective—what the Cluster (the Mall Manager) thinks is happening to your pod. It lists the **Events**, showing you if there were scheduling failures, image pull errors, or resource limit violations.

## Inspecting the Shop (Exec)

If the logs and incident reports aren't enough, the Manager might actually put on a hard hat and **walk into the shop** to look around for themselves. They might check the shelves, look under the counter, or try to use the machinery.

This is `kubectl exec`. It allows you to step inside a running pod and run commands directly, helping you find those tricky "local" problems that don't show up in the logs.

---

### 🧰 Study Toolbox

* 🖼️ **Comic 01:** [The Health Inspector - The Broken Shop](../../visual-learning/comics/ch15-debugging/03-the-broken-shop/README.md)
* 🖼️ **Comic 02:** [SSH and Contexts (Service Elevator)](../../visual-learning/comics/ckad-exam/05-ssh-and-contexts/README.md)
* 📄 **Doc:** [Troubleshooting Kubernetes Guide](../../reference/md-resources/troubleshooting-kubernetes.md)
* 📄 **Doc:** [Diagnostic Cheat Sheet](../../reference/md-resources/diagnostic-cheat-sheet.md)
* 🧪 **Lab 01:** [CCTV Log Investigation](../../practice/labs/ch15-debugging/lab01-debugging-shop/README.md)
* 🧪 **Lab 02:** [Logging & Sidecar Tailing](../../practice/labs/ch15-debugging/lab02-logging-sidecars/README.md)
* 🧪 **Lab 03:** [The Mall Dashboard (Metrics Server)](../../practice/labs/ch15-debugging/lab03-metrics-server/README.md)

[<< Previous Chapter: Probes & Health Checks](ch14-probes-and-health-checks.md) | [Back to Story Index](../story.md)
