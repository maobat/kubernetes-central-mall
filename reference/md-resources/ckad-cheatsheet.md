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

## 🏷️ "Each Pod should have label X": Requirement Phrasing Trap

When the exam wording says *"each Pod created by the Job/Deployment/CronJob should have the label `x: yyyy`"*, it means the **Pod template's** labels, not the top-level resource's own `metadata.labels`.

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
> This applies to **every** controller with a Pod template: Deployment, Job, DaemonSet, StatefulSet: labels always go under `spec.template.metadata.labels`. For a **CronJob** it's nested one level deeper, under `spec.jobTemplate.spec.template.metadata.labels`, since a CronJob's template is itself a Job template.

Quick check that the label actually landed on the Pods (not just the controller object):

```bash
kubectl get pods -l x=yyyy
```

## 🌐 "TCP port redirection of X:Y": Service Port Mapping Trap

When the exam wording says *"the Service should use TCP port redirection of X:Y"*, read it like a Docker-style `HOST:CONTAINER` mapping: the **first** number (`X`) is the Service's own `port` (what clients connect to), the **second** number (`Y`) is `targetPort` (the container port it forwards to). `protocol` defaults to `TCP`, but set it explicitly if the task says "TCP" out loud.

> Example requirement: *"The Service should use TCP port redirection of 3333:80."*

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app
  ports:
  - port: 3333          # <-- first number: the Service's own port
    targetPort: 80       # <-- second number: forwarded to this container port
    protocol: TCP
```

Quick check that the mapping landed correctly:

```bash
kubectl get svc my-service -o jsonpath='{.spec.ports[0].port}{":"}{.spec.ports[0].targetPort}{"\n"}'
```

**Imperative shortcut:** `kubectl create service` (not `kubectl expose`, which has no `--tcp` flag) accepts `PORT:TARGETPORT` directly:

```bash
kubectl create service clusterip my-service --tcp=3333:80 --dry-run=client -o yaml > svc.yaml
```

> [!WARNING]
> The generated `selector` defaults to `app: <service-name>`, almost never what you actually want. Edit it to match your target Deployment/Pod's real labels before applying, or the Service will select zero Pods:
>
> ```yaml
> spec:
>   selector:
>     app: my-service   # <-- generated default, usually wrong
> ```

## 🧪 Testing a Service: ClusterIP vs FQDN vs Endpoint

When something can't reach a Service, test in **layers**: from "does DNS even resolve" down to "does the Pod itself respond", to isolate whether the problem is DNS, the Service's `selector`, or the app inside the Pod.

Example setup (`mars` namespace): Service `manager-api-svc` (`ClusterIP 10.96.224.255`, `port: 4444` → `targetPort: 80`) in front of a Deployment whose Pods carry label `id=manager-api-pod`.

```bash
kubectl get pods,deploy,svc,endpointslice -n mars --show-labels -o wide
```

**1. Via the Service's ClusterIP + port, tests the Service object itself:**

```bash
kubectl run tester --rm -it --restart=Never --image=busybox:1.36 -n mars -- \
  wget -qO- 10.96.224.255:4444
```

**2. Via the Service name / FQDN, tests DNS resolution too:**

```bash
# short name (same namespace only)
wget -qO- manager-api-svc:4444

# FQDN, works from any namespace
wget -qO- manager-api-svc.mars.svc.cluster.local:4444
```

**3. Via a Pod's IP + `targetPort` directly, bypasses the Service entirely:**

Get the real Pod/endpoint IPs from the EndpointSlice (or `kubectl get ep` on older clusters):

```bash
kubectl get endpointslice -n mars -o jsonpath='{.items[0].endpoints[*].addresses}'
```

```bash
# hits the Pod directly on its targetPort (80), no Service involved
wget -qO- 10.244.2.156:80
```

> [!TIP]
> **Where it breaks tells you the cause:**
>
> - Step 3 fails → the **app itself** is broken (bad container, wrong `containerPort`, app not listening), nothing to do with the Service.
> - Step 3 works but Step 1 fails → the **Service's `selector`** doesn't match the Pod's labels, so the EndpointSlice is empty even though the Pods are healthy. Compare `service.spec.selector` against `kubectl get pods --show-labels` directly.
> - Steps 1 and 3 work but Step 2 fails → a **DNS** problem, not a networking one (check CoreDNS, or that you're using the right namespace in the FQDN).
>
> An empty `ENDPOINTS` column on `kubectl get endpointslice` (or `kubectl get ep <svc>`) is the fastest single signal that it's a selector-mismatch problem before you even start testing connectivity.

### 🌍 NodePort: Reachable on *Every* Node, Not Just Where the Pod Runs

The trap: assuming a `NodePort` Service only answers on the node that's actually running the backing Pod. It doesn't, `kube-proxy` installs the same forwarding rule on **every** node in the cluster, so the NodePort responds cluster-wide regardless of Pod placement.

```text
service/jupiter-crew-svc   NodePort   10.96.29.238   <none>   8080:30100/TCP   SELECTOR: id=jupiter-crew
pod/jupiter-crew-deploy-6d6c6985c-zzp8m   Running   NODE: ckad-worker2
```

> Example requirement: *"Test the NodePort Service using the internal IP of all available nodes and port 30100: on which nodes is the Service reachable? On which node is the Pod running?"*

```bash
# 1. Get every node's internal IP
kubectl get nodes -o wide

# 2. curl the NodePort on each one
curl <control-plane-internal-ip>:30100
curl <ckad-worker-internal-ip>:30100
curl <ckad-worker2-internal-ip>:30100
```

> [!TIP]
> **Service reachable on:** every node in the cluster: that's the entire point of `NodePort`, it's a cluster-wide listening port, not a per-node one.
> **Pod running on:** exactly one node: read the `NODE` column from `kubectl get pods -o wide` (here, `ckad-worker2`).
>
> Don't confuse "where the Service answers" (everywhere) with "where the Pod lives" (one specific node); the exam question is testing exactly that distinction.

## 🛡️ Generating a NetworkPolicy Skeleton

Unlike Deployments, Services, or Jobs, there is **no imperative generator** for NetworkPolicy:

```bash
kubectl create networkpolicy --help
# error: unknown command "networkpolicy"
```

Two real options on exam day:

**1. `kubectl explain` to see the exact field tree while you hand-write the YAML:**

```bash
kubectl explain networkpolicy.spec --recursive
```

Shows the full structure: `podSelector`, `policyTypes`, `ingress[].from`, `egress[].to`, `ports[].protocol`/`port`, so you know exactly what to nest where without guessing.

**2. Copy the skeleton from the official docs (allowed during the exam):**
[kubernetes.io/docs/concepts/services-networking/network-policies/#the-networkpolicy-resource](https://kubernetes.io/docs/concepts/services-networking/network-policies/#the-networkpolicy-resource) has a ready-made example with `podSelector`, `policyTypes`, `ingress`, and `egress` already structured; copy it and edit only the values.

**Minimal skeleton worth memorizing**, trim `policyTypes`/`ingress`/`egress` to whatever the task actually asks for:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: <name>
  namespace: <ns>
spec:
  podSelector:
    matchLabels: {}
  policyTypes:
  - Ingress
  - Egress
  ingress: []
  egress: []
```

> [!WARNING]
> Adding `Egress` to `policyTypes` blocks **all** outgoing traffic not explicitly allowed, including DNS. If the task restricts egress to one destination, add a **separate** egress rule for UDP/TCP port 53 with no `to` field (so it applies to any destination), otherwise DNS resolution breaks and everything looks like it's failing for the wrong reason:
>
> ```yaml
> egress:
> - to:
>   - podSelector:
>       matchLabels:
>         id: api
>   # no "ports" here: if the task doesn't name a specific port for "api",
>   # leaving "ports" out means all ports/protocols are allowed to this destination
> - ports:                # <-- separate rule, no "to": DNS allowed to any destination
>   - protocol: TCP
>     port: 53
>   - protocol: UDP
>     port: 53
> ```

**Real error you'll hit if `to` is written as a map instead of a list:**

```text
Error from server (BadRequest): error when creating "np.yaml": NetworkPolicy in version "v1"
cannot be handled as a NetworkPolicy: json: cannot unmarshal object into Go struct field
NetworkPolicyEgressRule.spec.egress.to of type []v1.NetworkPolicyPeer
```

The error message itself tells you the fix: `[]v1.NetworkPolicyPeer` means `to` (and `from` on the Ingress side) is a **list**, confirmed by `kubectl explain networkpolicy.spec.egress.to`. Missing the `-` is the classic version of the List vs Map trap from earlier in this cheat sheet:

```yaml
# wrong: "to" parsed as a single object, not a list
egress:
- to:
    podSelector:
      matchLabels:
        id: api

# right: "-" makes it a list item
egress:
- to:
  - podSelector:
      matchLabels:
        id: api
```

## 🩺 "Wait X, then check every Y seconds": Probe Timing Trap

When the exam wording says *"it should initially wait N seconds and periodically wait M seconds"*, that maps to `initialDelaySeconds` and `periodSeconds`, and an exec-based probe ("executing `cat /tmp/ready`") means `exec.command`, not `httpGet` or `tcpSocket`.

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

## 🔐 "...on container level": SecurityContext Placement Trap

When the wording explicitly says *"...for the security context **on container level**"*, `allowPrivilegeEscalation` and `privileged` go under the **container's** `securityContext`, nested inside `spec.template.spec.containers[]`, not under `spec.template.spec.securityContext` (the Pod-level one). See the [Pod vs Container decision table](pod-vs-container-and-decisions.md) for the full field list: both of these fields are container-only regardless of wording.

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

There is **no imperative flag** to set a container name different from the resource's own name: `kubectl create job`/`kubectl run` always name the container the same as the Job/Pod. If the task requires a distinct container name (e.g. Job `neb-new-job` with container `neb-new-job-container`), you must dry-run, edit the YAML, then apply.

```bash
kubectl create job neb-new-job --image=busybox --dry-run=client -o yaml -- sleep 3600 > neb-new-job.yaml
```

Edit only the container's `name:` field (leave `metadata.name`, the Job's own name, untouched):

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

### 🥷 Native Sidecars (Kubernetes ≥ 1.28)

A **native sidecar** is a container placed inside `initContainers` with `restartPolicy: Always` set **on that container itself** (not at the Pod level). This marks it as a long-running helper: it starts before the regular `containers` and keeps running for the Pod's whole lifetime, instead of running-to-completion like a normal init container.

```yaml
spec:
  volumes:
  - name: logs
    emptyDir: {}
  initContainers:
  - name: logger-con                                     # <-- native sidecar
    image: busybox:1.36
    restartPolicy: Always                                # <-- this is what makes it a sidecar, not a regular init container
    command: ["sh", "-c", "tail -f /var/log/cleaner/cleaner.log"]
    volumeMounts:
    - name: logs
      mountPath: /var/log/cleaner
  containers:
  - name: cleaner-con
    image: busybox:1.36
    command: ["sh", "-c", "while true; do echo \"$(date): remove random file\" >> /var/log/cleaner/cleaner.log; sleep 1; done"]
    volumeMounts:
    - name: logs
      mountPath: /var/log/cleaner
```

> [!WARNING]
> **Race condition:** a native sidecar starts *before* the regular `containers`, so if it reads a file the main container is supposed to create (like `tail -f cleaner.log` here), that file may not exist yet: `tail -f` on a missing file fails immediately, and the sidecar crash-loops until the main container finally creates it.
>
> Fix it by pre-seeding the file with a plain (non-sidecar) init container that runs first:
>
> ```yaml
> initContainers:
> - name: init
>   image: busybox:1.36
>   command: ['sh', '-c', 'echo init > /var/log/cleaner/cleaner.log']
>   volumeMounts:
>   - name: logs
>     mountPath: /var/log/cleaner
> - name: logger-con        # the native sidecar, see block above for its definition
>   ...
> ```
>
> Regular init containers still run to completion in order before the native sidecar starts, so this guarantees the file exists first.

### 🔎 Verifying What an Init Container Did

A **regular** (non-sidecar) init container runs to completion and then **terminates**, it is no longer a running container, so `kubectl exec` into it fails once it's done:

```bash
kubectl exec -it <pod-name> -c init-con -- sh
# error: unable to upgrade connection / container not running
```

`kubectl logs -c <init-container-name> <pod-name>` still works (it reads the terminated container's stdout), but if you need to check the actual **effect** it had, files it wrote or modified on a shared volume, exec into a **running** container that mounts the same volume instead:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-init-container
  namespace: mars
spec:
  replicas: 1
  selector:
    matchLabels:
      id: test-init-container
  template:
    metadata:
      labels:
        id: test-init-container
    spec:
      volumes:
      - name: web-content
        emptyDir: {}
      initContainers:
      - name: init-con
        image: busybox:1.36
        command: ['sh', '-c', 'touch /tmp/index.html; echo "check this out!" > /tmp/index.html']
        volumeMounts:
        - name: web-content
          mountPath: /tmp
      containers:
      - name: nginx
        image: nginx:1.14
        volumeMounts:
        - name: web-content
          mountPath: /usr/share/nginx/html
        ports:
        - containerPort: 80
```

```bash
# init-con already exited, so you can't exec into it. Check its work through nginx instead,
# since both mount the same "web-content" volume:
kubectl exec -it <pod-name> -c nginx -- cat /usr/share/nginx/html/index.html
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
[Mall Directory ✨](../../GLOSSARY.md)
