# 🧪 LAB 06: Full Briefing ([ConfigMap](../../../../GLOSSARY.md#configmap) envFrom)

## Environment & Configuration – Injecting All Rules

---

## 🎯 Lab Goal

This lab focuses on injecting an entire **[ConfigMap](../../../../GLOSSARY.md#configmap)** as Environment Variables into a [Pod](../../../../GLOSSARY.md#pod). You will learn how to:
- Create a [ConfigMap](../../../../GLOSSARY.md#configmap) with multiple literal key-value pairs.
- Use `envFrom` to inject all keys natively as environment variables without specifying them individually.

> **CKAD Importance:** Core. Using `envFrom` saves a lot of YAML typing when an application expects multiple variables from a single configuration source.

---

## 🛍️ Mall Analogy

In the **Central Mall**, the Mall Manager has a long list of daily rules for the shop workers.

- **The Morning Briefing (envFrom):** Instead of telling the worker each rule individually, the Manager simply hands them the entire rulebook and says "memorize all of these before your shift."
- Unlike the **Employee Handbook (Volume Mount)** which is read throughout the day, the morning briefing is read once and kept in the worker's mind (Environment Variables) for the rest of their shift.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[ConfigMap](../../../../GLOSSARY.md#configmap)** | The list of daily rules. |
| **envFrom** | Telling the worker to memorize the entire list at once. |

---

## 📋 Requirements

1. **Create a [ConfigMap](../../../../GLOSSARY.md#configmap)** named `app-config`:
   - `APP_MODE`: `production`
   - `APP_VERSION`: `1.0`
2. **Deploy a [Pod](../../../../GLOSSARY.md#pod)** named `app-pod`:
   - Image: `nginx:1.29.0`
   - Inject all keys from the `app-config` [ConfigMap](../../../../GLOSSARY.md#configmap) as Environment Variables using `envFrom`.

---

## 🛠️ Step-by-Step Solution

### 1. Create the [ConfigMap](../../../../GLOSSARY.md#configmap)

Create the [ConfigMap](../../../../GLOSSARY.md#configmap) with the required literal values.

```bash
kubectl create cm app-config \
  --from-literal APP_MODE=production \
  --from-literal APP_VERSION=1.0
```

### 2. Scaffold the [Pod](../../../../GLOSSARY.md#pod)

Generate the basic YAML.

```bash
kubectl run app-pod --image=nginx:1.29.0 $do > app-pod.yaml
```

### 3. Edit the [Pod](../../../../GLOSSARY.md#pod) Configuration

Open `app-pod.yaml` and add the `envFrom` block.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app-pod
    image: nginx:1.29.0
    envFrom:
    - configMapRef:
        name: app-config
```

Apply the [pod](../../../../GLOSSARY.md#pod):
```bash
kubectl apply -f app-pod.yaml
```

---

## 🔎 Verification

1. **Wait for the [Pod](../../../../GLOSSARY.md#pod) to be Ready:**
   ```bash
   kubectl wait --for=condition=Ready pod/app-pod --timeout=60s
   ```

2. **Verify specific variables:**
   ```bash
   kubectl exec app-pod -- sh -c 'echo APP_MODE=$APP_MODE; echo APP_VERSION=$APP_VERSION'
   # Output should show:
   # APP_MODE=production
   # APP_VERSION=1.0
   ```

3. **Or list all environment variables and filter:**
   ```bash
   kubectl exec app-pod -- env | grep "^APP_"
   # Expected:
   # APP_MODE=production
   # APP_VERSION=1.0
   ```

---

## 🧠 Key Takeaways

- A [ConfigMap](../../../../GLOSSARY.md#configmap) can be mounted into Pods either as environment variables or as files (volumes).
- If the application supports reading environment variables, use `envFrom` to inject all keys, or `env` with `configMapKeyRef` to inject selectively.
- If the application expects configuration files, mount the [ConfigMap](../../../../GLOSSARY.md#configmap) as a volume so each key becomes a file.
- **CKAD Tip:** Always read the question carefully. "Mount as env vars" usually indicates `env` or `envFrom`, while "does not read env vars; config must be files" indicates a `volumeMount`.

## References

- **Comic** → [ConfigMap envFrom](../../../../visual-learning/comics/ch05-config-secrets/06-configmap-envfrom/README.md)
- **Docs** → [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/) | [Using ConfigMaps as Files](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configmap-volume-source) | [Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
- **Study Guide** → [Chapter 5: Configuration](../../../../sources/study-guide/ch05-configuration.md)
---
[Mall Directory ✨](../../../../GLOSSARY.md)
