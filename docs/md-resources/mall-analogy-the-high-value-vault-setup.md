### 4.9.2 Mall Analogy: The "High-Value Vault" Setup
In this scenario, we aren't just opening a standard stall. We are creating a restricted area where every worker must wear a specific "Secure" badge to be identified by the Management Office.
|Kubernetes Step|Mall Analogy|Command|
|--|--|--|
|**Create Namespace**|**Build the Restricted Wing**|`kubectl create ns secure`|
|**Create ServiceAccount**|**Print the Specialized Badges**|`kubectl create sa secure -n secure`|
|**Create Deployment**|**Hire the Security Team**|`kubectl create deploy securedeploy -n secure --image=nginx`|
|**Set ServiceAccount**|**Distribute the Badges**|`kubectl set serviceaccount -n secure deploy securedeploy secure`|


[Back to Documentation](../README.md)
