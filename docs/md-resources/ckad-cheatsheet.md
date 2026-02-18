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
```

## 🧩 Multi-Container / Sidecar

```bash
# Apply a multi-container Pod manifest
kubectl apply -f pod-sidecar.yaml

# Exec into a specific container within a Pod
kubectl exec -it <pod-name> -c <container-name> -- bash
```
