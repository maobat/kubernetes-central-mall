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

## 📐 "Do I need a `-` here?" — List vs Map in YAML

Ask `kubectl explain` for the field's type — it tells you definitively, no guessing:

```bash
kubectl explain pod.spec.containers
kubectl explain pod.spec.containers.command
kubectl explain pod.spec.containers.securityContext
```

| `KIND`/`TYPE` shown | Meaning | Syntax |
| :--- | :--- | :--- |
| `[]Object` / `[]string` | **List** | Each entry starts with `-` |
| `map[string]string` | **Map**, not a list | `key: value`, no `-` — even though the field name sounds like a collection |
| `Object` (e.g. `PodSecurityContext`) | Single map | `key: value`, nested — no `-` |
| `string` / `integer` / `boolean` | Scalar | Direct value — no `-` |

**Fast heuristic (no typing required):** plural-sounding fields are *usually* lists — `containers`, `volumes`, `volumeMounts`, `ports`, `env`, `tolerations`, `imagePullSecrets`, `command`/`args` (arrays of strings even though not literally "commands"), `capabilities.add`/`drop`. Singular fields like `securityContext`, `resources`, `metadata`, `selector` are almost always maps.

`command`/`args` and `capabilities.add`/`drop` are all confirmed `[]string` by `kubectl explain` — one array item per word/flag or per capability name:

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
> **The heuristic breaks on `labels`, `annotations`, and `nodeSelector`.** All three sound like collections but are `map[string]string` — key/value pairs, **not** a list:
>
> ```yaml
> metadata:
>   labels:
>     app: holy-api        # correct — no "-"
> spec:
>   nodeSelector:
>     disktype: ssd         # correct — no "-"
> ```
>
> Writing `labels: [{app: holy-api}]` or `- app: holy-api` is a validation error. When in doubt on these three specifically, trust `kubectl explain` over the plural-name heuristic.

**Safest option under exam pressure:** don't guess at all — generate with `--dry-run=client -o yaml` and let `kubectl` write the correct structure, then only edit the values.

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

## 🏷️ "Each Pod should have label X" — Requirement Phrasing Trap

When the exam wording says *"each Pod created by the Job/Deployment/CronJob should have the label `x: yyyy`"*, it means the **Pod template's** labels — not the top-level resource's own `metadata.labels`.

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: my-job
  # labels here only label the Job object itself, they do NOT reach the Pods
spec:
  template:
    metadata:
      labels:
        x: yyyy          # <-- this is what actually labels every Pod the Job creates
    spec:
      containers:
      - name: worker
        image: busybox
```

> [!TIP]
> This applies to **every** controller with a Pod template: Deployment, Job, DaemonSet, StatefulSet — labels always go under `spec.template.metadata.labels`. For a **CronJob** it's nested one level deeper, under `spec.jobTemplate.spec.template.metadata.labels`, since a CronJob's template is itself a Job template.

Quick check that the label actually landed on the Pods (not just the controller object):

```bash
kubectl get pods -l x=yyyy
```

## 🩺 "Wait X, then check every Y seconds" — Probe Timing Trap

When the exam wording says *"it should initially wait N seconds and periodically wait M seconds"*, that maps to `initialDelaySeconds` and `periodSeconds` — and an exec-based probe ("executing `cat /tmp/ready`") means `exec.command`, not `httpGet` or `tcpSocket`.

> Example requirement: *"The Pod should have a readiness probe executing `cat /tmp/ready`. It should initially wait 5 and periodically wait 10 seconds."*

```yaml
containers:
- name: app
  image: busybox
  command: ["sh", "-c", "touch /tmp/ready && sleep 3600"]
  readinessProbe:
    initialDelaySeconds: 5
    periodSeconds: 10
    exec:
      command:
      - cat
      - /tmp/ready
```

| Wording in the task | Field |
| :--- | :--- |
| "initially wait N seconds" | `initialDelaySeconds: N` |
| "periodically / every M seconds" | `periodSeconds: M` |
| "executing `<command>`" | `exec.command: [...]` (one array item per word/arg) |
| "checking `http://.../path` on port P" | `httpGet.path` / `httpGet.port` |
| "checking that port P is open" | `tcpSocket.port` |

## 🔐 "...on container level" — SecurityContext Placement Trap

When the wording explicitly says *"...for the security context **on container level**"*, `allowPrivilegeEscalation` and `privileged` go under the **container's** `securityContext`, nested inside `spec.template.spec.containers[]` — not under `spec.template.spec.securityContext` (the Pod-level one). See the [Pod vs Container decision table](pod-vs-container-and-decisions.md) for the full field list — both of these fields are container-only regardless of wording.

> Example requirement: *"The new Deployment should set `allowPrivilegeEscalation: false` and `privileged: false` for the security context on container level."*

```yaml
spec:
  replicas: 3
  selector:
    matchLabels:
      app: holy-api
  template:
    metadata:
      labels:
        app: holy-api
    spec:
      containers:
      - name: nginx
        image: nginx:1.14
        securityContext:                    # <-- container-level, nested under the container
          allowPrivilegeEscalation: false
          privileged: false
```

## 🏷️ Naming the Container Differently from the Job/Pod

There is **no imperative flag** to set a container name different from the resource's own name — `kubectl create job`/`kubectl run` always name the container the same as the Job/Pod. If the task requires a distinct container name (e.g. Job `neb-new-job` with container `neb-new-job-container`), you must dry-run, edit the YAML, then apply.

```bash
kubectl create job neb-new-job --image=busybox --dry-run=client -o yaml -- sleep 3600 > neb-new-job.yaml
```

Edit only the container's `name:` field (leave `metadata.name` — the Job's own name — untouched):

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: neb-new-job
spec:
  template:
    spec:
      containers:
      - name: neb-new-job-container   # <-- changed from the generated "neb-new-job"
        image: busybox
        command: ["sleep", "3600"]
      restartPolicy: Never
```

```bash
kubectl apply -f neb-new-job.yaml
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
