### 4.7 SecurityContext (Worker Safety & Conduct)
A **SecurityContext** defines the specific "behavioral rules" for a worker (Pod/Container).
|Setting|Mall Analogy|Role in Kubernetes|
|--|--|--|
|**runAsUser**|Specific Employee ID|Runs the container as a specific UID (e.g., user 1000).|
|**runAsNonRoot**|No "Master Key"|Prevents the worker from having "Root/Admin" access to the building.|
|**readOnlyFilesystem**|No Writing on Walls|Prevents the container from changing its own internal files.|
|**allowPrivilegeEscalation**|No Promotions|Prevents a worker from gaining higher clearance than assigned.|


[Back to Documentation](../README.md)
