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

---
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
