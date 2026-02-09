<h2 id="section-5-0">5.0 Storage and Logistics (Persistent & Local Data)</h2>

How workers (Pods) handle their data: temporary files, shared lockers, persistent storage.

| CONCEPT | RESOURCE | MALL ANALYGY | DATA LIFECYCLE / CONFIGURATION |
| :--- | :--- | :--- | :--- |
| **Temporary Files** | Container Filesystem | The Worker's Notepad | Lives only as long as the container is running. |
| **Local Storage** | Pod Volume | The Worker's Temporary Locker | Survives container restarts; deleted when the Pod is deleted. |
| **Locker Blueprint** | \`pod.spec.volumes\` | The Locker Attribute Definition | Defines the name and type of the volume (where the data comes from). |
| **Locker Access** | \`volumeMounts\` | The Worker's Key | Grants the container access to the volume at a specific path. |
| **New Locker Type** | \`emptyDir\` | A Brand New, Empty Locker | Shared, temporary storage for the entire Pod. |
| **Shared Resource** | \`hostPath\` | The Mall Utility Closet | Maps to a directory on the Node (physical machine). |
| **External Storage** | PersistentVolume | Warehouse Slot (The Room) | A block of durable, external storage. **Independent resource.** |
| **Storage Request** | PVC | Storage Request Form | The application requests specific storage criteria. |
| **Storage Automation** | StorageClass | The Logistics Officer / Contract Type | The administrative blueprint defining how storage is provisioned (Dynamic) or which pre-existing storage (Static) can be claimed. |


[Back to Documentation](../README.md)
