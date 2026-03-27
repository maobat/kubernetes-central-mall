# 🧪 Lab 03: Advanced Kubectl Sorting

## Finding the Troublemakers

---

## 🎯 Lab Goal

Use advanced `kubectl` sorting capabilities to identify pods based on their current status and lifecycle history.

1. **Sort** pods by restart count to find unstable containers.

---

## 🛠️ Part 1: List Pods by Restart Count

List all pods in the `session283884` namespace sorted by **restart count** in descending order.

```bash
kubectl -n session283884 get pods --sort-by=.status.containerStatuses[0].restartCount
```

---

## 🔎 Verification Checklist

| Check | Expected |
| :--- | :--- |
| `kubectl get pods` | `Pods are displayed, with those having more restarts at the bottom (ascending order by default)` |

> [!TIP]
> Kubectl sorts in ascending order. To find the "most" of something, look at the end of the list.

---

## 🧠 Key Takeaways

-   The `--sort-by` flag allows you to sort by any JSONPath field in the resource specification or status.
-   Common sort fields: `.metadata.creationTimestamp`, `.status.phase`, `.status.containerStatuses[0].restartCount`.
