# 8.0: Troubleshooting Kubernetes
<h3 id="section-8-0">8.0: Troubleshooting Kubernetes</h3>


## 8.1 Determining a Troubleshooting Strategy
Troubleshooting a cluster requires a structured approach to filter out the noise. When an application fails, follow the **Inside-Out** hierarchy:



### The Troubleshooting Hierarchy
1. **Pod Level:** Check the container status. Is it `Running`, `Pending`, or in `CrashLoopBackOff`?
2. **Access Level:** If the Pod is running, check the **Service**. Are the labels matching? Is the `targetPort` correct?
3. **Node Level:** If many Pods fail, check the **Node**. Is it `Ready`? Is there disk or memory pressure?
4. **Control Plane Level:** Check the **API Server** and **Scheduler**. Are resources being created at all?

---

## 8.1.1 Understanding Pod Startup
To find out *where* a Pod is failing, you must know the sequence of events that happen after a `kubectl apply`.



### The Sequence of Events:
1. **API Server & etcd:** The request is validated and stored in **etcd**.
2. **Scheduler:** The Scheduler notices a new Pod with no `nodeName` and assigns it to a healthy Node.
3. **Kubelet:** The Kubelet on the destination node sees the assignment and starts the **CRI (Container Runtime)**.
4. **Image Pull:** The runtime pulls the image from the registry.
5. **Container Start:** The container is created and the `ENTRYPOINT` command is executed.

---

## 8.1.2 Common Pod Errors
| Error Status | Meaning | Common Fix |
| :--- | :--- | :--- |
| **Pending** | Scheduler cannot find a node. | Check `kubectl describe pod` (usually Insufficient CPU/RAM). |
| **ImagePullBackOff** | Kubelet cannot fetch the image. | Check image name, tag, or registry credentials (Secrets). |
| **CrashLoopBackOff** | Container starts but then exits immediately. | Check `kubectl logs --previous` to see the application crash. |
| **OOMKilled** | Container exceeded its memory limit. | Increase the memory `limits` in the YAML. |
| **CreateContainerConfigError** | Missing ConfigMap or Secret. | Ensure the referenced ConfigMap/Secret exists. |


<h2 id="section-8-2-0">8.2.0 Analyzing Failing Applications</h2>

When an application fails, it leaves a trail of clues in its **State** and **Exit Code**.

### 1. Understanding Pod States
In its lifetime, a Pod will go through different states:

* **Pending:** The API accepted the Pod, but it can't be scheduled (e.g., no node has enough RAM).
* **Running:** The Pod is bound to a node and containers are created.
* **Completed:** The container finished its job successfully (Exit Code 0).
* **Failed:** The container finished but something went wrong (Exit Code non-zero).
* **CrashLoopBackOff:** The container is failing repeatedly, and K8s is waiting before trying again.
* **Unknown:** The API server can't talk to the Kubelet on the Pod's node.

---

### 2. The Detective's Toolkit (Investigation Steps)

#### Step 1: Check the Status
```bash
kubectl get pods
```
Look for `RESTARTS` and `STATUS`. A high restart count combined with `CrashLoopBackOff` is a major red flag.

#### Step 2: Investigate with Describe

```bash
kubectl describe pod <pod-name>
```

- <b>Events:</b> Look at the bottom. This tells the "story" of the failure (e.g., `FailedScheduling`, `Back-off restarting failed container`).

- <b>Containers State:</b> Look for the `Last State`.

  - <b>Exit Code 0:</b> The app finished its work and closed (Normal for a Job, Bad for a Web Server).

  - <b>Exit Code 1-255:</b> The app crashed. You must check the logs.

#### Step 3: Inspect the Logs
If the exit code is not 0, the problem is inside the application code or configuration.

```Bash
# Check current logs
kubectl logs <pod-name>

# Check logs from the PREVIOUS (crashed) instance
kubectl logs <pod-name> --previous
```

#### 3. Demo Recap: Failure Case Studies
#### Case A: The "Instant Exit" (Busybox)
<b>Command:</b> `kubectl create deploy failure1 --image=busybox`
- <b>Result:</b> `CrashLoopBackOff`.
- <b>Reason:</b> Busybox's default entrypoint is a shell. Since there is no interactive command, the shell finishes immediately.
- <b>Fix:</b> Give it a long-running task: `kubectl create deploy failure1 --image=busybox -- sleep 3600`.
#### Case B: The "Missing Config" (MariaDB)
<b>Command:</b> `kubectl create deploy failure2 --image=mariadb`
- <b>Result:</b> CrashLoopBackOff.
- <b>Investigation:</b> kubectl logs <pod-name>
- <b>Discovery:</b> The logs show: `[ERROR] You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD or MYSQL_RANDOM_ROOT_PASSWORD`.
- <b>Fix:</b> Add the required environment variables via a ConfigMap or Secret.

#### Summary Troubleshooting Workflow
|Step|Command|Goal|
|-|-|-|
|1|`kubectl get pods`|Find the failing Pod and check Restart count.|
|2|`kubectl describe pod`|Check <b>Events</b> and <b>Exit Codes</b>.
|3|`kubectl logs --previous`|Read the application's "death certificate" (Error messages).|
---

<h2 id="section-8-3">8.3 Analyzing Pod Access Problems</h2>

If your Pod is `Running` and `Ready` but you cannot reach it, the issue lies in the **Network Plumbing**.

### 1. Understanding Services (The Load Balancer)
A Service uses a **Selector** to find Pods. If the Selector doesn't perfectly match the Pod's **Labels**, the Service will have no "Endpoints."

**The Golden Rule of Connectivity:**
For traffic to flow, the string in `service.spec.selector` **must exactly match** the string in `pod.metadata.labels`. Case sensitivity and spelling count!

**Diagnostic Checklist:**
* **Labels:** Run `kubectl get pods --show-labels`. Does it match the service selector?
* **Endpoints:** Run `kubectl get endpoints <svc-name>`. If it says `<none>`, your selector is wrong.
* **Target Port:** Ensure the `targetPort` in the Service matches the `containerPort` of the Pod.

### 2. Understanding Ingress (The External Entry)
Ingress relies on a Service to forward traffic.
* **Ingress Controller:** Must be running (e.g., NGINX Ingress Controller).
* **Path Matching:** Ensure your `path` and `serviceName` in the Ingress YAML are correct.



### 3. Understanding NetworkPolicies (The Firewall)
NetworkPolicies are "Default Allow" unless a policy selects a Pod. Once a Pod is selected, it becomes "Default Deny" for everything not explicitly allowed.

**Key Troubleshooting Tips:**
* **Isolation:** If a policy applies to a Pod, all traffic is blocked unless a rule allows it.
* **Add-on Support:** Not all Network add-ons support NetworkPolicy (e.g., **Flannel** does NOT, **Calico** DOES).
* **Check Existence:** Use `kubectl get netpol -A` to see if a policy is silently blocking your traffic.

---

### 4. Demo: Troubleshooting a Broken Service

Follow this flow to see how changing a label "breaks" access.

**Step 1: Create and Expose a Deployment**
```bash
kubectl create deploy trouble --image=nginx
kubectl expose deploy trouble --port=80 --type=NodePort
```

**Step 2: Verify Initial Access**
```Bash
# Get the endpoints (should show the Pod IP)
kubectl get endpoints trouble

# Get the NodePort
kubectl get svc trouble

# Test access (should work)
curl $(minikube ip):<NODEPORT>
```
**Step 3: Break the Connection**
Edit the Service and change the selector label to something non-existent (e.g., `app: wrong`).
```Bash
kubectl edit svc trouble
```
**Step 4: Verify the Failure**
```Bash
# Endpoints will now be <none>
kubectl get endpoints trouble

# Access will fail/timeout
curl $(minikube ip):<NODEPORT>
```

<h2 id="section-8-4">8.4 The Network Add-on (The Engine)</h2>

The <b>CNI (Container Network Interface)</b> is the engine under the hood.
- <b>Flannel:</b> Simple, but no NetworkPolicy support.
- <b>Calico:</b> High performance, supports NetworkPolicy and Ingress integration. <b>(Recommended for CKAD labs)</b>.
  
#### Summary Troubleshooting Workflow for Access
|Problem|Action|Command|
|-|-|-|
|No Endpoints|Check Selector/Labels|`kubectl get pods --show-labels`|
|Connection Refused|Check Container Port|`kubectl describe pod`|
|Connection Timeout|Check Network Policies|`kubectl get netpol -A`|
|Ingress 404|Check Ingress Rules|`kubectl describe ingress`|

<h2 id="section-8-4">8.4 Monitoring Cluster Event Logs</h2>

If `kubectl logs` shows nothing, you need to check the **Cluster Events**. Events are the "Security Cameras" of the mall, they record every movement, successful or failed, of the Kubernetes components.



1. The Global View
When you aren't sure which resource is failing, check the events for the entire namespace:
```bash
# General overview
kubectl get events #--sort-by='.lastTimestamp'|`.source.component`|`.involvedObject.name`|`.type` 

# Detailed overview (shows nodes and exact times)
kubectl get events -o wide
```

2. Filtering for "Crime Scenes"The event log can be noisy. To find actual problems quickly, filter for Warnings:
```Bash
kubectl get events | grep Warning
```
<b>Common Warning:</b> `Back-off restarting failed container` (This confirms a `CrashLoopBackOff`).
<b>Common Warning:</b> `FailedScheduling` (This confirms the Pod is stuck in `Pending` due to lack of resources).

3. Resource-Specific InvestigationWhile get events is great for a global view, if you already know which "Shop" (Pod/Node) is having trouble, use describe.Checking the Worker (Pod)
```Bash
kubectl describe pod <pod-name>
```

The events at the bottom will tell you exactly when the image was pulled and when the container started or failed.Checking the Foundation (Node)If multiple Pods are failing, the issue might be the Node itself (the "Mall Floor"):
```Bash
kubectl describe nodes minikube
```

Look for Conditions like MemoryPressure, DiskPressure, or PIDPressure. If these are True, the node is unhealthy.

<h2 id="section-8-5">8.5 Troubleshooting Summary: The Detective's Checklist</h2>

|Tool|Analogous To...|Best Used When...|
|-|-|-|
|kubectl logs|Interviewing the Worker|The Pod is running but the app inside is crashing.|
|kubectl get events|Security Camera Footage|You don't know which resource is causing the problem.|
|kubectl describe|Reading the Incident Report|You know the specific Pod/Node that is broken.|
|kubectl get endpoints|Checking the Guest List|The Pod is healthy but the Service can't find it.|

<h2 id="section-8-7">8.7 Troubleshooting Authentication Problems</h2>

If you cannot talk to the cluster at all, or if you get "Permission Denied" errors, the problem lies in your **Credentials** or **Permissions**.



### 1. The Kubeconfig File (The Master Key)
Access to the cluster is managed via the `~/.kube/config` file. 
* This file contains the API Server address, your certificates, and your current "context" (which mall you are visiting).
* In a standard setup, this is a copy of `/etc/kubernetes/admin.conf` from the Control Plane.

**Diagnostic Commands:**
```bash
# View your current keys and active cluster
kubectl config view

# Switch to a different context/user if you have multiple
kubectl config use-context <context-name>
```
### 2. Authorization: "What can I do?"
Once you are inside the mall, <b>RBAC (Role-Based Access Control)</b> determines which shops you can enter. While configuring RBAC isn't on the CKAD, <b>testing</b> your access is.

<b>The "Can-I" Command:</b> Use this to check if your current user has the "keys" to perform a specific action:

```Bash

# Check if you can create pods
kubectl auth can-i create pods

# Check if you can delete services in a specific namespace
kubectl auth can-i delete svc -n production
```
### 3. Demo: Recovering a Lost Key (Minikube)
If your `~/.kube/config` is deleted or corrupted, you can recover it from the Minikube node. Think of this as getting a master key copy from the Mall Manager's office.

Recovery Flow:

1. SSH into the Node: `minikube ssh`

2. Locate the Admin Config: The master copy is at `/etc/kubernetes/admin.conf`.

3. Move to Temporary Space:

```Bash
sudo cp /etc/kubernetes/admin.conf /tmp/admin.conf
sudo chmod 644 /tmp/admin.conf
```
4. Exit and Copy to Local Machine:

```Bash
scp -i $(minikube ssh-key) docker@$(minikube ip):/tmp/admin.conf ~/.kube/config
```
## 8.6 Using Probes (Health Checks)
#### 1. Understanding the Three Probe Types
Probes allow Kubernetes to perform "Self-Healing" by checking if your app is actually working, not just "running.". Probes are defined in pods.spec.containers.

- **Liveness Probe:** "Is the app alive?" If it fails, Kubernetes **restarts** the container.
- **Readiness Probe:** "Is the app ready for traffic?" If it fails, the Pod is **removed from the Service** until it becomes healthy again.
- **Startup Probe:** Used for slow-starting legacy apps. It disables liveness/readiness checks until the app is fully initialized.

#### 2. Probe Mechanisms (The "How")You can perform these checks using three methods:

|Method|Description|Example Use Case|
|-|-|-|
|exec|Runs a command inside the container. Success = exit code 0.|Checking if a specific file exists (like /tmp/ready).|
|httpGet|Performs an HTTP GET request. Success = 200-399.|Checking an /healthz or /readyz API endpoint.|
|tcpSocket|Checks if a TCP port is open.|Checking if a database or Nginx port (80) is listening.|

#### 3. Rebuilding the "Busybox-Ready" Demo
The lesson shows why a Pod might stay in 0/1 READY state even if it is Running.

##### Step A: The Manifest (`busybox-ready.yaml`)
```YAML

apiVersion: v1
kind: Pod
metadata:
  name: busybox-ready
spec:
  containers:
  - name: busybox
    image: busybox
    args: ['sh', '-c', 'sleep 3600']
    readinessProbe:
      exec:
        command:
        - cat
        - /tmp/nothing
      initialDelaySeconds: 5
      periodSeconds: 10
```
##### Step B: The Execution Flow
1. <b>Create:</b> `kubectl create -f busybox-ready.yaml`

2. <b>The Problem:</b> Running `kubectl get pods` shows `READY 0/1`.

     - Why? The probe is looking for `/tmp/nothing`, which doesn't exist yet.

3. <b>The Attempted Fix (Edit):</b> Running `kubectl edit pod busybox-ready` to change the path to `/etc/hosts` <b>fails</b>.

     - <i>Note:</i> Most probe parameters cannot be edited on a live Pod; you usually have to delete and recreate it.

4. <b>The Manual Fix:</b>

```Bash

kubectl exec busybox-ready -- touch /tmp/nothing
```
<b>The Result:</b> After a few seconds (defined by `periodSeconds`), `kubectl get pods` will show `1/1 READY`.

#### 4. Applying this to your Lab
In the <b>Nginx Canary transition</b>, you should add a Readiness probe to your Nginx Deployment. This prevents the "Canary" from receiving traffic if the ConfigMap isn't mounted correctly or the index.html is missing.

<b>Try this for your Nginx manifest:</b>

```YAML
readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 2
  periodSeconds: 5
```
---

## 8.6.1 Liveness Probe Lab 
Create a Busybox Pod that runs sleep 3600. Configure a Liveness Probe that checks if the file /etc/hosts exists.

**Step 1: Create the Manifest**
We use /etc/hosts because that file is created automatically by Kubernetes, so the probe should always succeed.

`vim livenessprobe.yaml`
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: busybox-probe-lab
  labels:
    test: liveness
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - /bin/sh
    - -c
    - sleep 3600
    livenessProbe:
      exec:
        command:
        - cat
        - /etc/hosts
      initialDelaySeconds: 5
      periodSeconds: 5
```
#### 1. Understanding the "Exec" Mechanism
When you define an `exec` probe, the Kubelet "reaches into" the container and runs the command you specified.

  - <b>InitialDelaySeconds (5):</b> The Kubelet waits 5 seconds after the container starts before doing the first check.
  
  - <b>PeriodSeconds (5):</b> The Kubelet repeats the check every 5 seconds.
  
  - <b>Success:</b> If `cat /etc/hosts` returns exit code 0, the Pod stays `Running`.
  
  - <b>Failure:</b> If the file were missing, the command would return a non-zero exit code, and the Kubelet would kill and restart the container.

#### 3. Execution & Verification
Follow these commands to verify the lab results:

**1. Apply the manifest:**

```Bash

kubectl apply -f livenessprobe.yaml
```
**2. Check the status:**

```Bash

kubectl get pods busybox-probe-lab
```
You should see `STATUS: Running` and `RESTARTS: 0`.

**3. Describe the Pod to see the Probe activity:**

```Bash

kubectl describe pod busybox-probe-lab
```
<i>Look at the "Events" section at the bottom. You should see no "Unhealthy" warnings.</i>

#### 4. Troubleshooting Scenario
**Let's simulate a failure in the lab:** If you want to see the probe actually work/fail, you can edit your YAML to look for a non-existent file:

```YAML

      exec:
        command:
        - cat
        - /tmp/nonexistent-file
```
After applying this, run `kubectl get pods -w`. You will eventually see the **RESTARTS** count increase because the Liveness probe is failing and forcing a restart.

## Essential Troubleshooting Toolkit
Use these commands in order when a problem arises:

```bash
# 1. Check high-level status
kubectl get pods

# 2. Look at the "History" of the Pod (Events are at the bottom)
kubectl describe pod <pod-name>

# 3. See current application logs
kubectl logs <pod-name>

# 4. See logs from the container that just crashed
kubectl logs <pod-name> --previous

# 5. Check Service-to-Pod connectivity
kubectl get endpoints <service-name>
```

[Back to Documentation](../README.md)
