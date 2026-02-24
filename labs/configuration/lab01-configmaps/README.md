# Lab 01 – Configuration: ConfigMaps

## Decoupling Configuration from Application Code

---

## 🎯 Lab Goal

This lab focuses on **managing application configuration** using **ConfigMaps**. You will learn how to:

- **Decouple** configuration from container images.
- Create a **ConfigMap** imperatively (from literal).
- Inject configuration as **Environment Variables**.
- Mount configuration files as **Volumes**.

This is a **core CKAD topic**.

---

## 📖 Related Comic
👉 [comics/configuration/01-configmap/README.md](../../../comics/configuration/01-configmap/README.md)

It explains **ConfigMaps, Env Vars, and Decoupling**.

---

## 📘 Reference Docs

- ConfigMaps vs Secrets → [`docs/md-resources/core-concepts-configmaps-secrets-and-security.md`](../../../docs/md-resources/core-concepts-configmaps-secrets-and-security.md)
- Configuration Decoupling → [`docs/md-resources/configuration-decoupling.md`](../../../docs/md-resources/configuration-decoupling.md)
- Variables vs Files → [`docs/md-resources/configmaps-variables-vs-configuration-files.md`](../../../docs/md-resources/configmaps-variables-vs-configuration-files.md)

---

## 📋 Requirements

1. Create a **ConfigMap** named `app-config`
   - Key: `APP_COLOR` -> Value: `blue`
   - Key: `APP_MODE` -> Value: `prod`

2. Create a Pod named `config-pod` (image: `nginx`)
   - Inject `APP_COLOR` as an environment variable named `COLOR`.
   - Mount the entire ConfigMap as a volume at `/etc/config`.

3. **Verify**:
   - Check the environment variable inside the Pod.
   - Check the file `/etc/config/APP_MODE` inside the Pod.

---

## 🏬 Mall Analogy

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| **ConfigMap** | The **Rules & Guidelines** board in the breakroom. |
| **Env Var Injection** | Telling the employee "Wear the **Blue** uniform today". |
| **Volume Mount** | Giving the employee a **Rulebook** to keep in their pocket. |

---

## 🛠️ Solution

### 1️⃣ Create the ConfigMap Imperatively

Fastest way for CKAD:

```bash
kubectl create configmap app-config \
  --from-literal=APP_COLOR=blue \
  --from-literal=APP_MODE=prod
```

### 2️⃣ Create the Pod with Env Vars and Volume Mount

👉 [Lab 01 - The ConfigPod](./config-pod.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-pod
spec:
  containers:
  - name: nginx
    image: nginx
    # 1. Inject as Environment Variable
    env:
    - name: COLOR
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_COLOR
    
    # 2. Mount as Volume
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
  
  volumes:
  - name: config-volume
    configMap:
      name: app-config
```

Apply it:
```bash
kubectl apply -f config-pod.yaml
```

---

### 🔎 Verification

1. **Check Environment Variable:**
   ```bash
   kubectl exec config-pod -- env | grep COLOR
   # Output: COLOR=blue
   ```

2. **Check Mounted File:**
   ```bash
   kubectl exec config-pod -- ls /etc/config
   # Output: APP_COLOR  APP_MODE
   
   kubectl exec config-pod -- cat /etc/config/APP_MODE
   # Output: prod
   ```

✅ **Configuration is decoupled giving you flexibility!**

---

## 📖 Related Chapter
👉 [sources/study-guide/ch05-configuration.md](../../../sources/study-guide/ch05-configuration.md)
