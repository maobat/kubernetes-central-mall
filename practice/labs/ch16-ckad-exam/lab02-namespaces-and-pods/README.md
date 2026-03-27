# 🧪 Lab 02: Namespace & Pod Management

## Managing Isolated Departments

---

## 🎯 Lab Goal

Learn how to work with isolated namespaces and understand the relationship between pods and their controllers (Deployments).

1. **Deploy** a pod to a new namespace.
2. **Delete** pods manually and observe regeneration.
3. **Terminate** the root cause of regeneration.

---

## 🛠️ Part 1: New Department (Namespace)

Create a namespace called `devteam283884` and deploy a pod named `nginx` using the `nginx` image inside it.

```bash
# Create the namespace
kubectl create ns devteam283884

# Run the pod
kubectl -n devteam283884 run nginx --image=nginx --restart=Never
```

---

## 🛠️ Part 2: Pod Cleanup Mystery

Delete all pods in the `session283884` namespace but leave the namespace intact.

```bash
kubectl -n session283884 delete pods --all
```

---

## 🛠️ Part 3: The Persistent Pods

After deleting the pods in the `session283884` namespace, observe that new pods immediately appear. Why?

🔥 **Kubectl Tip:** The `kubectl get pods -w` command streams pod status so you can watch what happens after you delete them.

### Challenge
Delete whatever is causing the pods to regenerate so the namespace stays empty without deleting the namespace itself.

```bash
# Identify the controller (Deployment/ReplicaSet)
kubectl -n session283884 get deploy

# Delete the deployment
kubectl -n session283884 delete deployment web
```

---

## 🔎 Verification Checklist

| Check | Expected |
| :--- | :--- |
| `kubectl get pods -n devteam283884` | `nginx pod is Running` |
| `kubectl get pods -n session283884` | `Empty or terminating` |

---

## 🧠 Key Takeaways

-   Pods managed by **Deployments** or **ReplicaSets** will be automatically re-created if deleted.
-   To permanently remove such pods, you must delete the parent **Deployment**.
-   Use `--restart=Never` with `kubectl run` to create a standalone Pod instead of a Deployment.
