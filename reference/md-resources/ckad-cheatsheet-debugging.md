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

### 🚫 "Too Many Pods": The Per-Node Cap Is Cluster-Wide, Not Per-Namespace

A Pod stuck `Pending` with a `FailedScheduling` event saying `Too many pods` can be completely unrelated to the namespace you're working in. The **per-node pod cap** (`kubelet`'s `max-pods`, commonly 110) counts **every non-terminal Pod scheduled to that node, across every namespace**, it is not scoped to your namespace at all.

```text
Warning  FailedScheduling  default-scheduler  0/3 nodes are available: 1 node(s) had untolerated
taint {node-role.kubernetes.io/control-plane: }, 2 Too many pods.
```

Namespaces are an API/RBAC boundary, not a scheduling one, a runaway CronJob spamming `default` can starve every other namespace's Pods of scheduling room, exactly as if they were all competing for the same parking garage.

**Diagnose it** (confirm the nodes are actually full before assuming your YAML is wrong):

```bash
# allocatable pod capacity per node
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.allocatable.pods}{"\n"}{end}'

# actual non-terminal pod count per node, cluster-wide, any namespace
kubectl get pods -A --field-selector=status.phase!=Succeeded,status.phase!=Failed \
  -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | sort | uniq -c

# which namespace is actually hoarding pods
kubectl get pods -A --field-selector=status.phase!=Succeeded,status.phase!=Failed --no-headers \
  | awk '{print $1}' | sort | uniq -c | sort -rn
```

> [!WARNING]
> **A CronJob whose Pods never succeed never gets cleaned up by `successfulJobsHistoryLimit`/`failedJobsHistoryLimit`.** Those limits only prune *completed* Job history. A CronJob whose image is wrong (`ErrImagePull`) or whose Pods never finish stays `ACTIVE` forever and keeps spawning a brand-new Job on every schedule tick, silently filling up node capacity over days, cluster-wide, in a namespace you may not even be looking at.
>
> Check for this specifically:
>
> ```bash
> kubectl get cronjob -A    # a huge ACTIVE count on an old CronJob is the tell
> ```
>
> Fix at the source, deleting stray Pods without deleting the CronJob just refills the same capacity within one schedule interval:
>
> ```bash
> kubectl delete cronjob <name> -n <namespace>
> kubectl get job -n <namespace> -o name | grep '<name>-' | xargs -r kubectl delete -n <namespace>
> ```
>
> If leftover Pods get stuck in `Terminating` after the Job is gone (common for Pods that never had a container actually running, e.g. `ErrImagePull`), force them:
>
> ```bash
> kubectl get pods -n <namespace> --no-headers | grep Terminating | awk '{print $1}' \
>   | xargs -r kubectl delete pod -n <namespace> --force --grace-period=0
> ```

## 🧮 Custom Output: jsonpath

### The Basics: Single Object, No Loop

For **one** object (not a list), address the field directly, no `range` needed:

```bash
kubectl get pod <pod-name> -o jsonpath='{.status.podIP}'
kubectl get deploy nginx -o jsonpath='{.spec.replicas}'
```

### Array Indexing and Wildcards

`[N]` picks one item by position, `[*]` expands to every item in the array:

```bash
# first container's image only
kubectl get pod <pod-name> -o jsonpath='{.spec.containers[0].image}'

# every container's image, space-separated (no loop, still one line)
kubectl get pod <pod-name> -o jsonpath='{.spec.containers[*].image}'
```

### `{range}...{end}`: Looping Over a List

`kubectl get <resource>` (plural, no name) returns a list under `.items`. To print one line **per item**, wrap the fields in `{range .items[*]}...{end}`:

```bash
# name + phase, tab-separated, one line per Pod
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'

# name + container image(s), for Deployments
kubectl get deploy -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.template.spec.containers[*].image}{"\n"}{end}'
```

Anatomy of the pattern:

```text
{range .items[*]}   → loop over every item in the list
  {.field.path}      → print a field from the current item
  {"\t"} / {"\n"}     → literal separators (tab / newline)
{end}                → close the loop
```

### Nested `range`: Looping Inside Each Item

A second `{range}...{end}` inside the outer one lets you loop over a **nested** array per item, for example every container inside every Pod:

```bash
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{":\n"}{range .spec.containers[*]}{"  - "}{.name}{"="}{.image}{"\n"}{end}{end}'
```

```text
sidecar-example:
  - busybox=busybox:1.36
  - nginx=nginx:1.14
web-sidecar-pod:
  - app-web=nginx:1.14
  - sidecar-writer=busybox:1.36
```

Each `range`/`end` pair must match: the inner one closes before the outer one does, so the last two `{end}` tokens close, in order, the container loop then the Pod loop.

### `range` on a Single Object (No `.items`)

`kubectl get <resource>/<name>` (singular, one specific object) returns that object directly, it has **no** `.items` field, that only exists on a list result (`kubectl get pods`, plural, no name). To loop over a nested array on a single object, `range` directly over that array instead:

```bash
kubectl get pod/web-sidecar-pod -o jsonpath='{.metadata.name}{":\n"}{range .spec.containers[*]}- {.image}{"\n"}{end}'
```

```text
web-sidecar-pod:
- nginx:1.14
- busybox:1.36
```

> [!WARNING]
> **A `{range}` with no matching `{end}` fails silently, it does not error.** Kubernetes just never enters the loop and evaluates the rest of the template directly against the root object, as if `range` weren't there at all. This can mask a real bug: for example `{range .items[*]}...` (no `{end}`) run against a single object (which has no `.items`) still prints output, because the broken `range` is skipped and the fields resolve against the object's own root, not because the expression is actually correct. If output looks right but the command "feels off", check for a missing `{end}` before trusting the result.

### Filter Expressions: `[?(@.field=="value")]`

Pick only the array element(s) matching a condition instead of printing all of them. Common on Node addresses and Pod/Node conditions, both are arrays where you usually want exactly one entry:

```bash
# only the InternalIP address of each Node (Node.status.addresses is a list of {type, address} pairs)
kubectl get nodes -o jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'

# the Ready condition's status ("True"/"False") for every Node
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}'
```

> [!TIP]
> `@` inside `[?(...)]` means "the current array element being tested", not the root object. `[?(@.type=="Ready")]` reads as "the element of this array whose `type` field equals `Ready`".

### Practical One-Liners

```bash
# restart count per Pod (first container only, containerStatuses is a list)
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.containerStatuses[0].restartCount}{"\n"}{end}'

# every Pod's IP
kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.podIP}{"\n"}{end}'

# across ALL namespaces: namespace + name (note the extra field before the loop body)
kubectl get pods -A -o jsonpath='{range .items[*]}{.metadata.namespace}{"\t"}{.metadata.name}{"\n"}{end}'
```

### `--sort-by`: Also jsonpath, Different Flag

`--sort-by` takes a jsonpath expression too, but as a **separate flag**, not inside `-o jsonpath`, and without the outer `{}` braces:

```bash
kubectl get pods --sort-by=.metadata.creationTimestamp
kubectl get pods --sort-by=.status.containerStatuses[0].restartCount
```

### `-o jsonpath-file`: Load a Long Expression from a File

For an expression too long/fiddly to keep quoting correctly on one line:

```bash
echo '{range .items[*]}{.metadata.name}{"\n"}{end}' > names.tpl
kubectl get pods -o jsonpath-file=names.tpl
```

> [!TIP]
> **`-o jsonpath` reads from the current namespace only.** If a resource isn't showing up, check you're not missing `-n <namespace>` (or use `-A` for all namespaces) before assuming the `jsonpath` expression is wrong.

### Faster Alternative: `custom-columns`

For simple tabular output without hand-writing loop syntax:

```bash
kubectl get pods -o custom-columns='NAME:.metadata.name,STATUS:.status.phase'
```

`custom-columns` has no `range`/filter support though, for anything nested or conditional (multiple containers, filtered addresses), `jsonpath` is the only option.

---
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
