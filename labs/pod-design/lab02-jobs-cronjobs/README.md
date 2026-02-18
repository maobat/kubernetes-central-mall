# Lab 02 – Pod Design: Jobs & CronJobs

## Batch Processing & Scheduled Tasks

---

## 🎯 Lab Goal

This lab focuses on **short-lived processes** in Kubernetes. You will learn how to:

- Run a one-off task using a **Job**.
- Schedule a recurring task using a **CronJob**.
- Manage completions and parallelism.

This is a **high-probability CKAD topic**.

---

## 🧠 Conceptual Comic (Read First)

Before starting, read this short comic:

👉 [Lab 02 - The Painter & The Cleaning Crew](../../../comics/pod-design/02-jobs-cronjobs/README.md)

It explains **Jobs (One-off) vs CronJobs (Scheduled)**.

---

## 📘 Reference Docs

- Jobs → [Kubernetes Docs: Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- CronJobs → [Kubernetes Docs: CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)

---

## 📋 Requirements

1. Create a **Job** named `one-off-task`
   - Image: `busybox`
   - Command: Print "Hello CKAD" and exit.
   - Completions: 1

2. Create a **CronJob** named `scheduled-task`
   - Schedule: Run every minute (`*/1 * * * *`)
   - Image: `busybox`
   - Command: Print "This is a scheduled task".

3. **Verify**:
   - Check that the Job completes successfully (`Completed` status).
   - Check that the CronJob spawns new Jobs over time.

---

## 🏬 Mall Analogy

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| **Deployment** | The **Mall Customer Service Desk** (Always open). |
| **Job** | The **Painter** who paints a wall and leaves when finished. |
| **CronJob** | The **Garbage Truck** that comes every Monday morning. |

---

## 🛠️ Solution

### 1️⃣ Create a One-Off Job

File: `job.yaml`
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: one-off-task
spec:
  template:
    spec:
      containers:
      - name: main
        image: busybox
        command: ["echo",  "Hello CKAD"]
      restartPolicy: OnFailure
  backoffLimit: 4
```

Apply it:
```bash
kubectl apply -f job.yaml
```

**Verify Completion:**
```bash
kubectl get jobs
# COMPLETIONS should become 1/1
```

### 2️⃣ Create a Scheduled CronJob

File: `cronjob.yaml`
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: scheduled-task
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox
            command:
            - /bin/sh
            - -c
            - date; echo This is a scheduled task
          restartPolicy: OnFailure
```

Apply it:
```bash
kubectl apply -f cronjob.yaml
```

---

### 🔎 Verification

1. **Watch the CronJob spawn Jobs:**
   ```bash
   kubectl get cronjob scheduled-task --watch
   ```

2. **Wait a minute or two**, then check the Jobs created by the CronJob:
   ```bash
   kubectl get jobs
   ```

3. **Check the logs of one of the completed Pods:**
   ```bash
   # Find a pod name from the jobs list
   kubectl get pods
   
   kubectl logs <pod-name-from-cronjob>
   ```

✅ **You have master batch processing!**
