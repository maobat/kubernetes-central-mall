# 🧪 LAB 03: The Entry Permit Office (Admission Control)

## 🎯 Lab Goal
Understand how the **Admission Control** system acts as a policy enforcement gatekeeper before any workload is allowed into the mall.

## 🛍️ Mall Analogy
The **Entry Permit Office** (Admission Control) is the final checkpoint. Even if a worker has a valid badge (AuthN) and a permit (AuthZ), the office can still reject them if they violate mall-wide safety rules (like not having a safety vest/resource limits) or if the specific wing is already at full capacity (Resource Quotas).

## 📋 Requirements
1.  Create a namespace called `secure-wing`.
2.  Apply a **ResourceQuota** to the `secure-wing` that limits the total number of pods to **2**.
3.  Deploy 2 pods successfully.
4.  Attempt to deploy a 3rd pod and observe the **Admission Controller** rejecting the request.
5.  Inspect the events to see the "Permit Denied" message.

## 🛠️ Step-by-Step Solution

1.  **Create the Namespace:**
    ```bash
    kubectl create ns secure-wing
    ```

2.  **Create the ResourceQuota (The Wing Limit):**
    ```bash
    kubectl create quota wing-limit --hard=pods=2 -n secure-wing
    ```

3.  **Deploy the First Two Workers:**
    ```bash
    kubectl run worker-1 --image=nginx -n secure-wing
    kubectl run worker-2 --image=nginx -n secure-wing
    ```

4.  **Attempt to Deploy the 3rd Worker:**
    ```bash
    kubectl run worker-3 --image=nginx -n secure-wing
    ```

5.  **Observe the Rejection:**
    The output should immediately show an error from the API Server (Admission Control):
    `Error from server (Forbidden): pods "worker-3" is forbidden: exceeded quota: wing-limit, requested: pods=1, used: pods=2, limited: pods=2`

## 🔎 Verification
1.  **Check Quota Usage:**
    ```bash
    kubectl describe quota wing-limit -n secure-wing
    ```
    *You will see `Used: 2` and `Hard: 2`.*

2.  **Check Mall Events:**
    ```bash
    kubectl get events -n secure-wing --sort-by='.lastTimestamp'
    ```

## 🧠 Key Takeaways
- **Gatekeeper:** Admission Control intercepts requests *after* authentication and authorization but *before* the object is persisted in the ledger (etcd).
- **Types:** There are **Validating** controllers (checks rules) and **Mutating** controllers (changes the request to fit rules, like adding default sidecars).
- **CKAD Tip:** ResourceQuotas and LimitRanges are common examples of admission controllers encountered in the exam.

## 🔗 References
- **Study Guide** → [Chapter 7: Identity & RBAC](../../../../sources/study-guide/ch07-identity.md)
- **Docs** → [Admission Control Overview](../../../../reference/md-resources/authentication-and-authorization-the-security-team.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
