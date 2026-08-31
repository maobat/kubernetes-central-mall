# CKAD Cheatsheet: Probes & SecurityContext

Wording-to-YAML traps for readiness/liveness probes and container hardening.

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

> [!WARNING]
> **This only works cleanly on a Deployment.** If the task instead gives you a bare, already-running **Pod** (no Deployment/ReplicaSet in front of it) and asks you to add or change `securityContext`, a plain `kubectl apply` fails:
>
> ```text
> The Pod "holy-api" is invalid: spec: Forbidden: pod updates may not change fields other than
> `spec.containers[*].image`,`spec.initContainers[*].image`,`spec.activeDeadlineSeconds`,
> `spec.tolerations` (only additions to existing tolerations),`spec.terminationGracePeriodSeconds`
> ```
>
> A Pod's spec is immutable after creation, except for that short allow-list. `securityContext` isn't on it, so the only fix is delete-and-recreate, three equivalent ways:
>
> ```bash
> kubectl apply --force -f holy-api-pod.yaml
> ```
>
> ```bash
> kubectl replace --force -f holy-api-pod.yaml
> ```
>
> ```bash
> kubectl delete pod holy-api --force --grace-period=0
> kubectl apply -f holy-api-pod.yaml
> ```
>
> A Deployment doesn't hit this because updating its Pod template triggers a rollout, new Pods are created fresh with the new spec, the old ones are terminated, nothing gets mutated in place.

<!-- -->

> [!TIP]
> **`apply --force` and `replace --force` are not quite the same, verified:**
>
> - **`apply --force`** tries a normal patch first, and only falls back to delete-and-recreate when the patch is rejected for touching an immutable field (exactly this case). Change something that's actually mutable (e.g. the image) instead, and `apply --force` patches in place, same Pod UID, no interruption.
> - **`replace --force`** always deletes and recreates unconditionally, verified: the Pod's UID changes every time, even when nothing immutable was touched.
>
> For an immutable field like `securityContext` here, both land on the same result. **`apply --force` is the safer default** when you're not sure whether the field you're changing is mutable, it does the minimal thing either way; reach for `replace --force` only when you specifically want an unconditional recreate.

---
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
