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

## 📖 Related Comic
👉 [comics/pod-design/02-jobs-cronjobs/README.md](../../../comics/pod-design/02-jobs-cronjobs/README.md)

It explains **Jobs (One-off) vs CronJobs (Scheduled)**.

---

## 📘 Reference Docs

- Jobs → [Kubernetes Docs: Jobs](../../../docs/md-resources/jobs.md)
- CronJobs → [Kubernetes Docs: CronJobs](../../../docs/md-resources/cronjobs.md)

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

👉 [Lab 02 - The One-Off Task](./job.yaml)

**CKAD imperative shortcut**
```bash
k create job one-off-task --image=busybox $do -- echo "Hello CKAD" > job.yaml
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

👉 [Lab 02 - The Scheduled Task](./cronjob.yaml)

**CKAD imperative shortcut**
```bash
k create cj scheduled-task --image=busybox --schedule="*/1 * * * *" $do -- /bin/sh -c "date; echo('This is a schedule task')" > cronjob.yaml
```

Apply it:
```bash
kubectl apply -f cronjob.yaml
```

---

### 🔎 Verification

1. **Watch the CronJob spawn Jobs:**
   ```bash
   k get cronjob scheduled-task --watch
   ```

2. You can use the **Manual Trigger (The Best Way)**

    The `--from` command creates a `one-off Job` using the exact configuration (image, command, environment variables) defined in your CronJob, without waiting for the scheduler.
    
    ```Bash
    k create job --from=cronjob/scheduled-task manual-test-run
    ```

3. Verification
Once you run that, the Job starts instantly. You can verify it just like any other job:

    ```Bash
    # Check the status immediately
    k get jobs

    # Check the logs of the manual run
    k logs job/manual-test-run
    ```   
   >Adding these two fields will ensure Kubernetes automatically deletes old Job records, keeping your k get jobs output from becoming a mile long:
   ```yaml
   spec:
     schedule: '*/1 * * * *'
     successfulJobsHistoryLimit: 3  # Keeps only the last 3 successful jobs
     failedJobsHistoryLimit: 1      # Keeps only the last failed job for debugging
     concurrencyPolicy: Forbid      # Prevents a new job from starting if the old one is still running
     jobTemplate:
       ...
   ```

3. **Check the logs of one of the completed Pods:**
   ```bash
   # Find a pod name from the jobs list
   kgetp # alias kgetp='k get pod -o wide --sort-by=.metadata.creationTimestamp'
   k logs <pod-name-from-cronjob>
   ```

---

## 📖 Related Chapter
👉 [sources/study-guide/ch01-workloads.md](../../../sources/study-guide/ch01-workloads.md)
