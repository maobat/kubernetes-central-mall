# LAB 04 – Canary Deployments with NodePort and Replica Weighting

## Deploying Applications the DevOps Way – Canary Release (No Ingress)



---
## 🎯 Lab Goal

Implement a **Canary Deployment** using **NodePort** and **replica weighting** to control traffic distribution.

---

## 📖 Related Comic
👉 [comics/nodeport/01-canary-nodeport/README.md](../../../comics/nodeport/01-canary-nodeport/README.md)

---
## 📘 Reference Docs

- Canary deployments → [`docs/md-resources/canary-deployments.md`](../../../docs/md-resources/lab-canary-deployments-the-new-recipe-test.md)
- Introduction to Canary Deployments → [Implementing Canary Deployments](../../../docs/md-resources/implementing-canary-deployments.md)
- Reference: Blue/Green vs Canary → [Comparison](../../../docs/md-resources/related-deployment-strategies-comparison.md)
- Next Step: Advanced Traffic Splitting (Gateway API) → [Advanced Traffic Splitting](../../../docs/md-resources/advanced-traffic-splitting.md)



---
## 📋 Requirements

1. Run a Deployment named **oldbird**
   - Image: `nginx:1.18`
2. Run a Deployment named **newbird**
   - Image: `nginx:latest`
3. Expose both Deployments via **one NodePort Service**
4. Route traffic approximately:
   - **90% → oldbird**
   - **10% → newbird**

---

## 🏬 Mall Analogy

We are testing a **new shop layout** without rebuilding the mall entrance.

| Kubernetes Concept | Mall Analogy |
|-------------------|-------------|
| **oldbird Pods** | The trusted, old shop layout |
| **newbird Pods** | The experimental new layout |
| **Shared Service** | A single front door |
| **Replica count** | Number of shop assistants |
| **Traffic split** | Probability of who serves the customer |

Kubernetes doesn’t do percentages, it does **math with Pods**.

---

## 🛠️ Solution

### 1️⃣ Create the Base Deployment (oldbird)

```bash
kubectl create deploy oldbird \
  --image=nginx:1.18 \
  --dry-run=client -o yaml > old.yaml
```
Edit `old.yaml` and add a **shared label**:
```yaml
metadata:
  labels:
    type: bird
spec:
  template:
    metadata:
      labels:
        type: bird
```
Apply it:
```bash
kubectl apply -f old.yaml
```
### 2️⃣ Create the Canary Deployment (newbird)
Reuse the same file:
```bash 
vim old.yaml
```
Replace `oldbird` with `newbird` and `nginx:1.18` with `nginx:latest`:
Quick Vim helpers:
```vim
:%s/oldbird/newbird/g
:%s/nginx:1.18/nginx:latest/g
```
Apply it:
```bash
kubectl apply -f old.yaml
```
Verify:
```bash
kubectl get pods -l type=bird
```
### 3️⃣ Expose Both Deployments via One Service
Create a **NodePort Service** that selects **all bird pods**:
```bash
kubectl expose deploy oldbird \
  --name=bird \
  --port=80 \
  --selector=type=bird \
  --type=NodePort
```
Check the service:
```bash
kubectl get svc bird
```
### 4️⃣ Observe Traffic Distribution (Initial State)
```bash
curl $(minikube ip):<NODEPORT>
```
At this point:

- oldbird = 1 pod
- newbird = 1 pod
→ ~ **50/50 traffic**

### 5️⃣ Shift Traffic to 90/10 (The Canary Step)

Scale only the old Deployment:
```bash
kubectl scale deploy oldbird --replicas=9
```
Check the pods:
```bash
kubectl get pods -l type=bird
```
At this point:

- oldbird = 9 pods
- newbird = 1 pod

  → ~ **90/10 traffic split**

Verify again:
```bash
kubectl describe svc bird
```
🔎 **How Traffic Is Really Split**

Kubernetes Services do:

- Round-robin across Endpoints
- No weights
- No intelligence
- Traffic ratio = **number of Pods**

🧠 **Expert Summary**

- Canary deployments can be implemented without Ingress
- Replica count = traffic percentage
- NodePort + selector = shared entry point
- This is a **low-level**, **exam-friendly pattern**

📝 **CKAD Exam Tips**

- Expect **NodePort-based canaries**
- Ingress-based canaries are often out of scope
- Know how Services select Pods
- Always check `describe svc`→ Endpoints

---

## 📖 Related Chapter
👉 [sources/study-guide/ch09-deployments.md](../../../sources/study-guide/ch09-deployments.md)
