# 3.4 Mall Analogy: Ingress vs. Gateway API

Kubernetes traffic management has evolved.  
The shift from **Ingress** to **Gateway API** is not just a technical upgrade, but a **philosophical change** in how responsibilities are divided inside the mall.

---

## Ingress: The Old Way

**Ingress** is like a single, giant instruction manual stored at the front desk.

- Every shop shares the same document.
- A small change for the *Boutique* requires editing the same file used by the *Café*.
- Ownership is unclear.
- Mistakes affect the entire mall.

This model works, but it does not scale well with multiple teams.

---

## Gateway API: The New Way

The **Gateway API** introduces clear role separation.

- **The Mall Owner** creates the **GatewayClass**  
  *(Defines the standard and technology to be used)*

- **The Security Manager** configures the **Gateway**  
  *(Opens doors, listeners, and external access)*

- **The Shop Owner** manages their own **HTTPRoute**  
  *(Controls traffic routing for their application only)*

Each role operates independently, reducing risk and conflict.

---

## Feature Comparison

| Feature | Ingress (The Old Way) | Gateway API (The New Way) |
|-------|----------------------|---------------------------|
| **Philosophy** | One-size-fits-all (Single resource) | Divide and Conquer (Modular resources) |
| **Control Model** | Developers share and modify the same file | Admin controls the entrance, developers control their routes |
| **Customization** | Heavy reliance on annotations | First-class API features (headers, weights, matches) |
| **Extensibility** | Limited and vendor-specific | Built-in, role-aware, and extensible |
| **Exam Status** | Current CKAD standard | Emerging and increasingly important (2026+) |

---

## Why This Matters for CKAD

While **Ingress** remains relevant for the exam, understanding **Gateway API** gives you:

- A future-proof mental model
- A clear explanation of traffic ownership
- Confidence in modern Kubernetes architectures

Think of Gateway API as the **professional mall redesign**: safer, cleaner, and built for growth.
