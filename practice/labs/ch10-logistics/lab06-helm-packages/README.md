# 🧪 LAB 06: Prefab Stores & Blueprint Overlays (Helm & Kustomize)

## Logistics Tools – Managing Complex Manifests

---

## 🎯 Lab Goal

Learn how to manage Kubernetes resources at scale. You will use **Helm** to deploy fully "Prefabricated stores" from a catalog and **Kustomize** to apply custom overlays (like stickers or new paint) to standard blueprints without changing the original source.

> **CKAD Importance:** Medium-High. You must know basic Helm commands (`install`, `list`, `uninstall`) and how to use `kubectl apply -k`.

---

## 🛍️ Mall Analogy

In the **Central Mall**, we have two ways of building shops:

- **The Store-in-a-Box (Helm)** → You order a fully built MariaDB or WordPress shop from a catalog. You just fill out a form (`values.yaml`) to say how many registers you want, and the factory delivers the whole thing.
- **The Blueprint Overlay (Kustomize)** → You have a standard "Base" blueprint for a generic coffee shop. Instead of drawing on the original blueprint, you put a piece of tracing paper (Overlay) over it. You draw "Big Neon Sign" on the paper, and the final shop looks like the base *plus* your neon sign.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Helm** | A package manager for full applications. |
| **Values.yaml** | The order form for your prefab store. |
| **Kustomize** | A tool to modify existing YAMLs without editing them. |
| **Base / Overlay** | The original blueprint and the custom "tracing paper." |

---

## 📋 Requirements

1. **Helm**: Install an Nginx chart from the Bitnami repo with 2 replicas.
2. **Kustomize**:
   - Create a **Base** deployment (1 replica).
   - Create a **Staging Overlay** that patches the base to use 3 replicas.
   - Deploy using `kubectl -k`.

---

## 🛠️ Step-by-Step Solution

### 1. Helm: The Prefab Delivery
```bash
# Add repo and update
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Customize and install
helm install my-mall bitnami/nginx --set replicaCount=2
```

### 2. Kustomize: The Blueprint Surgery
Create the **Base**:
```bash
mkdir base
# [Create deployment.yaml inside base/]
cat <<EOF > base/kustomization.yaml
resources:
- deployment.yaml
EOF
```

Create the **Overlay**:
```bash
mkdir -p overlays/staging
# [Create patch.yaml to set replicas: 3]
cat <<EOF > overlays/staging/kustomization.yaml
resources:
- ../../base
patchesStrategicMerge:
- patch.yaml
EOF
```

Apply the final result:
```bash
kubectl apply -k overlays/staging
```

---

## 🔎 Verification

1. **Helm Check:**
   ```bash
   helm list
   kubectl get pods -l app.kubernetes.io/name=nginx
   # Should see 2 pods.
   ```

2. **Kustomize Check:**
   ```bash
   kubectl get pods -l app=mall
   # Should see 3 pods (the overlay worked!).
   ```

---

## 🧠 Key Takeaways

- **Helm for Consumption:** Use Helm when you want to deploy someone else's complex app (like Prometheus or Postgres).
- **Kustomize for Development:** Use Kustomize to manage your *own* apps across environments (Dev, Test, Prod) while keeping the base logic clean.
- **CKAD Tip:** `kubectl apply -k` is the magic command for Kustomize. You will likely see one question asking you to apply a kustomization directory.

---

## 🔗 References
- **Comic** → [Logistics Chain](../../../../visual-learning/comics/ch10-logistics/02-the-logistics-chain/README.md)
- **Docs** → [Helm Docs](https://helm.sh/docs/) | [Kustomize Docs](https://kustomize.io/)
- **Study Guide** → [Chapter 10: Management](../../../sources/study-guide/ch10-management.md)
