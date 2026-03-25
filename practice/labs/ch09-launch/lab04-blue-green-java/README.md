# 🧪 Lab 04: Blue-Green Sign Swap (Java Hello App)

## Launch Strategies – Guided Blue-Green with Real Apps & Challenges

---

## 🎯 Lab Goal

Perform a complete **Blue-Green Deployment** lifecycle using two real Java applications. You will inspect both versions, switch the traffic, and then reverse it — building muscle memory for the exam pattern.

> **CKAD Importance:** High. Blue-Green deployments are tested through Service selector manipulation. The challenge sections below simulate real CKAD scenarios.

---

## 🛍️ Mall Analogy

Two café storefronts exist side by side in the mall: **Blue Café (v1)** says "Hello Blue," and **Green Café (v2)** says "Hello Green." Each café has their own door (NodePort). The Mall Manager is about to move the **Blue Café sign** from the old kitchen to the new one — without any customer ever noticing.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| `hello-java-blue-v1` Deployment | Blue Café, currently open |
| `hello-java-green-v2` Deployment | Green Café, ready to serve |
| `svc-java-blue` Service | The Blue Café entrance sign |
| Editing the Service selector | Moving the sign overnight |

---

## 📋 Prerequisites

Two Deployments and two Services already exist in the cluster:

```bash
kubectl get deploy
# NAME                  READY   UP-TO-DATE   AVAILABLE
# hello-java-blue-v1    3/3     3            3
# hello-java-green-v2   3/3     3            3

kubectl get svc
# NAME             TYPE        CLUSTER-IP      PORT(S)
# svc-java-blue    NodePort    10.99.60.93     8080:30001/TCP
# svc-java-green   NodePort    10.97.210.25    8080:30000/TCP
```

> ⚠️ Deployments may take up to 90 seconds to become ready. Re-run `kubectl get deploy` until all show `3/3`.

You can verify the two apps by visiting:
- Port `30001` → **"Hello Blue"** (served by `hello-java-blue-v1`)
- Port `30000` → **"Hello Green"** (served by `hello-java-green-v2`)

---

## 🛠️ Part 1 — Switch Blue to serve Green

The goal is to redirect traffic on port `30001` (the Blue entrance) so it now serves the Green app — without touching the Deployment, only the Service.

### 1. Inspect the current selector

```bash
kubectl describe svc svc-java-blue | grep Selector
# Selector: app=hello-java-blue,version=v1
```

### 2. Edit the Service to point to the Green Deployment

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

Revisit port `30001`. The page should now say **"Hello Green"** — the sign has moved!

```bash
# Optional: confirm endpoints updated
kubectl get endpoints svc-java-blue
```

---

## 🛠️ Part 2 — Reverse the switch (Green → Blue)

Now perform the same swap on `svc-java-green` (port `30000`). Direct its traffic to the Blue app instead.

Edit the service:

```bash
kubectl edit svc svc-java-green
```

Change the selector to:

```yaml
selector:
  app: hello-java-blue
  version: v1
```

Revisit port `30000`. It should now say **"Hello Blue"**.

---

## 🎯 Challenge

Create a brand-new Deployment using the image `chadmcrowell/hello-world-java`, apply the label `version: "3"` to its pods, expose it via a **NodePort Service** on port `8080`, and visit the resulting web page.

**What does the page say?**

<details>
<summary>💡 Solution</summary>

```bash
# 1. Generate the Deployment YAML
kubectl create deploy java-hello \
  --image=chadmcrowell/hello-world-java \
  --dry-run=client -o yaml > deploy.yaml
```

Edit `deploy.yaml` to add `version: "3"` to the pod template labels:

```yaml
template:
  metadata:
    labels:
      app: java-hello
      version: "3"
```

```bash
kubectl apply -f deploy.yaml

# 2. Expose with NodePort
kubectl expose deploy java-hello \
  --port=8080 --target-port=8080 --type=NodePort

# 3. Get the assigned NodePort
kubectl get svc java-hello
```

Visit the NodePort shown in the output. The page will say the v3 message.

</details>

---

## 🔎 Verification Checklist

| Check | Expected |
| :--- | :--- |
| Port `30001` after Part 1 | "Hello Green" |
| Port `30000` after Part 2 | "Hello Blue" |
| New NodePort from Challenge | Page renders v3 message |
| `kubectl get endpoints <svc>` | Shows correct pod IPs |

---

## 🧠 Key Takeaways

- **Service selectors are the only lever** in a Blue-Green switch — no Deployment changes needed.
- **Labels must match exactly**: a single mismatch (`v2` vs `v2 `) means zero endpoints and a broken service.
- **Instant rollback**: changing the selector back restores v1 in milliseconds.
- Blue-Green requires **double the resources** during the overlap window.

---

## 🔗 References

- **Comic** → [Blue/Green Sign Swap](../../../../visual-learning/comics/ch09-launch/01-blue-green-sign-swap/README.md)
- **Study Guide** → [Chapter 9: Launch Strategies](../../../../sources/study-guide/ch09-deployments.md)
- **Lab 02** → [Blue-Green with the Wonderful Boutique](../lab02-blue-green-wonderful/README.md)
