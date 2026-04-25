<img src="lab02-ingress-virtual-host.png" alt="Ingress Virtual Host" width="40%" />

# 🕵️ The Virtual Host Gateway Show

This comic explains how **Ingress** acts as a sophisticated reception desk that can route customers based on the "shop name" they ask for.

---

## 🛍️ Mall Analogy

- **The Reception Desk (Ingress)** → A single point of entry for the entire mall building.
- **Host Header** → A customer walks up and says, "Take me to *electronics.mall.com*." The receptionist doesn't just see a person; they listen to the specific request.
- **The Directory (Ingress Rules)** → The book the receptionist checks: "Electronics? That's on the 3rd floor at Service A. Clothing? That's on the 1st floor at Service B."
- **One IP, Many Shops** → The mall only has one main street address, but the receptionist can handle thousands of different shop names.

> 🛍️ *The receptionist doesn't sell shoes; they just tell you which elevator to take.*

---

## 🧠 Key Takeaways

- **Layer 7 Routing:** Unlike Services (which work at Layer 4), Ingress can inspect the HTTP traffic to route by **Hostname** or **URL Path** (e.g., `/buy` vs `/refund`).
- **SSL Termination:** The Ingress Gateway can handle the "Security Check" (HTTPS/SSL) once at the entrance, so the individual shops don't have to.
- **Cost Efficiency:** Using one Ingress with a single LoadBalancer IP is much cheaper than giving every Service its own LoadBalancer.
- **CKAD Tip:** You will likely need to create an Ingress rule. Practice the syntax for `rules`, `host`, `http`, `paths`, and `backend`.

---

## 🔗 References
- **Study Guide** → [Chapter 12: Ingress & Gateway API](../../../../sources/study-guide/ch12-ingress.md)
- **Lab** → [Ingress Virtual Hosts](../../../../practice/labs/ch12-ingress/lab03-ingress-virtual-host/README.md)
- **Docs** → [Managing Ingress Resources](../../../../reference/md-resources/managing-ingress-resources.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
