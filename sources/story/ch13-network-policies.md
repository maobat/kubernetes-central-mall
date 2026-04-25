# 📖 Chapter 13: Network Policies: Locked Corridors and Badge Access

In a busy mall, not everyone should be allowed everywhere. You don't want a customer from the "Pet Store" accidentally wandering into the "Jewelry Vault," nor do you want a rival "Pizza Shop" employee spying on the secret recipe of the "Burger Joint." To prevent this, the Mall Owner installs **Locked Corridors**.

## The Firewall of the Mall (Network Policy)

A **Network Policy** is a set of security rules that decide which employees (Pods) can talk to each other. By default, in a standard mall (Kubernetes cluster), all corridors are open. Anyone can talk to anyone. This is convenient but dangerous.

The Mall Owner implements **Isolation**:
- **Ingress Rules:** Who is allowed to *enter* my shop? (e.g., "Only the Ingress entrance and the Inventory app can talk to me.")
- **Egress Rules:** Where are my employees allowed to *go*? (e.g., "My staff can talk to the Database, but they are forbidden from calling external websites.")

## Badge-Based Access (Selectors)

The security guards (the Network Plugin) don't look at individual faces. They look at the **Magnetic ID Badge** (Labels).

A rule might say: "Allow anyone with a `role: customer-support` badge to enter the `dept: complaints` office." If an employee from the "Janitorial" department tries to enter without that badge, the door remains locked.

By locking the corridors between competing departments and only allowing necessary communication, the Mall Owner ensures that even if one shop is "compromised," the rest of the mall remains secure.

---

### 🧰 Study Toolbox

**🎨 Visualize the Analogy**
* [The Locked Corridor - Whitelisting Traffic](../../visual-learning/comics/ch13-networking/01-locked-corridors/README.md)
* [The One-Way Corridor - Egress Control](../../visual-learning/comics/ch13-networking/02-one-way-corridors/README.md)

**📘 Technical Deep Dive**
* [Network Policies: Concept and Application](../../reference/md-resources/troubleshooting-kubernetes.md#section-8-3)

**🛠️ Hands-on Practice**
* [Explore Chapter 13 Labs](../../practice/labs/ch13-networking/README.md)

[<< Previous Chapter: Ingress & Gateway API](ch12-ingress-and-gateway-api.md) | [Back to Story Index](../story.md) | [Mall Directory ✨](../../GLOSSARY.md) | [Next Chapter: Probes & Health Checks >>](ch14-probes-and-health-checks.md)
