# 3.0 The Cast of Characters (Internal & External Components)

| CONCEPT | RESOURCE | MALL ANALOGY | ROLE IN KUBERNETES |
| :--- | :--- | :--- | :--- |
|**The Management Office**|	**kube-apiserver**|	Central Management|	The single source of truth. Every request to change the mall must go through this office.|
|**The Front Desk**|	**Kubernetes API**|	The Mall Ledger|	The official record of every shop, worker, and rule. If it isn’t in the Ledger, it doesn’t exist.|
|**The Security Badge**|	**kubeconfig** (~/.kube/config)|	The Owner's ID Badge|	The digital certificate that proves who you are and what parts of the Management Office you can access. This is your Master Key. You use it to tell the Management Office to build the mall.|
|**The Translator**|	**kubectl proxy**|	The Proxy/Phone Line|	A secure "tunnel" that lets standard tools (like curl) talk to Management without needing a complex badge.|
| **The Stable Counter** | **Service (ClusterIP)** | The Permanent Storefront Sign | A stable, internal "extension number" or counter location. Even if the workers change, the counter stays put. |
| **The Worker** | **Pod** | The Individual Employee | The running containerized application that does the actual work (temporary/scalable). |
| **The Manager** | **Deployment**| The Store Manager | Ensures the correct number of Pods (workers) are always running. |
| **The Main Gate** | **Ingress Controller**| The Guard at the Main Entrance | The program that reads the Ingress Rules and directs external traffic. |
| **The Rulebook** | **Ingress Resource**| The Guard's Rule Sheet (YAML) | **(Legacy)** A single file that lists every store. If the Boutique changes its hours, the Guard has to update the entire list for the whole mall. |
| **The Guest List** |	**EndpointSlice**| The Digital Staff List |	The real-time list of which workers are currently at their desks.|
| **The Side Door**	|**Service (NodePort)**	|Side Entrance with Keypad|	A high-port entry (30000+) on every building for external testing.|
|**The Architect**|	**GatewayClass**	| The Mall Construction Plan |	**(Modern)** Defines the type of technology used (Nginx, Istio, Cloud). Set once by the Cloud/Infrastructure provider.|
|**The Entrance**|	**Gateway**|	The Physical Transit Hub |	**(Modern)** The actual entrance with an IP address. Managed by **Admins** who decide which domains (like `myapp.info`) are allowed in.|
|**The Signage** |	**HTTPRoute** |	Store-Specific Directions |	**(Modern)** Individual rules created by **App Developers**. They control their own traffic (like 90/10 Canary splits) without touching the main Gate.|
|**The Auto-Builder**| **GitOps Operator**|	The Robotic Architect|	**(Modern)** Watches the blueprints in the vault (Git) and automatically builds the mall to match them.|
|**The Shop's Internal Badge**|**ServiceAccount (SA)**|The Automated Employee ID|The identity used by Pods to authenticate with the Management Office. Every worker (Pod) wears one.|
|**The Job Description**|**Role**|The Local Shop Permit|A list of "Can-Do" rules (verbs) restricted to a **single shop (Namespace)**. Example: "Can read the Jewelry Ledger."|
|**The HR Assignment Letter**|**RoleBinding**|The Local HR Appointment|The document that pins a **Local Permit (Role)** to a specific **Employee ID (ServiceAccount)** within one shop.|
|**The Executive Permit**|**ClusterRole**|The Mall-Wide Authority|A list of rules that apply to the **entire Mall (Cluster)**. Used for resources like Nodes or for tasks across all Namespaces.|
|**The Executive Promotion**|**ClusterRoleBinding**|The Mall-Wide Appointment|The high-level document that grants an **Executive Permit (ClusterRole)** to an ID, giving them power across the **entire mall**.|


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
