# 📖 Chapter 7: Identity & Access (RBAC): The Magnetic ID Badge and the HR Manual

In the early days of the Central Mall, every worker had a generic "Guest" badge. They could walk the halls, but if they tried to ask the **Management Office** for a list of other workers or a look at the delivery schedules, they were turned away. To get anything done, a worker needs a proper identity and permission.

## The Magnetic ID Badge (ServiceAccount)

When a new specialist joins the mall—perhaps a **Logistics Coordinator** who needs to monitor all incoming shipments—the Owner doesn't just give them a name tag. They issue a **Magnetic ID Badge**. In Kubernetes, this is the **ServiceAccount**.

This badge is more than just a piece of plastic. It contains a digital chip that the **Management Office (API Server)** recognizes. Every time the worker approaches the Front Desk, they tap their badge. The clerk sees who they are and proceeds with the request.

## The HR Job Description (Role)

Having a badge is only half the battle. A badge without permissions is just a decoration. The Mall Owner keeps an **HR Manual** that defines various **Job Descriptions**. This is the **Role**.

A Job Description is a list of specific "Can-Do" rules:
- "Can read the Delivery Ledger."
- "Can update the Staff Schedule."
- "Can NOT enter the Mall Vault."

These rules are usually limited to a **single floor or department (Namespace)**. A worker might be allowed to manage shipments for the "Sports Wing" but be completely unauthorized to touch anything in the "Food Court."

## The HR Assignment Letter (RoleBinding)

The final step is connecting the person to the job. The Mall Owner writes an **HR Assignment Letter**. This is the **RoleBinding**.

This letter officially states: "The person holding Badge #123 (ServiceAccount) is now assigned to the 'Logistics Coordinator' Job Description (Role)."

The moment this letter is signed and filed in the **Mall Ledger (etcd)**, the worker's badge "flashes green." When they tap it at the Front Desk, the clerk checks the Assignment Letter and says, "Welcome, Coordinator. Here is the Delivery Ledger you requested."

## The Entry Permit Office (Admission Control)

Even if you have a valid badge and a job description, you might still be stopped at the door. Before any worker can actually enter the mall, they must pass through the **Entry Permit Office**. This is **Admission Control**.

Think of it as a final compliance check:
- "Is this worker wearing the required safety vest?" (Resource Limits check)
- "Are they bringing any prohibited items?" (Security Policy check)
- "Is the shop already too crowded?" (Quota check)

The Admission Controllers can either **Validate** (check the rules) or **Mutate** (automatically add a safety vest if the worker forgot theirs). If the Permit Office says "No," the worker is rejected before they even get a chance to start their shift.

## Why Three Parts?

You might wonder why the Mall doesn't just write the permissions directly onto the badge. By separating the **Badge (Identity)**, the **Job Description (Group of Permissions)**, and the **Assignment Letter (The Link)**, the Mall stays organized:
- If the worker leaves, the Badge is deactivated, but the Job Description remains for the next hire.
- If the permissions for all coordinators change, the Owner updates one Job Description, and everyone with that assignment is automatically updated.

---

### 🧰 Study Toolbox

**🎨 Visualize the Analogy**
* [The Secure Badge (Comic 01)](../../visual-learning/comics/ch07-identity/01-the-secure-badge/README.md)
* [The HR Manual (Role) (Comic 02)](../../visual-learning/comics/ch07-identity/02-the-hr-manual/README.md)
* [The Entry Permit Office (Comic 03)](../../visual-learning/comics/ch07-identity/03-admission-control/README.md)

**📘 Technical Deep Dive**
* [Understanding RBAC (Technical Doc)](../../reference/md-resources/understanding-role-based-access-control-rbac.md)

**🛠️ Hands-on Practice**
* [Explore All Chapter 07 Labs](../../practice/labs/ch07-identity/README.md)

[<< Previous Chapter: Worker Safety & Conduct](ch06-worker-safety-and-conduct.md) | [Back to Story Index](../story.md) | [Mall Directory ✨](../../GLOSSARY.md) | [Next Chapter: Resource Budgets >>](ch08-resource-budgets.md)
