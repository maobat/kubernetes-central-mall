# 🧪 LAB 04: Reading the Breakroom Rules
*Accessing ConfigMaps in Pods*

In the **Central Mall**, once the Mall Manager posts the rules in the breakroom (ConfigMap), the clerks (Pods) need a way to read them. This lab focuses on the two primary ways a clerk can receive these rules: as a direct instruction before their shift (**Environment Variable**) or as a physical handbook on their desk (**Volume Mount**).

---

## 🎯 Lab Objectives
1. Create a **Pod** named `pod1` using the `nginx:alpine` image.
2. Inject a single rule from the `trauerweide` ConfigMap as an **Environment Variable**.
3. Provide the entire `birke` ConfigMap as a physical handbook by mounting it as a **Volume**.
4. Test that the clerk can successfully access both.

> **CKAD Importance:** Injecting configuration into Pods is a core requirement for almost every application deployment scenario.

---

## 🛠️ Step 1: The "Hacker" Scaffold

Generate the basic YAML for the clerk (Pod) without applying it yet.

```shell
k run pod1 --image=nginx:alpine $do > pod.yaml
```

---

## 🛠️ Step 2: The Surgery (Vim Routine)

Open `pod.yaml` and equip the clerk with their instructions. 

> **Mall Logic:** > - **The Vibe (Env Var):** We look up the `tree` key from the `trauerweide` ConfigMap and tell the clerk to remember it as `TREE1`.
> - **The Handbook (Volume Mount):** We take the entire `birke` ConfigMap and place it on the clerk's desk at `/etc/birke`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod1
spec:
  volumes:
  - name: birke
    configMap:
      name: birke
  containers:
  - image: nginx:alpine
    name: pod1
    volumeMounts:
      - name: birke
        mountPath: /etc/birke
    env:
      - name: TREE1
        valueFrom:
          configMapKeyRef:
            name: trauerweide
            key: tree
```

---

## 🔎 The Inspector's Check (Verification)

Apply the manifest and interrogate the clerk to ensure they understand the rules.

```shell
k apply -f pod.yaml

# Check if the clerk remembered the "vibe" (Env Var)
kubectl exec pod1 -- env | grep "TREE1=trauerweide"

# Check if the clerk has the handbook and can read specific pages (Volume)
kubectl exec pod1 -- cat /etc/birke/tree
kubectl exec pod1 -- cat /etc/birke/level
kubectl exec pod1 -- cat /etc/birke/department
```

---

[Back to Chapter 05 Index](../../README.md)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
