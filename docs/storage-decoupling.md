# 2.0 The Core Idea: Storage Decoupling

The Kubernetes storage model is built on **decoupling**. Applications (Pods) should only declare their **need** for storage, not **where** that storage comes from.

| Kubernetes Concept | Mall Analogy | Description |
| :--- | :--- | :--- |
| **PersistentVolume (PV)** | **The Storage Room** | The physical storage resource, set up by the Cluster Administrator. |
| **PersistentVolumeClaim (PVC)** | **The Request Form** | The application's request for a specific size and access mode (e.g., 1Gi, ReadWriteOnce). |
| **Binding** | **The Matchmaking** | The Kubernetes Control Plane (Mall Manager) matches a PVC Request Form to an available PV Storage Room. |
| **Decoupling** | **Worker Freedom** | The Worker (Pod) only references the PVC Request Form, allowing it to move across the cluster without needing to know the physical storage path (PV hostPath, cloud disk, etc.). |


[Back to Documentation](https://github.com/maobat/kubernetes-central-mall/tree/main/docs#documentation)
