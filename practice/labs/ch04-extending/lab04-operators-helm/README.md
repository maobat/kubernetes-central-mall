# 🧪 LAB 04: The Franchise Manager (Operators & Helm)

## Extending the Mall – Intelligent Automation & Package Management

---

## 🎯 Lab Goal

Learn the difference between **Helm** (a static factory that produces shop kits) and **Operators** (an intelligent Franchise Manager that stays in the shop to manage it day-to-day).

---

## 🛍️ Mall Analogy

In the **Central Mall**, we have two ways of growing:

- **The Kit Assembly (Helm)** → A factory sends you a truck with all the parts for a coffee shop. You assemble it once, and the factory leaves. If the shop burns down, you have to call the factory to send another truck.
- **The Franchise Manager (Operator)** → A specialized manager who not only builds the shop but *stays there* 24/7. If a shelf breaks, the manager fixes it instantly without you asking.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Helm** | A "Shop-in-a-Box" assembly kit. |
| **Operator** | A dedicated, intelligent "Franchise Manager." |
| **Control Loop** | The Manager constantly checking: "Is the store okay?" |

---

## 📋 Requirements

Explore the interaction between package management and custom controllers.

1. **Scenario:** Understand how an Operator uses a CRD as its "to-do list."
2. **Practice:** Imagine a `MariaDB` operator watching for `MariaDB` custom resources.

---

## 🛠️ Step-by-Step Solution

### 1. Analyze the Relationship
Operators often install their own CRDs when they first arrive in the mall.
```bash
# Check if any operator-specific CRDs are present
kubectl get crds | grep -i operator
```

---

## 🧠 Key Takeaways

- **Helm:** Great for one-time setup and simple apps.
- **Operators:** Essential for complex, stateful apps (databases, messaging queues) that need active management.

---

## 🔗 References
- **Comic** → [The Nightly Backup Permit](../../../../visual-learning/comics/ch04-extending/01-the-nightly-backup-permit/README.md)
- **Docs** → [Operator Pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)
- **Study Guide** → [Chapter 04: Extending](../../../../sources/study-guide/ch04-extending-k8s.md)
