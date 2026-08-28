# CKAD Cheatsheet: YAML & kubectl Fundamentals

Core `kubectl`/YAML mechanics used across almost every task on the exam.

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

## 📐 "Do I need a `-` here?": List vs Map in YAML

Ask `kubectl explain` for the field's type; it tells you definitively, no guessing:

```bash
kubectl explain pod.spec.containers
kubectl explain pod.spec.containers.command
kubectl explain pod.spec.containers.securityContext
```

| `KIND`/`TYPE` shown | Meaning | Syntax |
| :--- | :--- | :--- |
| `[]Object` / `[]string` | **List** | Each entry starts with `-` |
| `map[string]string` | **Map**, not a list | `key: value`, no `-`, even though the field name sounds like a collection |
| `Object` (e.g. `PodSecurityContext`) | Single map | `key: value`, nested, no `-` |
| `string` / `integer` / `boolean` | Scalar | Direct value, no `-` |

**Fast heuristic (no typing required):** plural-sounding fields are *usually* lists: `containers`, `volumes`, `volumeMounts`, `ports`, `env`, `tolerations`, `imagePullSecrets`, `command`/`args` (arrays of strings even though not literally "commands"), `capabilities.add`/`drop`. Singular fields like `securityContext`, `resources`, `metadata`, `selector` are almost always maps.

`command`/`args` and `capabilities.add`/`drop` are all confirmed `[]string` by `kubectl explain`: one array item per word/flag or per capability name:

```yaml
containers:
- name: app
  image: busybox
  command: ["sh", "-c"]        # <-- list: one item per word
  args: ["sleep 3600"]         # <-- list: one item per argument
  securityContext:
    capabilities:
      add: ["NET_BIND_SERVICE"]  # <-- list: one item per capability
      drop: ["ALL"]              # <-- list: one item per capability
```

> [!WARNING]
> **The heuristic breaks on `labels`, `annotations`, and `nodeSelector`.** All three sound like collections but are `map[string]string`; key/value pairs, **not** a list:
>
> ```yaml
> metadata:
>   labels:
>     app: holy-api        # correct, no "-"
> spec:
>   nodeSelector:
>     disktype: ssd         # correct, no "-"
> ```
>
> Writing `labels: [{app: holy-api}]` or `- app: holy-api` is a validation error. When in doubt on these three specifically, trust `kubectl explain` over the plural-name heuristic.

**Safest option under exam pressure:** don't guess at all: generate with `--dry-run=client -o yaml` and let `kubectl` write the correct structure, then only edit the values.

## 🔌 `env` vs `envFrom`: Picking One Key vs the Whole Map

Both are Container-level fields (see the [Pod vs Container decision table](pod-vs-container-and-decisions.md)), confirmed `[]EnvVar` and `[]EnvFromSource` by `kubectl explain`; both **lists**, but they solve different problems.

| | `env` | `envFrom` |
| :--- | :--- | :--- |
| **Use when** | You need **one specific key**, possibly renamed | You want **every key** from a ConfigMap/Secret injected as-is |
| **Env var name** | You choose it (`name:`) | Forced to match the ConfigMap/Secret's key name |
| **Source** | `valueFrom.configMapKeyRef` / `valueFrom.secretKeyRef` (one key) | `configMapRef` / `secretRef` (the whole object) |

**`env`, to pick a single key and rename it if you want:**

```yaml
env:
- name: DB_HOST                        # <-- the env var name inside the container
  valueFrom:
    configMapKeyRef:
      name: app-config                 # <-- the ConfigMap
      key: database_host               # <-- the specific key
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: db-secret
      key: password
```

**`envFrom`, to bulk-inject every key with no renaming:**

```yaml
envFrom:
- configMapRef:
    name: app-config      # <-- every key in app-config becomes an env var, same names
- secretRef:
    name: db-secret        # <-- every key in db-secret becomes an env var, same names
```

> [!TIP]
> If the task says *"inject **all** the keys from ConfigMap X as environment variables,"* that's `envFrom`. If it names **one specific key** (especially with a different env var name than the key), that's `env` + `valueFrom`.

Verify what actually landed inside the container:

```bash
kubectl exec <pod-name> -- env
```

---
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
