# 🧪 LAB 04: Automated Tasks (Countdown & Reports)
*Focus: Procedural Jobs and Scheduled Maintenance*

## 🎯 Lab Goal
In this lab, you will learn how to handle one-time procedural tasks (Jobs) and recurring automated reports (CronJobs) by inspecting their logs and execution history.

## 🛍️ Mall Analogy
In the **Central Mall**, some tasks are predictable and procedural.
- **The Countdown (Job)** → A specialized contractor hired to count down the seconds until the grand opening. Once they hit "1", they pack up and leave.
- **The Scheduled Report (CronJob)** → A clerk who prints the daily sales report at a specific time every day. You don't have to remind them; it's in their job description.

---

## 📋 Part 1: Managing Procedural Staff (Jobs)

### 1. Inspect the Blueprint
We have a file named `job-countdown.yaml` that uses a `centos:7` worker to run a for-loop.

### 2. Hire the Worker
Start the job:
```bash
kubectl apply -f job-countdown.yaml
```

### 3. Verify Completion
List the jobs and pods:
```bash
kubectl get job,po
```
(Look for `countdown` with 1/1 completions and a pod in `Completed` status).

### 4. Check the "Incident Report" (Logs)
Verify that the work was done correctly:
```bash
kubectl logs <pod-name>
```
(Output should show the countdown from 9 to 1).

---

## 📋 Part 2: Scheduling the Night Shift (CronJobs)

### 1. Deploy the Schedule
Use `cronjob.yaml` to set up a recurring task that prints the date every minute:
```bash
kubectl apply -f cronjob.yaml
```

### 2. Monitor the Spawning
Wait for a few minutes and watch the mall activity:
```bash
kubectl get cj,job,po
```
(You will see a list of uniquely named jobs and pods, one for each scheduled minute).

---

## 🧠 Key Takeaways
- **Job Identity**: Jobs create pods with randomized suffixes (e.g., `countdown-mqd2s`).
- **Execution History**: CronJobs keep a history of successful and failed jobs, which can be configured using `successfulJobsHistoryLimit`.

---

## 🔗 References
- **Study Guide** → [Chapter 01: Workloads](../../../../sources/study-guide/ch01-workloads.md)
- **Docs** → [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/) | [CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
