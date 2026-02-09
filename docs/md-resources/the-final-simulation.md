## 10.0 The Final Simulation
This section transforms your knowledge into **Muscle Memory**. The exam isn't just about knowing Kubernetes; it's about navigating the mall under a 2-hour time limit.

### 10.1 The Environment Setup
To replicate the exam, you must clear the "Mall Floor":
1. **Reset:** `minikube delete`
2. **CNI Support:** `minikube start --cni=calico` (Essential for Task 8: NetworkPolicy).
3. **Verification:** `minikube status` should show "Running" and "Configured."

### 10.2 Task Themes & "Mall Manager" Focus
The exam covers 15 critical tasks that test your ability to build and fix components quickly:

* **Infrastructure:** Namespaces, Resource Quotas, and ServiceAccounts.
* **Application Design:** Sidecars, Liveness Probes, and multi-container Pods.
* **Networking:** Ingress routing, NetworkPolicy firewalls, and Service exposure.
* **Storage:** HostPath mounts and Persistent Volumes.
* **Advanced Deployment:** Canary 80/20 splits and Rolling Update tuning (`maxSurge`).

|Task|	Topic|	Key Goal|
|-|-|-|
|1	|Namespaces & Secrets|	Create namespace Indiana, Pod inpod, and Secret insecret.|
|2	|Label Filtering	|Write names of Pods with tier=control-plane to /tmp/task2pods.|
|3	|ConfigMaps	|Mount an index.html via ConfigMap to /usr/share/nginx/html/.|
|4	|Sidecars	|Pod sidepod with Nginx + a container running sleep 15.|
|5	|Probes	|Busybox Pod with a Liveness Probe checking the K8s Service.|
|6	|Deployments|	Rolling update (50% surge/available) -> Update -> Rollback.|
|7	|Ingress	|Expose via Service + Ingress for host myapp.info.|
|8	|NetworkPolicy|	Only allow Pods with type=tester to access type=webapp.|
|9	|Storage |(HostPath)	Mount Minikube's /webapp to Pod; expose via NodePort 32032.|
|10|	Helm	|Install bitnami/mysql chart.|
|11|	Resources|	Set Memory Request 64MiB and Limit 128MiB in namespace nebraska.|
|12|	Canary	|80/20 traffic split between oldbird and newbird using labels.|
|13|	SecurityContext|	No privilege escalation + Supplemental GID 2000.|
|14|	Docker/OCI	|Build image myapp:1.0 and export to /tmp/myapp.tar.|
|15|	ServiceAccounts|	Create SA secure and link it to Pod securepod in oklahoma.|
---
### 10.2.1 
This specific task is a classic CKAD challenge because it tests your ability to manage **Namespaces**, **Secrets**, and **Pod Environment Variables** all in one go.

# Task 1 - Namespaces & Secrets
  1. **Create the Namespace**
```Bash
kubectl create ns indiana
```
  2. **Create the Secret**

Create it directly from the command line.
```Bash
kubectl create secret generic insecret --from-literal=COLOR=blue -n indiana
```

  3. **Create the Deployment (Imperative)**
Create the deployment without a YAML file first.

```Bash
kubectl create deploy indeploy --image=nginx:latest -n indiana
```

  4. **Attach the Secret (The "Fast" Way)**
Instead of opening vim and typing out valueFrom and secretKeyRef, use this single command:

```Bash
kubectl set env --from=secret/insecret deployment/indeploy -n indiana
```
**What this does:** It automatically updates the Deployment's template. Kubernetes will trigger a rolling update, and every new Pod will now have the environment variables from that Secret.

**How to Verify (Fast)**
Don't waste time opening a shell (exec) unless the task specifically asks you to. You can verify the configuration has been applied to the deployment directly:

```Bash
kubectl describe deploy indeploy -n indiana | grep -A 5 Environment
```
<i>You should see `COLOR` sourced from `insecret`.</i>

To verify that your Pod is actually using the Secret to define the variable, you need to check **inside** the running container. While kubectl describe shows that the link exists, only exec proves the value is there.

Run this command to print the environment variable directly from the container's shell:

```Bash
kubectl exec -n indiana pod/indeploy-7dd88896fb-hlpdj -- printenv COLOR
```
**Expected Output:** `blue`

---

# Task 2 - Label Filtering
This task tests your ability to filter resources and manipulate text output, which is a frequent requirement in the CKAD exam.

Here the quickest way:
```shell
kubectl get pods -A -l tier=control-plane --no-headers  | awk '{print $2}' > /tmp/task2pods
```
---
# Task 3 - ConfigMaps
This task is a classic CKAD objective: Decoupling configuration from the application.

**Step A: Create the File and CM**
```Bash
echo "welcome to the task 3 webserver" > index.html
kubectl create cm task3cm --from-file=index.html
```
**Step B: Generate the Pod YAML (The "Dry-Run" Trick)**
Don't copy-paste from the web if you can avoid it. Use this:

```Bash
kubectl run oregonpod --image=nginx:latest --dry-run=client -o yaml > task3.yaml
```
**Step C: Quick Edit**
Open `task3.yaml` and add the `volumes` and `volumeMounts`. **Note:** Ensure you mount to the exact directory Nginx uses for its default page.

**2. Refined YAML (The Final Result)**
```YAML
apiVersion: v1
kind: Pod
metadata:
  name: oregonpod
spec:
  containers:
  - name: nginx-container
    image: nginx:latest
    volumeMounts:
    - name: config-volume
      mountPath: /usr/share/nginx/html  # This replaces the default index.html
  volumes:
  - name: config-volume
    configMap:
      name: task3cm
```
**3. The "Gotcha": Directory Overwriting**
In your current YAML, mounting the ConfigMap to `/usr/share/nginx/html` will **hide everything else** in that folder.

  - **Standard Nginx Behavior:** The folder usually contains index.html and 50x.html.

  - **Mount Behavior:** Because you mounted the volume at the **directory** level, the container will only see `index.html` (from your CM). This is fine for this task, but if the exam asks you to "add a file to an existing directory without deleting others," you must use a `subPath`.

**4. Verification (The Last 10% of the Task)**
In the exam, always verify. Since it's a webserver, you can verify from inside the pod:

```Bash
# Verify the file content
kubectl exec oregonpod -- cat /usr/share/nginx/html/index.html

# Verify the webserver is actually serving it
kubectl exec oregonpod -- curl -s localhost
```
---
# Task 4 - 4th Edition of the CKAD: Native Sidecar support
Create a Pod with the name “sidepod”. It should run the nginx:latest image
together with a sidecar container that runs the sleep 15 command.
```shell
kubectl run sidepod --image=nginx:latest --dry-run=client -o yaml > task4.yaml
```
**Pro-Tip for generating this fast:**
Instead of typing it all out, use the `--` flag in `kubectl run`. It separates the image from the command and arguments automatically:

**This command will generate the YAML for you with the correct structure!** It usually puts them all into the `args` field or a single `command` field depending on the K8s version, but it is guaranteed to be valid YAML.
```Bash

kubectl run sidepod --image=nginx:latest --dry-run=client -o yaml -- /bin/sh -c "sleep 15"
```
Edit the yaml and put the sidecar in the initContainers section with restartPolicy: Always, Kubernetes expects it to run forever **(Native Sidecars) **.

Tips: you can copy and fix it from the `kubernetes.io`.
```shell
vim task4.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: sidepod
spec:
  containers:
  - image: nginx:latest
    name: sidepod
    resources: {}
  initContainers:
  - name: sidecar
    image: alpine:latest
    restartPolicy: Always
    command: ["/bin/sh", "-c", "sleep 15"]
  restartPolicy: Always
```
After applying, run: `kubectl get pod sidepod -w` (The -w stands for watch).
```shell
k apply -f task4.yaml
```
If you see the Pod stay at `2/2` for 15 seconds and then drop to `1/2`, you have successfully executed the `sleep 15` command as requested.
```
k get pod sidepod -w
```
---
# Task 5 - Probes
Here is exactly how you should build it to satisfy the exam requirements:

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: probepod
  namespace: probes      # Requirement 1: Namespace
spec:
  containers:
  - name: busybox
    image: busybox       # Requirement 2: Image
    args: 
    - /bin/sh
    - -c
    - "sleep infinity"   # Requirement 3: Command
    livenessProbe:       # Requirement 4: Liveness Probe
      httpGet:           # Because the task said "endpoint"
        path: /healthz   # The specific endpoint name
        port: 80         # Standard port for health checks
      initialDelaySeconds: 3
      periodSeconds: 5
```

**1. Create the namespace:**

```Bash
kubectl create ns probes
```
**2. Create the file:** Copy the code above into a file named `task5.yaml`.

**Apply it:**

```Bash
kubectl apply -f task5.yaml
```
**What to expect when you verify:**

If you run `kubectl describe pod probepod -n probes`, you will see that the probe is **failing** (because Busybox isn't a web server).

**Don't worry!** In a CKAD exam, if the instructions say "Configure an HTTP probe for /healthz," you get the points for **configuring it correctly**, even if the application inside the pod isn't actually set up to answer that call. The examiner is testing your **Kubernetes skills**, not your web development skills.

---
# Task 6 - Deployments

**1. Pro-Tip:** The "One-Liner" Creation
**Generate the base:**
```Bash
kubectl create deploy updates --image=nginx:1.17 --replicas=3 
```
**2. Add labels** during creation to save time:
```Bash
# Then add the specific label required:
kubectl label deploy updates type=prod
```
**3. Let's use dry-run to generate the** YAML and then edited it to change image version and add the strategy. This is the safest way. 
```
kubectl create deploy updates --image=nginx:latest --replicas=3 --dry-run=client -o yaml > task6.yaml
```
**4. Edit and adding Strategy**
To add the "Strategy" snippet from the official documentation to your workflow, you can reference the section titled **"Strategy"** under the Deployment concept page.

In the CKAD exam, searching for "Deployment" and then using **Ctrl+F** to find `strategy` is the fastest way to get this exact block.

Copy the right snippet from the **Official Documentation Snippet** on [kubernetes.io](https://www.kubernetes.io/), paste it and apply `task6.yaml`:
```shell
vim task6.yaml
k apply task6.yaml
```
**What about that "Warning"?**
The warning after apply is about the missing annotation happens because you originally created the deployment using kubectl create and are now trying to update it using kubectl apply.

**In the Exam:** You can ignore this warning. It just means Kubernetes is adding a "tracking note" to the deployment so it can manage future changes. It won't stop your deployment from working!

**5. Tracking history**
Before you ran `kubectl rollout undo`, it’s often helpful to see the **Revision History**. If the exam asks you to "rollback to a specific version" (e.g., version 1), you need to know the revision number.

```Bash
kubectl rollout history deploy/updates
```
In the exam you might see `<none>` and wonder if you did something wrong. You didn't! This column only fills up if you use the `--record` flag (which is being deprecated) or if you add an annotation manually.
```bash
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
```
**Pro-Tip for the Exam:** If the task asks you to "Record the change," you can add a note like this:
```Bash
kubectl annotate deployment updates kubernetes.io/change-cause="Updating to latest nginx"
```

**6. If you need to go back to a specific revision (like Revision 1):**

```Bash
kubectl rollout undo deploy/updates --to-revision=1
```
**7. Verification Check**
After your rollback, you saw the ReplicaSet hash change back.
  - updates-646bc8d9c9 (The "latest" version) went to 0.
  - updates-5856644c8c (The "1.17" version) went back to 3.

**One Final Verification (The "CKAD Safety Check")**
In the exam, before moving to the next question, always do a quick check to ensure the image is what you expect. Since you rolled back to Revision 1, the image should be **nginx:1.17**.

Run this to be sure:
```Bash
kubectl describe deploy updates | grep Image
```
---
# Task 7 - Ingress, Exposing Applications

## Objectives
- Map a custom domain to the Minikube IP.
- Expose the 'updates' Deployment via a Service.
- Configure Ingress to route external traffic to the Service.

---

## Step 1: Identify the Entry Point (The Mall Address)   
Map the Minikube IP to the domain `myapp.info` so the local machine knows where to send requests.
   
```bash
# Get Minikube IP
minikube ip 

# Add to hosts file (Assuming IP is 192.168.49.2)
sudo vi /etc/hosts
# Add line: 192.168.49.2  myapp.info
```

## Step 2. Create the Storefront (The Service)
Expose the Deployment internally. This creates a stable "Front Door" for the pods.

```Bash
kubectl expose deploy updates --name=task7svc --port=80
```

## Step 3. Prepare the Mall (Enable Ingress)
Minikube requires the Ingress addon to be enabled to process Ingress rules.

```Bash
minikube addons enable ingress
```

## Step 4. Create the Directory Rule (The Ingress)
Create the rule that routes `myapp.info` traffic to the `task7svc` Service.

```Bash
kubectl create ing myapp --rule="myapp.info/=task7svc:80"
```

## Step 5a: Verification
Test the full chain: **User -> Ingress -> Service -> Pod**.

```Bash
curl myapp.info
```
## Step 5b: Verification Strategies (The "No-Hosts-File" Way)
In the exam, you don't have time to edit `/etc/hosts`. Use these methods instead:

**Strategy A: The Host Header (Best for Ingress)**
This tells the Ingress controller which "Store" you want without needing DNS.
```Bash
# curl -H "Host: <Domain>" <Ingress_IP>
curl -H "Host: myapp.info" $(minikube ip)
```
<i>Expected Output: HTML source for the Nginx welcome page.</i>

**Strategy B: Internal Pod Test (Best for Service)**
Check if the "Storefront" is working by calling it from another "Store" (Pod) inside the mall.

```Bash
kubectl run test-pod --image=busybox -it --rm -- restart=Never -- wget -q- task7svc
```
**Strategy C: Endpoint Check (The "Quick Look")**
Verify that the Service has successfully found its Pods. If **ENDPOINTS** is empty, the traffic has nowhere to go.
```Bash
kubectl get ep task7svc
```
### CKAD Exam Tip
If the `curl` command returns a **404**, it usually means the Ingress rule is correct, but the **Host Header** doesn't match what you defined in the YAML. Always double-check that `myapp.info` is spelled exactly the same in your rule and your `curl` command.

---
### 3. Key Takeaways for the CKAD Exam

1.  **Ingress Class:** In your lab, Minikube automatically handles the class. In the exam, you might need to add `--class=nginx` to your `kubectl create ing` command if multiple controllers exist.
2.  **Path Types:** When using `kubectl create ing`, the default path type is usually `Prefix`. If the exam asks for an "Exact" match, you'll need to edit the YAML.
3.  **The "Curl" Test:** If `curl myapp.info` fails but `curl <MINIKUBE_IP>` works, the issue is your `/etc/hosts`. If both fail, check `kubectl get pods` to ensure the workers are actually running!
---

# Task 8: Managing NetworkPolicy (The Mall Bouncer)

### 8.1 The Security Guard at the Door (NetworkPolicy)
|CONCEPT|RESOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The VIP Store**|**Pod (nevaginx)**|The High-End Boutique|The application we are trying to protect.|
|**The Store Sign**|	**Service (ClusterIP)**|	The Boutique Signage	| Allows other pods to find the store by name.|
|**The VIP Badge**|**Label (type=tester)**|The "Security Clearance"| Badge|The specific metadata required to pass the security check.|
|**The Bouncer**|**NetworkPolicy**|The Bouncer at the Store Door|The rule that says: "No badge, no entry."|

### 8.2 The "Bouncer" Workflow (Task 8 Walkthrough)
**1. Open the Boutique (Create the Pod)** You started by opening the store and giving it a name.
- **Command:** `kubectl run nevaginx --image=nginx:latest --labels="type=webapp"`
- **Analogy:** You open the "NevaGinx" boutique and give it a "Web App" category sign.

**2. Hang the Store Sign (Create the Service) — CRITICAL STEP** If you don't do this, other pods will get a `bad address` error.

**Command:** `kubectl expose pod nevaginx --port=80`

**Analogy:** You put "NevaGinx" in the Mall Directory so people can look up the room number.

**3. Building & Hiring the Bouncer (Create the NetworkPolicy)** You create the rulebook (YAML) and hire the guard to stand at the door. 

**The YAML Rule:**
```YAML
spec:
  podSelector:
    matchLabels:
      type: webapp  # Target this store
  ingress:
  - from:
    - podSelector:
          type: tester # Only allow this badge
        matchLabels:
```
When building a NetworkPolicy, think of it in three parts: **Who am I protecting?**, **What type of traffic?**, and **Who is allowed in?**

```YAML

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy  # The name of our "Bouncer"
  namespace: default         # The Mall location
spec:
  # 1. WHO AM I PROTECTING? (The Target)
  podSelector:
    matchLabels:
      type: webapp           # Apply this rule to the 'nevaginx' pod
      
  # 2. WHAT DIRECTION?
  policyTypes:
  - Ingress                  # We are controlling "Incoming" traffic
  
  # 3. WHO IS ALLOWED IN? (The Whitelist)
  ingress:
  - from:
    - podSelector:
        matchLabels:
          type: tester       # Only pods with this badge get through
```

**Command:** `kubectl apply -f task8.yaml`

**Analogy:** The Bouncer stands at the "Web App" door with a clipboard: "Only people wearing a **'Tester'** badge can enter."

**CKAD Exam Tip:** If you forget the syntax, use `kubectl explain networkpolicy.spec` to see the fields, and always run kubectl get pod --show-labels to verify your spelling before applying the YAML.

**4. The Shopper Arrives (Create the Tester Pod)** Now you bring in the second worker, but they don't have a badge yet.

**Command:** `kubectl run nevatest --image=busybox -- sleep infinity`

**Analogy:** A shopper named nevatest walks into the mall without a badge.

**5. The Unauthorized Guest (The Initial Failure)** You tried to enter from the nevatest pod, but it didn't have a badge yet.
- **Command:** `kubectl exec -it nevatest -- wget --spider nevaginx`
- **Result:** `download timed out`
- **Analogy:** Because of the Service (Step 2), the shopper finds the door. But because of the Bouncer (Step 3), they are ignored and eventually give up (Timeout).

**6. Handing out the Badge (Labeling the Pod)** You gave the shopper the correct security clearance.
- **Command:** `kubectl label pod nevatest type=tester`
- **Analogy:** You pin a **"Tester"** badge onto the shopper's lapel.

**7. Successful Entry (The Verification)** Now that the badge matches the Bouncer's clipboard, the connection is allowed.
- **Command:** `kubectl exec -it nevatest -- wget --spider nevaginx`
- **Result:** `remote file exists`
- **Analogy:** The Bouncer sees the "Tester" badge, steps aside, and lets the shopper into the boutique.

### Troubleshooting Cheat Sheet
|IF YOU SEE...|IT MEANS...|ANALOGY|
|-|-|-|
|bad address|**Missing Service**. The name doesn't exist.|The store isn't in the Mall Directory.|
|download timed out|**NetworkPolicy is blocking.** The packet was dropped.|The Bouncer is ignoring you.
|connection refused|**Pod is down or wrong port.**|You found the door, but the store is closed.|

---
# Task 9: Using Storage (The Basement Locker)

In our Mall analogy, this is like renting a storage locker in the basement of the mall building and connecting it directly to your store shelf.

## 9.1 The Storage & Side Door Characters
|CONCEPT|RESOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The Basement Locker**|**HostPath**|A storage unit in the building's basement.|Storage located on the actual physical node (host).|
|**The Shelf**|**VolumeMount**|The shelf inside your boutique.|Where the storage is "attached" inside the container.|
|**The Side Door**|**NodePort**|A specific side entrance for the public.|Exposes the service on a specific port (30000-32767) of the Node IP.|

## 9.2 The "Storage" Workflow (Task 9 Walkthrough)
1. **Stocking the Basement (Minikube SSH)** 

    Before the store opens, you put the inventory in the building's basement.

    **- Commands:** 
 
      `minikube ssh`

      `sudo mkdir /webapp`
     
      `sudo sh -c "echo welcome to the store > /webapp/index.html"`
     
      `exit` 
    
    **- Analogy:** You go into the mall's basement, build a crate (`/webapp`), and put a "Welcome" sign inside it.

2. **Building the Store with a Chute (The Pod YAML)** You build your store (`storepod`) and create a "delivery chute" (Volume) that connects your shelf directly to that basement crate.
**How to build this quickly (Exam Strategy):** Search the Kubernetes Documentation for `hostPath` to find a template. Ensure `volumes` and `containers` are siblings under `spec`.

  - **The YAML Build** (`task9.yaml`):

```YAML

apiVersion: v1
kind: Pod
metadata:
  name: storepod
spec:
  containers:
  - name: nginx
    image: nginx:latest
    volumeMounts:
    - name: store-volume
      mountPath: /usr/share/nginx/html # The Shelf
  volumes:
  - name: store-volume
    hostPath:
      path: /webapp # The Basement Locker
```

**Analogy:** You tell the construction crew: "Mount the shelf in the display window (`/usr/share/nginx/html`) so it pulls whatever is in the basement crate (`/webapp`)."

3. **Labeling and Hanging the Side Door (Service & NodePort)** You need a specific entrance so customers can visit using a special port number.

  - **Commands:**
    - ```kubectl apply -f task9.yaml```
    - ```kubectl label pod storepod type=storage``` **(The Badge)**
    - ```kubectl expose pod storepod --port=80``` **(The Sign)**
    - ```kubectl edit svc storepod``` (Changing to ` nodePort: 32032`)

  - **Analogy:** You assign the store a "Storage" category, hang the sign, and then tell the Mall Manager: "I want a special side entrance at Door #32032."

## 9.3 The "Service Edit" Hack
While `kubectl edit` works, generating a file is often safer for complex tasks. Use the **Dry Run** command to create a template instantly:

  - **The Command:**
    ```Bash
    kubectl expose pod storepod --port=80 --type=NodePort --dry-run=client -o yaml > svc.yaml
    ```
    **The Edit:** Open `svc.yaml` and simply add the `nodePort` line:

    ```YAML
    spec:
      ports:
      - port: 80
        protocol: TCP
        targetPort: 80
        nodePort: 32032  # Add this line specifically!
    ```

## 9.4 Pro-Tips for the CKAD Exam
  - **Indentation Check:** YAML is very sensitive. A common mistake is putting the `volumes:` block inside the `containers:` list.
      
      **Remember:** `containers` and `volumes` are **siblings**, they both live directly under the `spec:` key.

  - **Empty Directory / 403 Forbidden:** If you see the default Nginx page or an error, check your `mountPath`. Mounting a volume to `/usr/share/nginx/html` hides the original Nginx files. If your host directory is empty, your store shelf will be empty!

  - **Verification:** Always test your work with `curl $(minikube ip):32032` to ensure the "Welcome" sign is visible from the outside.

---

# Task 10: Using Helm (The Franchise Package)
In our Mall analogy, Helm is the "**Store-in-a-Box**" service. Instead of hiring every contractor yourself to build walls, floors, and wiring, you just call a provider and say, "Send me a fully furnished Pizza Hut," and they deliver the whole thing ready to go.

## 10.1 The Helm Characters
|CONCEPTRE|SOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The Catalog**|**Helm Repo**|A Franchise Directory|A repository containing various pre-configured apps.|
|**The Blueprint**|**Helm Chart**|The Franchise Manual|A bundle of YAML files that define how an app is built.|
|**The Franchise**|**Helm Release**|A specific store location|A specific instance of a chart running in your cluster.|

## 10.2 The "Franchise" Workflow (Task 10 Walkthrough)
1. **Finding the Franchise Provider (Helm Repo Add)** Before you can install a specific store, you have to add the provider to your directory.

  - **Command:** `helm repo add bitnami https://charts.bitnami.com/bitnami`
  - **Analogy:** You add "Bitnami Franchises" to your mall's approved vendor list.
2. **Ordering the Store-in-a-Box (Helm Install)** You order a MySQL "store" and tell the system to give it a name automatically.
**Command:** `helm install bitnami/mysql --generate-name`
**Analogy:** You call Bitnami and say, "Deliver one MySQL store and just give it whatever tracking number (name) is available."
3. **The Grand Opening (Verification)** Because Helm is a "package deal," it doesn't just create a Pod. It creates the Manager (Deployment), the Workers (Pods), and the Signage (Services) all at once.
Command: `kubectl get all`
Result: You see `pod/mysql-xxxxx` and `service/mysql-xxxxx` appearing instantly.
Analogy: You look at the mall map and notice that a fully staffed store with a sign and workers has appeared out of nowhere!

## 10.3 Pro-Tips for Helm in the CKAD Exam
1. **Search First:** If the exam asks for a package but you aren't sure of the name, use `helm search repo mysql`. It's like checking the table of contents in the franchise directory.
2. **Naming:** If the exam asks for a specific name (e.g., "mydb"), the command is `helm install mydb bitnami/mysql`. Only use `--generate-name` if explicitly told to.
3. **The "Init" Status:** In your lab results, you saw `STATUS: Init:0/1`.
  - Analogy: The workers are inside the store setting up the kitchen equipment before they can open for business. Just wait a minute, and it will change to **Running**.

## 10.4 Diagnostic Cheat Sheet for Helm
|COMMAND|ANALOGY|PURPOSE|
|-|-|-|
|`helm list`|"Show all franchises"|See which Helm apps are currently running.|
|`helm uninstall [name]`|"Close the franchise"|Removes every resource (Pods, Services, etc.) created by that chart.|
|`helm status [name]`|"Check store health"|Shows the instructions and connection info for that specific app.|

---

# Task 11: Resource Restrictions (The Lease Agreement)
In our Mall analogy, this is the "**Lease Agreement.**" The Mall Manager (Kubernetes) needs to know how much physical space (Memory/CPU) your store will take up so the building doesn't run out of electricity or floor space.

### 11.1 The Resource Characters
|CONCEPT|RESOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The New Wing**|**Namespace**|A new section of the Mall|A logical partition to group related resources.|
|**The Minimum Rent**|**Requests**|The guaranteed floor space|The minimum amount of resources K8s guarantees to the Pod.|
|**The Maximum SpaceLimits**|**The maximum shop size**|The hard ceiling. If the shop tries to expand past this, it gets shut down.|

### 11.2 The "Resource" Workflow (Task 11 Walkthrough)
1. **Building the New Wing (Create Namespace)** Before opening the store, you define which part of the mall it belongs to.
  - **Command:** `kubectl create ns nebraska`
  - **Analogy:** You open a new wing of the mall called "Nebraska."

2. **Hiring the Manager (Create Deployment)** You hire a manager to run the "Snow" shop in the Nebraska wing.
  - **Command:** `kubectl create deploy snowdeploy -n nebraska --image=nginx`
  - **Analogy:** You hire a manager (`Deployment`) to set up a boutique (`Pod`) in the Nebraska wing.

3. **The "Help" Strategy (Finding the Template)** Instead of typing the command from memory, you used the built-in manual to find a working example.
  - **Action:** `kubectl set resources -h | less`
  - **Analogy:** You check the Mall’s "Standard Lease Terms" book to find the correct phrasing for a space restriction.
  ```
    # Set the resource request and limits for all containers in nginx
    kubectl set resources deployment nginx --limits=cpu=200m,memory=512Mi --requests=cpu=100m,memory=256Mi
  ```

4. **Signing the Lease (Set Resources)** You define exactly how much "power and space" the shop is allowed to use.
  - **Command:** ```kubectl set resources -n nebraska deploy snowdeploy --limits=memory=128Mi --requests=memory=64Mi```
  - **Analogy:** You tell the manager: "You are guaranteed 64sqm of space (`Request`), but under no circumstances can you occupy more than 128sqm (`Limit`)."

### 11.3 Pro-Tips for the CKAD Exam
1. **Don't Type It, Generate It:** Use `kubectl set resources` as you did in the lab. It is much faster and less error-prone than manually editing YAML.
2. **Verify with Describe:** Always check your work with `kubectl describe deploy snowdeploy -n nebraska`. Look for the **Pod Template** section to see if the Limits and Requests were applied correctly.
3. ***The "OOMKilled" Ghost:* * Analogy:** If your store tries to pack in more inventory than the 128Mi limit allows, the Mall Security will suddenly close the shop.
   -  **Kubernetes**: The Pod will crash with an **OOMKilled** (Out Of Memory) error.

### 11.4 Diagnostic Cheat Sheet
|COMMAND|PURPOSE|
|-|-|
|`kubectl top pod -n nebraska`|See how much "electricity" (RAM/CPU) the shop is actually using right now.|
|`kubectl describe node`|See how much total space is left in the entire Mall.|

---
# Task 12: Creating Canary Deployments (The Taste Test)
**The Canary Deployment.** In our Mall analogy, this is the "**Taste Test.**" You aren't ready to change the whole menu yet, so you keep 4 chefs cooking the old recipe and bring in 1 chef cooking the new one. The customers walk up to the same counter and get whichever chef is free.

### 12.1 The Canary Characters
|CONCEPT|RESOURCE|MALL ANALOGY|ROLE IN KUBERNETES|
|-|-|-|-|
|**The Aviary**|**Namespace (birds)**|A themed wing of the mall|Isolates the bird shop resources.|
|**The Veteran Staff**|**Deployment (oldbird)**|4 Chefs using the old recipe|The stable, existing version (v1.17).|
|**The New Recruit**|**Deployment (newbird)**|1 Chef using the new recipe|The "Canary" version (latest).|
|**The Shared Counter**|**Service (allbirds)**|One unified ordering desk|Routes traffic to any chef with the `type=allbirds` badge.|

### 12.2 The "Canary" Workflow (Task 12 Walkthrough)
1. **Building the Aviary (Create Namespace)**
  - **Command:** `kubectl create ns birds`
2. **Drafting the Blueprints (Dry Run to YAML)** Instead of typing from scratch, you generate the base files to edit them.
  - **Command:** 
    - `kubectl -n birds create deploy oldbird --image=nginx:1.17 --dry-run=client -o yaml > oldbird.yaml`
    - `kubectl -n birds create deploy newbird --image=nginx:latest --dry-run=client -o yaml > newbird.yaml`
3. **YAML Surgery (The "Shared Badge" Labeling)** To make the Canary work, you must manually add the `type: allbirds` label to the **Pod Template** in both files. This allows one Service to find both Deployments.
  - Editing **oldbird.yaml**:
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: oldbird
    namespace: birds
    labels:
      app: oldbird
      type: allbirds  # Add this!
  spec:
    template:
      metadata:
        labels:
          app: oldbird
          type: allbirds  # AND Add this!
      spec:
        containers:
        - image: nginx:1.17
          name: nginx
  ```
   - **Editing** `newbird.yaml`: (Repeat the same process, ensuring `type: allbirds` is added to the metadata and template labels, while keeping the image as `nginx:latest`).
  4. **Hiring the Staff (Apply the Files)**
  - **Command:** 
    ```
      kubectl apply -f oldbird.yaml -n birds
      kubectl apply -f newbird.yaml -n birds
    ```
   5. **Setting up the Shared Counter (The Service)** You create a Service that ignores the "app" name and only looks for the "type" badge.
   - **Command:** `kubectl -n birds expose deploy oldbird --name=allbirds --selector type=allbirds --type=NodePort --port=80`
   - **The Edit:** Use `kubectl edit svc allbirds -n birds` to set `nodePort: 32323`.
   6. **The 80/20 Split (Scaling)**
  - **Command:** `kubectl scale -n birds deploy oldbird --replicas=4`
  - **Analogy:** With 4 `oldbird` pods and 1 `newbird` pod all sharing the `type: allbirds` label, the service naturally sends 80% of traffic to the old version.
  
### 12.3 Pro-Tip: The "Metadata vs. Template" Trap
In the CKAD exam, remember that the Service looks at the labels on the **Pod**, not the Deployment.
  - **Deployment Labels:** These are for the Mall Manager's filing cabinet.
  - **Template Labels:** These are the actual "Badges" pinned to the workers. **Crucial:** Ensure type: allbirds is inside the spec.template.metadata.labels section!

### 12.4 Diagnostic Tip: Is the Split Working?
If you want to see the **80/20 split in action**, run a loop from your `pod/newbird-7bf6b8f57f-84whm` pod:`for i in {1..20}; do curl -sI allbirds | grep -i "Server"; done | sort | uniq -c`. 
You should see: 
```
  17 Server: nginx/1.17.10
  3 Server: nginx/1.29.4
```
---
# Task 13: securityContext
**The Mall Analogy:** The "High-Security Boutique" 
In our mall, most shops have general rules. But for the **"SecuredPod" Boutique**, the Mall Manager has issued very specific security mandates for the staff (containers) working there.

### 1. The Supplemental Group (The "Staff ID Badge")
  - **The Rule:** `supplementalGroups: [2000]`
  - **The Analogy:** Every staff member in this shop belongs to a specific "Security Guild" (Group ID 2000). This badge gives them extra access to shared mall resources (like the loading dock or a shared safe) that other shops can't touch.
  - **Where it lives:** This is a **Pod-level** rule. It applies to everyone inside the shop.
### 1. No Privilege Escalation (The "No Master Key" Rule)
  - **The Rule:** `allowPrivilegeEscalation: false`
  - **The Analogy:** Even if a staff member finds a way to open a locked drawer, they are strictly forbidden from becoming "Mall Security" (root). They cannot gain more power than they were given on their first day.
  - **Where it lives:** This is a **Container-level** rule. It applies specifically to the individual worker at the counter.

### The "Blueprint" (YAML Construction)
Here is how we translate the Mall Manager's mandates into a valid Kubernetes YAML:

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: securedpod
spec:
  # POD LEVEL SECURITY (The Shop Rules)
  securityContext:
    supplementalGroups: [2000]
  containers:
  - name: nginx
    image: nginx:latest
    # CONTAINER LEVEL SECURITY (The Worker Rules)
    securityContext:
      allowPrivilegeEscalation: false
```

### Step-by-Step Lab Execution
Follow these commands to build and verify your secured shop:

**Step 1: Generate the base blueprint**
```Bash
mk -- -n securitycontext run securedpod --image=nginx --dry-run=client -o yaml > task13.yaml
```
**Step 2: Edit the security settings**
Open `task13.yaml` and ensure it looks like the block above. Notice the distinction:
  - `spec.securityContext`: For the `supplementalGroups`.
  - `spec.containers[].securityContext`: For `allowPrivilegeEscalation`.

**Step 3: Open the shop**
```Bash
mk -- create ns securitycontext
mk -- apply -f task13.yaml -n securitycontext
```
**Step 4: Inspect the "Security Clearance"**
Once the pod is running, verify the group ID is active by "talking" to the worker:
```Bash
mk -- exec securedpod -- id
```
The Goal: You should see `groups=... 2000` in the output!
---
# Task 14: Docker/OCI
This task shifts us from the **Mall Manager** (Kubernetes) to the **Factory Floor** (Docker).

## The Mall Analogy: The "Custom Vending Machine" 
Imagine you want to set up a very specific vending machine in the mall. You can't just buy a standard one; you need to **build** it yourself according to a secret recipe and then **package** it so it can be shipped to other malls.

### 1. The Secret Recipe (The Dockerfile)
  - **The Concept:** You find the manual (`Dockerfile`) in the back office (`Git repository`). It tells you exactly what goes into the machine: a base frame (`FROM alpine`), a workspace (`WORKDIR /mydata`), and a specialized timer (`COPY countdown`).
  - **The Action:** docker build -t myapp:1.0 .
  - **Analogy:** You follow the manual to assemble the vending machine and name the model **"myapp:1.0"**.
### 1. The Shipping Crate (The Tar File)
  - **The Concept:** Now that the machine is built, you need to put it in a wooden crate (`.tar`) so the delivery truck can move it.
  - **The Action:** `docker save myapp:1.0 > /tmp/myapp.tar`
  - **Analogy:** You "freeze" the machine's state and slide it into a crate labeled `/tmp/myapp.tar`.

### Step-by-Step Lab Execution
**Step 1: Find Secret Recipe**

``` Dockerfile ```
```
# 1. The Base Frame (Lightweight Linux)
FROM alpine

# 2. The Designer Label (Metadata)
LABEL Sander=<mail@sandervanvugt.nl>

# 3. The Storage Bin (Persistent mount point)
VOLUME /mydata

# 4. The Workspace (Changing directory)
WORKDIR /mydata

# 5. Adding the Tool (Copying the script from your laptop to the machine)
COPY countdown .

# 6. The Core Mission (The command that CANNOT be easily changed)
ENTRYPOINT ["./countdown"]

# 7. The Default Setting (The number of seconds, which CAN be changed)
CMD ["1000"]
```
**Step 2: Build the Machine (The Image)**
You want to make sure the mall's factory knows about this image.

```Bash
docker build -t myapp:1.0 .
```
**CKAD Tip:** If the exam asks you to make the image available to the cluster without a registry, you might need to use minikube image load myapp:1.0 or point your shell to the minikube docker-env.

**Step 3: Package for Shipping (The OCI Tar)**
The requirement says it must be **OCI compliant**. Modern `docker save` does this by default, but to be safe and clear, we use the redirection or the `-o` (output) flag.

```Bash
docker save myapp:1.0 -o /tmp/myapp.tar
```
**Step 4: Verify the Crate**
Just like you did in your terminal, check that the file exists and is a valid archive:
```Bash
file /tmp/myapp.tar
# Result should be: POSIX tar archive
```
---
# Task 15 The Mall Analogy: The "Security Badge": Service Account 💳🏢
In our mall, most workers are "temporary" and don't have access to the Mall Manager's office. However, some shops need to talk to the office to check inventory or mall schedules.

### 1. The Membership (The ServiceAccount)
  - **The Concept:** You create a special "Security Badge" named `secure` in the `oklahoma` wing of the mall.
  - **The Action:** `kubectl create sa secure -n oklahoma`
  - **Analogy:** You register a new identity in the mall's database. This badge doesn't do anything yet, but it’s ready to be worn.
### 1. The Worker Wearing the Badge (The Pod)
  - **The Concept:** You tell the `securepod` worker that they must wear the `secure` badge while they are on the clock.
  - **The Action:** `serviceAccountName: secure` (inside the Pod spec).
  - **Analogy:** When the worker shows up for their shift, the Mall Manager sees their badge and knows exactly who they are and what they are allowed to touch.

**Step-by-Step Lab Execution**
### Step 1: Prepare the "Mall Wing" (Namespace)
```Bash
mk -- create ns oklahoma
```
### Step 2: Create the "Badge" (ServiceAccount)
```Bash
mk -- create sa secure -n oklahoma
```
### Step 3: Create the "Blueprint" (YAML)
Generate the base Pod file:
```Bash
mk -- run securepod --image=nginx --dry-run=client -o yaml -n oklahoma > task15.yaml
```
### Step 4: Link the Badge to the Worker (Editing the YAML)
You saw a "strict decoding error" in your logs. This usually happens if `serviceAccountName` is placed in the wrong spot. It belongs inside the `spec`, but not inside the `containers` list.

Correct `task15.yaml` structure:

```YAML
apiVersion: v1
kind: Pod
metadata:
  name: securepod
  namespace: oklahoma
spec:
  serviceAccountName: secure  # <--- MUST BE HERE (at the Pod level)
  containers:
  - name: securepod
    image: nginx
```
### Step 5: Open the Shop
```Bash
mk -- apply -f task15.yaml -n oklahoma
```
### Verification: Checking the "ID Card"
To ensure the pod is actually wearing the badge, inspect the running pod:
```Bash
mk -- get pod securepod -n oklahoma -o yaml | grep serviceAccountName
```
**Goal Result:** `serviceAccountName: secure`
---
### 10.3 The "Triage" Rule
In Section 10.0, remember the Mall Manager's priority:
1.  **Context Check:** Always `kubectl config set-context --current --namespace=<task-ns>`.
2.  **Dry-Runs:** Use `k run ... --dry-run=client -o yaml > task.yaml`. 
3.  **Validate:** Always test with `curl` or `kubectl get endpoints` before moving to the next task.

---

### 10.4 Grading the Exam
```bash 
student@ckad:~/ckad$ . /exam-grade.sh
```
