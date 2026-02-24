# LAB 02 – Identity & Access (RBAC)

---

## 🎯 Lab Goal
Learn how to create a ServiceAccount, bind it to a Role with specific permissions, and verify that a Pod can only perform actions allowed by its assigned "magnetic ID badge."

---

## 📖 Related Chapter
👉 [Chapter 7: Identity & Access (RBAC)](../../../sources/study-guide/ch07-identity.md)

---

## 📖 Related Comic
👉 [The Secure Badge](../../../comics/security/01-the-secure-badge/README.md)

---

## 🛍️ Mall Analogy
By default, new workers are given an **Anonymous Badge** (the `default` ServiceAccount) which doesn't let them enter restricted stockrooms. 

In this lab, we will:
1. Print a new **Stock Clerk Badge** (`ServiceAccount`).
2. Write a **Rulebook** that says "Stock Clerks can read inventory but not change prices" (`Role`).
3. **Clip the Badge to the Rulebook** so the security guards enforce it (`RoleBinding`).
4. Give the badge to a new worker (`Pod`).

---

## 🧩 Step 1 – Create the ID Badge (ServiceAccount)

Create a dedicated ServiceAccount in your namespace:
```bash
kubectl create serviceaccount stock-clerk
kubectl get sa stock-clerk
```

---

## 🧾 Step 2 – Write the Rules (Role)

Create a Role that only allows reading Pods (inventory) but no other resource:
```bash
kubectl create role pod-reader \
  --verb=get,list,watch \
  --resource=pods
```

---

## 📎 Step 3 – Bind the Rules to the Badge (RoleBinding)

Link the `stock-clerk` ServiceAccount to the `pod-reader` Role:
```bash
kubectl create rolebinding stock-clerk-binding \
  --role=pod-reader \
  --serviceaccount=default:stock-clerk
```

*Note: Replace `default` with your actual namespace if you are working in a different one.*

---

## 🏗️ Step 4 – Test the Permissions BEFORE Deploying

Kubernetes has an amazing built-in feature to test "Can I do this?" without actually running a Pod. It's called `auth can-i`.

Check if the `stock-clerk` can list pods:
```bash
kubectl auth can-i list pods --as=system:serviceaccount:default:stock-clerk
# Output: yes
```

Check if the `stock-clerk` can delete pods:
```bash
kubectl auth can-i delete pods --as=system:serviceaccount:default:stock-clerk
# Output: no
```

---

## 🤖 Step 5 – Hire the Worker (Deploy a Pod)

Let's deploy a Pod that explicitly uses this new badge.
Save this as `01-stock-clerk-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: api-tester
spec:
  serviceAccountName: stock-clerk  # <-- Handing over the badge
  containers:
  - name: tester
    image: bitnami/kubectl:latest
    command: ["sleep", "3600"]
```

Apply it:
```bash
kubectl apply -f 01-stock-clerk-pod.yaml
```

---

## 🕵️ Step 6 – The Real Test

Let's "exec" into the worker and try to mess with the mall using its internal credentials!

**Try to list pods (Should Succeed):**
```bash
kubectl exec api-tester -- kubectl get pods
```

**Try to get services (Should Fail):**
```bash
kubectl exec api-tester -- kubectl get services
```
*Output: Error from server (Forbidden): services is forbidden: User "system:serviceaccount:default:stock-clerk" cannot list resource "services"...*

---

## 🧹 Cleanup
```bash
kubectl delete pod api-tester
kubectl delete rolebinding stock-clerk-binding
kubectl delete role pod-reader
kubectl delete sa stock-clerk
```

---

## 🧠 Key Takeaways for CKAD

- Every Pod gets the `default` ServiceAccount if you don't specify one.
- **ServiceAccount** = The "Who" (Identity)
- **Role** = The "What" (Permissions)
- **RoleBinding** = The "Glue" connecting them.
- Always use imperative commands (`kubectl create role`, `kubectl create rolebinding`) in the exam. It is infinitely faster than writing the YAML by hand.
- Use `kubectl auth can-i` to verify your RBAC setup before wasting time debugging a failing Pod.
