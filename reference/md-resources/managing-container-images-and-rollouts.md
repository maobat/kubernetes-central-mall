### 6.3.4.5 Managing Container Images & Rollouts

In Kubernetes, updating an application often involves changing the container image. This process is handled by the **Deployment** controller, which ensures zero-downtime updates using a **Rolling Update** strategy.

## Key Concepts

### 1. Container Images
Images are immutable snapshots of your application. When you need to update your app, you don't update the running image; you build a new one and tell Kubernetes to use it.

### 2. Rolling Updates
By default, Deployments use a `RollingUpdate` strategy. This replaces pods one-by-one, ensuring that some replicas are always available to serve traffic during the update.

### 3. Record & Rollback
Kubernetes keeps a history of your deployment revisions. If a new version is faulty, you can quickly roll back to a previous stable revision.

## Useful Commands

| Action | Command |
| :--- | :--- |
| **Update Image** | `kubectl set image deployment/<name> <container>=<new-image>` |
| **Check Status** | `kubectl rollout status deployment/<name>` |
| **View History** | `kubectl rollout history deployment/<name>` |
| **Undo Update** | `kubectl rollout undo deployment/<name>` |

### Official Documentation
For more detailed information, refer to the official Kubernetes documentation:
- [Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment)
- [Rolling Back a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#rolling-back-a-deployment)

---
[Back to Documentation](../README.md)
