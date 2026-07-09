# ReplicaSet — Deep Dive

## Mall Analogy
The ReplicaSet is the Shift Scheduler: it makes sure the desired number of identical workers (Pods) are on duty.

## Overview
A ReplicaSet (RS) is a Kubernetes controller whose responsibility is to maintain a stable set of replica Pods running at any given time. You typically don't create ReplicaSets directly in day-to-day operations — Deployments manage ReplicaSets for you — but understanding RS helps explain how scaling and rolling updates work under the hood.

## How ReplicaSets work
- desired replicas: the number of identical Pod copies the ReplicaSet should maintain.
- selector: a label selector that matches Pods the ReplicaSet manages.
- pod template: used to create new Pods when the current number falls below the desired replicas.
- controller loop: watches Pod objects and creates or deletes Pods to converge to the desired state.

Important: ReplicaSets match Pods by labels. If multiple controllers select the same Pods, behavior becomes unpredictable — ensure selectors are unique or managed by a single higher-level controller (Deployment).

## Relationship to Deployments
- Deployments are the higher-level, user-facing controller for rolling updates, rollbacks, and declarative updates.
- A Deployment creates and owns ReplicaSets. During an update, the Deployment creates a new ReplicaSet with the updated Pod template and scales the old/new ReplicaSets to perform a rolling update.
- You normally interact with Deployments; ReplicaSets are useful to inspect when debugging rollout details.

## Example ReplicaSet YAML
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: hello-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello
  template:
    metadata:
      labels:
        app: hello
    spec:
      containers:
      - name: hello
        image: nginx:stable
        ports:
        - containerPort: 80
```

## Common kubectl commands
- View ReplicaSets: kubectl get rs
- Describe one: kubectl describe rs hello-rs
- View Pods managed by an RS: kubectl get pods -l app=hello
- Scale: kubectl scale rs hello-rs --replicas=5
- Delete (and its Pods): kubectl delete rs hello-rs

## Troubleshooting tips
- Mismatched selectors/labels: ensure the selector in the ReplicaSet matches the labels in the Pod template.
- Insufficient resources: if Pods remain Pending, check node capacity, resource requests/limits, and events (kubectl describe pod).
- Conflicting controllers: never let two controllers manage the same set of Pods—use Deployments to avoid this.
- Stuck replicas: inspect events (kubectl describe rs) and Pod statuses to find scheduling or image-pull errors.

## Further reading
- Official docs: https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/

