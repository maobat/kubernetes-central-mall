# 📖 Chapter 7: Identity & Access ([RBAC](../../GLOSSARY.md#rbac)): The Magnetic ID Badge and the HR Manual

In the early days of the Central Mall, every worker had a generic "Guest" badge. They could walk the halls, but if they tried to ask the **Management Office** for a list of other workers or a look at the delivery schedules, they were turned away. To get anything done, a worker needs a proper identity and permission.

## The Magnetic ID Badge ([ServiceAccount](../../GLOSSARY.md#serviceaccount))

When a new specialist joins the mall—perhaps a **Logistics Coordinator** who needs to monitor all incoming shipments—the Owner doesn't just give them a name tag. They issue a **Magnetic ID Badge**. In Kubernetes, this is the **[ServiceAccount](../../GLOSSARY.md#serviceaccount)**.

This badge is more than just a piece of plastic. It contains a digital chip that the **Management Office ([API Server](../../GLOSSARY.md#api-server))** recognizes. Every time the worker approaches the Front Desk, they tap their badge. The clerk sees who they are and proceeds with the [request](../../GLOSSARY.md#request).

## The HR [Job](../../GLOSSARY.md#job) Description ([Role](../../GLOSSARY.md#role))

Having a badge is only half the battle. A badge without permissions is just a decoration. The Mall Owner keeps an **HR Manual** that defines various **[Job](../../GLOSSARY.md#job) Descriptions**. This is the **[Role](../../GLOSSARY.md#role)**.

A [Job](../../GLOSSARY.md#job) Description is a list of specific "Can-Do" rules:
- "Can read the Delivery Ledger."
- "Can update the Staff Schedule."
- "Can NOT enter the Mall Vault."

These rules are usually limited to a **single floor or department ([Namespace](../../GLOSSARY.md#namespace))**. A worker might be allowed to manage shipments for the "Sports Wing" but be completely unauthorized to touch anything in the "Food Court."

## The HR Assignment Letter (RoleBinding)

The final step is connecting the person to the [job](../../GLOSSARY.md#job). The Mall Owner writes an **HR Assignment Letter**. This is the **RoleBinding**.

This letter officially states: "The person holding Badge #123 ([ServiceAccount](../../GLOSSARY.md#serviceaccount)) is now assigned to the 'Logistics Coordinator' [Job](../../GLOSSARY.md#job) Description ([Role](../../GLOSSARY.md#role))."

The moment this letter is signed and filed in the **Mall Ledger (etcd)**, the worker's badge "flashes green." When they tap it at the Front Desk, the clerk checks the Assignment Letter and says, "Welcome, Coordinator. Here is the Delivery Ledger you requested."

## The Entry Permit Office (Admission Control)

Even if you have a valid badge and a [job](../../GLOSSARY.md#job) description, you might still be stopped at the door. Before any worker can actually enter the mall, they must pass through the **Entry Permit Office**. This is **Admission Control**.

Think of it as a final compliance check:
- "Is this worker wearing the required safety vest?" (Resource Limits check)
- "Are they bringing any prohibited items?" (Security Policy check)
- "Is the shop already too crowded?" (Quota check)

The Admission Controllers can either **Validate** (check the rules) or **Mutate** (automatically add a safety vest if the worker forgot theirs). If the Permit Office says "No," the worker is rejected before they even get a chance to start their shift.

## Why Three Parts?

You might wonder why the Mall doesn't just write the permissions directly onto the badge. By separating the **Badge (Identity)**, the **[Job](../../GLOSSARY.md#job) Description (Group of Permissions)**, and the **Assignment Letter (The Link)**, the Mall stays organized:
- If the worker leaves, the Badge is deactivated, but the [Job](../../GLOSSARY.md#job) Description remains for the next hire.
- If the permissions for all coordinators change, the Owner updates one [Job](../../GLOSSARY.md#job) Description, and everyone with that assignment is automatically updated.

---

### 🧰 Study Toolbox

**🎨 Visualize the Analogy**
* [Explore Chapter 7 Comics](../../visual-learning/comics/ch07-identity/README.md)

**📘 Technical Deep Dive**
* [Understanding RBAC (Technical Doc)](../../reference/md-resources/understanding-role-based-access-control-rbac.md)

**🛠️ Hands-on Practice**
* [Explore All Chapter 07 Labs](../../practice/labs/ch07-identity/README.md)

[<< Previous Chapter: Worker Safety & Conduct](ch06-worker-safety-and-conduct.md) | [Back to Story Index](../story.md) | [Mall Directory ✨](../../GLOSSARY.md) | [Next Chapter: Resource Budgets >>](ch08-resource-budgets.md)
