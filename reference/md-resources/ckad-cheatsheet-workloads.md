# CKAD Cheatsheet: Workloads (Pods, Deployments, Jobs, Sidecars)

Commands and exam-wording traps for creating and structuring workloads.

## 📦 Deployments & Scaling

```bash
# Scale a deployment
kubectl scale deployment <deployment-name> --replicas=N

# Check rollout status
kubectl rollout status deployment <deployment-name>

# Rollback a deployment
kubectl rollout undo deployment <deployment-name>
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

## 🔢 "Run a total of X times, Y in parallel": Job Completions Trap

Two separate numbers in the wording map to two separate fields, don't merge them into one:

| Wording in the task | Field |
| :--- | :--- |
| "run a total of X times" | `completions: X` |
| "Y runs in parallel" / "Y at a time" | `parallelism: Y` |

> Example requirement: *"The Job should run a total of 3 times and should execute 2 runs in parallel."*

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: my-job
spec:
  completions: 3      # <-- total successful Pod completions needed before the Job is done
  parallelism: 2       # <-- how many Pods run at once while getting there
  template:
    spec:
      containers:
      - name: worker
        image: busybox
        command: ["sh", "-c", "sleep 5"]
      restartPolicy: Never
```

With `completions: 3` and `parallelism: 2`, Kubernetes starts 2 Pods immediately; as soon as one finishes, a 3rd Pod starts to reach the total of 3, it never runs more than 2 at once.

> [!TIP]
> `completions` alone (no `parallelism`, or `parallelism: 1`) runs the Pods **sequentially**, one at a time, X times total. `parallelism` with no `completions` set runs that many Pods concurrently but the Job is done as soon as **any one** succeeds, that's a different pattern (a "race", not "run X times"), don't set one when the task actually specifies both.

Verify what actually ran:

```bash
kubectl get job my-job -o jsonpath='{.status.succeeded}{"\n"}'   # should reach 3
kubectl get pods -l job-name=my-job                              # up to 2 Running at any moment while it converges on 3
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

---
[CKAD Cheatsheet Index](ckad-cheatsheet.md) | [Mall Directory ✨](../../GLOSSARY.md)
