<img src="readiness-probes.png" alt="Readiness Probes - The Stocked Shelves" width="40%" />

# 🖼️ Comic: The Velvet Rope
## Chapter 14: Probes – Readiness Checks

This comic explains the "Stocked Shelves" analogy—understanding that being "alive" doesn't necessarily mean you are "ready" to serve customers.

---

## 🛍️ Mall Analogy

- **The Shop (Pod)** → A store in the mall building.
- **The "Open" Sign (Readiness status)** → A sign that only goes up when the shelves are stocked and the cash register is working.
- **Empty Shelves** → The worker is awake (Alive), but they are still unboxing inventory. The mall manager doesn't fire them, but they keep the "Closed" sign on the door.
- **The Service Guide** → If the "Closed" sign is up, the Mall Directory (Service) won't send any customers to that specific store until the sign flips to "Open".

> 🛍️ *Don't open the doors until you're ready to serve.*

---

## 🧠 Key Takeaways

- **Traffic Management:** Readiness probes don't restart Pods; they only determine if the Pod should be included in the **Service's Endpoints**.
- **Graceful Startup:** Use readiness probes to allow your app to load large datasets or warm up its cache before it starts receiving real user traffic.
- **Dynamic Routing:** If an app becomes temporarily overwhelmed (e.g., a connection pool is full), it can fail its readiness probe to "take a break" from traffic without being killed.
- **CKAD Tip:** If a Service isn't sending traffic to your Pods, use `kubectl get ep <service-name>` to see if the Pods are failing their readiness checks.

---

## 🔗 References
- **Study Guide** → [Chapter 14: Health Checks & Probes](../../../../sources/study-guide/ch14-probes.md)
- **Lab** → [Lab 02 - Readiness Probes](../../../../practice/labs/ch14-probes/lab02-readiness-probes/README.md)
- **Docs** → [Troubleshooting Guide](../../../../reference/md-resources/troubleshooting-kubernetes.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
