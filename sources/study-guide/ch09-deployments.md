# 📖 Chapter 9: Launch Strategies
*The Sign Swap and the Taste Test*

In the **Central Mall**, a grand opening is a high-stakes event. If you open a new shop and the lights don't work, customers leave disappointed. To prevent this, successful managers use two strategies: the **Sign Swap** (Blue/Green) and the **Taste Test** (Canary).

---

## 🎭 9.1 Blue/Green Deployment: The Sign Swap

Imagine you have two identical storefronts: **Store A (Blue)** and **Store B (Green)**. 

1. **Blue (Stable):** This is the shop currently serving customers.
2. **Green (New):** You build the entire green shop behind a curtain. You test the lights and stock the shelves while nobody is looking.
3. **The Swap:** Once Green is ready, you simply move the "Main Entrance" sign from Blue to Green.

In Kubernetes, this is done by updating a **Service`s selector** to point to the Green shop`s labels.



---

## 🎭 9.2 Canary Deployment: The Taste Test

A **Canary Deployment** is like a free sample station. You don't move everyone at once. 

1. You open a tiny corner of the new shop (the "Canary") and invite 10% of your customers to try it.
2. If they like it, you slowly expand the corner until the new version takes over.

**Lab Tip:** In Kubernetes, we do this by having two Deployments (v1.14 and latest) sharing the same **Service**. By adjusting the **number of replicas** (e.g., 3 Old, 1 Canary), you control the traffic split!



---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. Rolling Updates (The Default)
Kubernetes replaces old workers with new ones, one by one, automatically.
```bash
kubectl set image deployment/clerk-dept clerk=nginx:1.21 --record
```

### 2. Monitoring the Launch
Always watch the rollout to make sure the manager isn`t struggling:
```bash
kubectl rollout status deployment/clerk-dept
```

### 3. The Emergency Brake (Rollback)
If the new shop is a disaster, go back to the previous version immediately:
```bash
kubectl rollout undo deployment/clerk-dept
```

---

### 🧰 Study Toolbox

### 🔵🟢 Blue/Green Strategy
* �🖼️ **Comic:** [Blue/Green Sign Swap](../../comics/deploying/01-blue-green-sign-swap/README.md)
* � **Doc:** [Implementing Blue/Green Deployments](../../docs/md-resources/implementing-bluegreen-deployments.md)
* 🧪 **Lab:** [Lab: Blue/Green Traffic Transition](../../docs/md-resources/lab-deployment-steps-full-traffic-transition-demo.md)

### 🐤 Canary Strategy
* �🖼️ **Comic:** [Replica Weighting - Canary at the Side Entrance](../../comics/canary-nodeport/01-canary-replica-weighting/README.md)
* 📄 **Doc:** [Implementing Canary Deployments](../../docs/md-resources/implementing-canary-deployments.md)
* 🧪 **Lab:** [Lab 04 - Canary Deployments](../../labs/deploying/lab04-canary-nodeport/README.md)

### ⚖️ Comparison
* 📄 **Doc:** [Comparison: Blue/Green vs. Canary](../../docs/md-resources/related-deployment-strategies-comparison.md)

---
[<< Previous: Resources](ch08-resources.md) | [Back to Story Index](../story.md) | [Next: Logistics Tools >>](ch10-management.md)
