# 🧪 LAB 02: Readiness Probes

## Observability – Automated Self-Healing

---

## 🎯 Lab Goal

Understand how Kubernetes determines if a container is ready to receive traffic using **Readiness Probes**. You will observe what happens when a worker is "not ready" (fails a probe) and how the Mall Manager (Kubernetes) handles the situation.

---

## 🛍️ Mall Analogy

In the **Central Mall**, we have a dedicated **Health Inspector** who checks if shops are ready for customers.

- **The Worker (Container)** → A shop assistant setting up their station.
- **The Readiness Check (Readiness Probe)** → The Inspector asks, "Are you ready for customers?".
- **The Condition (`stat /tmp/ready`)** → The shelves must be fully stocked (the file must exist) before opening the doors.
- **The Isolation** → If the shop isn't ready, the manager takes the shop's sign down. No customers are sent here until it passes.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Readiness Probe** | "Are you ready for customers?" check. |
| **initialDelaySeconds** | Grace period to let the app start up. |

---

## 📋 Requirements

**Create a Deployment with a ReadinessProbe**

A `ReadinessProbe` will be executed periodically all the time, not just during start or until a Pod is ready.

1. Create a Deployment named `space-alien-welcome-message-generator` of image `httpd:alpine` with one replica.
2. It should have a `ReadinessProbe` which executes the command `stat /tmp/ready`. This means once the file exists the Pod should be ready.
3. The `initialDelaySeconds` should be `10` and `periodSeconds` should be `5`.
4. Create the Deployment and observe that the Pod won't get ready.

**Probes Summary**
`ReadinessProbes` and `LivenessProbes` will be executed periodically all the time.

If a `StartupProbe` is defined, `ReadinessProbes` and `LivenessProbes` won't be executed until the `StartupProbe` succeeds.

- **ReadinessProbe fails***: Pod won't be marked Ready and won't receive any traffic
- **LivenessProbe fails***: The container inside the Pod will be restarted
- **StartupProbe fails***: The container inside the Pod will be restarted

*\*fails: fails more times than configured with failureThreshold*

> **Tip**
> Here is an example `ReadinessProbe` snippet:
> ```yaml
> readinessProbe:
>   exec:
>     command:
>     - ls
>     - /tmp
>   initialDelaySeconds: 5
>   periodSeconds: 5
> ```

---

## 🛠️ Step-by-Step Solution

### 1. Create the Blueprint
First we generate a Deployment yaml:
```bash
k create deploy space-alien-welcome-message-generator --image=httpd:alpine -oyaml --dry-run=client > deploy.yaml
```

### 2. Add the Health Inspector
Then we adjust it to the requirements:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: space-alien-welcome-message-generator
spec:
  replicas: 1
  selector:
    matchLabels:
      app: space-alien-welcome-message-generator
  strategy: {}
  template:
    metadata:
      labels:
        app: space-alien-welcome-message-generator
    spec:
      containers:
      - image: httpd:alpine
        name: httpd
        resources: {}
        readinessProbe:
          exec:
            command:
            - stat
            - /tmp/ready
          initialDelaySeconds: 10
          periodSeconds: 5
```

### 3. Apply and Observe
Observe that the Pod won't get ready. We see `0/1` in the `READY` column.

```bash
controlplane $ k get deploy
NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
space-alien-welcome-message-generator   0/1     1            0           40s
```

We can also run `k describe deploy` to see info about failed `ReadinessProbes`.

### 4. Make the Deployment Ready
Now, let's stock the shelves so the Inspector passes the shop. We need to create the `/tmp/ready` file inside the Pod.

First, get the Pod name:
```bash
k get pod -l app=space-alien-welcome-message-generator
```

Then, execute a command inside the Pod to create the file (replace the pod name with yours):
```bash
k exec <pod-name> -- touch /tmp/ready
```

### 5. Final Observation
After waiting for the next probe interval (up to 5 seconds), observe that the Pod is now marked as ready.

We see `1/1` in the `READY` column.

```bash
controlplane $ k get deploy
NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
space-alien-welcome-message-generator   1/1     1            0           3m53s
```

> **Alternative Check Method (HTTP)**
> Alternatively, if the app served a web page, you might configure an HTTP readiness probe instead of checking for a file. For example:
> ```yaml
>         readinessProbe:
>           httpGet:
>             path: /
>             port: 80
>           initialDelaySeconds: 5
>           periodSeconds: 5
> ```

---

## 🔗 References
- **Comic** → [The Health Inspector - Readiness](../../../../visual-learning/comics/ch14-probes/02-readiness-probes/README.md)
- **Docs** → [Configure Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- **Study Guide** → [Chapter 14: Observability](../../../../sources/study-guide/ch14-probes.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
