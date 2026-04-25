# 🧪 Lab 01: [Deployment](../../../../GLOSSARY.md#deployment) Lifecycle (Review)

## Basic Workload Operations

> **⚙️ Local Minikube Compatible**, uses standard `nginx` images.

---

## 🎯 Lab Goal

Practice the core `kubectl` operations for managing deployments and services within a specific [namespace](../../../../GLOSSARY.md#namespace). This is a common requirement in the CKAD exam.

1. **Create** a [deployment](../../../../GLOSSARY.md#deployment) in a custom [namespace](../../../../GLOSSARY.md#namespace).
2. **Scale** the [deployment](../../../../GLOSSARY.md#deployment).
3. **Update** the container image.
4. **Expose** the [deployment](../../../../GLOSSARY.md#deployment) as a [service](../../../../GLOSSARY.md#service).

---

## 🛠️ Part 1: Create a [Deployment](../../../../GLOSSARY.md#deployment)

Create a [deployment](../../../../GLOSSARY.md#deployment) named `web` in the `session283884` [namespace](../../../../GLOSSARY.md#namespace) with 3 replicas using the image `nginx:1.18`.

> [!NOTE]
> You may need to create the [namespace](../../../../GLOSSARY.md#namespace) first if it doesn't exist.

```bash
# Create the namespace
kubectl create ns session283884

# Create the deployment
kubectl -n session283884 create deployment web --image=nginx:1.18 --replicas=3
```

---

## 🛠️ Part 2: Scale the [Deployment](../../../../GLOSSARY.md#deployment)

Scale the existing [deployment](../../../../GLOSSARY.md#deployment) named `web` in the `session283884` [namespace](../../../../GLOSSARY.md#namespace) to **5 replicas**.

```bash
kubectl -n session283884 scale deployment web --replicas=5
```

---

## 🛠️ Part 3: Update [Deployment](../../../../GLOSSARY.md#deployment) Image

Update the [deployment](../../../../GLOSSARY.md#deployment) named `web` in the `session283884` [namespace](../../../../GLOSSARY.md#namespace) to use the image `nginx:1.19`.

```bash
kubectl -n session283884 set image deployment/web nginx=nginx:1.19
kubectl -n session283884 rollout status deployment/web
```

---

## 🛠️ Part 4: Create a ClusterIP [Service](../../../../GLOSSARY.md#service)

Expose the [deployment](../../../../GLOSSARY.md#deployment) `web` in the `session283884` [namespace](../../../../GLOSSARY.md#namespace) as a **ClusterIP** [service](../../../../GLOSSARY.md#service) on port 80.

```bash
kubectl -n session283884 expose deployment web --port=80 --target-port=80 --type=ClusterIP
```

---

## 🔎 Verification Checklist

| Check | Expected |
| :--- | :--- |
| `kubectl -n session283884 get deploy web` | `5/5 READY` |
| Image check | `nginx:1.19` |
| `kubectl -n session283884 get svc web` | `TYPE: ClusterIP`, `PORT: 80` |

---

## 🧠 Key Takeaways

-   Moving between namespaces requires the `-n` or `--namespace` flag.
-   `kubectl set image` is the standard way to trigger a [rolling update](../../../../GLOSSARY.md#rolling-update).
-   `expose` is a quick way to create a [service](../../../../GLOSSARY.md#service) mapping to a [deployment](../../../../GLOSSARY.md#deployment)'s pods.

---
[Mall Directory ✨](../../../../GLOSSARY.md)
