<img src="lab02-pod-design-jobs-cronjobs.png" alt="Pod Design Jobs CronJobs" width="40%" />

# 🖌️ The Painter & The Cleaning Crew

This comic explains the difference between **standard staff (Deployments)** and **specialized contractors (Jobs/CronJobs)** in the Central Mall.

---

## 🛍️ Mall Analogy

- **Receptionist (Deployment)** → Stays at the desk 24/7. If they leave, they are replaced immediately.
- **Painter (Job)** → Comes in once, paints the wall, and goes home forever upon completion.
- **Nightly Cleaning Crew (CronJob)** → A specialized Job that shows up on a specific schedule (e.g., midnight) to perform routine maintenance.

> 🛍️ *Hire a manager for the store, but hire a contractor for the leak.*

---

## 🧠 Key Takeaways

- **Jobs** are for tasks that run once to completion. They are successful when the Pod exits with status `0`.
- **CronJobs** schedule Jobs to run at specific times using Linux `cron` syntax.
- **Persistence:** Unlike Deployments, Jobs expect to "finish". If they fail, Kubernetes can retry them based on the `backoffLimit`.
- **CKAD Tip:** Memorize the `cron` schedule format (`* * * * *`) and know how to use `kubectl create job --from=cronjob` for manual testing.

---

## 🔗 References
- **Lab** → [Jobs & CronJobs](../../../../practice/labs/ch01-workloads/lab02-jobs-cronjobs/README.md)
- **Docs** → [Scheduled Maintenance Guide](../../../../reference/md-resources/cronjobs.md)
- **Study Guide** → [Chapter 1: Workloads & Contracts](../../../../sources/study-guide/ch01-workloads.md)
