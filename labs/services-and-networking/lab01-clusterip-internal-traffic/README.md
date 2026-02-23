# 🧪 LAB 01 – ClusterIP & Internal Communication

## Services and Networking – Managing Internal Traffic

---

## 🎯 Lab Goal

This lab focuses on **ClusterIP Services**. You will learn how to create a stable entry point for a group of Pods, enabling internal communication within the "mall" (cluster).

---

## 📖 Related Comic
👉 [comics/clusterip/01-internal-intercom](../../../comics/clusterip/01-internal-intercom)

---

## 🏬 Mall Analogy

We are setting up a **Staff Support** desk that can be reached from any internal intercom in the mall.

| Kubernetes Concept | Mall Analogy |
| :--- | :--- |
| **Pod: staff-support** | A staff member ready to help. |
| **Service: ClusterIP** | The internal intercom system. |
| **Service Name: support-svc** | The extension number everyone dials. |
| **testpod (BusyBox)** | A store manager calling for help. |

---

## 📋 Requirements

1. Create a Deployment named **`staff-support`**:
   - Image: `nginx`
   - Replicas: `2`
2. Expose the Deployment via a **ClusterIP Service** named `support-svc` on port **80**.
3. In the **default** Namespace, run a **BusyBox Pod** named `testpod`.
4. **Verification:**
   - `testpod` must reach the `support-svc` using its DNS name.

---

## 🛠️ Solution

### 1. Deploy the Staff Support Team
```bash
kubectl create deployment staff-support --image=nginx --replicas=2
```

### 2. Install the Internal Intercom (ClusterIP Service)
```bash
kubectl expose deployment staff-support --name=support-svc --port=80
```

### 3. Test the Connection
```bash
# Start a test worker
kubectl run testpod --image=busybox -- sleep infinity

# Dial the Staff Support extension
kubectl exec testpod -- wget -qO- support-svc
```

---

## 🔎 Verification Results

✅ **Internal Check:** `testpod` successfully receives a response from `support-svc`.

---

## 🧰 Study Toolbox

* 🖼️ **Comic:** [The Internal Intercom (ClusterIP)](../../../comics/clusterip/01-internal-intercom/README.md)
* 📄 **Doc:** [Service IP Tracker Evolution](../../../docs/md-resources/service-ip-tracker-evolution.md)
