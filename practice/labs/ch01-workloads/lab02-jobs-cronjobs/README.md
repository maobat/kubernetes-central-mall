# 🧪 LAB 02: The Painter & The Garbage Truck (Jobs & CronJobs)

## Pod Design – Batch Processing & Scheduled Tasks

---

## 🎯 Lab Goal

This lab focuses on **short-lived processes** in Kubernetes. You will learn how to:
- Run a one-off task using a **Job**.
- Schedule a recurring task using a **CronJob**.
- Manage completions, parallelism, and job history.

> **CKAD Importance:** High. Expect at least one question on Jobs or CronJobs.

---

## 🛍️ Mall Analogy

In the **Central Mall**, not every worker stays forever. 

- **The Painter (Job)** → Hired to paint a specific wall. Once the wall is painted, the painter packs up and leaves. If they fainted (crashed), we hire another one to finish the job.
- **The Garbage Truck (CronJob)** → Doesn't stay at the mall. It arrives exactly at 6:00 AM every morning, does its work, and leaves.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Job** | A one-off task that terminates once successful. |
| **CronJob** | A scheduled task that creates new Jobs periodically. |
| **Completions** | How many walls the painter needs to finish. |
| **Parallelism** | How many painters can work at the same time. |

---

## 📋 Requirements

1. **Create a Job** named `one-off-task`:
   - Image: `busybox`
   - Command: `echo "Hello CKAD" && sleep 5`
   - Requirement: Must complete exactly 1 time.

2. **Create a CronJob** named `scheduled-task`:
   - Schedule: Run every minute (`*/1 * * * *`).
   - Image: `busybox`
   - Command: `date; echo "This is a scheduled task"`.
   - History: Keep only the 3 most recent successful jobs.

---

## 🛠️ Step-by-Step Solution

### 1. The One-Off Job
Use the imperative shortcut to generate the blueprint.

```bash
# Generate the scaffold
k create job one-off-task --image=busybox $do -- sh -c 'echo "Hello CKAD" && sleep 5' > job.yaml

# Apply the job
k apply -f job.yaml
```

### 2. The Scheduled CronJob
CronJobs have a specific imperative command as well.

```bash
# Generate the scaffold
k create cj scheduled-task --image=busybox --schedule="*/1 * * * *" $do -- sh -c 'date; echo "This is a scheduled task"' > cronjob.yaml
```

**Manual Edit:** Add the history limit to keep the "Mall Records" clean.
```yaml
spec:
  successfulJobsHistoryLimit: 3
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          ...
```

---

## 🔎 Verification

1. **Check Job Status:**
   ```bash
   k get jobs
   # Check that COMPLETIONS is 1/1
   ```

2. **Trigger CronJob Manually:**
   Don't wait for the clock! This is the best way to test if your CronJob works.
   ```bash
   k create job --from=cronjob/scheduled-task manual-test-run
   k get jobs
   k logs job/manual-test-run
   ```

---

## 🧠 Key Takeaways

- **Restart Policy:** Jobs and CronJobs *cannot* use `Always`. They must use `OnFailure` or `Never`.
- **Active Deadline:** Use `activeDeadlineSeconds` to fire a painter who is taking too long to finish.
- **Completions vs Parallelism:** `completions` is the total work; `parallelism` is how many work at once.
- **CKAD Tip:** If you need to fix a CronJob during the exam, it's often faster to `k delete` and `k apply` rather than trying to edit the live object.

---

## 🔗 References
- **Comic** → [Jobs & CronJobs](../../../../visual-learning/comics/ch01-workloads/02-jobs-cronjobs/README.md)
- **Docs** → [Jobs](../../../../reference/md-resources/jobs.md) | [CronJobs](../../../../reference/md-resources/cronjobs.md)
- **Study Guide** → [Chapter 1: Workloads](../../../../sources/study-guide/ch01-workloads.md)
