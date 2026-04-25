# 🧪 Lab 04: Blue-Green Sign Swap (Java Hello App)

## Launch Strategies – Guided Blue-Green with Real Apps & Challenges


> **⚙️ Local Minikube Compatible**, uses `hashicorp/http-echo` instead of KillerCoda-specific images.

---

## 🎯 Lab Goal

Perform a complete **Blue-Green [Deployment](../../../../GLOSSARY.md#deployment)** lifecycle using two real Java applications. You will inspect both versions, switch the traffic, and then reverse it, building muscle memory for the exam pattern.

> **CKAD Importance:** High. Blue-Green deployments are tested through [Service](../../../../GLOSSARY.md#service) selector manipulation. The challenge sections below simulate real CKAD scenarios.

---

## 🛍️ Mall Analogy

Two café storefronts exist side by side in the mall: **Blue Café (v1)** says "Hello Blue," and **Green Café (v2)** says "Hello Green." Each café has their own door (NodePort). The Mall Manager is about to move the **Blue Café sign** from the old kitchen to the new one, without any customer ever noticing.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| `hello-java-blue-v1` [Deployment](../../../../GLOSSARY.md#deployment) | Blue Café, currently open |
| `hello-java-green-v2` [Deployment](../../../../GLOSSARY.md#deployment) | Green Café, ready to serve |
| `svc-java-blue` [Service](../../../../GLOSSARY.md#service) | The Blue Café entrance sign |
| Editing the [Service](../../../../GLOSSARY.md#service) selector | Moving the sign overnight |

---

## 📋 Prerequisites, Deploy the Lab Environment

Apply both Deployments and Services to spin up the starting state:

```bash
kubectl apply -f deploy-spring-boot-blue.yaml
kubectl apply -f deploy-spring-boot-green.yaml
kubectl apply -f svc-spring-boot-blue.yaml
kubectl apply -f svc-spring-boot-green.yaml
```

Wait until all pods are ready:

```bash
kubectl get deploy
# NAME                  READY   UP-TO-DATE   AVAILABLE
# hello-java-blue-v1    3/3     3            3
# hello-java-green-v2   3/3     3            3
```

### 🌐 Access the Services (Minikube)

In minikube, NodePorts are not accessible via `localhost`. Use:

```bash
# Get the URL for the Blue service (port 30001)
minikube service svc-java-blue --url

# Get the URL for the Green service (port 30000)
minikube service svc-java-green --url
```

Or fetch the minikube IP once and reuse it:

```bash
MINIKUBE_IP=$(minikube ip)
curl http://$MINIKUBE_IP:30001   # → Hello Blue
curl http://$MINIKUBE_IP:30000   # → Hello Green
```

---

## 🛠️ Part 1, Switch Blue to serve Green

The goal is to redirect traffic on port `30001` (the Blue entrance) so it now serves the Green app, without touching the [Deployment](../../../../GLOSSARY.md#deployment), only the [Service](../../../../GLOSSARY.md#service).

### 1. Inspect the current selector

```bash
kubectl describe svc svc-java-blue | grep Selector
# Selector: app=hello-java-blue,version=v1
```

### 2. Edit the [Service](../../../../GLOSSARY.md#service) to point to the Green [Deployment](../../../../GLOSSARY.md#deployment)

```bash
kubectl edit svc svc-java-blue
```

Change the `selector` block:

```yaml
selector:
  app: hello-java-green
  version: v2
```

Save and exit (`:wq`).

### 3. Verify the switch

```bash
MINIKUBE_IP=$(minikube ip)
curl http://$MINIKUBE_IP:30001
# → Hello Green
```

Or: `minikube service svc-java-blue --url` and open the URL in your browser.

---

## 🛠️ Part 2, Reverse the switch (Green → Blue)

Now perform the same swap on `svc-java-green` (port `30000`). Direct its traffic to the Blue app instead.

Edit the [service](../../../../GLOSSARY.md#service):

```bash
kubectl edit svc svc-java-green
```

Change the selector to:

```yaml
selector:
  app: hello-java-blue
  version: v1
```

Revisit `svc-java-green`:

```bash
curl http://$(minikube ip):30000
# → Hello Blue
```

---

## 🎯 Challenge

Create a brand-new [Deployment](../../../../GLOSSARY.md#deployment) using the image `hashicorp/http-echo:latest`, apply the label `version: "3"` to its pods, expose it via a **NodePort [Service](../../../../GLOSSARY.md#service)** on port `8080`, and visit the resulting web page.

**What does the page say?**

<details>
<summary>💡 Solution</summary>

```bash
# 1. Apply the challenge deployment (already has version: "3" label)
kubectl apply -f deploy.yaml

# 2. Expose with NodePort
kubectl expose deploy java-hello \
  --port=8080 --target-port=8080 --type=NodePort

# 3. Get the assigned NodePort
kubectl get svc java-hello

# 4. Access it
curl http://$(minikube ip):<nodeport-from-above>
# → Hello World v3
```

</details>

---

## 🔎 Verification Checklist

| Check | Expected |
| :--- | :--- |
| Port `30001` after Part 1 | "Hello Green" |
| Port `30000` after Part 2 | "Hello Blue" |
| New NodePort from Challenge | Page renders v3 message |
| `kubectl get endpoints <svc>` | Shows correct [pod](../../../../GLOSSARY.md#pod) IPs |

---

## 🧠 Key Takeaways

- **[Service](../../../../GLOSSARY.md#service) selectors are the only lever** in a Blue-Green switch, no [Deployment](../../../../GLOSSARY.md#deployment) changes needed.
- **Labels must match exactly**: a single mismatch (`v2` vs `v2 `) means zero endpoints and a broken [service](../../../../GLOSSARY.md#service).
- **Instant rollback**: changing the selector back restores v1 in milliseconds.
- Blue-Green requires **double the resources** during the overlap window.

---

## 🔗 References

- **Comic** → [Blue/Green Sign Swap](../../../../visual-learning/comics/ch09-launch/01-blue-green-sign-swap/README.md)
- **Study Guide** → [Chapter 9: Launch Strategies](../../../../sources/study-guide/ch09-deployments.md)

## 🔄 See Also: Lab 02

| | **Lab 02** | **This lab (Lab 04)** |
| :--- | :--- | :--- |
| **Focus** | Build the full Blue-Green setup from scratch | Practice the switch & reverse with pre-built apps |
| **You author** | Deployments, labels, [Service](../../../../GLOSSARY.md#service) YAML | Only [Service](../../../../GLOSSARY.md#service) selector edits |
| **Bonus** |, | Challenge: deploy a v3 app from scratch |
| **Best for** | Understanding the pattern | Exam-speed muscle memory |

➡️ [Lab 02: Blue-Green with the Wonderful Boutique](../lab02-blue-green-wonderful/README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
