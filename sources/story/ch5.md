# 📖 Chapter 5: Locked Drawers & Shop Manuals
*ConfigMaps and Secrets*

In the **Central Mall**, every clerk needs instructions (Config) and some need keys to the safe (Secrets). If you write the safe combination on the back of the clerk's shirt (hard-coding it into the Image), anyone can see it! Instead, we use external storage.

---

## 🎭 5.1 The Storage Difference

| Resource | Mall Analogy | Security Level |
| :--- | :--- | :--- |
| **ConfigMap** | **The Shop Manual** | Public info. Set the background color, the store name, or the `index.html`. |
| **Secret** | **The Locked Drawer** | Sensitive info. Passwords, API keys, or certificates. Encoded (obfuscated) so casual bypassers can't read it. |



---

## 🛠️ 5.2 ConfigMaps: The index.html Strategy

As we planned for your Lab, we use a **ConfigMap** to change how a store looks without rebuilding the mannequin (Image).

### 1. Create the Instruction Folder
```bash
# Create a ConfigMap from a literal string
kubectl create configmap web-content --from-literal=index.html="<html><h1>Welcome to Canary Mall</h1></html>"
```

### 2. Hand the Manual to the Clerk
We "mount" the folder into the shop so the clerk can read it at `/usr/share/nginx/html`.

```yaml
spec:
  containers:
  - name: nginx
    image: nginx:1.14
    volumeMounts:
    - name: html-volume
      mountPath: /usr/share/nginx/html
  volumes:
  - name: html-volume
    configMap:
      name: web-content
```

---

## 🔐 5.3 Secrets: The Locked Drawer

Secrets are handled exactly like ConfigMaps, but they are stored in `base64` encoding. **Warning:** Base64 is not encryption! It is just "scrambled" text.

```bash
# Create a secret for the "Safe Key"
kubectl create secret generic db-pass --from-literal=password=MallPass123
```

### How to use a Secret as an Environment Variable:
The clerk gets the password as a "vibe" (Environment Variable) instead of a file.

```yaml
env:
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: db-pass
      key: password
```



---

## 🛠️ The Blueprint (CKAD Speed-Run)

### 1. Fast Creation
```bash
kubectl create configmap my-config --from-file=config.txt
kubectl create secret generic my-secret --from-literal=user=admin
```

### 2. Viewing the Content (The Decoder Ring)
If you need to see what's inside a secret during the exam:
```bash
kubectl get secret my-secret -o jsonpath='{.data.password}' | base64 --decode
```

---

### 🧰 Study Toolbox

* 🖼️ **Comic:** [The Rulebook & The Uniform - ConfigMaps & Secrets](../../comics/configuration/01-configmap/README.md)
* 🧪 **Lab:** [Lab 01 - ConfigMaps](../../labs/configuration/lab01-configmaps/README.md)
* 📄 **Doc:** [Core Concepts: ConfigMaps, Secrets, and Security](../../docs/md-resources/core-concepts-configmaps-secrets-and-security.md)


