# 🧪 LAB 04: The New Fashion Test (Canary Deployments)

## Launch Strategies – Traffic Splitting & Testing in Production

---

## 🎯 Lab Goal

Implement a **Canary Deployment** using **NodePort** and **replica weighting**. You will learn how to route a small percentage of customers to a new version of your shop to test it before a full rollout.

> **CKAD Importance:** Medium. While complex traffic tools (Istio) are out of scope, the "Service Label Selector" trick for simple canaries is a classic CKAD pattern.

---

## 🛍️ Mall Analogy

In the **Central Mall**, we are testing a experimental new uniforms for our staff.

- **The Old Guard (oldbird)** → 9 workers in the classic blue uniform.
- **The New Guard (newbird)** → 1 worker in the experimental neon uniform.
- **The Common Entrance (Service)** → A single front door label "Fashion Outlet".
- **The Customer Experience (Traffic)** → Since there's only 1 neon worker out of 10 total staff, any customer walking through the door has a 10% chance of being served by the "Canary".

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **oldbird / newbird** | Two different implementations of the same shop. |
| **Shared Selector Label** | The common sign above the door (`type=bird`). |
| **Replica Count** | Determining the probability of who serves the user. |

---

## 📋 Requirements

1. **V1 Deployment**: `oldbird` (nginx:1.18), 9 replicas.
2. **V2 Deployment**: `newbird` (nginx:latest), 1 replica.
3. **Shared Label**: Both must have the label `type: bird`.
4. **Service**: Create a NodePort service that selects `type: bird`.
5. **Verify**: Observe that roughly 10% of requests hit the latest version.

---

## 🛠️ Step-by-Step Solution

### 1. Deploy the Standard Shop (V1)
```bash
k create deploy oldbird --image=nginx:1.18 --replicas=9
k label deploy oldbird type=bird --overwrite
# Ensure pods also have the label!
```

### 2. Deploy the Canary (V2)
```bash
k create deploy newbird --image=nginx:latest --replicas=1
k label deploy newbird type=bird --overwrite
```

### 3. Open the Common Entrance
```bash
k expose deploy oldbird --name=bird-portal --port=80 --type=NodePort --selector=type=bird
```

---

## 🔎 Verification

1. **Check Endpoints:**
   ```bash
   k describe svc bird-portal
   # You should see 10 IP addresses (9 from oldbird, 1 from newbird).
   ```

2. **Test Traffic Split:**
   ```bash
   for i in {1..10}; do curl -s $(minikube ip):<NODEPORT> | grep "nginx"; done
   # Statistically, you'll see one or two "latest" responses.
   ```

---

## 🧠 Key Takeaways

- **Math with Pods:** A Service simply sends traffic to all Pods matching its selector. It doesn't care about versions.
- **Simplicity:** This is the easiest way to do a canary without complex Ingress controllers or Service Meshes.
- **CKAD Tip:** Always use `k describe svc` to check the **Endpoints**. If you don't see both Deployment IPs listed, your labels are inconsistent.

---

## 🔗 References
- **Comic** → [Canary NodePort](../../../visual-learning/comics/ch09-launch/01-canary-nodeport/README.md)
- **Docs** → [Canary Deployments](../../../reference/md-resources/lab-canary-deployments-the-new-recipe-test.md)
- **Study Guide** → [Chapter 9: Launch Strategies](../../../sources/study-guide/ch09-deployments.md)
