### 6.3.1 Using Kustomize (The "Transparent Sheet" Method)
Kustomize is a native Kubernetes tool that tweaks YAMLs without templates.

**The "Flat" Approach (Quick Fixes):** you can put a `kustomization.yaml` in the same folder as your manifests to quickly add a `test-` prefix. This is great for a one-time test.

**The "Professional" Approach (Base & Overlays):** For real DevOps, we use the **Base/Overlay** pattern. This prevents "test" settings from ever accidentally reaching "production" by separating the core blueprints from environment-specific tweaks.

---

### 6.3.1.1 The Directory "Brain"
  - **Base:** The "Pure" blueprint (No prefixes, No namespaces).
  - **Overlays:** The environment-specific "filters" (Dev, Prod, Staging).

---
### 6.3.1 Lab Understanding Kustomize

Kustomize uses a file with the name `kustomization.yaml` to apply changes to a set of resources.

* **Convenience:** This is particularly convenient for applying non-destructive changes to input files (e.g., community charts or third-party manifests) that the user does not control and whose contents may change because of new versions appearing in Git.
* **Application Command:** Use `kubectl apply -k ./` in the directory with the `kustomization.yaml` and the files it refers to to apply changes.
* **Deletion Command:** Use `kubectl delete -k ./` in the same directory to delete all resources created by the Kustomization.

---
### Understanding a Sample `kustomization.yaml`

**The `base` directory** contains only the manifests (Deployment, Service) without environment prefixes or labels. Each overlay (dev, prod, staging) consumes this base and individually applies the appropriate prefix and label. This eliminates the unintended creation of default "testing" resources.

#### 1. Directory Structure

The structure remains the same, but the function of the `base` directory has changed.

```text
.
├── base
│   ├── deployment.yaml
│   ├── kustomization.yaml
│   └── service.yaml
└── overlays
    ├── dev
    │   └── kustomization.yaml
    ├── prod
    │   └── kustomization.yaml
    └── staging
        └── kustomization.yaml
```
---
#### 2. Base Configuration Files (PURE)

The base defines the default configuration that the overlays will extend. **We no apply environment-specific prefixes or labels here.**

---
#### `base/deployment.yaml`

Defines the core Nginx deployment with 3 replicas and default resource limits.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: nginx-friday20
  name: nginx-friday20
spec:
  replicas: 3 # This is the base value, modified by the overlays
  selector:
    matchLabels:
      app: nginx-friday20
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: nginx-friday20
    spec:
      containers:
      - image: nginx
        imagePullPolicy: Always
        name: nginx-friday20-container
        resources:
          limits:
            memory: "128Mi"
            cpu: "500m"
        securityContext:
          privileged: false
      terminationGracePeriodSeconds: 30
```

#### `base/service.yaml`

Defines the LoadBalancer service for the application.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-friday20-service
  labels:
    app: nginx-friday20
spec:
  type: LoadBalancer 
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: http
  selector:
    app: nginx-friday20
```

#### `base/kustomization.yaml` (Pure Resource Base)

Contains only the resources, without modifiers like `namePrefix` or `commonLabels`.

```yaml
resources:
  - deployment.yaml
  - service.yaml
```

### 3. Overlay Configurations

Each overlay now specifies both the prefix and the label, ensuring no unintended "testing" resources are created.

#### `overlays/dev/kustomization.yaml` (Development)

Sets the name prefix to `dev-`, updates the label to `dev`, and patches the deployment to use 1 replica.

```yaml
resources:
  - ../../base
namespace: development # <--- Add this for completeness
# Apply the specific environment prefix
namePrefix: dev-

commonLabels:
  environment: dev

# Reduce replicas for development
patches:
- target:
    kind: Deployment
    name: nginx-friday20
  patch: |-
    - op: replace
      path: /spec/replicas
      value: 1
```

#### `overlays/prod/kustomization.yaml` (Production)

Sets the name prefix to `prod-`, updates the label to `prod`, and patches the deployment to use 5 replicas and increases the CPU limit to `1000m`.

```yaml
resources:
  - ../../base

# Apply the specific environment prefix
namePrefix: prod-

commonLabels:
  environment: prod

# Increase replicas and resources for production
patches:
- target:
    kind: Deployment
    name: nginx-friday20
  patch: |-
    - op: replace
      path: /spec/replicas
      value: 5
    - op: replace
      path: /spec/template/spec/containers/0/resources/limits/cpu
      value: "1000m"
```

#### `overlays/staging/kustomization.yaml` (Staging)

Sets the name prefix to `staging-`, updates the label to `staging`, and patches the deployment to use 2 replicas.

```yaml
resources:
  - ../../base

# Apply the specific environment prefix
namePrefix: staging-

commonLabels:
  environment: staging

# Set replicas to 2 for staging (intermediate between dev and prod)
patches:
- target:
    kind: Deployment
    name: nginx-friday20
  patch: |-
    - op: replace
      path: /spec/replicas
      value: 2
```

### 4. Deployment Demonstration and Status (Overlays Only)

We now apply only the overlays, as the base is not intended for direct application.

### Deployment 1: Dev Environment

Applying the development overlay configuration:

```bash
kubectl apply -k overlays/dev
# service/dev-nginx-friday20-service created
# deployment.apps/dev-nginx-friday20 created
```

Checking resources labeled `environment=dev`:

> (Note: The prefix is now just `dev-`)

```bash
kubectl get all --selector environment=dev
NAME                                  READY   STATUS    RESTARTS   AGE
pod/dev-nginx-friday20-78b85c9fff-wf8zw       1/1     Running   0          33s

NAME                                     TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
service/dev-nginx-friday20-service         LoadBalancer    10.103.3.231    <pending>     80:30856/TCP      33s

NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/dev-nginx-friday20         1/1     1            1           33s

NAME                                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/dev-nginx-friday20-78b85c9fff               1         1         1       33s
```

*Result:* Resources are prefixed with **`dev-`** and running 1 replica. 

#### Deployment 2: Prod Environment

Applying the production overlay configuration:

```bash
kubectl apply -k overlays/prod
# service/prod-nginx-friday20-service created
# deployment.apps/prod-nginx-friday20 created
```

Checking resources labeled `environment=prod`:

> (Note: The prefix is now just `prod-`)

```bash
kubectl get all --selector environment=prod
NAME                                  READY   STATUS    RESTARTS   AGE
pod/prod-nginx-friday20-58d8c8f884-4dfpg       1/1     Running   0          11m
# ... (4 more Pods)

NAME                                      TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
service/prod-nginx-friday20-service         LoadBalancer    10.102.92.25    <pending>     80:32081/TCP      11m

NAME                                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/prod-nginx-friday20         5/5     5            5           11m

NAME                                                    DESIRED   CURRENT   READY   AGE
replicaset.apps/prod-nginx-friday20-58d8c8f884               5         5         5       11m
```
> *Result:* Resources are prefixed with **`prod-`** and running 5 replicas, with increased CPU limits. 

> **No `test-` resources were created.**
---


**Integration Note for CKAD**


**Helm (6.2.2)** is best when you are using **third-party apps** (like MySQL or Grafana) where the developers provided a "Menu" (values.yaml) for you.

**Kustomize (6.3.1)** is best for **your own apps**, where you want to keep your YAMLs simple and "Pure," but need different versions for Dev, Staging, and Prod.
