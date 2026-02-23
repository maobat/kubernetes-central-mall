<img src="lab04-blue-green-sign-swap.png" alt="Blue/Green Sign Swap" width="40%" />

# 🔵🟢 The Sign Swap (Blue/Green Deployment)

This comic explains the **Blue/Green Strategy** using the *Central Mall* storefront analogy.  
In this strategy, we don't change the shop while customers are inside. We build a second, identical shop nearby and swap the signs when it's perfect.

📌 Read this if:
- You need a **zero-downtime** grand opening
- You want the ability to perform an **instant rollback**
- You want to understand how **Service Selectors** act as "signs"

---

## 🎯 What This Comic Explains

- **The Blue Shop:** The current, stable production version (e.g., v1.14).
- **The Green Shop:** The new version (e.g., v1.15) being built and tested behind a "curtain" (not receiving public traffic).
- **The Sign Swap:** The moment when the Mall Manager (Kubernetes) updates the **Service Selector** to point to the Green Shop's labels.
- **Rollback:** If a pipe bursts in the Green Shop, you just move the sign back to the Blue Shop immediately.

> 🛍️ *Why fix a shop with workers inside when you can just build a better one next door?*

---

## 🧠 CKAD Mental Model

- **Blue/Green = All-or-Nothing Switch:** Unlike Canary, this is a 100% traffic flip.
- **Service Selector = The Entrance Sign:** The Service doesn't care which Deployment is active; it only cares about which **Selector** it's told to look for.
- **Isolation:** The Green shop can be tested privately using a temporary, internal service before the "Main Doors" are opened.

In exam terms:
> To perform a Blue/Green swap, use `kubectl patch service <name> -p '{"spec":{"selector":{"app":"green-nginx"}}}'`.

---

# 🏗️ How This Aligns with the Deployment Lab

This comic pairs directly with:

🧪 **Lab:** [Lab: Blue/Green Traffic Transition](../../../docs/md-resources/lab-deployment-steps-full-traffic-transition-demo.md)

**The Blue/Green Story:**

1. 🔵 **Blue is live:** Customers are happy in the old shop.
2. 🔨 **Build Green:** A perfect replica is constructed in secret.
3. 🧪 **Test Green:** The owner (admin) checks the Green shop via a side door (private service).
4. 🔄 **The Swap:** The "Main Entrance" sign is moved to Green.
5. ⏪ **Rollback:** Oh no! A bug! Move the sign back to Blue in seconds.

---
🔗 **References:**
- **Docs** → [`docs/md-resources/implementing-bluegreen-deployments.md`](../../../docs/md-resources/implementing-bluegreen-deployments.md)  
- **Comparison** → [`docs/md-resources/related-deployment-strategies-comparison.md`](../../../docs/md-resources/related-deployment-strategies-comparison.md)

**Key Takeaways (CKAD exam mode):**
- Blue/Green requires **double the capacity** (two full deployments).
- Rollback is nearly **instantaneous**.
- It is the safest strategy when you can't afford any errors for even 1% of users.
