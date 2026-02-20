# Lab 03 – Pod Design: Image Updates & Rollouts

## Swapping the Mannequins

---

## 🎯 Lab Goal

This lab focuses on the **lifecycle of a Deployment**. You will learn how to:

- Create a Deployment with a specific image version.
- Perform a **Rolling Update** to a newer version.
- Observe the rollout status.
- Perform a **Rollback** (Undo) when something goes wrong.

This is a **fundamental CKAD skill** (Application Deployment).

---

## 🧠 Conceptual Comic (Read First)

Before starting, read this short comic:

👉 [Lab 03 - The Perfect Mannequin](../../../comics/pod-design/03-image-updates/README.md)

It explains **Image Layers and Rolling Updates**.

---

## 📘 Reference Docs

- Updating a Deployment → [6.3.4.5 managing container images and rollouts](../../../docs/md-resources/managing-container-images-and-rollouts.md)
- Rollback → [6.3.4.5 managing container images and rollouts](../../../docs/md-resources/managing-container-images-and-rollouts.md)

---

## 📋 Requirements

1. Create a **Deployment** named `manager-firm` using the provided `deployment.yaml`.
   - Initial Image: `nginx:1.14`
2. **Update** the image to `nginx:1.16` using an imperative command.
3. **Verify** the update status and history.
4. **Roll back** the deployment to the previous version (`nginx:1.14`).

---

## 🏬 Mall Analogy

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| **Container Image** | The **Mannequin** (Frozen blueprint of a worker). |
| **Deployment Update** | Swapping the **Uniform** on the mannequins one by one. |
| **Rollback** | Bringing back the **Old Uniform** from the backroom. |

---

## 🛠️ Solution

### 1️⃣ Deploy the Initial Version

👉 [Lab 03 - Initial Deployment](./deployment.yaml)

Apply the manifest:
```bash
kubectl apply -f deployment.yaml
```

Check the version currently running:
```bash
kubectl describe deploy manager-firm | grep Image
```

### 2️⃣ Perform a Rolling Update (The Uniform Swap)

Update the image to `nginx:1.16`:
```bash
kubectl set image deployment/manager-firm nginx=nginx:1.16
```

**Watch the rollout progress:**
```bash
kubectl rollout status deployment/manager-firm
```

### 3️⃣ Check History

See how many "Uniform Sets" (Revisions) you have in the backroom:
```bash
kubectl rollout history deployment/manager-firm
```

### 4️⃣ The "Undo" Button (Rollback)

Oops! The new uniform version is buggy. Roll back to the previous version:
```bash
kubectl rollout undo deployment/manager-firm
```

**Verify the version is back to 1.14:**
```bash
kubectl describe deploy manager-firm | grep Image
```

✅ **You have mastered Zero-Downtime Updates!**
