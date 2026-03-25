# 📖 Chapter 9: Launch Strategies
*The Renovation, the Sign Swap, and the Taste Test*

In the **Central Mall**, a grand opening is a high-stakes event. If you open a new shop and the lights don't work, customers leave disappointed. To prevent this, successful managers use three strategies: the **Seamless Renovation** (Rolling Update), the **Sign Swap** (Blue/Green), and the **Taste Test** (Canary).

---

## 🎭 9.1 Rolling Update: The Seamless Renovation

This is the default strategy for a reason. Kubernetes replaces old workers with new ones, one by one, ensuring that the shop is always open for business.

1. **Old workers** keep serving customers.
2. **New workers** arrive and set up their counters.
3. Once a new counter is ready, an **old worker** clocks out.
4. Traffic automatically shifts as the workforce changes.

**Tuning the Change:**
- `maxSurge`: How many extra temporary workers you can hire during the move.
- `maxUnavailable`: How many empty counters you can tolerate during the move.

---

## 🎭 9.2 Blue/Green Deployment: The Sign Swap

Imagine you have two identical storefronts: **Store A (Blue)** and **Store B (Green)**. 

1. **Blue (Stable):** This is the shop currently serving customers.
2. **Green (New):** You build the entire green shop behind a curtain. You test the lights and stock the shelves while nobody is looking.
3. **The Swap:** Once Green is ready, you simply move the "Main Entrance" sign from Blue to Green.

In Kubernetes, this is done by updating a **Service's selector** to point to the Green shop's labels.

---

## ☎️ Resource: Service Selectors & Label Matching

In the **Central Mall**, a Service is an intercom system. The `--selector` flag defines exactly which desks will ring when a customer calls.

### 🧩 The "Hard-Coded" Selector
When using `kubectl expose --selector=key=value`, you are overriding the default behavior.

| Component | Function | Mall Analogy |
| :--- | :--- | :--- |
| **Service Name** | `wonderful` | The name on the directory board. |
| **Port** | `80` | The number the customer dials. |
| **Target Port** | `80` | The phone on the worker's desk. |
| **Selector** | `app=w,version=v1` | The specific "Skills" or "Badges" required to answer. |

### 🛠️ Practice Tip
To swap traffic in a Blue-Green scenario without deleting resources:
```bash
kubectl patch svc wonderful -p '{"spec":{"selector":{"version":"v2"}}}'
```
This command "re-wires" the intercom to the new office (v2) in milliseconds.

---

## 🎭 9.3 Canary Deployment: The Taste Test

A **Canary Deployment** is like a free sample station. You don't move everyone at once. 

1. You open a tiny corner of the new shop (the "Canary") and invite 10% of your customers to try it.
2. If they like it, you slowly expand the corner until the new version takes over.

**Lab Tip:** In Kubernetes, we do this by having two Deployments (v1.14 and latest) sharing the same **Service**. By adjusting the **number of replicas** (e.g., 3 Old, 1 Canary), you control the traffic split! For more advanced control, you'd use an **Ingress** or **Service Mesh**.

---

## ⚖️ Strategy Comparison

| Feature | Rolling Update | Blue-Green | Canary |
| :--- | :--- | :--- | :--- |
| **Native in Deploy?**| ✅ Yes | ❌ No (Pattern) | ❌ No (Pattern) |
| **Mixed Versions?** | ⚠️ Yes | ✅ No | ⚠️ Yes (by design) |
| **Rollback Speed** | 🐢 Slow | ⚡ Instant | ⚡ Instant |
| **Resources** | 🪙 Normal | 💰 2x Needed | 🪙 Normal |

### Pros & Cons
- **Rolling Update:** Zero downtime and automatic, but rollback is slower and versions mix during the move.
- **Blue-Green:** Instant rollback and no version mixing, but requires double resources and a manual switch.
- **Canary:** Safest for real-user testing and gradual risk, but requires more complex routing (Ingress/Mesh).

---

## 🧠 Quick CKAD Memory Trick

| Strategy | Traffic Style | Pod State |
| :--- | :--- | :--- |
| **Rolling Update** | Gradual replacement | Mixed versions |
| **Blue-Green** | Instant switch | Separate environments |
| **Canary** | Partial traffic testing | Percentage-based |

> [!IMPORTANT]
> **Exam Note:** Only `RollingUpdate` is native to the `Deployment` spec. Blue-Green and Canary are architectural patterns implemented using Services, Ingress, or Service Mesh.

---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. Rolling Updates (The Default)
Kubernetes replaces old workers with new ones, one by one, automatically.
```bash
kubectl set image deployment/clerk-dept clerk=nginx:1.21 --record
```

### 2. Monitoring the Launch
Always watch the rollout to make sure the manager isn't struggling:
```bash
kubectl rollout status deployment/clerk-dept
```

### 3. The Emergency Brake (Rollback)
If the new shop is a disaster, go back to the previous version immediately:
```bash
kubectl rollout undo deployment/clerk-dept
```

---

## ⚠️ Common Exam Traps
- **Selector Mismatches:** Once a Deployment is created, its `matchLabels` selector is **immutable**. You cannot change it to fix a typo. You must delete the Deployment and recreate it.
- **Rollout History:** If you don't use the `--record` flag (or `CHANGE-CAUSE` annotations), `kubectl rollout history` will show a blank `revision` cause. In recent k8s versions, `--record` is deprecated, so exams may prefer you manually annotate the Deployment.

---

### 🧰 Study Toolbox

* 🖼️ **Comic 01:** [The Trend Spot - Rolling Renovation](../../visual-learning/comics/ch09-launch/01-rolling-update/README.md)
* 🖼️ **Comic 02:** [Blue/Green Sign Swap](../../visual-learning/comics/ch09-launch/01-blue-green-sign-swap/README.md)
* 🖼️ **Comic 03:** [Replica Weighting - Canary at the Side Entrance](../../visual-learning/comics/ch09-launch/01-canary-nodeport/README.md)
* 📄 **Doc:** [Implementing Blue/Green Deployments](../../reference/md-resources/implementing-bluegreen-deployments.md)
* 📄 **Doc:** [Implementing Canary Deployments](../../reference/md-resources/implementing-canary-deployments.md)
* 📄 **Doc:** [Comparison: Blue/Green vs. Canary](../../reference/md-resources/related-deployment-strategies-comparison.md)
* 🧪 **Lab 01:** [Rolling Update Boutique](../../practice/labs/ch09-launch/lab01-rolling-update-wonderful/README.md)
* 🧪 **Lab 02:** [Blue-Green Sign Swap](../../practice/labs/ch09-launch/lab02-blue-green-wonderful/README.md)
* 🧪 **Lab 03:** [Canary Taste Test](../../practice/labs/ch09-launch/lab03-canary-wonderful/README.md)
* 🧪 **Lab 04:** [Blue-Green Java App (Guided + Challenge)](../../practice/labs/ch09-launch/lab04-blue-green-java/README.md)

---
[<< Previous: Resources](ch08-resources.md) | [Back to Story Index](../story.md) | [Next: Logistics Tools >>](ch10-management.md)
