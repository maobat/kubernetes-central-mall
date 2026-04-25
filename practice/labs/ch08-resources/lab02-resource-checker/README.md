# ⚖️ Lab: Pod with Resource Requests and Limits
*Managing the Mall's Utility Budget*

In the **Central Mall**, every shop must declare its consumption. If a shop uses more water or electricity than allowed, the security guards will step in to protect the rest of the building.

---

## 🎯 Lab Objectives
1. Create a dedicated **Namespace** called `limit`.
2. Deploy a **Pod** named `resource-checker` with a specific **Resource Budget**.
3. Verify the **QoS Class** based on the requests/limits ratio.

---

## 🛠️ Step 1: The New Wing (Namespace)
Every budget needs a department. We start by creating the dedicated space.

```shell
k create ns limit
```

---

## 🛠️ Step 2: The "Hacker" Scaffold
Generate the basic YAML for the clerk (Pod) without applying it yet.

```shell
k -n limit run resource-checker --image=httpd:alpine $do > pod.yaml
```

---

## 🛠️ Step 3: The Surgery (Vim Routine)
Open `pod.yaml` and define the **Resource Budget**. 

> **Mall Logic:** > - **Requests:** The guaranteed minimum (30m CPU / 30Mi RAM).
> - **Limits:** The maximum allowed (300m CPU / 30Mi RAM).



```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: resource-checker
  name: resource-checker
  namespace: limit
spec:
  containers:
  - image: httpd:alpine
    name: my-container
    resources:
      requests:
        memory: "30Mi"
        cpu: "30m"
      limits:
        memory: "30Mi"
        cpu: "300m"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
```

---

## 🔎 The Inspector's Check (Verification)
Apply the manifest and check the **Quality of Service (QoS)** assigned by the Mall Manager.

```shell
k apply -f pod.yaml

# Check the QoS Class
k -n limit describe pod resource-checker | grep -i qos
```

**Expected Result:** Since RAM Request == Limit, but CPU Request < Limit, the Mall will classify this worker as **Burstable**.



---

## 📝 Architect's Pro-Tip: Memory vs CPU
In the Mall, if you exceed your **Electricity** (CPU), we just dim your lights (**Throttling**). If you exceed your **Storage Space** (Memory), the guards will evict you immediately (**OOMKilled**). Always be precise with Memory limits!

---

[Back to Chapter 08](../../README.md)
---
[Mall Directory ✨](../../../../GLOSSARY.md) | [🔙 Back](javascript:history.back())
