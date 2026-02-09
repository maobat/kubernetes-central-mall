### 4.9.3 Lab Solution & Verification
After assigning the badge, we verify that the workers (Pods) are actually wearing them.

**1. Update the Store Manager's requirements:**
```Bash
kubectl set serviceaccount -n secure deploy securedeploy secure
```
<i>Logic</i>: This tells the Store Manager (Deployment) that every new worker (Pod) hired from now on must arrive at the office with the "secure" ID badge already pinned to their uniform.

**2. Verify the Worker's ID:**
We inspect one of the active workers to ensure the `Service Account` field has changed from `default` to `secure`.
```Bash
# Find the specific worker name first
kubectl get pods -n secure

# Inspect the worker
kubectl describe pod <pod-name> -n secure | grep "Service Account"
```
**Expected Output:**
`Service Account: secure`

> The ServiceAccount: This is the Restricted Key given to the Worker (Pod). If a worker needs to look at the Mall Ledger (API) to see if a shipment arrived, they use their ServiceAccount badge.
>
>we created the secure ServiceAccount is because:
>By default, workers are given a Guest Badge (default SA) that can't do anything but work.
>If a specific store (like the securedeploy) needs to perform special tasks (like reporting back to Management), we have to issue them a Specialized Badge (custom SA).

**3. Inspecting the Token Mount:**
If you look closer at the `describe` output, you will see a "Mount" point:
`Mounts: /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-xxxx (ro)`
  - **Mall Analogy:** This is the physical "Badge Holder" clipped to the worker's belt. It contains the digital key (token) that the worker uses to "swipe" into the Management Office (API Server).

**Security Summary Checklist**
  - **AuthN:** Did the worker show their Badge? (`~/.kube/config`)
  - **AuthZ:** Does the Job Description (**Role**) allow them to open this door?
  - **SA:** Is the worker using a specialized Badge (**ServiceAccount**) or just the guest one?
  - **SecurityContext:** Is the worker allowed to have a Master Key (**Root**) or are they restricted?
  - **Resources:** Is the worker staying within their allocated Desk Space (**Memory/CPU**)?

[Back to Documentation](../README.md)
