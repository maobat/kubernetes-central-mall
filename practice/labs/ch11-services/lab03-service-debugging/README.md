# 🧪 LAB 03: Intercom Investigation (Service Debugging)

## 🎯 Lab Goal
In this lab, you will learn how to troubleshoot **Services** that aren't working as expected. You'll investigate why the "Bakery" can't reach the "Flour Warehouse" by checking labels, endpoints, and DNS records.

## 🛍️ Mall Analogy
In the **Central Mall**, if the Intercom (Service) is crackling or silent, the security guards (Administrators) must perform an **Intercom Investigation**.
- **The Signal Check:** Are the workers actually in the shop? (Pods running).
- **The Wiring Check:** Are the workers wearing the correct department badge? (Labels matching).
- **The Directory Check:** Is the shop listed in the mall's directory? (DNS resolution).

---

## 📋 Scenario
The **Management Office** has reported that the internal "Hostnames" intercom is failing. Some shops can't find it, and even when they do, the calls don't seem to reach any workers.

### 🛡️ Part 1: Signal & Wiring Check (Pods & Labels)
The first step is to see if the workers (Pods) are actually available and wearing the correct department labels.

1.  **List all pods** and their labels to ensure the department is "staffed".
    ```bash
    kubectl get po --show-labels
    ```
2.  **Filter pods** by the department label (`app=hostnames`).
    ```bash
    kubectl get pods -l app=hostnames
    ```
3.  **Verify worker addresses**: Get the individual IP addresses of the worker pods.
    ```bash
    kubectl get po -o wide
    ```
4.  **Test the signal**: Try to contact a worker directly at their IP (e.g., `192.168.0.8:9376`).
    ```bash
    # Run a temporary 'busybox' pod to test from inside the mall
    kubectl run -it --rm --restart=Never busybox --image=busybox:1.36 -- sh
    
    # Inside busybox shell, test the pod IP directly
    wget -qO- <POD_IP>:9376
    ```

### 🛡️ Part 2: Directory Check (DNS & IP)
If the workers are fine, maybe the Internal Intercom (DNS) is misconfigured.

1.  **Check the Intercom List**: List all services to find the stable Intercom IP.
    ```bash
    kubectl get svc
    ```
2.  **Test the Speed-Dial (DNS)**: From inside the `busybox` pod, try to call the service by its short name.
    ```bash
    nslookup hostnames
    ```
3.  **Test the Full Address (FQDN)**: If the short name fails, try the formal mall address.
    ```bash
    nslookup hostnames.default.svc.cluster.local
    ```
4.  **Check the Phone Book**: Ensure the mall's DNS configuration is correct.
    ```bash
    cat /etc/resolv.conf
    ```

### 🛡️ Part 3: Spec & Connection Check (Endpoints)
If DNS is fine but calls still fail, the "Wiring" (Selector) at the Intercom station might be wrong.

1.  **Inspect the Intercom Station (Service Spec)**: Output the service configuration to check for port mismatches.
    ```bash
    kubectl get service hostnames -o yaml
    ```
2.  **Verify the Connections (Endpoints)**: Check if the Service has actually successfully connected to any workers.
    ```bash
    kubectl get endpoints hostnames
    ```
    *If the `ENDPOINTS` column is `<none>`, the `spec.selector` is likely wrong!*

---

## 🔎 Verification Checklist
- [ ] Do the Service labels match the Pod labels exactly?
- [ ] Is the `targetPort` in the Service correct for the application's port?
- [ ] Is the Service type correct for its intended use (ClusterIP for internal)?

---
## 🔗 References
- **Study Guide** → [Chapter 11: Finding the Stores](../../../../sources/study-guide/ch11-services.md)
- **Docs** → [Debug Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/)

---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
