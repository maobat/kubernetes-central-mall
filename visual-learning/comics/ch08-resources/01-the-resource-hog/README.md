<img src="lab08-the-resource-hog.png" alt="The Resource Hog" width="40%" />

# 🐷 The Resource Hog

This comic explains **Resource Management (Requests & Limits)** using the *Central Mall* analogy.  
In a busy mall, electricity and water are shared. If one shop uses too much, everyone suffers a blackout.

📌 Read this if:
- You are working on **[LAB 01](../../../../practice/labs/ch08-resources/lab01-managing-resource-constraints/README.md)**.
- You want to understand **Requests vs. Limits**
- You are troubleshooting **OOMKilled** or **Throttling**

---

## 🎯 What This Comic Explains

- **Requests = The Guaranteed Minimum:** The amount of "electricity" (CPU) and "floor space" (Memory) you are guaranteed to have.
- **Limits = The Circuit Breaker:** The maximum you are allowed to use before Management steps in.
- **CPU Throttling:** When you hit your electricity limit, Management dims your lights, but you stay open.
- **OOMKilled:** When you try to cram too much "stuff" into your shop's physical space, the shop is shut down immediately.
- **ResourceQuotas:** Limiting how much total electricity an entire wing (Namespace) of the mall can consume.

> 🛍️ *Don't be a hog! State your needs and respect your limits.*

---

## 🧠 CKAD Mental Model

- **Requests = Scheduling:** The "Mall Manager" (Scheduler) only lets you open in a building (Node) that has enough room for your *Requests*.
- **Limits = Enforcement:** Management (Kubelet/Runtime) ensures you don't exceed your *Limits*.
- **CPU (Compressible):** Throttled when over limit (slow but alive).
- **Memory (Incompressible):** Terminated when over limit (Crash/OOMKilled).

In exam terms:
> If a Pod is stuck in `Pending`, check its **Requests**.  
> If a Pod keeps `Restarting`, check its **Memory Limits**.

---

# 🏗️ How This Aligns with the Resources Lab

This comic pairs directly with:

🧪 **Lab:** [`lab-managing-resource-constraints`](../../../../practice/labs/ch08-resources/lab01-managing-resource-constraints/README.md)

**The Resource Story:**

1. 💡 **CPU (Electricity):** Throttling is annoying but survivable.
2. 🚰 **Memory (Water):** Flooding your shop (OOM) results in an immediate closure.
3. 🏢 **Quotas:** The entire "Food Court" can only have so much equipment.

---
🔗 **References:**
- **Docs** → [`docs/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md`](../../../../reference/md-resources/resource-requests-limits-and-quotas-the-resource-budget.md)  

**Key Takeaways (CKAD exam mode):**
- Define `resources` inside the **container** spec, not the Pod spec.
- Use `kubectl top pod` to find the "Resource Hog."
- `Requests` are for **Finding a Home**; `Limits` are for **Keeping the Home Safe**.
- Memory is binary: either it fits, or you're out.
