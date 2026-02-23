# Ch. 10: Logistics Tools: Shipping Containers and Layout Templates

Managing a single shop is one thing. Managing an entire international franchise with hundreds of malls is another. To keep everything organized, the Central Mall uses standardized logistics tools.

## The Shipping Container (Helm)

Imagine you want to open a "Standardized Gift Shop" in ten different malls. You don't want to design the layout, hire the staff, and order the inventory from scratch ten times. 

Instead, you use a **Helm Chart**. This is like a pre-packed shipping container. It contains everything the shop needs:
- The blueprints (Templates).
- The list of staff (Replica count).
- The inventory list (ConfigMaps).
- A simple "Manifest" (Values.yaml) where you can change the shop's name or color for each location.

When you're ready to open, you just "install" the chart. The Mall logistics system unpacks the container and sets up the shop exactly as specified. If you need to update all ten shops, you just update the chart and "upgrade" the installation.

## The Layout Template (Kustomize)

Sometimes, you have a base layout for a "Food Court Stall," but you need to make small changes for different locations. Maybe the "North Mall" stall needs a bigger sign, while the "South Mall" stall needs extra refrigeration.

You don't want to create two entirely different blueprints. Instead, you use **Kustomize**. You have one "Base" layout that never changes. Then, you create small "Overlays" that specify only what's different for each location.

Kustomize "patches" the base blueprint with your changes to create a final, customized plan. It's like having a master drawing and placing a transparent sheet over it with your notes.

---

## 🧰 Study Toolbox

### 📦 Helm (The Package Manager)
* 🖼️ **Comic:** [The Logistics Chain - Deploying at Scale](../../comics/deploying/02-the-logistics-chain/README.md)
* 📄 **Doc:** [Using the Helm Package Manager](../../docs/md-resources/using-the-helm-package-manager.md)
* 📄 **Doc:** [Working with Helm Charts](../../docs/md-resources/working-with-helm-charts.md)
* 🧪 **Lab:** [Lab 04: Architecture (Helm Section)](../../labs/architecture/lab04-crds-operators/README.md#4-the-store-in-a-box-helm)

### 🧩 Kustomize (Blueprint Overlays)
* 🖼️ **Comic:** [The Logistics Chain - Deploying at Scale](../../comics/deploying/02-the-logistics-chain/README.md)
* 📄 **Doc:** [Using Kustomize (Transparent Sheet Method)](../../docs/md-resources/using-kustomize.md)

[<< Previous Chapter: Launch Strategies](ch09-launch-strategies.md) | [Back to Story Index](../story.md) | [Next Chapter: Finding the Stores >>](ch11-finding-the-stores.md)
