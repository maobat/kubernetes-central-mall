#### 6.3.5.1. Phase 1: Defining the New Permit Type (The CRD)

This step extends the Official Mall Rulebook (Kubernetes API) to recognize the new `BackUp` resource.

| Kubernetes Step (Command) | Action in the Shopping Mall (Mall Analogy) | Logic |
| :--- | :--- | :--- |
| **6.3.5.1.1. Define the CRD Manifesto** (`vim crd-object.yaml`) | **Write the Rulebook Chapter:** Define exactly what a "Nightly Backup Service" (`kind: BackUp`) is. | Establishes the rules: the module name, the required fields (`backupType`, `replicas`, `image`), and where it will be filed. |
| **6.3.5.1.2. Create the CRD** (`kubectl create -f crd-object.yaml`) | **Formalize the Regulation:** Submit the new Chapter (the CRD) to Central Management. | Central Management updates its system: they now know what a `BackUp` request means and are ready to accept forms for it. |
| **6.3.5.1.3. Verify Extension** (`kubectl api-resources \| grep backup`) | **Check the Forms Database:** Verify that the new "Nightly Backup Services" form is officially listed. | Confirms the new resource type is known to the API server. |

#### crd-object.yaml (The Regulation)

```yaml
# A simplified CRD definition
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: backups.stable.example.com
spec:
  group: stable.example.com
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                backupType: { type: string }
                image: { type: string }
                replicas: { type: integer }
  scope: Namespaced
  names:
    plural: backups
    singular: backup
    shortNames:
      - bks
    kind: BackUp # <-- The new permit type (Nightly Backup Service)
```

#### 6.3.5.2. Phase 2: Creating a Custom Service Instance

This step is the act of requesting the new service.

| Kubernetes Step (Command) | Action in the Shopping Mall (Mall Analogy) | Logic |
| :--- | :--- | :--- |
| **6.3.5.2.1. Define the Instance** (`vim crd-backup.yaml`) | **Fill out the Form:** Request a specific instance of the "Nightly Backup Service." | Defines the desired state for the custom resource. |

#### 📄 crd-backup.yaml (The Form Instance)

```yaml
apiVersion: [stable.example.com/v1](https://stable.example.com/v1)
kind: BackUp
metadata:
  name: mybackup
spec:
  backupType: full
  image: backup-script:v2.0
  replicas: 1
```

| Kubernetes Step (Command) | Action in the Shopping Mall (Mall Analogy) | Logic |
| :--- | :--- | :--- |
| **6.3.5.2.2. Create the Custom Resource (CR)** (`kubectl create -f crd-backup.yaml`) | **Submit the Form:** Send the specific request to Central Management. | The API server stores this configuration in etcd. The resource now exists but is currently *unmanaged*. |
| **6.3.5.2.3. Verify the New Resource** (`kubectl get bks`) | **Check the Request Status:** List all submitted "Nightly Backup Services" forms. | Confirms the instance is stored in Kubernetes. The resource is pending action by a Controller/Operator. |


[Back to Documentation](../README.md)
