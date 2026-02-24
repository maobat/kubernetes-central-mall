# LAB 06 – Logistics Tools: Helm & Kustomize

---

## 🎯 Lab Goal
Learn how to deploy "Prefabricated Stores" (Helm Charts) and how to overlay "Custom Blueprints" (Kustomize) on top of standard Mall layouts.

---

## 📖 Related Chapter
👉 [Chapter 10: Logistics Tools](../../../sources/study-guide/ch10-management.md)

---

## 📖 Related Comic
👉 [The Logistics Chain](../../../comics/deploying/02-the-logistics-chain/README.md)

---

## 🛍️ Mall Analogy
- **Helm:** Ordering a fully prefabricated store from a catalog (like a Bitnami MySQL store). You tell the factory "I want 3 registers and blue paint" via a `values.yaml` form.
- **Kustomize:** Taking a standard floor plan (base) and putting a piece of tracing paper over it (overlay) to cross out "1 Register" and draw in "5 Registers".

---

## 📦 Part 1: Helm (The Prefab Store)

**Step 1.1: Add the Bitnami Catalog (Repo)**
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```

**Step 1.2: Inspect the Blueprint (Show Values)**
Before buying, let's see what options we can customize:
```bash
helm show values bitnami/nginx > nginx-values.yaml
```

**Step 1.3: Customize the Order**
Edit `nginx-values.yaml` and change `replicaCount: 1` to `replicaCount: 2`.

**Step 1.4: Install the Store**
Install the NGINX store using your custom order form:
```bash
helm install my-mall-nginx bitnami/nginx -f nginx-values.yaml
```

**Step 1.5: Verify the Delivery**
```bash
helm list
kubectl get pods
# You should see two NGINX pods running.
```

---

## 📐 Part 2: Kustomize (The Blueprint Overlay)

**Step 2.1: Create the Base Blueprint**
Create a directory `base/` and put a simple Deployment in it:
```bash
mkdir base
cat <<EOF > base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mall-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mall
  template:
    metadata:
      labels:
        app: mall
    spec:
      containers:
      - name: app
        image: nginx:alpine
EOF
```

Create exactly `base/kustomization.yaml`:
```yaml
resources:
- deployment.yaml
```

**Step 2.2: Create the Staging Overlay**
Create a directory `overlays/staging/`:
```bash
mkdir -p overlays/staging
```

Create an overlay that changes the replicas to 3 without touching the base deployment file:
```yaml
# overlays/staging/kustomization.yaml
resources:
- ../../base
patchesStrategicMerge:
- patch.yaml
```

```yaml
# overlays/staging/patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mall-app
spec:
  replicas: 3
```

**Step 2.3: Build and Apply the Blueprint**
Instead of applying the base, apply the overlay using `-k`:
```bash
kubectl apply -k overlays/staging
kubectl get pods
# You should see three pods running!
```

---

## 🧹 Cleanup
```bash
helm uninstall my-mall-nginx
kubectl delete -k overlays/staging
```

---

## 🧠 Key Takeaways for CKAD

- **Helm** uses `helm install` and `helm upgrade`, customizing via `values.yaml`.
- **Kustomize** is built natively into `kubectl apply -k`. It applies overlays to base resources using `patchesStrategicMerge` or `patchesJson6902`.
- You don't need to write complex Helm templates in the exam, but you *must* know how to pull a chart, modify its values, and deploy it.
- For Kustomize, practice creating `kustomization.yaml` files and changing basic fields like replicas or image versions.
