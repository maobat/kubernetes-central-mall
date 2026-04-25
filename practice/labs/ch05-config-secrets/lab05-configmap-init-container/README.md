# 🧪 LAB 05: The Automated Shop Manual (InitContainers & ConfigMaps)

## 🎯 Lab Goal
Learn how to use **InitContainers** to prepare complex configuration files from **ConfigMaps** before the main application starts. This is a common pattern when an application requires a specific file format that doesn't match the raw ConfigMap data.

## 🛍️ Mall Analogy
The **Redis Shop** has a very specific way of reading its manual (`redis.conf`). Instead of just pinning the manual to the wall, the Mall Owner hires an **Automated Prep Clerk** (InitContainer). This clerk arrives early, reads the **Generic Instructions** (ConfigMap), and writes a **Hand-Written Manual** into a **Temporary Notebook** (`emptyDir` volume). When the main **Shop Manager** (Redis) arrives, they just read the notebook and start the day.

---

## 📋 Requirements

1.  **Create the Instructions**: Create a ConfigMap named `redis-config` with the keys `maxmemory` (2mb) and `maxmemory-policy` (allkeys-lru).
2.  **Setup the Shop**: Deploy a Pod named `redis-pod` that:
    - Uses an **InitContainer** to read the ConfigMap and write a `redis.conf` file.
    - Uses a **Main Container** (`redis:7`) that reads the generated `redis.conf`.
    - Uses **Volumes** (`emptyDir`) to share the configuration between containers.
3.  **Inspect the Setup**: Use the `redis-cli` to verify that the configurations were applied correctly.

---

## 🛠️ Step-by-Step Solution

### 1. Creating the Instructions (ConfigMap)
```bash
kubectl create configmap redis-config \
  --from-literal=maxmemory=2mb \
  --from-literal=maxmemory-policy=allkeys-lru
```

### 2. Setting up the Shop (Pod with InitContainer)
Create a file named `redis-pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis-pod
spec:
  initContainers:
  - name: init-redis-config
    image: busybox:1.36
    command:
    - sh
    - -c
    - |
      set -e
      cat <<EOF >/redis-master/redis.conf
      maxmemory $(cat /configmap/maxmemory)
      maxmemory-policy $(cat /configmap/maxmemory-policy)
      EOF
    volumeMounts:
    - name: redis-config-dir
      mountPath: /redis-master
    - name: redis-config-map
      mountPath: /configmap
      readOnly: true
  containers:
  - name: redis
    image: redis:7
    command:
    - redis-server
    - /redis-master/redis.conf
    ports:
    - containerPort: 6379
    volumeMounts:
    - name: redis-config-dir
      mountPath: /redis-master
  volumes:
  - name: redis-config-map
    configMap:
      name: redis-config
  - name: redis-config-dir
    emptyDir: {}
```

Apply the manifest:
```bash
kubectl apply -f redis-pod.yaml
```

### 3. Inspecting the Setup (Verification)
Connect to the shop's control panel:
```bash
kubectl exec -it redis-pod -- redis-cli
```

Inside the Redis shell, check the settings:
```bash
CONFIG GET maxmemory
CONFIG GET maxmemory-policy
```

---

## 🔎 Verification
1.  Check the pod status: `kubectl get pod redis-pod`.
2.  Check the logs to see if the Prep Clerk finished: `kubectl logs redis-pod -c init-redis-config`.

## 🧠 Key Takeaways
- **InitContainers:** Perfect for pre-processing data or waiting for dependencies.
- **Shared Volumes:** `emptyDir` is the bridge between the Prep Clerk and the Manager.
- **Dynamic Config:** You can change the ConfigMap and restart the Pod to get new "hand-written" manuals.

---
## 🔗 References
- **Study Guide** → [Chapter 5: Configuration](../../../../sources/study-guide/ch05-configuration.md)
- **Docs** → [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

---
[Mall Directory ✨](../../../../GLOSSARY.md)
