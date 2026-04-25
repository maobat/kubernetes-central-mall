# 🧪 LAB 02: Prefab Stores & Blueprint Overlays (Helm & Kustomize)

## Logistics Tools – Managing Complex Manifests

---

## 🎯 Lab Goal

Learn how to manage Kubernetes resources at scale using **Helm** for third-party apps and **Kustomize** for overriding your own internal blueprints across different environments.

---

## 🛍️ Mall Analogy

In the **Central Mall**, we have two ways of building shops:

- **The Store-in-a-Box (Helm)** → You order a fully built MariaDB shop from a catalog.
- **The Blueprint Overlay (Kustomize)** → You have a standard "Base" blueprint for a coffee shop. You put a piece of tracing paper (Overlay) over it to add a "Big Neon Sign" for the Staging environment.

---

## 🛠️ Step-by-Step Solution

### 1. Helm: The Prefab Delivery
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-mall bitnami/nginx --set replicaCount=2
```

### 2. Kustomize: The Blueprint Surgery
Create the **Base**:
```bash
mkdir base
vi base/deployment.yaml
vi base/kustomization.yaml
```

**Fill `base/kustomization.yaml`:**
```yaml
resources:
- deployment.yaml
```

Create the **Overlay**:
```bash
mkdir -p overlays/staging
vi overlays/staging/patch.yaml
vi overlays/staging/kustomization.yaml
```

**Fill `overlays/staging/kustomization.yaml`:**
```yaml
resources:
- ../../base
patchesStrategicMerge:
- patch.yaml
```

Apply the final result:
```bash
kubectl apply -k overlays/staging
```

---

## 🔗 References
- **Comic** → [The Logistics Chain](../../../../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
- **Docs** → [Kustomize](https://kustomize.io/)
- **Study Guide** → [Chapter 10: Management](../../../../sources/study-guide/ch10-management.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
