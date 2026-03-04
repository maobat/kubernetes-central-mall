# 📄 Jobs: The Temporary Contractor
*One-time Tasks in the Central Mall*

In the **Central Mall**, most workers (Pods/Deployments) are meant to stay forever. But sometimes, you just need a contractor to come in, fix a leak, and leave. This is a **Job**.

---

## 🎭 The Concept: Success is the Goal
Unlike a Deployment, which restarts a worker if they finish their task, a **Job** expects the worker to finish and exit. The Job is considered "Complete" once the worker leaves with a success code.

| Feature | Description |
| :--- | :--- |
| **Completions** | How many contractors must finish the task? |
| **Parallelism** | How many contractors can work at the exact same time? |
| **BackoffLimit** | How many times can the contractor fail before we give up? |



---

## 🛠️ The Blueprint (YAML)

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: floor-scrubber
spec:
  completions: 3   # We need 3 floors scrubbed in total
  parallelism: 1   # Only one contractor working at a time
  template:
    spec:
      containers:
      - name: scrubber
        image: busybox
        command: ["sh", "-c", "echo Scrubbing floor...; sleep 5"]
      restartPolicy: OnFailure # Jobs cannot use 'Always'
```

---

## 🏗️ CKAD Speed-Run Commands

```bash
# Create a job to calculate pi (classic exam task)
kubectl create job pi-calc --image=perl:5.34 -- perl -Mbignum=bpi -wle 'print bpi(2000)'

# Check the status of your contractors
kubectl get jobs
```