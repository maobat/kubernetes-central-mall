# 🧪 Lab 04: SSH & Contexts

## Managing the Control Room

---

## 🎯 Lab Goal

Understand how to manage `kubectl` contexts to switch between different environments or namespaces easily.

1. **View** available contexts.
2. **Switch** between contexts to observe change in scope.

---

## 🛍️ Mall Analogy

The **Mall Manager** uses different keycards (Contexts) to access different wings of the mall. One keycard opens the **Purple Wing**, and another opens the **Yellow Wing**. Without switching cards, you can't see what's happening in the other wing.

---

## 🛠️ Part 1: [Kubectl](../../../../GLOSSARY.md#kubectl) Contexts

A [kubectl](../../../../GLOSSARY.md#kubectl) context contains connection information to a Kubernetes cluster. Different [kubectl](../../../../GLOSSARY.md#kubectl) contexts can connect to different Kubernetes clusters, or to the same cluster but using different users or different default namespaces.

List all available [kubectl](../../../../GLOSSARY.md#kubectl) contexts and write the output to `/tmp/contexts` (using `/tmp` as a safe alternative to `/root` for practice).

### Tip
`kubectl config -h`

```bash
# List all contexts
kubectl config get-contexts

# Save to a file
kubectl config get-contexts > /tmp/contexts
```

---

## 🛠️ Part 2: Switch Context (Purple)

Switch to context `purple` and list all Pods.

```bash
# Switch context
kubectl config use-context purple

# List pods
kubectl get pods
```

---

## 🛠️ Part 3: Switch Context (Yellow)

Switch to context `yellow` and list all Pods.

```bash
# Switch context
kubectl config use-context yellow

# List pods
kubectl get pods
```

---

## 🔎 Verification Checklist

| Check | Expected |
| :--- | :--- |
| `kubectl config current-context` | `Reflects the chosen color (purple or yellow)` |

---

## 🧠 Key Takeaways

-   **Context = Cluster + User + [Namespace](../../../../GLOSSARY.md#namespace).**
-   `kubectl config use-context` is the standard way to switch focus.
-   Contexts help avoid mistakes by setting a default [namespace](../../../../GLOSSARY.md#namespace).

---
[Mall Directory ✨](../../../../GLOSSARY.md)
