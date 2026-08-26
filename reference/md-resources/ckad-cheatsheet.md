# CKAD Cheatsheet & Keymap

A quick reference guide for common `kubectl` commands used during the CKAD exam.

## 🚀 General Commands

```bash
kubectl get nodes
kubectl get pods
kubectl get svc
kubectl get deployments
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- bash
kubectl apply -f <file.yaml>
kubectl delete -f <file.yaml>
```

## 📦 Deployments & Scaling

```bash
# Scale a deployment
kubectl scale deployment <deployment-name> --replicas=N

# Check rollout status
kubectl rollout status deployment <deployment-name>

# Rollback a deployment
kubectl rollout undo deployment <deployment-name>
```

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

## 🏗️ Pod & Deployment Creation (Imperative)

```bash
# Create a simple Nginx Pod
kubectl run nginx --image=nginx

# Expose a Pod as a Service (NodePort)
kubectl expose pod nginx --type=NodePort --port=80

# Get resources with wide output (shows IP and Node)
kubectl get pods -o wide
kubectl get deployments -o wide
```

## 🔍 Observability & Debugging

```bash
# Detailed Pod information (Events are at the bottom!)
kubectl describe pod <pod-name>

# tailored logs
kubectl logs <pod-name>

# Check resource usage (Metrics Server must be enabled)
kubectl top pod

# View all cluster events for debugging
kubectl get events --sort-by=.metadata.creationTimestamp
```

## 💾 Storage

```bash
# List Persistent Volumes and Claims
kubectl get pv
kubectl get pvc

# Apply a PVC manifest
kubectl apply -f pvc.yaml

> [!TIP]
> **No Imperative command for PV/PVC!**  
> There is no `kubectl create pv` or `kubectl create pvc` command. You **must** use a YAML file. Copy an example from the official documentation during the exam.
```

## 🧩 Multi-Container / Sidecar

```bash
# Apply a multi-container Pod manifest
kubectl apply -f pod-sidecar.yaml

# Exec into a specific container within a Pod
kubectl exec -it <pod-name> -c <container-name> -- bash
```

## 🧮 Custom Output — jsonpath

```bash
# Print a single field for every item, tab-separated, one line per item
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'

# Same idea for Deployments: name + container image(s)
kubectl get deploy -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}{end}'

# Grab a single field from a single object (no range needed)
kubectl get pod <pod-name> -o jsonpath='{.status.podIP}'
```

> [!TIP]
> **`-o jsonpath` reads from the current namespace only.** If a resource isn't showing up, check you're not missing `-n <namespace>` (or use `-A` for all namespaces) before assuming the `jsonpath` expression is wrong.

Anatomy of the `range` pattern:

```text
{range .items[*]}   → loop over every item in the list
  {.field.path}      → print a field from the current item
  {"\t"} / {"\n"}     → literal separators (tab / newline)
{end}                → close the loop
```

Faster alternative for readable tabular output without hand-writing jsonpath:

```bash
kubectl get pods -o custom-columns='NAME:.metadata.name,STATUS:.status.phase'
```

---
[Mall Directory ✨](../../GLOSSARY.md)
