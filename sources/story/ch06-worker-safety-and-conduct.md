# Ch. 6: Worker Safety: Safety Gear and Conduct Protocols

In a massive, crowded mall, a small fire in one shop can quickly become a disaster for everyone. To prevent this, the Mall Owner doesn't just hire workers and give them instructions; they also enforce strict **Safety Gear** and **Conduct Protocols**. In the world of Kubernetes, these are the **SecurityContexts**.

## The Safety Gear (Capabilities and Privileges)

Some jobs in the mall require specialized tools. A plumber might need a heavy-duty torch (privileged access), while a shop clerk only needs a pen.

However, giving every worker a torch is dangerous. The **SecurityContext** allows the Owner to specify exactly what "Safety Gear" each worker is allowed to carry:
- **No Master Keys:** By default, workers are told they cannot use a "Master Key" (**Privileged: false**). They can only open the doors they are explicitly assigned to.
- **Limited Toolset:** Instead of a full toolbox, a worker might be given just one or two specific tools (**Capabilities**), like "Permission to change the clock" but not "Permission to rewire the building."

## Conduct Protocols (RunAs and ReadOnly)

Beyond the tools they carry, workers must follow rules of behavior:

### The HR Conduct Rule: "No Roots Allowed"
In many shops, workers try to start their shift as if they own the place—using the identity of the building's founder (**Root User**). This is a major safety violation.
The Mall Owner enforces a rule: `runAsNonRoot: true`. If a worker shows up claiming to be the Founder, the **Security Guard** at the shop door sends them home immediately. The shop stays closed until a proper, lower-level worker is assigned.

### The "Look but Don't Touch" Rule
Sometimes, a worker needs to read the manual but has no business writing in it. To prevent accidental (or malicious) changes to the shop's foundational structure, the Owner can lock the shelves: `readOnlyRootFilesystem: true`. The worker can see everything they need, but they can't move the furniture or paint the walls.

## Why it Matters: The Blast Radius

If a worker in the "Chemical Supply Store" has a bad day or makes a mistake, these safety protocols ensure that the damage is contained within that one storefront. Without a Master Key and with restricted visibility, they cannot climb into the ventilation ducts to disrupt the "Jewelry Store" next door.

By defining **Worker Safety & Conduct**, the Mall Owner ensures that the entire structure remains stable, secure, and ready for customers, no matter what happens inside an individual shop.

---

### Resources for this Chapter:
- [Worker Safety & Conduct (SecurityContexts)](file:///home/mauro.battello/projects/kubernetes-central-mall/docs/md-resources/securitycontext-worker-safety-and-conduct.md)
- [Lab: Managing Security Settings](file:///home/mauro.battello/projects/kubernetes-central-mall/docs/md-resources/lab-managing-security-settings.md)

[<< Previous Chapter: ConfigMaps & Secrets](ch05-configmaps-and-secrets.md) | [Back to Story Index](../story.md) | [Next Chapter: Identity & Access >>](ch07-identity-and-access.md)
