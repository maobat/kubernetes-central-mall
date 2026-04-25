# 🧪 LAB 03: The Canary Corner (Wonderful Boutique)

## Launch Strategies – Traffic Weighting & Testing in Production

---

## 🎯 Lab Goal

Implement a **[Canary Deployment](../../../../GLOSSARY.md#canary-deployment)** using **replica weighting** and a shared [Service](../../../../GLOSSARY.md#service) selector. You will learn how to route a small percentage of customers to a new version of your shop to test it before a full rollout.

> **CKAD Importance:** Medium. In the CKAD, you perform canary testing manually by adjusting the **Replica Count** of shared deployments since advanced traffic management tools are often out of scope for basic setups.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a **Canary Rollout** is like having 10 shop assistants. To test a new uniform, you give it to only 2 assistants (20%). 

Customers have an 80% chance of meeting the old style and a 20% chance of meeting the new one as they walk through the main entrance. We keep the main entrance ([Service](../../../../GLOSSARY.md#service)) exactly as it is; the workers just "join" the team by wearing the same brand badge (`app: wonderful`).

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Shared Selector Label** | The "Wonderful Boutique" badge (`app: wonderful`) both teams wear. |
| **Replica Count Strategy** | Hiring 8 classic workers and 2 "canary" workers to hit the 20% target. |
| **Probability Routing** | The random chance of a customer meeting a specific worker. |

---

## 📋 Requirements

The Manager wants to test `nginx:alpine` but is afraid of a total failure. 

**Initial State:** The application YAML is available at `/wonderful/init.yaml` (v1: `httpd:alpine`).

1. **The Math (80/20 Rule):** To achieve the 80/20 split with 10 total Pods:
   - **wonderful-v1:** 8 replicas (`httpd:alpine`).
   - **wonderful-v2:** 2 replicas (`nginx:alpine`).
2. **Current (v1):** Reduce the replicas of the old [deployment](../../../../GLOSSARY.md#deployment) to 8.
3. **New (v2):** Create a new [Deployment](../../../../GLOSSARY.md#deployment) `wonderful-v2` with 2 replicas using `nginx:alpine`.
4. **Shared Identity:** Both must have the label `app: wonderful` to be reached through the `NodePort` [Service](../../../../GLOSSARY.md#service)
   
---

## 🛠️ Step-by-Step Solution

### 1. Adjust the Main Squad (v1 - httpd:alpine - initial [deployment](../../../../GLOSSARY.md#deployment))
Scale the existing [deployment](../../../../GLOSSARY.md#deployment) to make room for the Canary.

```bash
kubectl scale deploy wonderful-v1 --replicas=8
```

### 2. Launch the Canary (v2)
Create the new [deployment](../../../../GLOSSARY.md#deployment). **Crucial:** It must share the same `app: wonderful` label so the existing [Service](../../../../GLOSSARY.md#service) can find it.

```bash
kubectl create deploy wonderful-v2 --image=nginx:alpine --replicas=2 --dry-run=client -o yaml > canary.yaml
```

**Edit `canary.yaml` to ensure the labels match the [Service](../../../../GLOSSARY.md#service) selector:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wonderful-v2
spec:
  replicas: 2
  selector:
    matchLabels:
      app: wonderful # Must match the Service selector!
  template:
    metadata:
      labels:
        app: wonderful # The "intercom" label shared with v1
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
```
Then apply the [canary deployment](../../../../GLOSSARY.md#canary-deployment)
```bash
kubectl apply -f canary.yaml
```

---

## 🔎 Verification

Since both Deployments share the label `app: wonderful`, the [Service](../../../../GLOSSARY.md#service) will distribute traffic randomly (Round Robin) among all 10 Pods.

1. **Check the Endpoints:** (You should see 10 IP addresses)
   ```bash
   k describe svc wonderful
   ```
   obviously previoulsly you need to expose the [service](../../../../GLOSSARY.md#service)

   ```bash
   k expose deploy wonderful-v1 --name=wonderful --type=NodePort --port=80 --target-port=80 --selector=app=wonderful
   ```

2. **Test Traffic Split:**
   ```bash
   PORT=$(kubectl get svc wonderful -o jsonpath='{.spec.ports[0].nodePort}')
   
   # Run multiple curls to see the different responses
   for i in {1..10}; do curl -sI $(minikube ip):$PORT | grep -i "Server"; done
   ```
   *Statistically, you should see 'httpd' about 8 times and 'nginx' about 2 times.*

---

## 🧠 Key Takeaways

- **The Selector is Key:** In Blue-Green, we change the [Service](../../../../GLOSSARY.md#service) selector. In Canary, we keep the [Service](../../../../GLOSSARY.md#service) selector fixed and let new Pods "join" the pool by sharing the same label.
- **Standardization:** In the real world, tools like **[Gateway API](../../../../GLOSSARY.md#gateway-api)** or **[Ingress](../../../../GLOSSARY.md#ingress)-Nginx** handle this with percentages (Weights). In the CKAD, you often do it manually with the **Replica Count**.
- **Low Risk:** If the "Canary" Pods fail, only 20% of the customers are affected while you investigate.

---

## 🔗 References
- **Comic** → [Canary Traffic at the Side Entrance](../../../../visual-learning/comics/ch09-launch/01-canary-nodeport/README.md)
- **Study Guide** → [Chapter 9: Launch Strategies](../../../../sources/study-guide/ch09-deployments.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
