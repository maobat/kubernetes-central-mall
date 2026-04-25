# 🧪 LAB 01: The Temporary Staff (Jobs & CronJobs)

## Application Design and Build – Background Tasks and Maintenance

---

## 🎯 Lab Goal

In this lab, you'll learn how to manage tasks that don't need to run forever. You will deploy a **Job** to perform a one-time cleanup and a **CronJob** to schedule recurring maintenance staff, ensuring the mall stays tidy without manual intervention.

---

## 🛍️ Mall Analogy

In the **Central Mall**, not all workers are "Full Time" (Deployments). 

- **The Contractors (Jobs)** → You hire a team to scrub the floors once. When they are done, they leave. They don't stay in the breakroom forever.
- **The Night Shift (CronJobs)** → Every night at 2:00 AM, the cleaning crew automatically arrives, does their work, and leaves. You don't have to call them; it's on the schedule.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Job** | A one-time contract worker. |
| **CronJob** | A recurring scheduled shift. |
| **Completions** | How many times the task must be finished. |

---

## 📋 Requirements

The Mall Management needs to run a data backup and a daily report.

1. **Namespace:** `default`.
2. **Job:** `backup-job`.
   - Image: `busybox`.
   - Task: `echo "Backing up Mall Database..." && sleep 5`.
3. **CronJob:** `daily-report`.
   - Schedule: `*/5 * * * *` (Every 5 minutes for this lab).
   - Image: `busybox`.
   - Task: `date; echo "Report generated."`.

---

## 🛠️ Step-by-Step Solution

### 1. Create the One-Time Job
```bash
kubectl create job backup-job --image=busybox -- /bin/sh -c "echo 'Backing up Mall Database...' && sleep 5"
```

### 2. Create the Recurring CronJob
```bash
kubectl create cronjob daily-report --image=busybox --schedule="*/5 * * * * " -- /bin/sh -c "date; echo 'Report generated.'"
```

---

## 🔎 Verification

1. **Check Job Status:**
   ```bash
   kubectl get jobs
   # Should show 1/1 completions.
   ```

2. **Check CronJob Schedule:**
   ```bash
   kubectl get cronjobs
   # Wait for the next 5-minute mark to see a job spawned.
   ```

---

## 🧠 Key Takeaways

- **Reliability:** If a Job fails, Kubernetes will restart the pod until it completes (backoffLimit).
- **Automation:** CronJobs are perfect for backups, certificate renewals, or clearing logs.
- **CKAD Tip:** Ensure you know the cron format (`* * * * *`). It's a common area for simple mistakes.

---

## 🔗 References
- **Comic** → [Workload Types](../../../visual-learning/comics/ch01-workloads/README.md)
- **Docs** → [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) | [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
- **Study Guide** → [Chapter 01: Workloads](../../../sources/study-guide/ch01-workloads.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
