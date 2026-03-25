# 📖 Chapter 9: Launch Strategies: The Sign Swap and the Taste Test

In the Central Mall, opening a new store or updating an existing one is a major event. You don't just shut down the mall, change everything, and hope for the best. You need a strategy to ensure customers aren't disappointed and the business keeps running.

## The Full Sign Swap (Blue/Green Deployment)

Imagine the "Main Café" is getting a complete makeover. Instead of closing the old café and making everyone wait, the Mall Owner builds an identical "New Café" in the empty space across the hall.

For a while, both cafés exist. The old one is still serving customers. Once the New Café is perfect, the Owner simply swaps the signs. One minute, the "Main Café" sign points to the old shop; the next minute, it points to the new one. 

In Kubernetes, this is a **Blue/Green Deployment**. You have two full versions of your app (Blue and Green). You switch the **Service** (the sign) to point to the new version once it's ready. If something goes wrong with the New Café, you just swap the sign back to the old one. Zero downtime, zero risk.

### 🔵🟢 Blue/Green Strategy
* 🖼️ **Comic:** [Blue/Green Sign Swap](../../visual-learning/comics/ch09-launch/01-blue-green-sign-swap/README.md)

## The Taste Test (Canary Deployment)

What if you're not sure if the new "Sriracha Gelato" will be a hit? You don't want to replace all your vanilla ice cream at once. Instead, you keep the main counter as it is, but you set up a tiny "Sample Station" at the entrance.

Most customers (95%) go to the main counter for vanilla. A few adventurous souls (5%) are directed to the sample station to try the new flavor. If they love it, you gradually increase the size of the sample station until it becomes the new main counter. If they hate it, you just close the sample station, and no one is the wiser.

In Kubernetes, this is a **Canary Deployment**. You run a small number of new pods alongside the old ones. The **Service** (the entrance) distributes traffic between them. As you gain confidence, you scale up the new version and scale down the old one.

## The Rolling Update: The Seamless Renovation

Sometimes, you don't need a separate shop or a sample station. You just need to update the furniture in your existing store. You don't close the store; instead, you move customers to one side, replace two chairs, then move them back and replace the next two.

This is the default **Rolling Update** in Kubernetes. One by one, old pods are replaced by new ones, ensuring that the shop is always open for business.

**The Progression:**
```text
Old version:  v1 v1 v1 v1
Update →      v2 v1 v1 v1
              v2 v2 v1 v1
              v2 v2 v2 v1
              v2 v2 v2 v2
```

**What Happens:**
1. **Old workers** keep serving customers.
2. **New workers** arrive and set up their counters.
3. Once a new counter is ready, an **old worker** clocks out.
4. Traffic automatically shifts as the workforce changes.

---

## 🏬 Mall Analogy: Fast Recall

| Strategy | Mall Story |
| :--- | :--- |
| **Rolling Update** | Replace chairs in the café one by one while customers sit elsewhere. |
| **Blue-Green** | Build an entirely new café across the hall, then move the sign overnight. |
| **Canary** | Offer a new flavor at a tiny sample counter first before changing the main menu. |

---

* 🖼️ **Comic 01:** [The Trend Spot - Rolling Renovation](../../visual-learning/comics/ch09-launch/01-rolling-update/README.md)
* 🖼️ **Comic 02:** [Blue/Green Sign Swap](../../visual-learning/comics/ch09-launch/01-blue-green-sign-swap/README.md)
* 🖼️ **Comic 03:** [Canary Traffic at the Side Entrance](../../visual-learning/comics/ch09-launch/01-canary-nodeport/README.md)
* 📄 **Doc:** [Implementing Canary Deployments](../../reference/md-resources/implementing-canary-deployments.md)
* 📄 **Doc:** [Implementing Blue/Green Deployments](../../reference/md-resources/implementing-bluegreen-deployments.md)
* 🧪 **Lab 01:** [Rolling Update Boutique](../../practice/labs/ch09-launch/lab01-rolling-update-wonderful/README.md)
* 🧪 **Lab 02:** [Blue-Green Sign Swap](../../practice/labs/ch09-launch/lab02-blue-green-wonderful/README.md)
* 🧪 **Lab 03:** [Canary Taste Test](../../practice/labs/ch09-launch/lab03-canary-wonderful/README.md)
* 🧪 **Lab 04:** [Blue-Green Java App (Guided + Challenge)](../../practice/labs/ch09-launch/lab04-blue-green-java/README.md)
* 🧪 **Lab 05:** [Deployment Lifecycle (Create, Scale & Update)](../../practice/labs/ch09-launch/lab05-deployment-lifecycle/README.md)

[<< Previous Chapter: Resource Budgets](ch08-resource-budgets.md) | [Back to Story Index](../story.md) | [Next Chapter: Logistics Tools >>](ch10-logistics-tools.md)
