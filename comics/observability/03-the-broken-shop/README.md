<img src="broken-shop.png" alt="Troubleshooting - The Broken Shop" width="40%" />

# 🕵️ The Health Inspector - The Broken Shop

This comic explains the **Troubleshooting toolkit** in Kubernetes using the "Crime Scene Investigation" analogy.

## 🛍️ Mall Analogy

- **The Crime Scene** → A Pod that is `CrashLoopBackOff` or `Pending`.
- **CCTV Tapes** → `kubectl logs`. Watch what the clerk was doing right before the incident.
- **Security Logbook** → `kubectl describe`. See the Mall Manager's (Kubernetes) official reports on events like "Door Jammed" (ImagePullBackOff) or "Worker Fainted" (OOMKilled).
- **Walking Inside** → `kubectl exec`. Physically entering the shop to check the shelves and inventory.

## 🧠 Key Takeaway

Investigating a broken shop requires a step-by-step approach:
1.  **Check the Logbook (`describe`)** for infrastructure issues.
2.  **Review the CCTV (`logs`)** for application crashes.
3.  **Enter the Shop (`exec`)** for deep inspection.

---

## 🔗 References
- Lab → [LAB 15 – Fixing the Broken Shop](../../../labs/observability/lab15-fixing-the-broken-shop/README.md)
- Chapter → [Chapter 15: Debugging & Logs](../../../sources/story/ch15.md)
