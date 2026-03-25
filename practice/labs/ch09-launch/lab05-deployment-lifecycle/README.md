# 🧪 Lab 05: Deployment Lifecycle, Create, Scale & Update

## Launch Strategies – The Complete Deployment Lifecycle

> **⚙️ Local Minikube Compatible**, uses standard `nginx` images, no special registry required.

---

## 🎯 Lab Goal

Walk through the full lifecycle of a Kubernetes Deployment in three steps:
1. **Create** a deployment from scratch
2. **Scale** it to handle more traffic
3. **Update** the image to release a new version (triggering a rolling update)

> **CKAD Importance:** High. Creating, scaling, and rolling out Deployments are bread-and-butter tasks in the exam.

---

## 🛍️ Mall Analogy

The **Scaler Boutique** is a new shop in the Central Mall. First, the owner opens the doors with a single counter. Then, when the weekend rush hits, they call in extra staff. Finally, when a better supplier is available, they swap the product line while the shop stays open.

| Step | Mall Story | K8s Action |
| :--- | :--- | :--- |
| **Create** | Open a single-counter shop | `kubectl create deploy` |
| **Scale** | Add 2 more counters for the rush | `kubectl scale deploy --replicas=3` |
| **Update** | Swap the product line mid-shift | `kubectl set image deploy ...` |

---

## 🛠️ Part 1, Create the Deployment

Create a deployment named `scaler` using `nginx:1.25` (v1):

```bash
kubectl create deploy scaler --image=nginx:1.25
```

Verify the deployment and its underlying ReplicaSet and Pod:

```bash
kubectl get deploy,rs,po -l app=scaler
```

Expected output:
```
NAME                    READY   UP-TO-DATE   AVAILABLE
deployment.apps/scaler  1/1     1            1

NAME                              DESIRED   CURRENT   READY
replicaset.apps/scaler-<hash>     1         1         1

NAME                         READY   STATUS    RESTARTS
pod/scaler-<hash>-<hash>     1/1     Running   0
```

**Optionally expose it** to verify it's serving traffic:

```bash
kubectl expose deploy scaler --port=80 --type=NodePort
# Access via:
curl http://$(minikube ip):$(kubectl get svc scaler -o jsonpath='{.spec.ports[0].nodePort}')
```

---

## 🛠️ Part 2, Scale to 3 Replicas

The weekend rush is here. Add two more counters:

```bash
kubectl scale deploy scaler --replicas=3
```

Watch the new pods appear:

```bash
kubectl get pods -l app=scaler -w
# Press Ctrl+C once all 3 are Running
```

Confirm:

```bash
kubectl get deploy scaler
# READY should show 3/3
```

---

## 🛠️ Part 3, Update the Image (Rolling Update)

The new supplier has arrived. Update from `nginx:1.25` to `nginx:1.27`:

```bash
kubectl set image deploy scaler nginx=nginx:1.27
```

> ⚠️ The container name (`nginx`) must match the name in the deployment spec. Check it with `kubectl describe deploy scaler | grep -A3 Containers`.

Watch the rolling update in real-time:

```bash
kubectl rollout status deploy scaler
# Waiting for deployment "scaler" rollout to finish: 1 out of 3 new replicas have been updated...
# ...
# deployment "scaler" successfully rolled out
```

Verify the new image is running:

```bash
kubectl get pods -l app=scaler -o jsonpath='{.items[*].spec.containers[*].image}'
# nginx:1.27  nginx:1.27  nginx:1.27
```

---

## 🔄 Rollback (Bonus)

If the new version has a problem, roll back instantly:

```bash
kubectl rollout undo deploy scaler
```

Check history:

```bash
kubectl rollout history deploy scaler
```

---

## 🔎 Verification Checklist

| Check | Expected |
| :--- | :--- |
| `kubectl get deploy scaler` after Part 1 | `1/1 READY` |
| `kubectl get deploy scaler` after Part 2 | `3/3 READY` |
| `kubectl rollout status deploy scaler` after Part 3 | `successfully rolled out` |
| Image check after Part 3 | All pods show `nginx:1.27` |

---

## 🧠 Key Takeaways

- **One command, full stack:** `kubectl create deploy` creates the Deployment, ReplicaSet, and Pod(s) automatically.
- **Scaling is non-destructive:** It simply adjusts `spec.replicas`; existing pods are not touched.
- **Rolling update is the default strategy:** Changing the image triggers a controlled replacement, old pods are only removed once new ones are healthy.
- **Container name matters:** `kubectl set image` targets by container name, not image name. Always verify it with `kubectl describe`.

---

## 🔗 References

- **Comic** → [The Trend Spot - Rolling Renovation](../../../../visual-learning/comics/ch09-launch/01-rolling-update/README.md)
- **Study Guide** → [Chapter 9: Launch Strategies](../../../../sources/study-guide/ch09-deployments.md)
- **Lab 01** → [Rolling Update with Strategy Tuning](../lab01-rolling-update-wonderful/README.md) *(advanced: maxSurge/maxUnavailable)*
