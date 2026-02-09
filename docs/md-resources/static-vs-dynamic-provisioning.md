<h3 id="section-5-0-1">5.0.1 Provisioning Strategies: Static vs. Dynamic</h3>

The two core strategies for managing PersistentVolumes (PVs) highlight a critical difference in Kubernetes administration. This distinction is often simplified by the number of resource files required to set up the storage system:

1.  **Dynamic Provisioning (The 1 or 2-File Strategy):** Only requires the Cluster Administrator to define a StorageClass. The user then simply creates the PersistentVolumeClaim (PVC). The control plane automatically creates the matching PV based on the StorageClass, eliminating the need for manual PV creation. This requires the user to submit only two files (PVC and Pod), or effectively one main resource (the PVC) that triggers the PV creation.

    **Process:**
    * The cluster has a `StorageClass` configured (a "blueprint" for creating new storage).
    * The developer only defines the `PersistentVolumeClaim` (PVC) in their YAML.
    * When the PVC is created, the Kubernetes control plane sees the request and automatically uses the `StorageClass` to provision the necessary storage in the backend (e.g., creating a new disk in the cloud) and simultaneously creates the matching `PersistentVolume` (PV) for you.

    **When to use this:**
    * In most real-world, cloud-native scenarios, as it simplifies workflow and scales easily.
    * When using cloud storage types (like GCP Persistent Disks or AWS EBS) or other solutions that integrate with a `StorageClass`.
2.  **Static Provisioning (The 3-File Approach):** Requires the Cluster Administrator to manually pre-create the PersistentVolume (PV). The user then creates the PersistentVolumeClaim (PVC) to claim it, and finally, the Pod uses the PVC. This requires three distinct YAML definitions: PV, PVC, and Pod.
* **`pv-rwo.yaml` (PersistentVolume):** Defines the actual physical or network storage resource available in the cluster.
* **`pvc-rwo.yaml` (PersistentVolumeClaim):** Defines the *request* for storage by a user.
* **`pod-rwo.yaml` (Pod):** Defines the application that consumes the storage request.

    **Process:** You manually define the supply (PV) and the demand (PVC). The Kubernetes control plane then binds the specific PV to the PVC, and the Pod uses that bound PVC.

    **When to use this:**
    * When demonstrating the fundamental connection between PV, PVC, and Pod.
    * When using storage that must be manually set up and managed (e.g., specialized network shares or legacy systems).
    * If the lab explicitly requires you to define a PersistentVolume.

***

#### Conclusion: Matching Strategy to the Lab's Goal

The key takeaway is that the file count is a symptom of the provisioning method:

| Scenario | Strategy | Files Needed | Purpose |
| :--- | :--- | :--- | :--- |
| **Section 5.5** | **Dynamic** | **1 or 2** (PVC + Pod) | Request storage, allowing Kubernetes to automatically create the necessary backend volume. |
| **Section 5.7.1** | **Static** | **3** (PV, PVC, Pod) | Explicitly define and manually bind a pre-existing storage resource. |


[Back to Documentation](../README.md)
