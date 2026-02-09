<h2 id="section-6-7-0">🐤 6.7 Lab: Canary Deployments (The "New Recipe" Test)</h2>

In the Kubernetes "Mall," a **Canary Deployment** is like testing a new recipe by opening a small pop-up stand next to your established restaurant. You see if customers like the new flavor before you renovate the whole building.

## Lab: Using Canary Deployments
This lab demonstrates how to use the **Canary** upgrade strategy to replace an old version of an application with a newer version by utilizing shared labels and a single Service.

---

### 1. Lab Objectives
* **Run an Nginx Deployment (v1.14)** with 3 replicas.
* **Use a ConfigMap** to provide a specific `index.html`.
* **Deploy a "Canary" version (latest)** with a different ConfigMap.
* **Verify the traffic split** between versions.
* **Complete the transition** by removing the old version.

---

### 2. Phase 1: Deploying the Old Version

**Step 1: Create the Local Content**
```bash
echo "welcome to the old version" > index.html
```

**Step 2: Create the ConfigMap**
```
kubectl create cm oldversion --from-file=index.html
```
**Step 3: Create the Deployment (old-nginx.yaml)**

Define a deployment with the label `type: canary` and mount the `oldversion` ConfigMap to `/usr/share/nginx/html`.
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: old-nginx
    type: canary
  name: old-nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: old-nginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: old-nginx
        type: canary
    spec:
      containers:
      - image: nginx:1.14
        name: nginx
        resources: {}
        volumeMounts: 
        - name: indexfile
          mountPath: /usr/share/nginx/html
      volumes:
      - name: indexfile
        configMap:
          name: oldversion
status: {}
```
**Apply the deployment:**
```
kubectl apply -f old-nginx.yaml
```
**Step 4: Expose the Service**
```
kubectl expose deployment old-nginx --name=canary-svc --port=80 --target-port=80 --selector=type=canary
```
### 3. Phase 2: Deploying the Canary (New Version)
**Step 1: Create the New Content & ConfigMap**
```
echo "welcome to the new version" > index.html
kubectl create cm newversion --from-file=index.html
```
**Step 2: Create the New Deployment (new-nginx.yaml)**
```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: new-nginx
    type: canary
  name: new-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: new-nginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: new-nginx
        type: canary
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        resources: {}
        volumeMounts:
        - name: indexfile
          mountPath: /usr/share/nginx/html
      volumes:
      - name: indexfile
        configMap:
          name: newversion
status: {}
```
**Apply the canary deployment:**
```
kubectl apply -f new-nginx.yaml
```
### 4. Phase 3: Traffic Verification
**Step 1: Get the Service IP**
```
kubectl get svc canary-svc
# NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
# canary-svc   ClusterIP   10.111.0.65    <none>        80/TCP    21m
```
**Step 2: SSH and Run Test Loop**
```
minikube ssh
docker@minikube:~$ while true; do curl -s 10.111.0.65; sleep 1; done
```
**Expected Result:** Roughly 75% "old version" and 25% "new version".
### 5. Phase 4: Finalizing the Rollout
**Step 1: Scale the New Version**
```
kubectl scale deployment new-nginx --replicas=3
```
**Step 2: Delete the Old Version**
```
kubectl delete deployment old-nginx
```
**Final Verification:** All traffic returns "welcome to the new version".
### Summary Table
|Resource|Old Component|New Component|
|-|-|-|
|ConfigMap|oldversion|newversion|
|Image|nginx:1.14|nginx:latest|
|Service Label|type: canary|type: canary|
|Count|3 Replicas|3 Replicas|


[Back to Documentation](../README.md)
