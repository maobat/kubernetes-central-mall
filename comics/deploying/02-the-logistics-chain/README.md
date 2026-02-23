<img src="the-logistics-chain.png" alt="The Logistics Chain" width="40%" />

# 🎭 The Logistics Chain

This comic explains the difference between **Helm** and **Kustomize** using the Central Mall's logistics system.

📌 Read this if:
- You are working on **CHAPTER 10 (Logistics Tools)**.
- You want to understand why we need two different ways to manage YAML.
- You want to remember the difference between **Templating** (Helm) and **Patching** (Kustomize).

🔗 References:
- Docs → [Using Helm](../../docs/md-resources/using-the-helm-package-manager.md)
- Docs → [Using Kustomize](../../docs/md-resources/using-kustomize.md)
- Lab → [`labs/architecture/lab04-crds-operators`](../../labs/architecture/lab04-crds-operators/README.md) (See Helm Section)

---

# 📖 Comic Script (Text Version)

### Panel 1: Helm - The Store-in-a-Box
**Worker:** "Just unbox the standard kit with my specific order!"
**Narrator:** A mall worker stands next to a large shipping container labeled **'Helm Charts - Store-in-a-Box'**. They are unboxing a miniature, fully-furnished gift shop.
- **Helm Chart:** The shipping container (Standard Kit).
- **Values.yaml:** The worker's 'Order Form' (Specific customizations like colors or names).

### Panel 2: Kustomize - The Overlay Blueprint
**Architect:** "I'll just add my custom changes on top without altering the original plan."
**Narrator:** An architect places a transparent sheet of trace paper (**'Overlay/Kustomize'**) over a solid **'Base Blueprint'**. Instead of rewriting the whole plan, they just draw the changes on the sheet.
- **Base:** The original, standard blueprint.
- **Overlays:** The transparent sheets with environment-specific changes (Dev, Prod).

---

> **Key Takeaway:**
> - **Helm**: Use it when you want a complete, pre-packaged solution where you just fill in the blanks.
> - **Kustomize**: Use it when you want to keep your central blueprints "pure" and apply different adjustments for different mall locations.
