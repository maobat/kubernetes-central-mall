# 🧪 LAB 01: The Breakroom Rules (ConfigMaps)

## Environment & Configuration – Decoupling Configuration

---

## 🎯 Lab Goal

This lab focuses on **managing application configuration** using **ConfigMaps**. You will learn how to:
- **Decouple** configuration from container images.
- Create a **[ConfigMap](../../../../GLOSSARY.md#configmap)** imperatively (from literal).
- Inject configuration as **Environment Variables**.
- Mount configuration files as **Volumes**.

> **CKAD Importance:** Core. ConfigMaps are a fundamental part of almost every CKAD scenario involving application behavior.

---

## 🛍️ Mall Analogy

In the **Central Mall**, you don't paint the rules on the shop walls. Instead, you use a modular system.

- **The Rules Board ([ConfigMap](../../../../GLOSSARY.md#configmap))** → A central board in the mall's breakroom where management posts store-wide rules (e.g., `THEME_COLOR=blue`).
- **The Morning Briefing (Env Vars)** → Telling a worker exactly what rules to follow for the day before they start their shift.
- **The Employee Handbook (Volume Mount)** → Giving the worker a physical book that they can read whenever they need to check a rule. If management changes the board, the book in the worker's pocket is eventually updated too.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **[ConfigMap](../../../../GLOSSARY.md#configmap)** | A collection of non-sensitive configuration settings. |
| **Env Var KeyRef** | Injecting a specific rule as a variable. |
| **Volume Mount** | Rendering the rules as files inside the shop. |

---

## 📋 Requirements

1. **Create a [ConfigMap](../../../../GLOSSARY.md#configmap)** named `app-config`:
   - `APP_COLOR`: `blue`
   - `APP_MODE`: `prod`
2. **Deploy a [Pod](../../../../GLOSSARY.md#pod)** named `config-pod`:
   - Image: `nginx`
   - Env Var: Map `APP_COLOR` to a variable named `COLOR`.
   - Volume: Mount the entire `app-config` to `/etc/config`.

---

## 🛠️ Step-by-Step Solution

### 1. Create the [ConfigMap](../../../../GLOSSARY.md#configmap) (Imperative)
Avoid writing YAML for simple key-value pairs!
```bash
k create configmap app-config --from-literal=APP_COLOR=blue --from-literal=APP_MODE=prod
```

### 2. Create the Shop ([Pod](../../../../GLOSSARY.md#pod))
Generate the scaffold and add the special configuration.
```bash
k run config-pod --image=nginx $do > config-pod.yaml
```

**Manual Surgery:**
```yaml
spec:
  containers:
  - name: nginx
    image: nginx
    env:
    - name: COLOR
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_COLOR
    volumeMounts:
    - name: config-vol
      mountPath: /etc/config
  volumes:
  - name: config-vol
    configMap:
      name: app-config
```

---

## 🔎 Verification

1. **Check the Variable:**
   ```bash
   k exec config-pod -- env | grep COLOR
   # Output: COLOR=blue
   ```

2. **Check the Rulebook (Files):**
   ```bash
   k exec config-pod -- ls /etc/config
   # Output: APP_COLOR, APP_MODE
   k exec config-pod -- cat /etc/config/APP_MODE
   # Output: prod
   ```

---

## 🧠 Key Takeaways

- **Decoupling:** ConfigMaps allow you to use the *same* image for Dev, Staging, and Prod by changing only the [ConfigMap](../../../../GLOSSARY.md#configmap).
- **Updates:** If you update a [ConfigMap](../../../../GLOSSARY.md#configmap), Environment Variables in a running [Pod](../../../../GLOSSARY.md#pod) *do not* update. However, Volume Mounts *will* update (eventually).
- **CKAD Tip:** If you need to inject *all* keys from a [ConfigMap](../../../../GLOSSARY.md#configmap) as env vars, use `envFrom` instead of `env` with `configMapKeyRef`.

---

## 🔗 References
- **Comic** → [ConfigMaps](../../../../visual-learning/comics/ch05-config-secrets/01-configmap/README.md)
- **Docs** → [Configuration Decoupling](../../../../reference/md-resources/configuration-decoupling.md)
- **Study Guide** → [Chapter 5: Configuration](../../../../sources/study-guide/ch05-configuration.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
