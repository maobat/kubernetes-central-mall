# 🧪 LAB 01: Blue-Green Sign Swap (Wonderful Boutique)

## Launch Strategies – Instant Traffic Switching & High-Availability

---

## 🎯 Lab Goal

Implement a **Blue-Green Deployment** strategy. You will learn how to run two full environments in parallel and perform an instant cutover using a Kubernetes Service.

> **CKAD Importance:** High. Understanding how Services route traffic based on labels is a core requirement for mastering deployment patterns like Blue-Green and Canary.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a **Blue-Green Deployment** is like building a brand new shop (**Green**) right next to the old one (**Blue**). 

The old shop stays open until the new one is perfect. Once the manager is satisfied, they simply move the "Main Entrance" sign from the old door to the new one. In an instant, customers follow the sign to the new version!

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Blue Environment** | The existing shop serving customers. |
| **Green Environment** | The new shop being prepared/tested behind the scenes. |
| **Service Selector** | The "Main Entrance" sign points to the new location. |

---

## 📋 Requirements

The "Wonderful" boutique needs a total overhaul. The Manager wants an **instant switch**: one second customers see the old shop (`httpd`), the next second they see the new one (`nginx`).

1. **Blue (v1):** Already running (Deployment `wonderful-v1`, image `httpd:alpine`).
2. **Green (v2):** Create a new Deployment `wonderful-v2` with `nginx:alpine` and 4 replicas.
3. **The Switch:** Update the selector of the `wonderful` Service to point to the `v2` version.
4. **Cleanup:** Scale the old version to 0 once verified.

---

## 🛠️ Step-by-Step Solution

### 1. The "Hacker" Scaffold (If needed)
If you need to prepare the "Blue" environment:
```bash
kubectl create deploy wonderful-v1 --image=httpd:alpine --replicas=3
kubectl label deploy wonderful-v1 app=wonderful version=v1 --overwrite
kubectl expose deploy wonderful-v1 --name=wonderful --type=NodePort --port=80 --target-port=80 --selector=app=wonderful,version=v1
```

### 2. Prepare the "Green" Deployment
We build the new version in parallel without touching the old one.

```bash
kubectl create deploy wonderful-v2 --image=nginx:alpine --replicas=4 --dry-run=client -o yaml > wonderful-v2.yaml
```

**Edit `wonderful-v2.yaml` to ensure the labels are correct:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wonderful-v2
  labels:
    app: wonderful
spec:
  replicas: 4
  selector:
    matchLabels:
      app: wonderful
      version: v2  # CRITICAL: Distinguishes Green from Blue
  template:
    metadata:
      labels:
        app: wonderful
        version: v2
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
```

### 3. Flip the Switch
Once the new pods are `Running`, update the Service:

```bash
kubectl edit svc wonderful
```

**Change the selector:**
```yaml
spec:
  selector:
    app: wonderful
    version: v2  # Switch from v1 to v2
```

> [!TIP]
> **Deep Dive:** Want to know why this works and how to do it even faster with `kubectl patch`? Check out the [Service Selectors & Label Matching](../../../../sources/study-guide/ch09-deployments.md#☎️-resource-service-selectors--label-matching) resource in the Study Guide.

---

## 🔎 Verification

1. **Check the Entrance:**
   ```bash
   # Should now see the Nginx welcome page
   curl wonderful:30080
   ```

2. **Decommission Blue:**
   ```bash
   kubectl scale deploy wonderful-v1 --replicas=0
   ```

---

## 🧠 Key Takeaways

- **Isolation by Labels:** The `version` label is the key. Without it, the Service would route traffic to both versions simultaneously.
- **Instant Rollback:** If v2 fails, simply edit the Service and change the selector back to `version: v1`.
- **Resource Usage:** Remember that Blue-Green requires double the resources during the transition period.

---

## 🔗 References
- **Comic** → [Blue/Green Sign Swap](../../../../visual-learning/comics/ch09-launch/01-blue-green-sign-swap/README.md)
- **Study Guide** → [Chapter 9: Launch Strategies](../../../../sources/study-guide/ch09-deployments.md)

## 🔄 See Also: Lab 04

| | **This lab (Lab 02)** | **Lab 04** |
| :--- | :--- | :--- |
| **Focus** | Build the full Blue-Green setup from scratch | Practice the switch & reverse with pre-built apps |
| **You author** | Deployments, labels, Service YAML | Only Service selector edits |
| **Bonus** | - | Challenge: deploy a v3 app from scratch |
| **Best for** | Understanding the pattern | Exam-speed muscle memory |

➡️ [Lab 04: Blue-Green Java App (Guided + Challenge)](../lab04-blue-green-java/README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
