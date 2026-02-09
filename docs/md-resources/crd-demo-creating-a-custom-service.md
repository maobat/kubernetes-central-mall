<h3 id="section-6-4-3">6.4.3 CRD Demo (Creating a Custom Service)</h3>

This section details the missing link: the **Controller** that watches for the Custom Resources (`kind: BackUp`) and takes action to match the desired state (the CR) with the current state (a running Pod). This is the foundational component of an Operator.

#### 1. The Controller's Role (The Watcher)
The Controller is a persistent process running inside the Kubernetes cluster. Its core job is to continuously monitor the API server for changes to the Custom Resource type it manages (`BackUp` resources).

| Control Loop Component | Action on `BackUp` Resource |
| :--- | :--- |
| **Watcher** | Listens for creation, update, or deletion events for `BackUp` resources. |
| **Reconciler** | Compares the desired state (defined in the `BackUp` CR's `spec`) with the actual state of the cluster (e.g., is the backup Pod running?). |
| **Actuator** | If states don't match, it takes corrective action (e.g., creates a Deployment, updates a ConfigMap, or starts a Pod). |

#### 2. The Reconcile Function (The Logic)

The heart of every Controller is the `Reconcile` function. When a `BackUp` object is created (like `mybackup` in 6.3.5.2), the Controller sees the event and runs the logic below.

**Conceptual Pseudocode (Operator Logic):**

```python
# Simplified Logic of the BackUp Controller

def Reconcile(backup_cr_name):
    # 1. Fetch the Desired State (The CR)
    backup_cr = api_client.get_custom_resource('BackUp', backup_cr_name)

    if not backup_cr:
        # Resource was deleted (cleanup if needed)
        # Ensure associated Deployment/Job is also deleted
        delete_job(backup_cr_name)
        return

    # 2. Define the Actual State (The Dependent Kubernetes Object)
    job_name = f"job-{backup_cr.metadata.name}"
    existing_job = api_client.get_kubernetes_job(job_name)

    # 3. Check and Act (Reconciliation Loop)
    if not existing_job:
        # Create a new Kubernetes Job/Deployment based on the CR spec
        new_job_spec = create_job_spec(
            image=backup_cr.spec.image,
            replicas=backup_cr.spec.replicas,
            command=f"/run/backup --type={backup_cr.spec.backupType}"
        )
        api_client.create_kubernetes_job(new_job_spec)
        
        # Update the CR's status to 'Creating'
        api_client.update_cr_status(backup_cr_name, 'Status: Creating Job')

    elif existing_job.spec.image != backup_cr.spec.image:
        # Update Case: The image in the CR was changed
        api_client.update_kubernetes_job(job_name, new_image=backup_cr.spec.image)
        
        # Update the CR's status to 'Updating'
        api_client.update_cr_status(backup_cr_name, 'Status: Image Updated')

    # ... other logic for scaling, deletion, or failure handling

    return # Reconciliation complete
```
#### 3. Result: Automated Management
Once the Controller is running, the user never interacts directly with the Kubernetes Deployment or Job resources for the backup. They simply manage the simple `BackUp` CR:

* **To create the backup:** `kubectl apply -f crd-backup.yaml` (The Controller sees this and creates the K8s Job).
* **To change the image:** `kubectl edit bks mybackup` (The Controller sees the update and rolls out the new K8s Job).
* **To delete the backup service:** `kubectl delete bks mybackup` (The Controller sees the deletion and automatically cleans up the underlying K8s Job).
