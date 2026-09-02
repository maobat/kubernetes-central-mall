# CKAD Cheatsheet: Services & NetworkPolicy

Services, port mapping, layered connectivity testing, and NetworkPolicy traps.

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

## 🔵🟢 Blue/Green vs Canary: Which Label Does the Service Selector Use?

Both patterns put two Deployments behind one Service, the difference is entirely in **which label the Service selects on**, not in the Deployments themselves.

**The one constraint both patterns share:** each Deployment's own `selector.matchLabels` must be unique (can't overlap another Deployment's), so every Deployment needs at least one label that's exclusive to it, on top of anything shared.

### True Blue/Green — instant 100/0 cutover

The Service selects **only** the exclusive/distinguishing label, so at any moment it routes to exactly one color. Cutover = flip that one selector value, an atomic all-or-nothing switch with an equally instant rollback.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-blue
spec:
  replicas: 3
  selector:
    matchLabels: {app: myapp, version: blue}
  template:
    metadata:
      labels: {app: myapp, version: blue}
    spec:
      containers: [{name: myapp, image: myapp:v1}]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-green
spec:
  replicas: 3
  selector:
    matchLabels: {app: myapp, version: green}
  template:
    metadata:
      labels: {app: myapp, version: green}
    spec:
      containers: [{name: myapp, image: myapp:v2}]
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
spec:
  selector: {app: myapp, version: blue}   # <-- 100% blue right now
  ports: [{port: 80}]
```

Cutover to green: `kubectl patch svc myapp-svc -p '{"spec":{"selector":{"version":"green"}}}'` — no rolling update, no replica math, just a Service edit. Rollback is the same command with `blue` again.

### Weighted split (what CKAD calls "blue/green X% / Y%", really a canary shape)

The Service selects a label **shared** by both Deployments, excluding the distinguishing one entirely. Both colors are always live endpoints, the traffic ratio is controlled purely by **replica count**, not by the Service.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-blue
spec:
  replicas: 7                       # 70%
  selector:
    matchLabels: {app: myapp, version: blue}
  template:
    metadata:
      labels: {app: myapp, version: blue}
    spec:
      containers: [{name: myapp, image: myapp:v1}]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-green
spec:
  replicas: 3                       # 30%
  selector:
    matchLabels: {app: myapp, version: green}
  template:
    metadata:
      labels: {app: myapp, version: green}
    spec:
      containers: [{name: myapp, image: myapp:v2}]
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-svc
spec:
  selector: {app: myapp}              # <-- no "version" here, matches BOTH colors
  ports: [{port: 80}]
```

Shifting the ratio: `kubectl scale deployment app-blue --replicas=5` + `kubectl scale deployment app-green --replicas=5` for 50/50, and so on, no Service edit needed, ever.

> [!TIP]
> **The tell in an exam question:** a percentage split ("70% to blue, 30% to green") only makes sense as a replica-ratio weighted split, a plain Service has no concept of a weighted percentage (that needs a service mesh/Ingress-level traffic split, out of CKAD scope). An instant cutover ("switch all traffic to green", "roll back to blue immediately") is the exclusive-label pattern instead. Read which one the question is actually asking for before picking a label scheme, using the wrong one either breaks the split (excluded label ends up in the Service selector) or breaks the cutover (shared label means both colors always get some traffic, cutover never reaches 100%).

### 🏷️ Distinguishing-Label Variant: Two Different Keys, Not One Shared Key

The examples above use the same key with a different value per color (`version: blue` vs `version: green`), but a real question can just as easily hand you **two entirely different keys** instead, one per Deployment, neither shared with the other:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: blue-apd
  labels: {type-one: blue}          # <-- Deployment's OWN metadata.labels, a different tier from the pod template
spec:
  replicas: 7
  selector:
    matchLabels: {type-one: blue, version: v1}
  template:
    metadata:
      labels: {type-one: blue, version: v1}   # <-- "Add labels to the pod": BOTH keys land here
    spec:
      containers: [{name: blue-apd, image: myapp:v1}]
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: green-apd
  labels: {type-two: green}          # <-- a DIFFERENT key, not "type-one: green"
spec:
  replicas: 3
  selector:
    matchLabels: {type-two: green, version: v1}
  template:
    metadata:
      labels: {type-two: green, version: v1}
    spec:
      containers: [{name: green-apd, image: myapp:v2}]
---
apiVersion: v1
kind: Service
metadata:
  name: route-apd-svc
spec:
  type: NodePort
  selector: {version: v1}             # <-- the ONE key both Deployments actually share
  ports: [{port: 8080, targetPort: 8080}]
```

`type-one` and `type-two` are each exclusive to their own Deployment (functionally interchangeable with a `version: blue`/`version: green` scheme), the difference is purely cosmetic naming, don't assume `type-one`/`type-two` are typos for the same key, or that the second one should also read `type-one`. `version: v1` is the real shared key here, and it's identical on both colors (not `v1`/`v2`), it's the label that makes the weighted split work, `type-one`/`type-two` never appear in the Service's selector at all. Also note the two-tier label placement: "use the label X" on a Deployment typically means the Deployment's own `metadata.labels` (informational, not involved in selection), while "add labels to the pod X and Y" means `spec.template.metadata.labels` (and, by extension, `spec.selector.matchLabels`, which must match it) — conflating the two is an easy way to lose points on a question that grades both separately.

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

The error message itself tells you the fix: `[]v1.NetworkPolicyPeer` means `to` (and `from` on the Ingress side) is a **list**, confirmed by `kubectl explain networkpolicy.spec.egress.to`. Missing the `-` is the classic version of the [List vs Map trap](ckad-cheatsheet-fundamentals.md):

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

### 🔀 OR vs AND Logic in `from`/`to` Selectors

The same List vs Map distinction from earlier decides whether two selectors are combined with **OR** or **AND**, and it's one of the most common NetworkPolicy traps on the exam.

**OR: separate list items, each with its own `-`.** Traffic is allowed if it matches *either* peer:

```yaml
ingress:
- from:
  - podSelector:
      matchLabels:
        role: frontend
  - podSelector:
      matchLabels:
        role: monitoring
```

This allows traffic from Pods labeled `role: frontend` **or** Pods labeled `role: monitoring`, two independent peers in the same `from` list.

**AND: multiple selectors inside the *same* list item, as siblings.** Traffic is allowed only if it matches *all* the conditions at once:

```yaml
ingress:
- from:
  - namespaceSelector:
      matchLabels:
        team: ops
    podSelector:
      matchLabels:
        role: monitoring
```

Here `namespaceSelector` and `podSelector` sit under the **same** `-`, so this allows traffic only from Pods labeled `role: monitoring` that are *also* running in a Namespace labeled `team: ops`. Combining `namespaceSelector` and `podSelector` this way scopes the podSelector to that specific namespace instead of the policy's own namespace.

> [!TIP]
> **Read the indentation, not the words.** `podSelector` and `namespaceSelector` at the same indent level under one `-` are AND'ed together; each separate `-` under `from`/`to` is OR'ed with the others. The exact same rule applies inside a single `matchLabels` block too: every key/value pair listed there must all match (AND), since `matchLabels` is itself one selector, not a list.
>
> Same principle for `ports`: multiple entries in a `ports` list are OR'ed (any listed port is allowed), there's no AND equivalent for ports within one rule.

---
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
