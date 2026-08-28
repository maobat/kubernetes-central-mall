# CKAD Cheatsheet: Namespaces, Config & Storage

Quick reference for Namespaces, ConfigMaps/Secrets, and PV/PVC commands.

## 🏢 Namespaces

```bash
# List namespaces
kubectl get ns

# Create a namespace
kubectl create ns dev

# Switch context to a specific namespace permanently
kubectl config set-context --current --namespace=dev
```

## ⚙️ ConfigMaps & Secrets

```bash
# Create ConfigMap from literal
kubectl create configmap <name> --from-literal=key=value

# Create Secret from literal
kubectl create secret generic <name> --from-literal=key=value

# Inspect ConfigMap
kubectl describe cm <name>

# Inspect Secret
kubectl describe secret <name>
```

> [!TIP]
> For consuming ConfigMaps/Secrets as environment variables (`env` vs `envFrom`), see the [Fundamentals cheat sheet](ckad-cheatsheet-fundamentals.md).

## 💾 Storage

```bash
# List Persistent Volumes and Claims
kubectl get pv
kubectl get pvc

# Apply a PVC manifest
kubectl apply -f pvc.yaml
```

> [!TIP]
> **No Imperative command for PV/PVC!**
> There is no `kubectl create pv` or `kubectl create pvc` command. You **must** use a YAML file. Copy an example from the official documentation during the exam.

---
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
