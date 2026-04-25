# 🧪 LAB 03: Swapping the Mannequins (Image Updates & Rollouts)

## Pod Design – Image Lifecycle & Deployment Rollouts

---

## 🎯 Lab Goal

This lab focuses on the **lifecycle of a Deployment**. You will learn how to:
- Create a Deployment with a specific image version.
- Perform a **Rolling Update** to a newer version without downtime.
- Observe the rollout status and history.
- Perform a **Rollback** (Undo) when a new version is "buggy."

> **CKAD Importance:** Fundamental. Expect to perform at least one rolling update and potentially a rollback.

---

## 🛍️ Mall Analogy

In the **Central Mall**, a **Deployment** is like a store's management firm. Instead of closing the shop to change everyone's clothes, they do it one worker at a time.

- **The Mannequin (Image Layer)** → A frozen, unchangeable blueprint of a worker.
- **The Uniform Swap (Rolling Update)** → Swapping the old mannequins for new ones one by one, so there's always someone at the counter.
- **The Backroom Records (Rollout History)** → A list of all the old uniform sets we used to have.
- **The Undo Button (Rollback)** → Realizing the new uniforms are ugly and immediately bringing back the old ones from the backroom.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Rolling Update** | Swapping workers one by one until everyone has the new uniform. |
| **Rollback** | Returning to a previous "Revision" of the uniform. |
| **Rollout History** | The history of all uniform changes. |

---

## 📋 Requirements

1. **Deploy the initial version**:
   - Deployment Name: `manager-firm`
   - Replicas: `3`
   - Image: `nginx:1.14`
2. **Perform an Update**: Change the image to `nginx:1.16`.
3. **Check the Rollout**: Monitor the status until completion.
4. **Undo the Change**: Roll back to the previous version (`1.14`).

---

## 🛠️ Step-by-Step Solution

### 1. Deploy the Shop
```bash
k apply -f deployment.yaml
# Or imperatively:
k create deploy manager-firm --image=nginx:1.14 --replicas=3
```

### 2. The Uniform Swap (Update)
Use the imperative command—it's much faster than editing YAML in the exam!
```bash
k set image deployment/manager-firm nginx=nginx:1.16
```

### 3. Watching the Rollout
```bash
k rollout status deployment/manager-firm
```

### 4. The Emergency Undo (Rollback)
```bash
# Check history first
k rollout history deployment/manager-firm

# Undo the last change
k rollout undo deployment/manager-firm
```

---

## 🔎 Verification

1. **Check the Image:**
   ```bash
   k describe deploy manager-firm | grep Image
   # Should show 1.14 again after the rollback.
   ```

2. **Check Pod Events:**
   ```bash
   k get pods
   # Notice that pods are being terminated and new ones created during the rollout.
   ```

---

## 🧠 Key Takeaways

- **Immutability:** You don't "update" a container; you replace its image/uniform.
- **Zero Downtime:** Rolling updates ensure your shop stays open during the swap.
- **Revision History:** Kubernetes keeps track of changes, allowing you to `undo` effortlessly.
- **CKAD Tip:** Always use `k rollout status` after a `set image` to ensure the update actually finished before moving to the next task.

---

## 🔗 References
- **Comic** → [Image Updates & Rollouts](../../../../visual-learning/comics/ch03-images/03-image-updates/README.md)
- **Docs** → [Managing Images and Rollouts](../../../../reference/md-resources/managing-container-images-and-rollouts.md)
- **Study Guide** → [Chapter 3: Pod Design](../../../../sources/study-guide/ch03-pod-design.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
