# 🧪 LAB 01: The "Wonderful" Boutique Makeover (Rolling Update)

## Launch Strategies – Strategy Tuning & Upgrades

---

## 🎯 Lab Goal

Perform a **Rolling Update** of an application modifying its `maxSurge` and `maxUnavailable` parameters to achieve a seamless, zero-downtime transition.

> **CKAD Importance:** High. Adjusting Deployment strategies, performing rollouts, and checking rollout status are foundational CKAD tasks.

---

## 🛍️ Mall Analogy

In the **Central Mall**, changing an image from `httpd` to `nginx` is like renovating a boutique while keeping the doors open. We use a **Rolling Update** to ensure there is always a worker at the counter.

The shop "Wonderful" is switching suppliers. We need to move from the old system (`httpd:alpine`) to the new one (`nginx:alpine`). The Mall Manager demands specific safety rules during the renovation.

- **Current Gear:** `httpd:alpine`
- **Target Gear:** `nginx:alpine`
- **Safety Rule 1:** `maxSurge: 50%` (Allow 50% extra workers during transition).
- **Safety Rule 2:** `maxUnavailable: 0%` (Zero downtime, no empty counters).

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **RollingUpdate** | Renovating replacing staff/shelves one-by-one |
| **maxSurge** | Allowing extra temporary staff during the move |
| **maxUnavailable** | Tolerating empty counters during the move |

---

## � Requirements

1. **Initial Deployment:** Application "wonderful" is running with `httpd:alpine` and 3 replicas.
2. **Strategy:** Set `maxSurge` to 50% and `maxUnavailable` to 0%.
3. **Update:** Switch the image to `nginx:alpine`.
4. **Verification:** Wait till the rolling update has succeeded and the application is accessible.

---

## �🛠️ Step-by-Step Solution

### 1. The "Hacker" Scaffold (If needed)
If you need to prepare the ground from scratch in your lab environment:

```bash
# 1. Create the initial Deployment
kubectl create deploy wonderful-v1 --image=httpd:alpine --replicas=3

# 2. Expose it via NodePort (Port 30080 is common in Killercoda)
kubectl expose deploy wonderful-v1 --name=wonderful --type=NodePort --port=80 --target-port=80
```

### 2. The Strategy Surgery
Adjust the requirements directly in the YAML or using `edit`:

```bash
kubectl edit deploy wonderful-v1
```

**Modify the `spec` section to match these requirements:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wonderful-v1
  labels:
    app: wonderful-v1
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 50%         # Allowed to hire 50% extra staff during move
      maxUnavailable: 0%    # ZERO workers can be offline during move
  selector:
    matchLabels:
      app: wonderful-v1
  template:
    metadata:
      labels:
        app: wonderful-v1
    spec:
      containers:
      - name: httpd
        image: nginx:alpine # THE CHANGE: From httpd to nginx
```

---

## 🔎 Verification

Apply the changes (if using a file) or save the editor, and watch the "Shift Change" in the Mall Ledger.

1. **Watch the rollout progress:**
   ```bash
   kubectl rollout status deploy wonderful-v1
   ```

2. **Check the internal phone block:** (assuming /etc/hosts maps `wonderful` correctly)
   ```bash
   curl wonderful:30080
   ```

3. **Check if the new "Mannequin" (Image) is active:**
   ```bash
   kubectl get pods -l app=wonderful-v1 -o jsonpath='{.items[*].spec.containers[*].image}'
   ```

---

## 🧠 Key Takeaways

- **Rolling Updates are the Default:** Changing an image naturally triggers a rolling update in Kubernetes Deployments.
- **Tuning Availability:** Adjusting `maxSurge` and `maxUnavailable` gives you total control over the balance between rollout speed and resource over-provisioning versus application stability and availability.
- **Internal Routing:** A Service finds the Pods by `selector` ignoring their underlying image version, so the `NodePort` keeps working immediately!

---

## 🔗 References
- **Comic** → [Rolling Renovation](../../../../visual-learning/comics/ch09-launch/01-rolling-update/README.md)
- **Study Guide** → [Chapter 9: Launch Strategies](../../../../sources/study-guide/ch09-deployments.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
