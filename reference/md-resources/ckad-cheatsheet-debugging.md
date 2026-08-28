# CKAD Cheatsheet: Observability & Debugging

Quick commands for inspecting a live cluster and shaping `kubectl` output.

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

## 🧮 Custom Output: jsonpath

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
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
