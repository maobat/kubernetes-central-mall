### 6.3.3.1 Deployment Steps: Progressive Traffic Demo
---
#### Canary Deployment Implementation Plan (Kubernetes CLI)

This plan outlines the steps for setting up a robust Canary deployment strategy using standard Kubernetes CLI commands. The strategy relies on defining a **shared label** for both stable and canary deployments, which the Service targets. Traffic management is then controlled by scaling the replicas of the respective deployments.

Canary Deployment Implementation Plan (With Food Court Analogy)
We will deploy the new application version (V2) by treating the Service as the **Food Court Entrance** and the Pods as individual **Food Stalls**. Traffic (customers) is routed based on the number of open stalls for each version.

---
##### Analogy Key
* **Service (`canary-svc`):** The Food Court Entrance/Main Sign.
* **Deployment:** The blueprints/staffing plan for a stall type (V1 or V2).
* **Pods (Replicas):** The actual, running Food Stalls (serving customers).
* **Shared Label (`traffic-group`):** The common category ("Food Stalls") that the Entrance directs customers toward.
* **Traffic:** Customers entering the food court.

---
#### 6.3.3.1.1. Deploy Stable Version (V1)
---
##### 6.3.3.1.1.1. Create the Deployment

**Action:** Deploy the Stable Version (V1.14) - This is the existing 10 stalls of the successful V1 restaurant.

```bash
kubectl create deployment stable-nginx --image=nginx:1.14 --replicas=10
```
---
##### 6.3.3.1.1.2. Apply Shared Labels to Pod Template (Tag the Stalls)
We apply the common label (`traffic-group=nginx-canary`) to the Pod Template. This is like putting up the "Food Stalls" sign on the existing V1 restaurants so the Entrance knows where to send customers.

**Action:** Patch the Deployment's Pod Template metadata.

```bash
kubectl patch deployment stable-nginx -p '{"spec": {"template": {"metadata": {"labels": {"app": "stable-nginx", "traffic-group": "nginx-canary"}}}}}'
```
---
#### 6.3.3.1.2. Expose Stable Deployment with a Service (Open the Entrance)
The Service is configured to use the **shared label**. The Entrance is opened, directing traffic to any stall with the "Food Stalls" sign. Since only V1 has the sign, it gets 100% of the traffic.

**Action:** Create the Service targeting the common label.
```bash
kubectl expose deployment stable-nginx --port=80 --name=canary-svc --selector="traffic-group=nginx-canary"
```
---
#### 6.3.3.1.3. Deploy Canary Version (V2 Initial Rollout)
---
##### 6.3.3.1.3.1. Create the Canary Deployment (Build the New Stall)
We introduce the new Canary version (`canary-nginx`), but we keep it closed (`--replicas=0`). The new V2 recipe is ready, but the stall isn't staffed yet.

**Action:** Deploy the Canary Version with 0 replicas initially.

```bash
kubectl create deployment canary-nginx --image=nginx:1.15 --replicas=0
```
---
##### 6.3.3.1.3.2. Apply Shared Labels to Canary Pod Template (Tag the New Stall)
We apply the required labels to the new Canary's Pod Template. The new V2 stall is also given the "Food Stalls" sign, ready for the Entrance to include it when it opens.

**Action:** Patch the Canary Deployment's Pod Template metadata.

```bash
kubectl patch deployment canary-nginx -p '{"spec": {"template": {"metadata": {"labels": {"app": "canary-nginx", "traffic-group": "nginx-canary"}}}}}'
```
---
#### 6.3.3.1.4. Deployment Steps: Progressive Traffic Demo (Staffing the Stalls)
The Entrance (Service) routes customers (traffic) randomly across all open stalls. We control the traffic split by opening V2 stalls and closing V1 stalls using `kubectl scale`.

<table border="1" cellspacing="0" cellpadding="6">
  <tr>
    <th>Phase</th>
    <th>Objective (Mall Analogy)</th>
    <th>Command Executed (Stable / Canary)</th>
    <th>Total Target Replicas</th>
    <th>Status After Execution</th>
  </tr>

  <tr>
    <td>6.3.3.1.4.1. Initial Setup</td>
    <td>10 V1 Stalls Open (100%), V2 Stalls Closed (0%).</td>
    <td>
      kubectl scale deploy stable-nginx --replicas=10 <br>
      kubectl scale deploy canary-nginx --replicas=0
    </td>
    <td>10</td>
    <td>Stable 100% (10/10)</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.2. Canary Test (10% Low Risk)</td>
    <td>Open 1 V2 Stall and close 1 V1 Stall. 10% of customers are now exposed to the new recipe. <b>(Followed by 6.3.3.1.5: Testing)</b></td>
    <td>
      <b>Scale Up Canary:</b><br>
      kubectl scale deploy canary-nginx --replicas=1<br><br>
      <b>Scale Down Stable:</b><br>
      kubectl scale deploy stable-nginx --replicas=9
    </td>
    <td>10</td>
    <td>10% traffic to v1.15 (1/10)</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.3. Progressive Rollout (50% Medium Risk)</td>
    <td>The V2 recipe is popular and safe. Open 4 more V2 Stalls and close 4 V1 Stalls. <b>(Followed by 6.3.3.1.5: Testing)</b></td>
    <td>
      kubectl scale deploy canary-nginx --replicas=5<br>
      kubectl scale deploy stable-nginx --replicas=5
    </td>
    <td>10</td>
    <td>50% traffic to v1.15 (5/10)</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.4. Instant Rollback (Optional)</td>
    <td><i>**Failure Scenario:** Customer feedback is terrible (errors/bugs). Immediately close all V2 stalls and reopen V1 stalls.</i></td>
    <td>
      kubectl scale deploy canary-nginx --replicas=0<br>
      kubectl scale deploy stable-nginx --replicas=10
    </td>
    <td>10</td>
    <td>Rollback completed, 0% traffic to Canary</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.5. Full Promotion (100%)</td>
    <td>The V2 recipe is stable. Close all V1 Stalls and staff all 10 V2 Stalls. The new version is now the standard.</td>
    <td>
      kubectl scale deploy canary-nginx --replicas=10<br>
      kubectl scale deploy stable-nginx --replicas=0
    </td>
    <td>10</td>
    <td>Full Promotion (10/10)</td>
  </tr>

  <tr>
    <td>6.3.3.1.4.6. Final Cleanup</td>
    <td>Remove the blueprints for the old V1 stalls now that V2 is the new standard.</td>
    <td>
      kubectl delete deploy stable-nginx
    </td>
    <td>N/A</td>
    <td>Old Stable removed</td>
  </tr>
</table>


#### 6.3.3.1.5. Testing and Observation Procedures (Between Scaling Steps)
---
After each change in the number of open stalls (traffic increment), a mandatory observation period must occur.

---
##### 6.3.3.1.5.1. Health and Error Monitoring (Food Safety)

| Metric | Description (Analogy) | Command or Tool |
| :--- | :--- | :--- |
| **Pod Health** | Ensure all V2 stalls remain open, staffed, and ready to serve customers. | **Immediate Check:** Get the status of all Canary pods. <pre>kubectl get pods -l app=canary-nginx</pre> |
| **Log Analysis** | Check the V2 kitchen's internal logs for critical failures or system crashes. | **Immediate Check:** Stream logs from one Canary pod (replace `[POD_NAME]` with a live pod name). <pre>kubectl logs -f [POD_NAME] -c nginx</pre> |
| **Error Rate** | Check for "food poisoning reports" (HTTP 5xx responses) specific to the new V2 stalls. | **Monitoring Query (e.g., Prometheus/Grafana):** Compare the rate of 5xx errors between V1 and V2 services. <pre>sum(rate(http_requests_total{app="canary-nginx", status="5xx"}[5m])) / sum(rate(http_requests_total{app="canary-nginx"}[5m]))</pre> |

---
##### 6.3.3.1.5.2. Performance Metrics (Service Speed)

| Metric | Description (Analogy) | Command or Tool |
| :--- | :--- | :--- |
| **Resource Utilization** | Check if the new V2 stall is using excessive resources (CPU/Memory). | **Immediate Check:** Check CPU/Memory for all Canary pods. (Requires Kubernetes Metrics Server). <pre>kubectl top pod -l app=canary-nginx</pre> |
| **Latency/Response Time** | Monitor customer wait times (response latency) at the new V2 stall. | **Monitoring Query (e.g., Prometheus/Grafana):** Compare the 95th percentile (P95) response time. <pre>histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{app="canary-nginx"}[5m]))</pre> |
| **Key Business Metrics (KBMs) & User Feedback** | Track critical business metrics (e.g., conversion rates). The V2 stall should not negatively impact overall sales. | **External APM/Analytics:** Monitored via dedicated Application Performance Monitoring (APM) tools (e.g., New Relic, Datadog) or A/B testing platforms which track user behavior specific to traffic hitting the V2 code path. |

---
**Summary:** By using a common `traffic-group` label, the Food Court Entrance (Service) seamlessly directs customers across all available stalls (Pods). The progressive scaling is only executed after successful completion of the observation and testing steps defined in 6.3.3.1.5, ensuring the new recipe is safe and fast before full promotion.

---
### 6.3.3.2 Lab: The "Smart Transit Hub" (Gateway API Lab)

<img src="images/image12.png" alt="The 'Smart Transit Hub'" height="35%" width="35%" />

**Why use this instead of Ingress?**

In `Task 7 - Ingress, Exposing Applications`, we used Ingress for simple routing. For DevOps/Canary (Section 6.0), we use the **Gateway API** because "Weighting" (90/10 split) is a native feature, not a hack.

While **Section 6.3.3.1** used the "Manual Scaling" method (hiring more workers), this section uses the **Gateway API** to manage traffic at the entrance using **Weights**.

**1. Hiring the Management Team (Infrastructure)**
Before the mall can open the new hub, we need to install the rules and hire the security firm.
  **- Mall Analogy:** You can't have a "Smart Gate" if the Mall Manager doesn't recognize the new permit types.
```Bash
# 1. Install the "Global Mall Regulations" (CRDs)
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.1.0/standard-install.yaml

# 2. Hire the Security Firm (Nginx Gateway Fabric)
helm install ngf oci://ghcr.io/nginxinc/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway

# 3. Verify the "Office" is open
kubectl get pods,svc -n nginx-gateway

# 4. Check the Blueprint (GatewayClass)
# You should see a class named "nginx"
kubectl get gc
```
**2. Opening the Physical Entrance (The NodePort Trick)**
**- Mall Analogy:** Since we are in a local lab (Minikube), we don't have a "Main Highway" (Cloud LoadBalancer), so we tell the guard to let people in through the **Side Door** (NodePort).
```Bash
# Edit the Service to change type from LoadBalancer to NodePort
kubectl edit -n nginx-gateway svc ngf-nginx-gateway-fabric
# (Change 'type: LoadBalancer' to 'type: NodePort')
```
**3. Building the Store & Smart Signage**
**- Mall Analogy:** We build the "Nginx Boutique" and put up the **Digital Signage** (`HTTPRoute`) to direct customers.
```Bash
# 1. Build the Store and the Intercom
kubectl create deployment nginxgw --image=nginx --replicas=3 -n nginx-gateway
kubectl expose deploy nginxgw -n nginx-gateway --port=80

# 2. Apply the Smart Signage (The 'http-routing.yaml')
kubectl apply -f http-routing.yaml -n nginx-gateway
```
**4. Verification (The GPS Update)**
**- Mall Analogy:** We update the customer's GPS (`/etc/hosts`) to point `whatever.com` to the Mall's address.
```Bash
# 1. Get Mall Address and Side Door Number
minikube ip
kubectl get svc -n nginx-gateway # Note the NodePort, e.g., 31702
# 2. Add to hosts file (Assuming IP is 192.168.49.2)
sudo vi /etc/hosts
# Add line: 192.168.49.2  whatever.com
# 3. Final Test
curl whatever.com:<NODEPORT>
```
---
**Comparison** 
|Feature|6.3.3.1 (Manual Canary)|6.3.3.2 (Gateway API)|
|--|--|--|
|**Control**|Scale replicas (9:1)|Set weight: 10 in YAML|
|**Logic**|Probability based on worker count|Precise traffic percentage|
|**Resource**|Service + Deployment|Gateway + HTTPRoute|


[Back to Documentation](../README.md)
