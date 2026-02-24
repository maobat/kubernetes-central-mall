# 🧪 LAB 15 – Fixing the Broken Shop

## 🎯 Lab Goal
Investigate and repair a "broken" shop that refuses to serve customers. You will use the standard Kubernetes troubleshooting toolkit: `describe`, `logs`, and `exec`.

## 🏢 Mall Analogy
The **Central Mall** security team has reported that one of the new stores is having recurring "incidents." The Mall Manager wants you to look at the **Security Logbook** (Describe) and the **CCTV Tapes** (Logs) to find out what's wrong and fix it.

## 📖 Related Chapter
👉 [sources/study-guide/ch15-debugging.md](../../../sources/study-guide/ch15-debugging.md)

---

## 🏗️ Step 1: Deploy the "Broken" Shop
Apply the following "broken" blueprint. It contains three hidden issues.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: broken-shop
  labels:
    app: central-mall
spec:
  containers:
  - name: shop-clerk
    image: nginx:typo-version # Issue 1: Image Typo
    resources:
      limits:
        memory: "10Mi" # Issue 2: Memory Limit too low (OOM)
    command: ["sh", "-c", "echo 'Opening shop...'; sleep 2; exit 1"] # Issue 3: App Crash
```

## 🔍 Step 2: Investigation (The Logbook)
Check the status of your shop and read the manager's notes.

```bash
kubectl get pod broken-shop
# You should see: ImagePullBackOff or ErrImagePull

kubectl describe pod broken-shop
# Look at the "Events" section. It will say: 
# "Failed to pull image... repository does not exist"
```

**Fix 1:** Edit the Pod (or recreate it) with a valid image: `image: nginx`.

## 🔍 Step 3: Investigation (The CCTV)
After fixing the image, the shop will start, but it will keep crashing (`CrashLoopBackOff`). Let's look at the CCTV.

```bash
kubectl logs broken-shop
# You should see: "Opening shop..." but then nothing.
```

**Fix 2 & 3:** The app faints immediately because of the `exit 1` command and low memory. Update the blueprint to:
1. Increase memory: `memory: "64Mi"`.
2. Fix the command: `command: ["sh", "-c", "echo 'Shop is open!'; sleep 3600"]`.

---

## ✅ Verification
Once fixed, the shop should be `Running` and `READY 1/1`.

```bash
kubectl get pod broken-shop
```

## 🧠 Key Takeaways
1. **Logbook (Describe):** Finds infrastructure issues (wrong images, no resources, mounting errors).
2. **CCTV (Logs):** Finds application issues (crashes, internal errors).
3. **Walking Inside (Exec):** Used for manual checks inside a running container.
