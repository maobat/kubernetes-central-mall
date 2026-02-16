<img src="lab04-canary-nodeport.png" alt="Canary NodePort" width="40%" />

# 🕵️ Canary Traffic at the Side Entrance

This comic explains:

- how canary works **without Ingress**
- why traffic split happens via **replicas**
- the limits of NodePort-based canary

---

## 🛍️ Mall Analogy

- One entrance
- Two shops behind the same door
- More clerks = more customers

---

## 🧠 Key Takeaways

- NodePort has no traffic awareness
- Canary = replica math
- Simple but limited strategy

---

## 🔗 References
- Lab → [LAB 04 – Canary with NodePort](../../../labs/deploying/lab04-canary-nodeport/README.md)
