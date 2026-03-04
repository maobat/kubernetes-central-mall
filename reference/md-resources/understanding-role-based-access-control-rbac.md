<h2 id="section-4-4-3">4.4.3 Understanding Role-Based Access Control (RBAC)</h2>

RBAC is the mechanism that connects the "Who" to the "What."

| RBAC Element | Mall Analogy | Description |
| :--- | :--- | :--- |
| **Role** | **The Job Description** | Defines access permissions (verbs like get, create, delete) to specific resources (Pods, Deployments, ConfigMaps) within a **namespace**. |
| **ClusterRole** | **The Executive Job Description** | Defines access permissions that span **the entire cluster** (non-namespaced resources like Nodes or PersistentVolumes). |
| **User/ServiceAccount** | **The Employee/System ID Badge** | The entity (human user or application system) in Kubernetes that works with the API and needs permissions. |
| **RoleBinding** | **The HR Assignment Letter** | Connects a **User** or **ServiceAccount** to a specific **Role** within a **namespace**. |
| **ClusterRoleBinding** | **The Executive Appointment** | Connects a **User** or **ServiceAccount** to a **ClusterRole** across the entire cluster. |


[Back to Documentation](../README.md)
