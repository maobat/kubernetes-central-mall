# 📄 CronJobs: The Scheduled Maintenance Crew
*Repeating Tasks & Routine Inspections*

A **CronJob** is simply a **Job** that runs on a timer. It’s the "Nightly Cleaning Crew" that shows up every day at midnight to sweep the mall.

---

## 🎭 The Schedule (The Watch)
CronJobs use the standard Linux `cron` format:
` * * * * * `
`min hr dom mon dow`



---

## 🛠️ The Blueprint (YAML)

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: nightly-inventory
spec:
  schedule: "0 0 * * *" # Every night at midnight
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: counter
            image: busybox
            command: ["sh", "-c", "echo Counting stock..."]
          restartPolicy: OnFailure
```

---

## 🏗️ CKAD Speed-Run Commands

```bash
# Create a CronJob imperatively
kubectl create cronjob log-sweep --image=busybox --schedule="*/5 * * * *" -- echo "Cleaning logs"

# Manually trigger a CronJob right now (Testing)
kubectl create job --from=cronjob/log-sweep test-run-now

# Pause a CronJob (Suspend the crew)
kubectl patch cronjob log-sweep -p '{"spec" : {"suspend" : true }}'
```

---

## ⚠️ Important Note: Suspend & History
* **concurrencyPolicy:** What happens if the old crew isn't done when the new crew arrives? (`Allow`, `Forbid`, or `Replace`).
* **successfulJobsHistoryLimit:** How many "Success Reports" do we keep in the logbook? (Default is 3).
---
[Mall Directory ✨](../../GLOSSARY.md)
